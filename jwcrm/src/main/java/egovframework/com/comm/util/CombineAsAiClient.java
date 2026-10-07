package egovframework.com.comm.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.model.CombineAsAiVO;

/**
 * [AX Lab] 신규 파일 (2026-10-06 AX Lab): AS 통합화면 AI 추천 — 추천 API(/api/recommend) HTTP 클라이언트.
 *
 * 설계서 mdfile/AS통합화면_AI추천_통합설계.md §5(A안) / §6 / §9 를 구현한다.
 *  - CRM WAS 만 키를 가진다. 브라우저는 이 클래스를 거치지 않고는 추천 API 를 호출할 수 없다.
 *  - 기존 외부 호출 선례(CommonExecute.exceptionInterface 의 HttpURLConnection)와 같은 방식이라
 *    새 HTTP 라이브러리를 들이지 않는다. JSON 은 AdAsController 가 이미 쓰는 jackson-databind 를 쓴다.
 *  - 타임아웃(기본 연결 1.0s / 읽기 2.5s) 초과·네트워크 오류·HTTP 오류는 예외를 던지지 않고
 *    result 코드로 돌려준다. AS 상세 화면은 추천이 실패해도 그대로 동작해야 한다(§6 실패 처리).
 *  - 질의 본문(call_content)은 로그에 남기지 않는다. 길이만 남긴다(§9 3-1 로그 위생).
 *
 * result 코드 (챗봇 서버 "000" 외에 CRM 쪽에서 붙이는 코드):
 *   "901" 비활성(combine.ai.enabled=N)   "902" 설정 누락(URL 없음)   "903" 타임아웃
 *   "904" 네트워크/IO 오류                "905" HTTP 상태 오류          "906" 응답 파싱 실패
 */
public class CombineAsAiClient {

	private static final Logger logger = LoggerFactory.getLogger(CombineAsAiClient.class);

	public static final String RESULT_OK        = "000";
	public static final String RESULT_DISABLED  = "901";
	public static final String RESULT_NO_CONFIG = "902";
	public static final String RESULT_TIMEOUT   = "903";
	public static final String RESULT_IO        = "904";
	public static final String RESULT_HTTP      = "905";
	public static final String RESULT_PARSE     = "906";

	private static final String PROP_FILE = "combine-ai.properties";
	private static volatile Properties props = null;

	private static final ObjectMapper om = new ObjectMapper();

	/* ------------------------------------------------------------------ 설정 */

	/** classpath:combine-ai.properties 를 1회 로드한다. 없으면 빈 Properties (→ 902). */
	private static Properties props() {
		if (props == null) {
			synchronized (CombineAsAiClient.class) {
				if (props == null) {
					Properties p = new Properties();
					InputStream in = null;
					try {
						in = CombineAsAiClient.class.getClassLoader().getResourceAsStream(PROP_FILE);
						if (in != null) {
							p.load(new InputStreamReader(in, StandardCharsets.UTF_8));
						} else {
							logger.warn("[AX Lab] {} 를 classpath 에서 찾지 못했습니다. 시스템 프로퍼티/환경변수만 사용합니다.", PROP_FILE);
						}
					} catch (Exception e) {
						logger.warn("[AX Lab] {} 로드 실패: {}", PROP_FILE, e.toString());
					} finally {
						if (in != null) { try { in.close(); } catch (Exception ignore) {} }
					}
					props = p;
				}
			}
		}
		return props;
	}

	/** 우선순위: -Dkey > 환경변수(KEY 를 대문자·점→밑줄) > properties 파일 > 기본값 */
	static String conf(String key, String def) {
		String v = System.getProperty(key);
		if (v == null || v.trim().isEmpty()) {
			v = System.getenv(key.toUpperCase().replace('.', '_'));
		}
		if (v == null || v.trim().isEmpty()) {
			v = props().getProperty(key);
		}
		return (v == null || v.trim().isEmpty()) ? def : v.trim();
	}

	static int confInt(String key, int def) {
		try { return Integer.parseInt(conf(key, String.valueOf(def))); } catch (Exception e) { return def; }
	}

	/* ------------------------------------------------------------------ 호출 */

	/**
	 * 추천 API 를 호출해 vo 의 result / elapsed_ms / items 를 채운다. 예외를 던지지 않는다.
	 */
	public static CombineAsAiVO recommend(CombineAsAiVO vo) {
		long t0 = System.currentTimeMillis();

		if (!"Y".equalsIgnoreCase(conf("combine.ai.enabled", "Y"))) {
			return fail(vo, RESULT_DISABLED, "combine.ai.enabled=N", t0);
		}
		String urlStr = conf("combine.ai.url", "");
		String apiKey = conf("combine.ai.key", "");
		if (urlStr.isEmpty()) {
			return fail(vo, RESULT_NO_CONFIG, "combine.ai.url 미설정", t0);
		}
		int connectTimeout = confInt("combine.ai.connectTimeoutMs", 1000);
		int readTimeout    = confInt("combine.ai.readTimeoutMs", 2500);

		HttpURLConnection conn = null;
		try {
			byte[] body = om.writeValueAsBytes(buildRequest(vo));

			conn = (HttpURLConnection) new URL(urlStr).openConnection();
			conn.setRequestMethod("POST");
			conn.setConnectTimeout(connectTimeout);
			conn.setReadTimeout(readTimeout);
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
			conn.setRequestProperty("Accept", "application/json");
			if (!apiKey.isEmpty()) conn.setRequestProperty("X-Api-Key", apiKey);

			OutputStream os = conn.getOutputStream();
			os.write(body);
			os.flush();
			os.close();

			int status = conn.getResponseCode();
			InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
			String text = readAll(is);

			if (status < 200 || status >= 300) {
				return fail(vo, RESULT_HTTP, "HTTP " + status + " " + abbreviate(text, 200), t0);
			}

			Map<String, Object> res;
			try {
				@SuppressWarnings("unchecked")
				Map<String, Object> parsed = om.readValue(text, Map.class);
				res = parsed;
			} catch (Exception pe) {
				return fail(vo, RESULT_PARSE, "JSON 파싱 실패: " + pe.getMessage(), t0);
			}

			String result = String.valueOf(res.get("result") == null ? "" : res.get("result"));
			vo.setResult(result.isEmpty() ? RESULT_PARSE : result);
			vo.setItems(asItemList(res.get("items")));
			Object em = res.get("elapsed_ms");
			vo.setElapsed_ms(System.currentTimeMillis() - t0);
			if (em != null) vo.setMessage("server_elapsed_ms=" + em);

			if (logger.isInfoEnabled()) {
				logger.info("[AX Lab] AI 추천 호출 as_no={} result={} items={} elapsed={}ms queryLen={}",
						vo.getAs_no(), vo.getResult(), vo.getItems().size(), vo.getElapsed_ms(), vo.getQuery() == null ? 0 : vo.getQuery().length());
			}
			return vo;

		} catch (SocketTimeoutException te) {
			return fail(vo, RESULT_TIMEOUT, "timeout(" + connectTimeout + "/" + readTimeout + "ms)", t0);
		} catch (Exception e) {
			return fail(vo, RESULT_IO, e.getClass().getSimpleName() + ": " + e.getMessage(), t0);
		} finally {
			if (conn != null) { try { conn.disconnect(); } catch (Exception ignore) {} }
		}
	}

	/** §6 요청 JSON. cust_code / cust_nm 은 어떤 경우에도 넣지 않는다. */
	static Map<String, Object> buildRequest(CombineAsAiVO vo) {
		Map<String, Object> req = new HashMap<String, Object>();
		req.put("query", nvl(vo.getQuery()));
		req.put("as_no", nvl(vo.getAs_no()));
		req.put("exclude_as_no", vo.getExclude_as_no() == null ? new ArrayList<String>() : vo.getExclude_as_no());
		req.put("service_cate", nvl(vo.getService_cate()));
		req.put("inquiry_type", nvl(vo.getInquiry_type()));
		req.put("request_type", nvl(vo.getRequest_type()));
		req.put("program_nm", nvl(vo.getProgram_nm()));
		req.put("screen_nm", nvl(vo.getScreen_nm()));
		req.put("top_k", vo.getTop_k() <= 0 ? 5 : vo.getTop_k());
		if (vo.getTiers() != null && !vo.getTiers().isEmpty()) req.put("tiers", vo.getTiers());
		return req;
	}

	/* ------------------------------------------------------------------ 보조 */

	private static CombineAsAiVO fail(CombineAsAiVO vo, String code, String reason, long t0) {
		vo.setResult(code);
		vo.setItems(new ArrayList<Map<String, Object>>());
		vo.setElapsed_ms(System.currentTimeMillis() - t0);
		vo.setMessage(reason);
		/* 실패는 경고 1줄. 질의 본문은 남기지 않는다. */
		logger.warn("[AX Lab] AI 추천 호출 실패 as_no={} code={} reason={} elapsed={}ms", vo.getAs_no(), code, reason, vo.getElapsed_ms());
		return vo;
	}

	@SuppressWarnings("unchecked")
	private static List<Map<String, Object>> asItemList(Object items) {
		List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
		if (items instanceof List) {
			for (Object o : (List<Object>) items) {
				if (o instanceof Map) out.add((Map<String, Object>) o);
			}
		}
		return out;
	}

	private static String readAll(InputStream is) throws Exception {
		if (is == null) return "";
		BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
		StringBuilder sb = new StringBuilder();
		char[] buf = new char[4096];
		int n;
		while ((n = br.read(buf)) > 0) sb.append(buf, 0, n);
		br.close();
		return sb.toString();
	}

	private static String nvl(String s) { return s == null ? "" : s; }

	private static String abbreviate(String s, int max) {
		if (s == null) return "";
		s = s.replaceAll("\\s+", " ").trim();
		return s.length() <= max ? s : s.substring(0, max) + "…";
	}
}
