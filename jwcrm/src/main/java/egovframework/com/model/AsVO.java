package egovframework.com.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("asVO")
public class AsVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 8270977273658995518L;
	
	private String search_as = "" ;
	
	private String as_no = "" ;
	private String as_no2 = "" ;
	private String cn_as_no = "" ;
	private String as_no_link = "" ;
	private String as_no_link_count = "" ;
	private String as_no_link_grp = "" ;
	private String accept_dt = "" ;
	private String as_complete_dt = "" ;
	private String as_accept_dt = "" ;
	private String as_proc_dt = "" ;
	private String accept_time = "" ;
	private String accept_route = "" ;
	private String cust_code = "" ;
	
	private String cust_nm="";
	private String cust_address="";
	
	private String apply_nm = "" ;
	private String apply_id = "" ;
	private String apply_tel = "" ;
	private String service_cate = "" ;
	private String inquiry_service = "" ;
	private String version_info = "" ;
	private String inquiry_type = "" ;
	private String call_content = "" ;
	private String file_seq = "" ;
	private String proc_dt = "" ;
	private String proc_time = "" ;
	private String inportance = "" ;
	private String inportance_nm = "" ;
	private String cause_type = "" ;
	private String cause_type_nm = "" ;
	private String action_type = "" ;
	private String action_type_nm = "" ;
	private String assign_id = "" ;
	private String chg_assign_id = "" ;
	private String assign_nm = "";
	private String proc_status = "" ;
	private String proc_status2 = "" ;
	private String proc_status_nm = "" ;
	private String action_content = "" ;
	private String action_content2 = "" ;
	private String happy_call_yn = "" ;
	private String cust_kor_name = "" ;
	private String file_cnt = "";
	private String send_sms = "";
	private String template_code = "";
	private String alimTalk_message = "";
	private String sms_message = "";
	private String alimTalk_btn = "";
	private String mobile_no = "";
	private int cnt = 0;
	private String change_yn = "";
	private String init_yn = "";
	
	private String success_yn = "";
	private String check_yn = "";
	
	/* 보이스봇 연속실패 여부 */
	private String flc_yn = "";
	
	/* 보이스봇 중단시점 */
	private String break_point_nm = "";
	
	private String service_cate_nm = "";
	private String inquiry_type_nm = "";
	
	
	private String request_type = "" ;
	private String request_type_nm = "" ;
	
	
	private String star_state_date = "";
	
	/* 요청내용 */
	private String request_content = "";
	
	/* 고객평가 */
	private String star_state = "";
	private String star_content = "";
	
	private String emp_no = "" ; 
	private String emp_nm = "" ; 
	private String dept_cd = "" ;
	private String dept_nm = "" ;
	private String part_type = "" ; 
	
	private String delAttach2 = "" ; 
	private String delAttach1 = "" ; 
	
	private String w_id = "" ;
	private String w_content = "" ;	 
	private String w_content_pop = "" ;	
	private String w_date = "" ;
	private String w_gubun = "" ;
	private String a_seq = "" ;
	private String seq = "";
	private String aws_cnt = "";
	private String total_aws_cnt = "";
	private String emp_name = "" ; 
	private String star_state_id = "" ; 
	private String cn_count = "" ; 
	private String starRate = "" ; 
	private String tel_no = "" ; 
	
	private String del_as_no = "";
	private String search_gubun = "";
	
	private String del_type = "";
	
	// 20171113 박승모 추가
	private String accept_route_nm = "";
	private String last_coment = "";
	
	//20171212 김민지 추가 (조치이력 등록자이름)
	private String reg_nm = "";
	private String attach2_flag = "";
	private String attach3_flag = "";
	private String once_flag = "";
	
	private String complete_dt = "";
	
	
	Map<String , Object> amap = new HashMap<String , Object>() ;
	Map<String , Object> attach_list1 = new HashMap<String , Object>() ;
	Map<String , Object> attach_list2 = new HashMap<String , Object>() ;
	Map<String , Object> attach_list3 = new HashMap<String , Object>() ;
	Map<String , Object> answer_list = new HashMap<String , Object>() ;
	
	
	private String[] procSelectArray = null ; 
	private String procSelect;
		
	
	
	//답변 검색
	private String aw_search_start1 = "";
	private String aw_search_start2 = "";
	private String aw_search_end1 = "";
	private String aw_search_end2 = "";
	private String aw_gubun = "";
	private String aw_search_text3 ="";
	private String aw_search_text4 ="";
	private String aw_search_text5 ="";
	private String aw_search_type1 ="";
	private String aw_search_type2 ="";
	private String w_nm ="";
	private String aw_gubun2 = "";
	private String aw_gubun3 = "";
	private String w_an_date = "";
	
	private String acceptor = "";
	private String acceptor_nm = "";
	private String save_gubun = "";
	private String work_time ="";
	
	
	private String rl_apply_nm = "";
	
	private String tel_confirm = "";
	private String tel_absence = "";
	private String tel_absence_cnt = "";
	
	private String val1 = "";
	private String val2 = "";
	private String val3 = "";
	private String val4 = "";
	private String val5 = "";
	
	
	private String wk_emp_no = "" ; 
	private String wk_emp_nm = "" ; 
	private String as_admin = "" ;
	
	private String priority = "" ;
	
	private String chatbot_id = "" ;
	
	private String proc_gubun ="";
	private String proc_gubun_nm ="";
	private String proc_build_info ="";
	private String proc_test_info ="";
	private String proc_process_sp ="";
	private String proc_screen_sp ="";
	private String proc_table_sp ="";
	private String proc_function_sp ="";
	private String proc_interface_sp ="";
	
	private String sender_email ="";
	private String retire_yn ="";	
	
	// [AX Lab] 수정 시작 (2026-07-24 AX Lab): AS 통합검색 - 처리구분(나의/전체 A/S) + 고급 동적 검색조건(AND 중복)
	/** 처리구분: "2"=나의 A/S(담당자=로그인계정), ""=전체 A/S */
	private String asGubunFlag = "";
	/** 나의 A/S 필터용 로그인 사용자 사번(=CRM_AS_MGT.ASSIGN_ID) */
	private String user_id = "";
	/** 고급 동적필터 검색구분 키 배열 (예: AS_NO, EMP_NM, CAUSE_TYPE, PROC_DT ...) */
	private String[] adv_field;
	/** 고급 동적필터 값 배열 (키워드/선택코드/날짜 시작일). adv_field 와 인덱스 정렬 */
	private String[] adv_value;
	/** 고급 동적필터 보조값 배열 (날짜형의 종료일). adv_field 와 인덱스 정렬 */
	private String[] adv_value2;
	/** 컨트롤러에서 adv_field/adv_value/adv_value2 를 조립한 쿼리용 조건 목록 (field/value/value2) */
	private List<Map<String, String>> advFilterList;
	/** 화면 재구성용 고급필터 JSON (리로드 시 동적행 복원) */
	private String advFiltersJson = "[]";

	public String getAsGubunFlag() {
		return asGubunFlag;
	}
	public void setAsGubunFlag(String asGubunFlag) {
		this.asGubunFlag = asGubunFlag;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String[] getAdv_field() {
		return adv_field;
	}
	public void setAdv_field(String[] adv_field) {
		this.adv_field = adv_field;
	}
	public String[] getAdv_value() {
		return adv_value;
	}
	public void setAdv_value(String[] adv_value) {
		this.adv_value = adv_value;
	}
	public String[] getAdv_value2() {
		return adv_value2;
	}
	public void setAdv_value2(String[] adv_value2) {
		this.adv_value2 = adv_value2;
	}
	public List<Map<String, String>> getAdvFilterList() {
		return advFilterList;
	}
	public void setAdvFilterList(List<Map<String, String>> advFilterList) {
		this.advFilterList = advFilterList;
	}
	public String getAdvFiltersJson() {
		return advFiltersJson;
	}
	public void setAdvFiltersJson(String advFiltersJson) {
		this.advFiltersJson = advFiltersJson;
	}
	// [AX Lab] 수정 끝

	// [AX Lab] 수정 시작 (2026-07-29 AX Lab): AS 목록 컬럼 개편(거래상태/첨부여부 표식 + 헤더클릭 정렬)
	/** 거래상태 코드 (CRM_CUST_OPERATE_INFO.DEAL_CODE) C003:해지 C004:폐업 C005:중지 */
	private String deal_code = "";
	/** 거래상태 명칭 (공통코드 CUST/CD03) */
	private String deal_code_nm = "";
	/** 첨부파일 보유여부 'Y'/'N' (접수첨부 FILE_SEQ + 조치첨부 ATTACH_SEQ2 기준) */
	private String has_file = "";

	/** 화면이 보낸 정렬 컬럼 키 (예: accept_dt). 화면 복원용이며 SQL 에는 쓰지 않는다. */
	private String sort_col = "";
	/** 화면이 보낸 정렬 방향 (ASC/DESC). 화면 복원용. */
	private String sort_dir = "";

	/* 아래 두 값은 egov-as-query.xml 의 getAsList 에서 ${} 문자열 치환으로 SQL 에 직접 박힌다.
	   반드시 AdAsController.applyAsSort() 의 화이트리스트를 통과한 값만 넣어야 한다.
	   기본값(AS_NO / DESC / ASC)은 정렬 미지정 시 개편 전과 완전히 동일한 쿼리가 되도록 맞춘 것이며,
	   applyAsSort() 를 호출하지 않는 경로가 생기더라도 쿼리가 깨지지 않게 하는 안전장치이기도 하다. */
	/** 정렬 대상 컬럼명 (테이블 별칭 없는 순수 컬럼명) */
	private String sort_expr = "AS_NO";
	/** 최종 출력 정렬 방향 */
	private String sort_dir_sql = "DESC";
	/** ROW_NUMBER 채번용 역방향 (sort_dir_sql 의 반대). 역순 RNUM 페이징 구조상 필수 */
	private String sort_dir_inv = "ASC";

	public String getDeal_code() {
		return deal_code;
	}
	public void setDeal_code(String deal_code) {
		this.deal_code = deal_code;
	}
	public String getDeal_code_nm() {
		return deal_code_nm;
	}
	public void setDeal_code_nm(String deal_code_nm) {
		this.deal_code_nm = deal_code_nm;
	}
	public String getHas_file() {
		return has_file;
	}
	public void setHas_file(String has_file) {
		this.has_file = has_file;
	}
	public String getSort_col() {
		return sort_col;
	}
	public void setSort_col(String sort_col) {
		this.sort_col = sort_col;
	}
	public String getSort_dir() {
		return sort_dir;
	}
	public void setSort_dir(String sort_dir) {
		this.sort_dir = sort_dir;
	}
	public String getSort_expr() {
		return sort_expr;
	}
	public void setSort_expr(String sort_expr) {
		this.sort_expr = sort_expr;
	}
	public String getSort_dir_sql() {
		return sort_dir_sql;
	}
	public void setSort_dir_sql(String sort_dir_sql) {
		this.sort_dir_sql = sort_dir_sql;
	}
	public String getSort_dir_inv() {
		return sort_dir_inv;
	}
	public void setSort_dir_inv(String sort_dir_inv) {
		this.sort_dir_inv = sort_dir_inv;
	}
	// [AX Lab] 수정 끝

	
	public String getOnce_flag() {
		return once_flag;
	}

	public void setOnce_flag(String once_flag) {
		this.once_flag = once_flag;
	}

	public Map<String, Object> getAnswer_list() {
		return answer_list;
	}

	public void setAnswer_list(Map<String, Object> answer_list) {
		this.answer_list = answer_list;
	}

	public String getAttach3_flag() {
		return attach3_flag;
	}

	public void setAttach3_flag(String attach3_flag) {
		this.attach3_flag = attach3_flag;
	}

	public String getSave_gubun() {
		return save_gubun;
	}

	public void setSave_gubun(String save_gubun) {
		this.save_gubun = save_gubun;
	}

	public String getAttach2_flag() {
		return attach2_flag;
	}

	public void setAttach2_flag(String attach2_flag) {
		this.attach2_flag = attach2_flag;
	}

	public String getAcceptor() {
		return acceptor;
	}

	public void setAcceptor(String acceptor) {
		this.acceptor = acceptor;
	}

	public String getAcceptor_nm() {
		return acceptor_nm;
	}

	public void setAcceptor_nm(String acceptor_nm) {
		this.acceptor_nm = acceptor_nm;
	}

	public String getCust_nm() {
		return cust_nm;
	}

	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}

	public String getCust_address() {
		return cust_address;
	}

	public void setCust_address(String cust_address) {
		this.cust_address = cust_address;
	}

	public String getW_an_date() {
		return w_an_date;
	}

	public void setW_an_date(String w_an_date) {
		this.w_an_date = w_an_date;
	}

	public String getAw_gubun3() {
		return aw_gubun3;
	}

	public void setAw_gubun3(String aw_gubun3) {
		this.aw_gubun3 = aw_gubun3;
	}
	
	
	public String getAw_gubun2() {
		return aw_gubun2;
	}

	public void setAw_gubun2(String aw_gubun2) {
		this.aw_gubun2 = aw_gubun2;
	}

	public String getW_nm() {
		return w_nm;
	}

	public void setW_nm(String w_nm) {
		this.w_nm = w_nm;
	}

	public String getAw_search_type1() {
		return aw_search_type1;
	}

	public void setAw_search_type1(String aw_search_type1) {
		this.aw_search_type1 = aw_search_type1;
	}

	public String getAw_search_type2() {
		return aw_search_type2;
	}

	public void setAw_search_type2(String aw_search_type2) {
		this.aw_search_type2 = aw_search_type2;
	}

	public String getAw_search_start1() {
		return aw_search_start1;
	}

	public void setAw_search_start1(String aw_search_start1) {
		this.aw_search_start1 = aw_search_start1;
	}

	public String getAw_search_start2() {
		return aw_search_start2;
	}

	public void setAw_search_start2(String aw_search_start2) {
		this.aw_search_start2 = aw_search_start2;
	}

	public String getAw_search_end1() {
		return aw_search_end1;
	}

	public void setAw_search_end1(String aw_search_end1) {
		this.aw_search_end1 = aw_search_end1;
	}

	public String getAw_search_end2() {
		return aw_search_end2;
	}

	public void setAw_search_end2(String aw_search_end2) {
		this.aw_search_end2 = aw_search_end2;
	}

	public String getAw_gubun() {
		return aw_gubun;
	}

	public void setAw_gubun(String aw_gubun) {
		this.aw_gubun = aw_gubun;
	}

	public String getAw_search_text3() {
		return aw_search_text3;
	}

	public void setAw_search_text3(String aw_search_text3) {
		this.aw_search_text3 = aw_search_text3;
	}

	public String getAw_search_text4() {
		return aw_search_text4;
	}

	public void setAw_search_text4(String aw_search_text4) {
		this.aw_search_text4 = aw_search_text4;
	}

	public String getAw_search_text5() {
		return aw_search_text5;
	}

	public void setAw_search_text5(String aw_search_text5) {
		this.aw_search_text5 = aw_search_text5;
	}

	public Map<String, Object> getAmap() {
		return amap;
	}

	public void setAmap(Map<String, Object> amap) {
		this.amap = amap;
	}
	
	
	public Map<String, Object> getAttach_list1() {
		return attach_list1;
	}

	public void setAttach_list1(Map<String, Object> attach_list1) {
		this.attach_list1 = attach_list1;
	}

	public Map<String, Object> getAttach_list2() {
		return attach_list2;
	}

	public void setAttach_list2(Map<String, Object> attach_list2) {
		this.attach_list2 = attach_list2;
	}

	
		
	
	public Map<String, Object> getAttach_list3() {
		return attach_list3;
	}

	public void setAttach_list3(Map<String, Object> attach_list3) {
		this.attach_list3 = attach_list3;
	}

	public String getLast_coment() {
		return last_coment;
	}

	public void setLast_coment(String last_coment) {
		this.last_coment = last_coment;
	}

	public String getAccept_route_nm() {
		return accept_route_nm;
	}

	public void setAccept_route_nm(String accept_route_nm) {
		this.accept_route_nm = accept_route_nm;
	}

	private List<AsVO> OUTCURSOR = null ;

	
	public String getSearch_gubun() {
		return search_gubun;
	}

	public void setSearch_gubun(String search_gubun) {
		this.search_gubun = search_gubun;
	}

	public String getChg_assign_id() {
		return chg_assign_id;
	}

	public void setChg_assign_id(String chg_assign_id) {
		this.chg_assign_id = chg_assign_id;
	}

	public String getDel_as_no() {
		return del_as_no;
	}

	public void setDel_as_no(String del_as_no) {
		this.del_as_no = del_as_no;
	}
	
	public String getDel_type() {
		return del_type;
	}

	public void setDel_type(String del_type) {
		this.del_type = del_type;
	}

	public String getTel_no() {
		return tel_no;
	}

	public void setTel_no(String tel_no) {
		this.tel_no = tel_no;
	}

	public String getAs_no2() {
		return as_no2;
	}

	public void setAs_no2(String as_no2) {
		this.as_no2 = as_no2;
	}

	public String getProc_status2() {
		return proc_status2;
	}

	public void setProc_status2(String proc_status2) {
		this.proc_status2 = proc_status2;
	}

	public String getStarRate() {
		return starRate;
	}

	public void setStarRate(String starRate) {
		this.starRate = starRate;
	}

	public String getCn_count() {
		return cn_count;
	}

	public void setCn_count(String cn_count) {
		this.cn_count = cn_count;
	}

	public String getStar_state_id() {
		return star_state_id;
	}

	public void setStar_state_id(String star_state_id) {
		this.star_state_id = star_state_id;
	}

	public String getEmp_name() {
		return emp_name;
	}

	public void setEmp_name(String emp_name) {
		this.emp_name = emp_name;
	}

	public String getAws_cnt() {
		return aws_cnt;
	}

	public void setAws_cnt(String aws_cnt) {
		this.aws_cnt = aws_cnt;
	}
	
	public String getTotal_aws_cnt() {
		return total_aws_cnt;
	}

	public void setTotal_aws_cnt(String total_aws_cnt) {
		this.total_aws_cnt = total_aws_cnt;
	}


	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getW_id() {
		return w_id;
	}

	public void setW_id(String w_id) {
		this.w_id = w_id;
	}

	public String getW_content() {
		return w_content;
	}

	public void setW_content(String w_content) {
		this.w_content = w_content;
	}
	
	public String getW_content_pop() {
		return w_content_pop;
	}

	public void setW_content_pop(String w_content_pop) {
		this.w_content_pop = w_content_pop;
	}

	public String getW_date() {
		return w_date;
	}

	public void setW_date(String w_date) {
		this.w_date = w_date;
	}

	public String getW_gubun() {
		return w_gubun;
	}

	public void setW_gubun(String w_gubun) {
		this.w_gubun = w_gubun;
	}

	public String getA_seq() {
		return a_seq;
	}

	public void setA_seq(String a_seq) {
		this.a_seq = a_seq;
	}

	public String getDelAttach2() {
		return delAttach2;
	}

	public void setDelAttach2(String delAttach2) {
		this.delAttach2 = delAttach2;
	}

	public String getDelAttach1() {
		return delAttach1;
	}

	public void setDelAttach1(String delAttach1) {
		this.delAttach1 = delAttach1;
	}

	public String getEmp_no() {
		return emp_no;
	}

	public void setEmp_no(String emp_no) {
		this.emp_no = emp_no;
	}

	public String getEmp_nm() {
		return emp_nm;
	}

	public void setEmp_nm(String emp_nm) {
		this.emp_nm = emp_nm;
	}
	
	public String getDept_cd() {
		return dept_cd;
	}

	public void setDept_cd(String dept_cd) {
		this.dept_cd = dept_cd;
	}
	
	public String getDept_nm() {
		return dept_nm;
	}

	public void setDept_nm(String dept_nm) {
		this.dept_nm = dept_nm;
	}
	
	public String getReg_nm() {
		return reg_nm;
	}

	public void setReg_nm(String reg_nm) {
		this.reg_nm = reg_nm;
	}
	
	public String getService_cate_nm() {
		return service_cate_nm;
	}

	public void setService_cate_nm(String service_cate_nm) {
		this.service_cate_nm = service_cate_nm;
	}

	public String getInquiry_type_nm() {
		return inquiry_type_nm;
	}

	public void setInquiry_type_nm(String inquiry_type_nm) {
		this.inquiry_type_nm = inquiry_type_nm;
	}

	public String getStar_state_date() {
		return star_state_date;
	}

	public void setStar_state_date(String star_state_date) {
		this.star_state_date = star_state_date;
	}

	public String getFile_cnt() {
		return file_cnt;
	}

	public void setFile_cnt(String file_cnt) {
		this.file_cnt = file_cnt;
	}

	public String getRequest_content() {
		return request_content;
	}

	public void setRequest_content(String request_content) {
		this.request_content = request_content;
	}

	public String getStar_state() {
		return star_state;
	}

	public void setStar_state(String star_state) {
		this.star_state = star_state;
	}

	public String getStar_content() {
		return star_content;
	}

	public void setStar_content(String star_content) {
		this.star_content = star_content;
	}

	public List<AsVO> getOUTCURSOR() {
		return OUTCURSOR;
	}

	public void setOUTCURSOR(List<AsVO> oUTCURSOR) {
		OUTCURSOR = oUTCURSOR;
	}

	public String getInportance_nm() {
		return inportance_nm;
	}

	public void setInportance_nm(String inportance_nm) {
		this.inportance_nm = inportance_nm;
	}

	public String getCause_type_nm() {
		return cause_type_nm;
	}

	public void setCause_type_nm(String cause_type_nm) {
		this.cause_type_nm = cause_type_nm;
	}

	public String getAction_type_nm() {
		return action_type_nm;
	}

	public void setAction_type_nm(String action_type_nm) {
		this.action_type_nm = action_type_nm;
	}

	public String getAssign_nm() {
		return assign_nm;
	}

	public void setAssign_nm(String assign_nm) {
		this.assign_nm = assign_nm;
	}

	public String getProc_status_nm() {
		return proc_status_nm;
	}

	public void setProc_status_nm(String proc_status_nm) {
		this.proc_status_nm = proc_status_nm;
	}

	public String getCust_kor_name() {
		return cust_kor_name;
	}

	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}

	public String getSearch_as() {
		return search_as;
	}

	public void setSearch_as(String search_as) {
		this.search_as = search_as;
	}

	public String getAs_no() {
		return as_no;
	}

	public void setAs_no(String as_no) {
		this.as_no = as_no;
	}

	public String getCn_as_no() {
		return cn_as_no;
	}

	public void setCn_as_no(String cn_as_no) {
		this.cn_as_no = cn_as_no;
	}
	
	public String getAs_no_link() {
		return as_no_link;
	}

	public void setAs_no_link(String as_no_link) {
		this.as_no_link = as_no_link;
	}
	
	public String getAs_no_link_count() {
		return as_no_link_count;
	}

	public void setAs_no_link_count(String as_no_link_count) {
		this.as_no_link_count = as_no_link_count;
	}
	
	public String getAs_no_link_grp() {
		return as_no_link_grp;
	}

	public void setAs_no_link_grp(String as_no_link_grp) {
		this.as_no_link_grp = as_no_link_grp;
	}

	public String getAccept_dt() {
		return accept_dt;
	}

	public void setAccept_dt(String accept_dt) {
		this.accept_dt = accept_dt;
	}
	
	/*접수완료일 추가*/
	
	
	public String getAs_complete_dt() {
		return as_complete_dt;
	}

	public void setAs_complete_dt(String as_complete_dt) {
		this.as_complete_dt = as_complete_dt;
	}
	
	/*접수일 추가*/
	
	
	public String getAs_accept_dt() {
		return as_accept_dt;
	}

	public void setAs_accept_dt(String as_accept_dt) {
		this.as_accept_dt = as_accept_dt;
	}
	
	/*처리완료예정일 추가*/
	
	
	public String getAs_proc_dt() {
		return as_proc_dt;
	}

	public void setAs_proc_dt(String as_proc_dt) {
		this.as_proc_dt = as_proc_dt;
	}

	
	
	

	public String getAccept_time() {
		return accept_time;
	}

	public void setAccept_time(String accept_time) {
		this.accept_time = accept_time;
	}

	public String getAccept_route() {
		return accept_route;
	}

	public void setAccept_route(String accept_route) {
		this.accept_route = accept_route;
	}

	public String getCust_code() {
		return cust_code;
	}

	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}

	public String getApply_nm() {
		return apply_nm;
	}

	public void setApply_nm(String apply_nm) {
		this.apply_nm = apply_nm;
	}

	public String getApply_id() {
		return apply_id;
	}

	public void setApply_id(String apply_id) {
		this.apply_id = apply_id;
	}

	public String getApply_tel() {
		return apply_tel;
	}

	public void setApply_tel(String apply_tel) {
		this.apply_tel = apply_tel;
	}

	public String getService_cate() {
		return service_cate;
	}

	public void setService_cate(String service_cate) {
		this.service_cate = service_cate;
	}

	public String getInquiry_service() {
		return inquiry_service;
	}

	public void setInquiry_service(String inquiry_service) {
		this.inquiry_service = inquiry_service;
	}

	public String getVersion_info() {
		return version_info;
	}

	public void setVersion_info(String version_info) {
		this.version_info = version_info;
	}

	public String getInquiry_type() {
		return inquiry_type;
	}

	public void setInquiry_type(String inquiry_type) {
		this.inquiry_type = inquiry_type;
	}

	public String getCall_content() {
		return call_content;
	}

	public void setCall_content(String call_content) {
		this.call_content = call_content;
	}

	public String getFile_seq() {
		return file_seq;
	}

	public void setFile_seq(String file_seq) {
		this.file_seq = file_seq;
	}

	public String getProc_dt() {
		return proc_dt;
	}

	public void setProc_dt(String proc_dt) {
		this.proc_dt = proc_dt;
	}

	public String getProc_time() {
		return proc_time;
	}

	public void setProc_time(String proc_time) {
		this.proc_time = proc_time;
	}

	public String getInportance() {
		return inportance;
	}

	public void setInportance(String inportance) {
		this.inportance = inportance;
	}

	public String getCause_type() {
		return cause_type;
	}

	public void setCause_type(String cause_type) {
		this.cause_type = cause_type;
	}

	public String getAction_type() {
		return action_type;
	}

	public void setAction_type(String action_type) {
		this.action_type = action_type;
	}

	public String getAssign_id() {
		return assign_id;
	}

	public void setAssign_id(String assign_id) {
		this.assign_id = assign_id;
	}

	public String getProc_status() {
		return proc_status;
	}

	public void setProc_status(String proc_status) {
		this.proc_status = proc_status;
	}

	public String getAction_content() {
		return action_content;
	}

	public void setAction_content(String action_content) {
		this.action_content = action_content;
	}
	
	public String getAction_content2() {
		return action_content2;
	}

	public void setAction_content2(String action_content2) {
		this.action_content2 = action_content2;
	}

	public String getHappy_call_yn() {
		return happy_call_yn;
	}

	public void setHappy_call_yn(String happy_call_yn) {
		this.happy_call_yn = happy_call_yn;
	}

	public String getWork_time() {
		return work_time;
	}

	public void setWork_time(String work_time) {
		this.work_time = work_time;
	}
	
	public String getPart_type() {
		return part_type;
	}

	public void setPart_type(String part_type) {
		this.part_type = part_type;
	}
	
	public String getComplete_dt() {
		return complete_dt;
	}

	public void setComplete_dt(String complete_dt) {
		this.complete_dt = complete_dt;
	}
	
	public String getRl_apply_nm() {
		return rl_apply_nm;
	}

	public void setRl_apply_nm(String rl_apply_nm) {
		this.rl_apply_nm = rl_apply_nm;
	}
	
	public String getTel_confirm() {
		return tel_confirm;
	}

	public void setTel_confirm(String tel_confirm) {
		this.tel_confirm = tel_confirm;
	}
	
	public String getTel_absence() {
		return tel_absence;
	}

	public void setTel_absence(String tel_absence) {
		this.tel_absence = tel_absence;
	}
	
	public String getTel_absence_cnt() {
		return tel_absence_cnt;
	}

	public void setTel_absence_cnt(String tel_absence_cnt) {
		this.tel_absence_cnt = tel_absence_cnt;
	}

	public String getSend_sms() {
		return send_sms;
	}

	public void setSend_sms(String send_sms) {
		this.send_sms = send_sms;
	}

	public String getTemplate_code() {
		return template_code;
	}

	public void setTemplate_code(String template_code) {
		this.template_code = template_code;
	}

	public String getSms_message() {
		return sms_message;
	}

	public void setSms_message(String sms_message) {
		this.sms_message = sms_message;
	}

	public String getAlimTalk_message() {
		return alimTalk_message;
	}

	public void setAlimTalk_message(String alimTalk_message) {
		this.alimTalk_message = alimTalk_message;
	}

	public String getAlimTalk_btn() {
		return alimTalk_btn;
	}

	public void setAlimTalk_btn(String alimTalk_btn) {
		this.alimTalk_btn = alimTalk_btn;
	}

	public int getCnt() {
		return cnt;
	}

	public void setCnt(int cnt) {
		this.cnt = cnt;
	}

	public String[] getProcSelectArray() {
		return procSelectArray;
	}

	public void setProcSelectArray(String[] procSelectArray) {
		this.procSelectArray = procSelectArray;
	}

	public String getProcSelect() {
		return procSelect;
	}

	public void setProcSelect(String procSelect) {
		this.procSelect = procSelect;
	}

	public String getChange_yn() {
		return change_yn;
	}

	public void setChange_yn(String change_yn) {
		this.change_yn = change_yn;
	}

	public String getInit_yn() {
		return init_yn;
	}

	public void setInit_yn(String init_yn) {
		this.init_yn = init_yn;
	}
	
	public String getSuccess_yn() {
		return success_yn;
	}

	public void setSuccess_yn(String success_yn) {
		this.success_yn = success_yn;
	}
	
	public String getCheck_yn() {
		return check_yn;
	}

	public void setCheck_yn(String check_yn) {
		this.check_yn = check_yn;
	}
	
	public String getFlc_yn() {
		return flc_yn;
	}

	public void setFlc_yn(String flc_yn) {
		this.flc_yn = flc_yn;
	}
	
	public String getBreak_point_nm() {
		return break_point_nm;
	}

	public void setBreak_point_nm(String break_point_nm) {
		this.break_point_nm = break_point_nm;
	}

	public String getMobile_no() {
		return mobile_no;
	}

	public void setMobile_no(String mobile_no) {
		this.mobile_no = mobile_no;
	}
	
	public String getRequest_type() {
		return request_type;
	}

	public void setRequest_type(String request_type) {
		this.request_type = request_type;
	}
	
	public String getRequest_type_nm() {
		return request_type_nm;
	}

	public void setRequest_type_nm(String request_type_nm) {
		this.request_type_nm = request_type_nm;
	}
	
	public String getVal1() {
		return val1;
	}

	public void setVal1(String val1) {
		this.val1 = val1;
	}
	
	public String getVal2() {
		return val2;
	}

	public void setVal2(String val2) {
		this.val2 = val2;
	}
	
	public String getVal3() {
		return val3;
	}

	public void setVal3(String val3) {
		this.val3 = val3;
	}
	
	public String getVal4() {
		return val4;
	}

	public void setVal4(String val4) {
		this.val4 = val4;
	}
	
	public String getVal5() {
		return val5;
	}
	
	public void setVal5(String val5) {
		this.val5 = val5;
	}
	
	public String getWk_emp_no() {
		return wk_emp_no;
	}
	
	public void setWk_emp_no(String wk_emp_no) {
		this.wk_emp_no = wk_emp_no;
	}
	
	public String getWk_emp_nm() {
		return wk_emp_nm;
	}
	
	public void setWk_emp_nm(String wk_emp_nm) {
		this.wk_emp_nm = wk_emp_nm;
	}
	
	public String getAs_admin() {
		return as_admin;
	}
	
	public void setAs_admin(String as_admin) {
		this.as_admin = as_admin;
	}
	
	public String getPriority() {
		return priority;
	}
	
	public void setPriority(String priority) {
		this.priority = priority;
	}
	
	public String getChatbot_id() {
		return chatbot_id;
	}
	
	public void setChatbot_id(String chatbot_id) {
		this.chatbot_id = chatbot_id;
	}
	
	public String getProc_gubun() {
		return proc_gubun;
	}
	
	public void setProc_gubun(String proc_gubun) {
		this.proc_gubun = proc_gubun;
	}
	
	public String getProc_gubun_nm() {
		return proc_gubun_nm;
	}
	
	public void setProc_gubun_nm(String proc_gubun_nm) {
		this.proc_gubun_nm = proc_gubun_nm;
	}
	
	public String getProc_build_info() {
		return proc_build_info;
	}
	
	public void setProc_build_info(String proc_build_info) {
		this.proc_build_info = proc_build_info;
	}
	
	public String getProc_test_info() {
		return proc_test_info;
	}
	
	public void setProc_test_info(String proc_test_info) {
		this.proc_test_info = proc_test_info;
	}
	
	public String getProc_process_sp() {
		return proc_process_sp;
	}
	
	public void setProc_process_sp(String proc_process_sp) {
		this.proc_process_sp = proc_process_sp;
	}
	
	public String getProc_screen_sp() {
		return proc_screen_sp;
	}
	
	public void setProc_screen_sp(String proc_screen_sp) {
		this.proc_screen_sp = proc_screen_sp;
	}
	
	public String getProc_table_sp() {
		return proc_table_sp;
	}
	
	public void setProc_table_sp(String proc_table_sp) {
		this.proc_table_sp = proc_table_sp;
	}
	
	public String getProc_function_sp() {
		return proc_function_sp;
	}
	
	public void setProc_function_sp(String proc_function_sp) {
		this.proc_function_sp = proc_function_sp;
	}
	
	public String getProc_interface_sp() {
		return proc_interface_sp;
	}
	
	public void setProc_interface_sp(String proc_interface_sp) {
		this.proc_interface_sp = proc_interface_sp;
	}
	
	public String getSender_email() {
		return sender_email;
	}

	public void setSender_email(String sender_email) {
		this.sender_email = sender_email;
	}
	
	public String getRetire_yn() {
		return retire_yn;
	}

	public void setRetire_yn(String retire_yn) {
		this.retire_yn = retire_yn;
	} 

}
