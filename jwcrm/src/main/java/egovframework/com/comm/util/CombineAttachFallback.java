package egovframework.com.comm.util;

import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.comm.model.FileVO;

/**
 * [AX Lab] 신규 파일 (2026-10-08 AX Lab): 첨부파일 원격 폴백(개발/복제 환경용).
 *
 * <p>배경: 복제 DB(NEWCIT) 를 바라보는 로컬 PC 에는 CRM_ATTACH_MGT 메타데이터만 있고
 * 물리 파일(ATTACH_PATH_DTL = C:/upload\... , 운영 앱서버 디스크)은 없다. 그래서
 * {@code /comm/fileDown.do} 가 {@code File.exists()==false} 로 조용히 빈 응답을 돌려줘
 * "기존 첨부가 다운로드되지 않는" 증상이 난다.</p>
 *
 * <p>운영 웹서버는 업로드 루트를 {@code /upload/**} 정적 경로로 그대로 서비스하므로
 * (예: https://lineusadmin.cwit.co.kr/upload/as/2026/07/29/xxxx.pdf), 로컬에 파일이 없을 때
 * 그 URL 에서 받아 그대로 흘려보내면(프록시) 다운로드가 된다. 파일을 PC 로 복사해 둘 필요가 없고
 * DB 를 다시 동기화해도 새 첨부가 자동으로 따라온다.</p>
 *
 * <p>설정은 classpath:combine-attach.properties (우선순위: -D 시스템 프로퍼티 &gt; 환경변수 &gt; 파일).
 * {@code combine.attach.fallback.url} 이 비어 있거나 enabled=N 이면 아무 것도 하지 않아
 * 운영 동작(빈 응답)과 완전히 동일하다. 운영에서는 파일이 항상 로컬에 있으므로 이 코드가 실행될 일이 없다.</p>
 */
public final class CombineAttachFallback {

	private static final Logger logger = LoggerFactory.getLogger(CombineAttachFallback.class);

	private static final String PROP_FILE = "combine-attach.properties";
	private static volatile Properties props = null;

	private CombineAttachFallback() {}

	/* ------------------------------------------------------------------ 설정 */

	private static Properties props() {
		if (props == null) {
			synchronized (CombineAttachFallback.class) {
				if (props == null) {
					Properties p = new Properties();
					InputStream in = null;
					try {
						in = CombineAttachFallback.class.getClassLoader().getResourceAsStream(PROP_FILE);
						if (in != null) {
							p.load(new InputStreamReader(in, StandardCharsets.UTF_8));
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

	/** 우선순위: -Dkey > 환경변수(KEY 대문자, 점→밑줄) > properties 파일 > 기본값 */
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

	/** 폴백이 설정되어 있고 켜져 있는지 */
	public static boolean isEnabled() {
		// 기본값 N: properties 파일이 없거나 키가 빠져도 운영에서는 꺼진 상태를 보장. 로컬은 pom.xml systemProperties 로 Y 주입.
		return "Y".equalsIgnoreCase(conf("combine.attach.fallback.enabled", "N"))
				&& !conf("combine.attach.fallback.url", "").isEmpty();
	}

	/* ------------------------------------------------------------------ URL 조립 */

	/**
	 * DB 메타데이터로 원격 URL 을 만든다.
	 * 웹 경로는 ATTACH_PATH_DTL(물리 절대경로, 예 C:/upload\as\2026\07\29\) 에서 "/upload/" 이후를 잘라 쓴다.
	 * ATTACH_PATH(/upload/...) 를 쓰지 않는 이유: 2017년 이전 게시판 자료는 ATTACH_PATH 가
	 * "/upload/board/2017old/..." 처럼 구분자가 빠져 있어 실제 디스크 구조와 다르다. ATTACH_PATH_DTL 이 진실에 가깝다.
	 * "/upload/" 를 못 찾으면 ATTACH_PATH 로 대체한다.
	 */
	public static String buildUrl(FileVO f) {
		String base = conf("combine.attach.fallback.url", "");
		if (base.isEmpty() || f == null) return null;
		while (base.endsWith("/")) base = base.substring(0, base.length() - 1);

		String webPath = null;
		String dtl = f.getAttach_path_dtl();
		if (dtl != null) {
			String norm = dtl.replace('\\', '/');
			int i = norm.toLowerCase().indexOf("/upload/");
			if (i >= 0) webPath = norm.substring(i);
		}
		if (webPath == null) webPath = f.getAttach_path();
		if (webPath == null || webPath.trim().isEmpty()) return null;
		webPath = webPath.trim();
		if (!webPath.startsWith("/")) webPath = "/" + webPath;
		if (!webPath.endsWith("/")) webPath = webPath + "/";

		String saveNm = f.getAttach_save_nm();
		if (saveNm == null || saveNm.trim().isEmpty()) return null;

		StringBuilder sb = new StringBuilder(base);
		for (String seg : webPath.split("/")) {
			if (seg.isEmpty()) continue;
			sb.append('/').append(enc(seg));
		}
		sb.append('/').append(enc(saveNm.trim()));
		return sb.toString();
	}

	private static String enc(String s) {
		try { return URLEncoder.encode(s, "UTF-8").replace("+", "%20"); }
		catch (Exception e) { return s; }
	}

	/* ------------------------------------------------------------------ 스트리밍 */

	/**
	 * 로컬에 파일이 없을 때 원격(운영) URL 에서 받아 응답으로 그대로 흘려보낸다.
	 * 성공하면 true. 폴백 미설정/비활성/원격 404/네트워크 오류면 false 를 돌려주고 응답에는 손대지 않는다
	 * (호출측이 기존 동작을 그대로 이어가게 하기 위함).
	 *
	 * @param inline true 면 Content-Disposition inline(미리보기), false 면 attachment(다운로드)
	 */
	public static boolean stream(FileVO f, HttpServletRequest request, HttpServletResponse response, boolean inline) {
		if (!isEnabled()) return false;
		String url = buildUrl(f);
		if (url == null) {
			logger.info("[AX Lab] 첨부 폴백 URL 조립 실패 attach_seq={} ord={}", f == null ? null : f.getAttach_seq(), f == null ? null : f.getAttach_ord());
			return false;
		}

		HttpURLConnection con = null;
		InputStream in = null;
		BufferedOutputStream out = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("GET");
			con.setConnectTimeout(confInt("combine.attach.fallback.connectTimeoutMs", 3000));
			con.setReadTimeout(confInt("combine.attach.fallback.readTimeoutMs", 60000));
			con.setInstanceFollowRedirects(true);
			con.setRequestProperty("User-Agent", "CIT_Lineus-AttachFallback");
			int code = con.getResponseCode();
			if (code != HttpURLConnection.HTTP_OK) {
				logger.info("[AX Lab] 첨부 폴백 원격 응답 {} : {}", code, url);
				return false;
			}

			String ct = con.getContentType();
			if (inline && ct != null && !ct.trim().isEmpty()) {
				response.setContentType(ct);
			} else {
				response.setHeader("Content-Type", "application/octet-stream");
				response.setHeader("Content-Transfer-Encoding", "binary");
			}
			long len = con.getContentLengthLong();
			if (len >= 0) response.setHeader("Content-Length", String.valueOf(len));
			response.setHeader("Content-Disposition", disposition(request, f.getAttach_ori_nm(), inline));
			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1");

			in = con.getInputStream();
			out = new BufferedOutputStream(response.getOutputStream());
			byte[] b = new byte[8192];
			int read;
			while ((read = in.read(b)) != -1) {
				out.write(b, 0, read);
			}
			out.flush();
			logger.info("[AX Lab] 첨부 폴백 전송 완료 attach_seq={} ord={} <- {}", f.getAttach_seq(), f.getAttach_ord(), url);
			return true;
		} catch (Exception e) {
			logger.warn("[AX Lab] 첨부 폴백 실패 {} : {}", url, e.toString());
			return false;
		} finally {
			try { if (in != null) in.close(); } catch (Exception ignore) {}
			try { if (out != null) out.close(); } catch (Exception ignore) {}
			if (con != null) con.disconnect();
		}
	}

	/** CommonFileController.fileDown 과 동일한 파일명 인코딩 규칙 (IE/Trident 는 URL 인코딩, 그 외 8859_1 변환) */
	static String disposition(HttpServletRequest request, String oriNm, boolean inline) {
		String type = inline ? "inline" : "attachment";
		String nm = (oriNm == null || oriNm.trim().isEmpty()) ? "download" : oriNm;
		try {
			String ua = request.getHeader("User-Agent");
			boolean ie = ua != null && (ua.contains("MSIE") || ua.contains("Trident"));
			if (ie) {
				return type + ";filename=" + URLEncoder.encode(nm, "UTF-8").replaceAll("\\+", "%20") + ";";
			}
			return type + "; filename=\"" + new String(nm.getBytes("UTF-8"), "8859_1") + "\"";
		} catch (Exception e) {
			return type;
		}
	}
}
