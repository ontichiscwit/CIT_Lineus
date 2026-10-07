package egovframework.com.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.util.CombineAsAiClient;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.CombineAsAiVO;
import egovframework.com.service.CombineAsAiService;

/**
 * [AX Lab] 신규 파일 (2026-10-06 AX Lab): AS 통합화면 AI 추천 서비스 구현.
 *
 * 흐름 (설계서 §5 A안 / §6):
 *   ① combineAsAiDAO.getAiContext 로 문의 원문·유형 명칭·부모/자식/연결 접수번호를 1회 조회
 *   ② exclude_as_no = {자신, 부모(CN_AS_NO), 자식들(CHILD_AS_NOS), 연결건(AS_NO_LINK)} 로 구성
 *      — 자신을 빼지 않으면 유사도 1.0 으로 자기 자신이 1위가 되고, 파생건들이 상위를 점령한다(§6)
 *   ③ CombineAsAiClient.recommend 로 추천 API 호출 (타임아웃·오류는 result 코드로만 전달)
 *   ④ 브라우저 응답 Map 구성 — cust_code / cust_nm 은 어디에도 넣지 않는다(§9-1)
 *
 * 질의 텍스트 마스킹은 CRM 에서 하지 않는다(확정 사항). 추천 API 가 1겹 정규식을 적용한 뒤 임베딩한다(§9 3-1).
 */
@Service("combineAsAiService")
public class CombineAsAiServiceImpl implements CombineAsAiService {

	private static final Logger logger = LoggerFactory.getLogger(CombineAsAiServiceImpl.class);

	/** 문의 원문이 이보다 짧으면 임베딩 품질이 없다고 보고 호출하지 않는다 (result 907) */
	private static final int MIN_QUERY_LEN = 5;
	/** 임베딩 입력 상한. bge-m3 는 truncate 하지만 네트워크 페이로드를 줄이기 위해 CRM 에서도 자른다 */
	private static final int MAX_QUERY_LEN = 4000;

	public static final String RESULT_NO_CASE   = "908";   // 접수건 없음
	public static final String RESULT_NO_QUERY  = "907";   // 문의 원문 없음/너무 짧음

	@Autowired CommonDao commonDAO;

	@Override
	public Map<String, Object> recommend(AsVO vo) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String asNo = SsStringUtil.normalizeNull(vo.getAs_no()).trim();

		CombineAsAiVO ctx = null;
		if (!asNo.isEmpty()) {
			ctx = (CombineAsAiVO) commonDAO.selectOne(vo, "combineAsAiDAO.getAiContext");
		}
		if (ctx == null) {
			return failMap(returnMap, asNo, RESULT_NO_CASE);
		}

		String query = SsStringUtil.normalizeNull(ctx.getCall_content()).trim();
		if (query.length() < MIN_QUERY_LEN) {
			return failMap(returnMap, asNo, RESULT_NO_QUERY);
		}
		if (query.length() > MAX_QUERY_LEN) query = query.substring(0, MAX_QUERY_LEN);

		CombineAsAiVO req = new CombineAsAiVO();
		req.setAs_no(asNo);
		req.setQuery(query);
		req.setExclude_as_no(buildExclude(asNo, ctx));
		req.setService_cate(SsStringUtil.normalizeNull(ctx.getService_cate_nm()).trim());
		req.setInquiry_type(SsStringUtil.normalizeNull(ctx.getInquiry_type_nm()).trim());
		req.setRequest_type(SsStringUtil.normalizeNull(ctx.getRequest_type_nm()).trim());
		req.setTop_k(5);

		CombineAsAiClient.recommend(req);

		returnMap.put("result", req.getResult());
		returnMap.put("elapsed_ms", req.getElapsed_ms());
		returnMap.put("items", req.getItems());
		returnMap.put("as_no", asNo);
		/* 제외한 접수번호는 화면 디버깅용으로 함께 내려준다(접수번호는 민감정보가 아니다). */
		returnMap.put("exclude_as_no", req.getExclude_as_no());
		return returnMap;
	}

	/** 자신 / 부모 / 자식 / 연결건 — 중복 제거, 입력 순서 유지 */
	static List<String> buildExclude(String asNo, CombineAsAiVO ctx) {
		Set<String> set = new LinkedHashSet<String>();
		addNo(set, asNo);
		addNo(set, ctx.getCn_as_no());
		for (String c : SsStringUtil.normalizeNull(ctx.getChild_as_nos()).split(",")) addNo(set, c);
		for (String l : SsStringUtil.normalizeNull(ctx.getAs_no_link()).split("[,;\\s]+")) addNo(set, l);
		return new ArrayList<String>(set);
	}

	private static void addNo(Set<String> set, String no) {
		if (no == null) return;
		no = no.trim();
		if (!no.isEmpty()) set.add(no);
	}

	private static Map<String, Object> failMap(Map<String, Object> m, String asNo, String code) {
		m.put("result", code);
		m.put("elapsed_ms", 0);
		m.put("items", new ArrayList<Map<String, Object>>());
		m.put("as_no", asNo);
		logger.info("[AX Lab] AI 추천 생략 as_no={} code={}", asNo, code);
		return m;
	}
}
