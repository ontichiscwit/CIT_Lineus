package egovframework.com.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.JwConstants;
import egovframework.com.comm.model.PagingVO;

/**
 * @author 21001
 *
 */
@Alias("asVO")
public class AsVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 8270977273658995518L;
	
	private String search_as = "" ;
	private String as_no = "" ;
	private String as_no2 = "" ;
	private String cn_as_no = "" ;
	private String accept_dt = "" ;
	private String as_complete_dt = "" ;
	private String accept_time = "" ;
	private String accept_route = "" ;
	private String cust_code = "" ;
	private String apply_nm = "" ;
	private String apply_id = "" ;
	private String apply_tel = "" ;
	private String service_cate = "" ;
	private String inquiry_service = "" ;
	private String version_info = "" ;
	private String inquiry_type = "" ;
	private String inquiry_dt = "" ;
	
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
	private String happy_call_yn = "" ;
	private String cust_kor_name = "" ;
	private String file_cnt = "";
	private String cust_seq = "";
	private String service_cate_nm = "";
	private String inquiry_type_nm = "";
	private String system_type_nm = "";
	private String apply_email ="";
	private String star_state_date = "";
	private String system_nm = "";
	
	
	
	private String complete_dt = "";
	private String request_type = "";
	private String request_type_nm = "";
	private String e_mail = "";
	private String dept_grade_nm = "";
	private String dept1_nm = "";
	private String dept2_nm = "";
	private String company_no = "";
	
	
	
	
	
	
	
	
	/* 요청내용 */
	private String request_content = "";
	/* 고객평가 */
	private String star_state = "";
	private String star_content = "";
	private String emp_no = "" ; 
	private String emp_nm = "" ; 
	private String delAttach2 = "" ; 
	private String delAttach1 = "" ; 
	private String w_id = "" ;
	private String w_content = "" ;	 
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
	
	// 20171113 박승모 추가
	private String accept_route_nm = "";
	private String last_coment = "";
	
	//20171212 김민지 추가 (조치이력 등록자이름)
	private String reg_nm = "";
	Map<String , Object> amap = new HashMap<String , Object>() ;
	
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
	
	private String proc_grade = "";
	private String proc_build_info = "";
	private String proc_file_info = "";
	private String proc_db_info = "";
	private String proc_test_info = "";
	private String system_type = "";
	private String memo = "";
	
	private String send_email = "";
	private String send_sms = "";
	private String oper_seq = "";
	
	private String approval_dt = "";
	private String approval_time = "";
	private String approval_id = "";
	private String approval_nm ="";
	
	private String work_time ="";
	private String sender_email ="";
	private String apply_sms_tel = "" ;
	
	private String shared_doc_idx = "" ;
	private String shared_doc_id = "" ;
	private String shared_attach = "" ;
	private String shared_filenm = "" ;
	private String shared_filepath = "" ;
	private String shared_tag = "" ;		//jw그룹웨어 승인자 접수의견(검토의견)
	

	
	private String proc_gubun	="";
	private String proc_process_sp ="";
	private String proc_function_sp ="";
	private String proc_screen_sp ="";
	private String proc_table_sp ="";
	private String proc_interface_sp ="";
	private String proc_erd_sp ="";
	private String proc_erd_yn ="";
	
	private String proc_erd_yn_nm ="";
	private String proc_gubun_nm ="";
	
	private String proc_grade_nm ="";
	
	//유지보수담당자 퇴사자여부 2020.07.08. 이기은 추가 
	private String retire_yn ="";	
	
	//JW Shared service -> 라이너스 Job스케줄러 인터페이스 시 AS접수건 AS승인프로세스 추가에 따른 거래처구분, 승인대상1(팀장), 승인대상2(배포), 승인자1(팀장), 승인자2(배포)  2020.07.31. 이기은 추가
	private String cust_gubun ="";	
	private String gyul_gb1 ="";
	private String gyul_gb2 ="";
	private String gyul_emp1 ="";
	private String gyul_emp2 =""; 
	
	//라이너스 Job스케줄러 인터페이스 시 AS접수건 승인자1(팀장), 승인자2(배포)  2020.07.31. 이기은 추가
	private String appr_yn1 ="";	
	private String appr_emp1 ="";	
	private String appr_date1 ="";	
	private String appr_yn2 ="";	
	private String appr_emp2 ="";	
	private String appr_date2 ="";	
	private String appr_time2 ="";	
	private String distr_filepath ="";		
	private String distr_svn_ver ="";		
	private String distr_dt ="";
	private String search_type3 = "";
	private String search_type2 = "";
	private String cust_searh = "";
	private String search_start = "";
	private String search_end = "";
	private String search_start2 = "";
	private String search_end2 = "";
	private String search_start4 = "";
	private String search_end4 = "";
	private String cntdata = "";
	private String reg_id = "";
	private String asNoSave  = "";
	
	//2020.08.18. 이기은 추가
	private String appr_yn ="";	
	
	//1 팀장, 2 배포  2020.08.19. 이기은 추가 		
	private String appr_gb ="";	
	
	//AS승인 조회조건 라디오버튼 state_chk  A 미결 , B 결재, C 전체  2020.08.19. 이기은 추가 
	private String 	state_chk ="";

	//팀장승인자 이름, 배포승인자 이름  2020.08.21. 이기은 추가
	private String appr_emp1_nm ="";	
	private String appr_emp2_nm ="";
	
	private String current_file = "" ;
	
	//CMC add 2020.01.11
	private String cmc_pic = "" ;
	private String program_satisfaction = "" ;
	
	//CMC add 모듈 , 중분류 , 프로그램명  2021.01.12
	private String module_name = "" ;
	private String category_name = "" ;
	private String category_id = "" ;
	private String program_id = "" ;
	private String program_name = "" ;
	private String cmc_pic_nm = "" ;
	private String program_satisfaction_nm = "" ;
	private String module_name_nm = "" ;
	private String use_yn = "" ;
	private String system_name = "" ;
	private String system_code = "" ;
	
	//2021.03.05 이설아 
	private String login_id;		//로그인한 회원 사번
	private String login_name;		//로그인한 회원 이름
	private String login_grade;		//로그인한 회원 등급
	
	//2021.07.02 이설아
	private String peer_review_nm;	//동료검토자
	private String user_test_yn;	//사용자테스트 여부
	private String normal_oper_yn;	//정상 여부
	private String test_note;		//테스트 비고
	private String user_test_dt;	//사용자테스트 일자
	private String user_test_time;	//사용자테스트 시간
	
	//2021.11.29 이설아
	private String user_test_ip;	//사용자테스트자 ip주소
	private String user_test_id;	//사용자테스트자 id
	private String user_test_nm;	//사용자테스트자 이름
	
	//2022.01.27 이설아
	private String appr_sub_emp1;	//팀장승인 대체자(2차 결재자)
	private String appr_sub_emp2;	//배포승인 대체자(2차 결재자)
	
	private String[] procSelectArray = null ; 
	private String procSelect;
	
	//2023.07.12 김규민
	private int cn_as_yn;         //하위작업 여부
	private int cn_as_status;     //하위작업 처리상태
	
	//2023.08.01 김규민
	private int cn_as_dep_yn;     //하위작업 배포관련 여부
	private int cn_as_dep_status; //하위작업 배포관련 처리상태
	
	//2023.08.16 김규민
	private String appr_email;       //하위작업 승인자 관련 이메일
	
	//2023.10.31 김규민
	private String work_time_yn ="";
	
	//2024.04.02 김규민
	private String appr_ssub_emp1;	//팀장승인 대체자(3차 결재자)
	private String appr_ssub_emp2;	//배포승인 대체자(3차 결재자)
	
	//2025.08.19 김규민
	private String expected_work_time =""; //예상 작업시간
	private String target_project =""; 	   //대상 프로젝특
	
	private String progress_rate =""; //진행률
	
	public String getAsNoSave() {
		return asNoSave;
	}

	public void setAsNoSave(String asNoSave) {
		this.asNoSave = asNoSave;
	}

	public String getReg_id() {
		return reg_id;
	}

	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}

	public String getCntdata() {
		return cntdata;
	}

	public void setCntdata(String cntdata) {
		this.cntdata = cntdata;
	}


	public String getSearch_start() {
		return search_start;
	}

	public void setSearch_start(String search_start) {
		this.search_start = search_start;
	}

	public String getSearch_end() {
		return search_end;
	}

	public void setSearch_end(String search_end) {
		this.search_end = search_end;
	}

	public String getSearch_start2() {
		return search_start2;
	}

	public void setSearch_start2(String search_start2) {
		this.search_start2 = search_start2;
	}

	public String getSearch_end2() {
		return search_end2;
	}

	public void setSearch_end2(String search_end2) {
		this.search_end2 = search_end2;
	}

	public String getSearch_type3() {
		return search_type3;
	}

	public void setSearch_type3(String search_type3) {
		this.search_type3 = search_type3;
	}

	public String getSearch_type2() {
		return search_type2;
	}

	public void setSearch_type2(String search_type2) {
		this.search_type2 = search_type2;
	}

	public String getCust_searh() {
		return cust_searh;
	}

	public void setCust_searh(String cust_searh) {
		this.cust_searh = cust_searh;
	}

	public String getProc_grade_nm() {
		return proc_grade_nm;
	}

	public void setProc_grade_nm(String proc_grade_nm) {
		this.proc_grade_nm = proc_grade_nm;
	}

	public String getProc_gubun_nm() {
		return proc_gubun_nm;
	}

	public void setProc_gubun_nm(String proc_gubun_nm) {
		this.proc_gubun_nm = proc_gubun_nm;
	}

	public String getProc_erd_yn_nm() {
		return proc_erd_yn_nm;
	}

	public void setProc_erd_yn_nm(String proc_erd_yn_nm) {
		this.proc_erd_yn_nm = proc_erd_yn_nm;
	}

	public String getProc_gubun() {
		return proc_gubun;
	}

	public void setProc_gubun(String proc_gubun) {
		this.proc_gubun = proc_gubun;
	}

	public String getProc_process_sp() {
		return proc_process_sp;
	}

	public void setProc_process_sp(String proc_process_sp) {
		this.proc_process_sp = proc_process_sp;
	}

	public String getProc_function_sp() {
		return proc_function_sp;
	}

	public void setProc_function_sp(String proc_function_sp) {
		this.proc_function_sp = proc_function_sp;
	}

	public String getProc_screen_sp() {
		return proc_screen_sp;
	}

	public void setProc_screen_sp(String proc_screen_sp) {
		this.proc_screen_sp = proc_screen_sp;
	}
	
	public String getProc_erd_sp() {
		return proc_erd_sp;
	}

	public void setProc_erd_sp(String proc_erd_sp) {
		this.proc_erd_sp = proc_erd_sp;
	}

	public String getProc_table_sp() {
		return proc_table_sp;
	}

	public void setProc_table_sp(String proc_table_sp) {
		this.proc_table_sp = proc_table_sp;
	}

	public String getProc_interface_sp() {
		return proc_interface_sp;
	}

	public void setProc_interface_sp(String proc_interface_sp) {
		this.proc_interface_sp = proc_interface_sp;
	}

	public String getProc_erd_yn() {
		return proc_erd_yn;
	}

	public void setProc_erd_yn(String proc_erd_yn) {
		this.proc_erd_yn = proc_erd_yn;
	}

	public String getShared_filepath() {
		return shared_filepath.replaceAll("\\\\", "/");
	}

	public void setShared_filepath(String shared_filepath) {
		this.shared_filepath = shared_filepath;
	}

	public String getShared_filenm() {
		return shared_filenm;
	}

	public void setShared_filenm(String shared_filenm) {
		this.shared_filenm = shared_filenm;
	}

	public String getShared_attach() {
		return shared_attach;
	}

	public void setShared_attach(String shared_attach) {
		this.shared_attach = shared_attach;
	}

	public String getShared_doc_id() {
		return shared_doc_id;
	}

	public void setShared_doc_id(String shared_doc_id) {
		this.shared_doc_id = shared_doc_id;
	}

	public String getShared_doc_idx() {
		return shared_doc_idx;
	}

	public void setShared_doc_idx(String shared_doc_idx) {
		this.shared_doc_idx = shared_doc_idx;
	}

	public String getApply_sms_tel() {
		return apply_sms_tel;
	}

	public void setApply_sms_tel(String apply_sms_tel) {
		this.apply_sms_tel = apply_sms_tel;
	}

	public String getCompany_no() {
		return company_no;
	}

	public void setCompany_no(String company_no) {
		this.company_no = company_no;
	}

	public String getSender_email() {
		return sender_email;
	}

	public void setSender_email(String sender_email) {
		this.sender_email = sender_email;
	}

	public String getSystem_nm() {
		return system_nm;
	}

	public void setSystem_nm(String system_nm) {
		this.system_nm = system_nm;
	}

	public String getComplete_dt() {
		return complete_dt;
	}

	public void setComplete_dt(String complete_dt) {
		this.complete_dt = complete_dt;
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

	public String getE_mail() {
		return e_mail;
	}

	public void setE_mail(String e_mail) {
		this.e_mail = e_mail;
	}

	public String getDept_grade_nm() {
		return dept_grade_nm;
	}

	public void setDept_grade_nm(String dept_grade_nm) {
		this.dept_grade_nm = dept_grade_nm;
	}

	public String getDept1_nm() {
		return dept1_nm;
	}

	public void setDept1_nm(String dept1_nm) {
		this.dept1_nm = dept1_nm;
	}

	public String getDept2_nm() {
		return dept2_nm;
	}

	public void setDept2_nm(String dept2_nm) {
		this.dept2_nm = dept2_nm;
	}

	public String getWork_time() {
		return work_time;
	}

	public void setWork_time(String work_time) {
		this.work_time = work_time;
	}

	public String getApproval_nm() {
		return approval_nm;
	}

	public void setApproval_nm(String approval_nm) {
		this.approval_nm = approval_nm;
	}

	public String getApproval_dt() {
		return approval_dt;
	}

	public void setApproval_dt(String approval_dt) {
		this.approval_dt = approval_dt;
	}

	public String getApproval_time() {
		return approval_time;
	}

	public void setApproval_time(String approval_time) {
		this.approval_time = approval_time;
	}

	public String getApproval_id() {
		return approval_id;
	}

	public void setApproval_id(String approval_id) {
		this.approval_id = approval_id;
	}

	public String getInquiry_dt() {
		return inquiry_dt;
	}

	public void setInquiry_dt(String inquiry_dt) {
		this.inquiry_dt = inquiry_dt;
	}

	public String getApply_email() {
		return apply_email;
	}

	public void setApply_email(String apply_email) {
		this.apply_email = apply_email;
	}

	public String getOper_seq() {
		return oper_seq;
	}

	public void setOper_seq(String oper_seq) {
		this.oper_seq = oper_seq;
	}

	public String getSend_email() {
		return send_email;
	}

	public void setSend_email(String send_email) {
		this.send_email = send_email;
	}

	public String getSend_sms() {
		return send_sms;
	}

	public void setSend_sms(String send_sms) {
		this.send_sms = send_sms;
	}

	public String getCust_seq() {
		return cust_seq;
	}

	public void setCust_seq(String cust_seq) {
		this.cust_seq = cust_seq;
	}

	public String getSystem_type_nm() {
		return system_type_nm;
	}

	public void setSystem_type_nm(String system_type_nm) {
		this.system_type_nm = system_type_nm;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}
	
	public String getProc_grade() {
		return proc_grade;
	}

	public void setProc_grade(String proc_grade) {
		this.proc_grade = proc_grade;
	}

	public String getProc_build_info() {
		return proc_build_info;
	}

	public void setProc_build_info(String proc_build_info) {
		this.proc_build_info = proc_build_info;
	}

	public String getProc_file_info() {
		return proc_file_info;
	}

	public void setProc_file_info(String proc_file_info) {
		this.proc_file_info = proc_file_info;
	}

	public String getProc_db_info() {
		return proc_db_info;
	}

	public void setProc_db_info(String proc_db_info) {
		this.proc_db_info = proc_db_info;
	}

	public String getProc_test_info() {
		return proc_test_info;
	}

	public void setProc_test_info(String proc_test_info) {
		this.proc_test_info = proc_test_info;
	}

	public String getSystem_type() {
		return system_type;
	}

	public void setSystem_type(String system_type) {
		this.system_type = system_type;
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

	public String getHappy_call_yn() {
		return happy_call_yn;
	}

	public void setHappy_call_yn(String happy_call_yn) {
		this.happy_call_yn = happy_call_yn;
	}
	

	public String getRetire_yn() {
		return retire_yn;
	}

	public void setRetire_yn(String retire_yn) {
		this.retire_yn = retire_yn;
	} 
	
	
	public String getCust_gubun() {
		return cust_gubun;
	}

	public void setCust_gubun(String cust_gubun) {
		this.cust_gubun = cust_gubun;
	}

	public String getGyul_gb1() {
		return gyul_gb1;
	}

	public void setGyul_gb1(String gyul_gb1) {
		this.gyul_gb1 = gyul_gb1;
	}

	public String getGyul_gb2() {
		return gyul_gb2;
	}

	public void setGyul_gb2(String gyul_gb2) {
		this.gyul_gb2 = gyul_gb2;
	}

	public String getGyul_emp1() {
		return gyul_emp1;
	}

	public void setGyul_emp1(String gyul_emp1) {
		this.gyul_emp1 = gyul_emp1;
	}

	public String getGyul_emp2() {
		return gyul_emp2;
	}

	public void setGyul_emp2(String gyul_emp2) {
		this.gyul_emp2 = gyul_emp2;
	}

	
	public String getAppr_yn1() {
		return appr_yn1;
	}

	public void setAppr_yn1(String appr_yn1) {
		this.appr_yn1 = appr_yn1;
	}

	public String getAppr_emp1() {
		return appr_emp1;
	}

	public void setAppr_emp1(String appr_emp1) {
		this.appr_emp1 = appr_emp1;
	}

	public String getAppr_date1() {
		return appr_date1;
	}

	public void setAppr_date1(String appr_date1) {
		this.appr_date1 = appr_date1;
	}

	public String getAppr_yn2() {
		return appr_yn2;
	}

	public void setAppr_yn2(String appr_yn2) {
		this.appr_yn2 = appr_yn2;
	}

	public String getAppr_emp2() {
		return appr_emp2;
	}

	public void setAppr_emp2(String appr_emp2) {
		this.appr_emp2 = appr_emp2;
	}

	public String getAppr_date2() {
		return appr_date2;
	}

	public void setAppr_date2(String appr_date2) {
		this.appr_date2 = appr_date2;
	}

	public String getDistr_filepath() {
		return distr_filepath;
	}

	public void setDistr_filepath(String distr_filepath) {
		this.distr_filepath = distr_filepath;
	}

	public String getDistr_svn_ver() {
		return distr_svn_ver;
	}

	public void setDistr_svn_ver(String distr_svn_ver) {
		this.distr_svn_ver = distr_svn_ver;
	}

	public String getDistr_dt() {
		return distr_dt;
	}

	public void setDistr_dt(String distr_dt) {
		this.distr_dt = distr_dt;
	}	

	
	public String getAppr_yn() {
		return appr_yn;
	}

	public void setAppr_yn(String appr_yn) {
		this.appr_yn = appr_yn;
	}

	public String getAppr_gb() {
		return appr_gb;
	}

	public void setAppr_gb(String appr_gb) {
		this.appr_gb = appr_gb;
	}

	public String getState_chk() {
		return state_chk;
	}

	public void setState_chk(String state_chk) {
		this.state_chk = state_chk;
	}

	public String getAppr_emp1_nm() {
		return appr_emp1_nm;
	}

	public void setAppr_emp1_nm(String appr_emp1_nm) {
		this.appr_emp1_nm = appr_emp1_nm;
	}

	public String getAppr_emp2_nm() {
		return appr_emp2_nm;
	}

	public void setAppr_emp2_nm(String appr_emp2_nm) {
		this.appr_emp2_nm = appr_emp2_nm;
	}

	public String getCurrent_file() {
		return current_file;
	}

	public void setCurrent_file(String current_file) {
		this.current_file = current_file;
	}

	public String getCmc_pic() {
		return cmc_pic;
	}

	public void setCmc_pic(String cmc_pic) {
		this.cmc_pic = cmc_pic;
	}

	public String getProgram_satisfaction() {
		return program_satisfaction;
	}

	public void setProgram_satisfaction(String program_satisfaction) {
		this.program_satisfaction = program_satisfaction;
	}

	public String getModule_name() {
		return module_name;
	}

	public void setModule_name(String module_name) {
		this.module_name = module_name;
	}

	public String getCategory_name() {
		return category_name;
	}

	public void setCategory_name(String category_name) {
		this.category_name = category_name;
	}
	
	public String getCategory_id() {
		return category_id;
	}

	public void setCategory_id(String category_id) {
		this.category_id = category_id;
	}

	public String getProgram_id() {
		return program_id;
	}

	public void setProgram_id(String program_id) {
		this.program_id = program_id;
	}

	public String getProgram_name() {
		return program_name;
	}

	public void setProgram_name(String program_name) {
		this.program_name = program_name;
	}

	public String getCmc_pic_nm() {
		return cmc_pic_nm;
	}

	public void setCmc_pic_nm(String cmc_pic_nm) {
		this.cmc_pic_nm = cmc_pic_nm;
	}

	public String getProgram_satisfaction_nm() {
		return program_satisfaction_nm;
	}

	public void setProgram_satisfaction_nm(String program_satisfaction_nm) {
		this.program_satisfaction_nm = program_satisfaction_nm;
	}

	public String getModule_name_nm() {
		return module_name_nm;
	}

	public void setModule_name_nm(String module_name_nm) {
		this.module_name_nm = module_name_nm;
	}

	public String getUse_yn() {
		return use_yn;
	}

	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}

	public String getSystem_name() {
		return system_name;
	}

	public void setSystem_name(String system_name) {
		this.system_name = system_name;
	}

	public String getSystem_code() {
		return system_code;
	}

	public void setSystem_code(String system_code) {
		this.system_code = system_code;
	}
	public String getLogin_id() {
		return login_id;
	}

	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}

	public String getLogin_grade() {
		return login_grade;
	}

	public void setLogin_grade(String login_grade) {
		this.login_grade = login_grade;
	}
	public String getLogin_name() {
		return login_name;
	}
	
	public void setLogin_name(String login_name) {
		this.login_name = login_name;
	}

	public String getPeer_review_nm() {
		return peer_review_nm;
	}

	public void setPeer_review_nm(String peer_review_nm) {
		this.peer_review_nm = peer_review_nm;
	}

	public String getUser_test_yn() {
		return user_test_yn;
	}

	public void setUser_test_yn(String user_test_yn) {
		this.user_test_yn = user_test_yn;
	}

	public String getNormal_oper_yn() {
		return normal_oper_yn;
	}

	public void setNormal_oper_yn(String normal_oper_yn) {
		this.normal_oper_yn = normal_oper_yn;
	}

	public String getTest_note() {
		return test_note;
	}

	public void setTest_note(String test_note) {
		this.test_note = test_note;
	}

	public String getUser_test_dt() {
		return user_test_dt;
	}

	public void setUser_test_dt(String user_test_dt) {
		this.user_test_dt = user_test_dt;
	}

	public String getShared_tag() {
		return shared_tag;
	}

	public void setShared_tag(String shared_tag) {
		this.shared_tag = shared_tag;
	}

	public String getUser_test_ip() {
		return user_test_ip;
	}

	public void setUser_test_ip(String user_test_ip) {
		this.user_test_ip = user_test_ip;
	}

	public String getUser_test_id() {
		return user_test_id;
	}

	public void setUser_test_id(String user_test_id) {
		this.user_test_id = user_test_id;
	}

	public String getUser_test_nm() {
		return user_test_nm;
	}

	public void setUser_test_nm(String user_test_nm) {
		this.user_test_nm = user_test_nm;
	}

	public String getSearch_start4() {
		return search_start4;
	}

	public void setSearch_start4(String search_start4) {
		this.search_start4 = search_start4;
	}

	public String getSearch_end4() {
		return search_end4;
	}

	public void setSearch_end4(String search_end4) {
		this.search_end4 = search_end4;
	}

	public String getAppr_time2() {
		return appr_time2;
	}

	public void setAppr_time2(String appr_time2) {
		this.appr_time2 = appr_time2;
	}

	public String getUser_test_time() {
		return user_test_time;
	}

	public void setUser_test_time(String user_test_time) {
		this.user_test_time = user_test_time;
	}

	public String getAppr_sub_emp1() {
		return appr_sub_emp1;
	}

	public void setAppr_sub_emp1(String appr_sub_emp1) {
		this.appr_sub_emp1 = appr_sub_emp1;
	}

	public String getAppr_sub_emp2() {
		return appr_sub_emp2;
	}

	public void setAppr_sub_emp2(String appr_sub_emp2) {
		this.appr_sub_emp2 = appr_sub_emp2;
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
	
	public int getCn_as_yn() {
		return cn_as_yn;
	}

	public void setCn_as_yn(int cn_as_yn) {
		this.cn_as_yn = cn_as_yn;
	}
	
	public int getCn_as_status() {
		return cn_as_status;
	}

	public void setCn_as_status(int cn_as_status) {
		this.cn_as_status = cn_as_status;
	}

	public int getCn_as_dep_yn() {
		return cn_as_dep_yn;
	}

	public void setCn_as_dep_yn(int cn_as_dep_yn) {
		this.cn_as_dep_yn = cn_as_dep_yn;
	}
	
	public int getCn_as_dep_status() {
		return cn_as_dep_status;
	}

	public void setCn_as_dep_status(int cn_as_dep_status) {
		this.cn_as_dep_status = cn_as_dep_status;
	}
	
	public String getAppr_email() {
		return appr_email;
	}

	public void setAppr_email(String appr_email) {
		this.appr_email = appr_email;
	}
	
	public String getWork_time_yn() {
		return work_time_yn;
	}

	public void setWork_time_yn(String work_time_yn) {
		this.work_time_yn = work_time_yn;
	}
	
	public String getAppr_ssub_emp1() {
		return appr_ssub_emp1;
	}

	public void setAppr_ssub_emp1(String appr_ssub_emp1) {
		this.appr_ssub_emp1 = appr_ssub_emp1;
	}
	
	public String getAppr_ssub_emp2() {
		return appr_ssub_emp2;
	}

	public void setAppr_ssub_emp2(String appr_ssub_emp2) {
		this.appr_ssub_emp2 = appr_ssub_emp2;
	}
	
	public String getExpected_work_time() {
		return expected_work_time;
	}

	public void setExpected_work_time(String expected_work_time) {
		this.expected_work_time = expected_work_time;
	}
	
	public String getTarget_project() {
		return target_project;
	}

	public void setTarget_project(String target_project) {
		this.target_project = target_project;
	}
	
	public String getProgress_rate() {
		return progress_rate;
	}

	public void setProgress_rate(String progress_rate) {
		this.progress_rate = progress_rate;
	}
	
}
