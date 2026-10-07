package egovframework.com.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * [AX Lab] 신규 파일 (2026-10-06 AX Lab): AS 통합화면 AI 추천 — 추천 API 요청/응답 매핑 VO.
 *
 * 설계서 mdfile/AS통합화면_AI추천_통합설계.md §6 의 요청/응답 계약을 그대로 옮긴 것이다.
 *  - 요청 쪽 필드(query / exclude_as_no / service_cate …)는 CombineAsAiServiceImpl 이
 *    CRM DB(combineAsAiDAO.getAiContext)에서 채운다. 브라우저가 보내는 값은 as_no 뿐이다.
 *  - 응답 쪽 items 는 챗봇 서버가 내려주는 JSON 을 그대로 통과시킨다(Map 리스트).
 *    필드가 늘어도 CRM 코드를 다시 컴파일할 필요가 없게 하기 위해서다.
 *  - cust_code / cust_nm 은 요청에도 응답에도 싣지 않는다(§9-1 거래처 간 격리).
 *
 * ※ 이 클래스는 MyBatis resultType("combineAsAiVO", typeAliasesPackage=egovframework.com) 으로도 쓰인다.
 *    getAiContext 쿼리의 컬럼 라벨(CALL_CONTENT / SERVICE_CATE_NM …)과 setter 이름이 맞아야 한다.
 */
public class CombineAsAiVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/* ---------- 요청 (CRM → 추천 API) ---------- */
	private String as_no = "";
	private String query = "";                               // CALL_CONTENT 원문. 마스킹은 추천 API 쪽 1겹 정규식이 담당(§9 3-1)
	private List<String> exclude_as_no = new ArrayList<String>();
	private String service_cate = "";                        // 코드명 (예: 진료) — 코드값이 아니라 명칭을 보낸다
	private String inquiry_type = "";
	private String request_type = "";
	private String program_nm = "";
	private String screen_nm = "";
	private int top_k = 5;
	private List<Integer> tiers = null;                      // null 이면 서버 기본(1,2,3)

	/* ---------- DB 컨텍스트 (combineAsAiDAO.getAiContext 결과) ---------- */
	private String call_content = "";
	private String cn_as_no = "";
	private String as_no_link = "";
	private String child_as_nos = "";                        // 자식 접수번호 콤마 연결 (LISTAGG)
	private String service_cate_nm = "";
	private String inquiry_type_nm = "";
	private String request_type_nm = "";

	/* ---------- 응답 (추천 API → CRM → 브라우저) ---------- */
	private String result = "";                              // "000" 정상. 그 외는 실패 코드(§6 실패 처리)
	private long elapsed_ms = 0L;
	private List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
	private String message = "";                             // 실패 사유(운영 로그용 요약). 브라우저에는 노출하지 않아도 된다

	public String getAs_no() { return as_no; }
	public void setAs_no(String as_no) { this.as_no = as_no; }
	public String getQuery() { return query; }
	public void setQuery(String query) { this.query = query; }
	public List<String> getExclude_as_no() { return exclude_as_no; }
	public void setExclude_as_no(List<String> exclude_as_no) { this.exclude_as_no = exclude_as_no; }
	public String getService_cate() { return service_cate; }
	public void setService_cate(String service_cate) { this.service_cate = service_cate; }
	public String getInquiry_type() { return inquiry_type; }
	public void setInquiry_type(String inquiry_type) { this.inquiry_type = inquiry_type; }
	public String getRequest_type() { return request_type; }
	public void setRequest_type(String request_type) { this.request_type = request_type; }
	public String getProgram_nm() { return program_nm; }
	public void setProgram_nm(String program_nm) { this.program_nm = program_nm; }
	public String getScreen_nm() { return screen_nm; }
	public void setScreen_nm(String screen_nm) { this.screen_nm = screen_nm; }
	public int getTop_k() { return top_k; }
	public void setTop_k(int top_k) { this.top_k = top_k; }
	public List<Integer> getTiers() { return tiers; }
	public void setTiers(List<Integer> tiers) { this.tiers = tiers; }

	public String getCall_content() { return call_content; }
	public void setCall_content(String call_content) { this.call_content = call_content; }
	public String getCn_as_no() { return cn_as_no; }
	public void setCn_as_no(String cn_as_no) { this.cn_as_no = cn_as_no; }
	public String getAs_no_link() { return as_no_link; }
	public void setAs_no_link(String as_no_link) { this.as_no_link = as_no_link; }
	public String getChild_as_nos() { return child_as_nos; }
	public void setChild_as_nos(String child_as_nos) { this.child_as_nos = child_as_nos; }
	public String getService_cate_nm() { return service_cate_nm; }
	public void setService_cate_nm(String service_cate_nm) { this.service_cate_nm = service_cate_nm; }
	public String getInquiry_type_nm() { return inquiry_type_nm; }
	public void setInquiry_type_nm(String inquiry_type_nm) { this.inquiry_type_nm = inquiry_type_nm; }
	public String getRequest_type_nm() { return request_type_nm; }
	public void setRequest_type_nm(String request_type_nm) { this.request_type_nm = request_type_nm; }

	public String getResult() { return result; }
	public void setResult(String result) { this.result = result; }
	public long getElapsed_ms() { return elapsed_ms; }
	public void setElapsed_ms(long elapsed_ms) { this.elapsed_ms = elapsed_ms; }
	public List<Map<String, Object>> getItems() { return items; }
	public void setItems(List<Map<String, Object>> items) { this.items = items; }
	public String getMessage() { return message; }
	public void setMessage(String message) { this.message = message; }
}
