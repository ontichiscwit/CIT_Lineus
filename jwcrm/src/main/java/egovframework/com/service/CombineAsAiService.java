package egovframework.com.service;

import java.util.Map;

import egovframework.com.model.AsVO;

/**
 * [AX Lab] 신규 파일 (2026-10-06 AX Lab): AS 통합화면 AI 추천 서비스 인터페이스.
 *
 * AdAsController.getAsInfo(pageType=aiRecommend) 가 호출한다.
 * 기존 AsService 를 확장하지 않고 분리한 이유: AsService 는 운영 중인 AS 등록/수정 로직의 집합이라
 * 외부 HTTP 호출이 섞이면 장애 격리가 어렵다. 추천은 실패해도 AS 화면이 멀쩡해야 한다.
 */
public interface CombineAsAiService {

	/**
	 * 접수번호 기준으로 CRM DB 에서 문의 원문/유형/제외 대상을 모아 추천 API 를 호출한다.
	 *
	 * @param vo as_no 가 채워진 AsVO (브라우저 파라미터)
	 * @return 브라우저로 그대로 내려보낼 응답 Map — result / elapsed_ms / items (§6 응답 스키마)
	 *         실패 시에도 예외 없이 result != "000" 과 빈 items 를 돌려준다.
	 */
	public Map<String, Object> recommend(AsVO vo) throws Exception;

	// [AX Lab] 수정 시작 (2026-10-19 AX Lab): AI 문장 다듬기
	/**
	 * 작성 중인 고객 답변 본문을 추천 서버의 LLM(POST /api/polish)으로 다듬는다.
	 * AdAsController.getAsInfo(pageType=aiPolish) 가 호출한다.
	 *
	 * @param vo   as_no 가 채워진 AsVO (로그용 — 본문은 로그에 남기지 않는다)
	 * @param text 다듬을 본문 (request 파라미터 text — AsVO 필드를 늘리지 않기 위해 따로 받는다)
	 * @param tone polite | brief | typo
	 * @return 브라우저로 그대로 내려보낼 Map — result / text / tone / model / elapsed_ms / warnings
	 *         실패 시에도 예외 없이 result != "000" 과 빈 text 를 돌려준다. 화면은 로컬 규칙으로 대체한다.
	 */
	public Map<String, Object> polish(AsVO vo, String text, String tone) throws Exception;
	// [AX Lab] 수정 끝
}
