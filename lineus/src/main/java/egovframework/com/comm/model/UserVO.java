package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.model.CommonVO;

@Alias("userVO")
public class UserVO extends PagingVO implements Serializable{
	private static final long serialVersionUID = -7030846024891158125L;
	
	private String emp_no = "" ; 
	private String emp_nm = "" ; 
	private String dept_cd = "" ; 
	private String dept_duty = "" ; 
	private String e_mail = "" ; 
	private String mobile_no = "" ; 
	private String retire_date = "" ; 
	private String pass = "" ; 
	private String dept_nm = "" ; 
	private String dept_duty_nm = "" ; 
	private String use_yn = "" ; 
	private String cust_seq = "" ;
	private String as_approval_yn ="";
	private String approval_auth ="";
	private String company_no ="";
	
	private String use_agree ="";
	private String perdata_agree ="";
	private String sms_agree ="";
	private String email_agree ="";
	
	
	
	/**	CRM_CUST_EMP	*/
	private String seq = "" ;
	private String emp_id = "" ;
	private String cust_code = "" ;
	private String emp_grade = "" ;
	private String use_type = "" ;
	private String use_type2 = "" ;
	private String join_date = "" ;
	private String emp_name = "" ;
	private String dept_name = "" ;
	private String dept_grade = "" ;
	private String email = "" ;
	private String tel_no = "" ;
	private String emp_grade_name = "" ;
	private String use_type_name = "" ;
	private String cust_kor_name = "" ;
	private String seq_arr = "" ;
	
	private String erp_code = "" ;
	private String cust_address = "" ;
	private String zip_code = "" ;
	private String cust_no = "" ;
	private String ceo = "" ;
	
	private String dam_emp_name = "" ; 
	private String dam_tel_no = "" ;
	
	private String dept1_nm;
	private String dept2_nm;
	private String dept1_cd;
	private String dept2_cd;
	
	
	private String dept_grade_nm;
	private String dept_grade_cd;
	
	
	private String as_no = "" ; 
	private String accept_dt = "" ; 
	private String proc_status = "" ; 
	private String proc_dt = "" ; 
	private String inquiry_service = "" ; 
	private String inquiry_type = "" ; 
	private String cust_nm = "" ; 
	private String crm_code = "" ; 
	private String treat_no = "" ; 
	private String changePass = "" ; 
	
	private String his_basic_code = "" ; 	
	private String his_treat_code = "" ; 		
	private String his_work_code = "" ;		
	private String his_claim_code = "" ; 
	
	/**	프로시저 return 값	*/
	private List<UserVO> OUTCURSOR = null ; 
	
	
	private String group_code = "" ; 
	private String point_5 = "" ;
	private String point_4_up = "" ;
	private String point_4_down = "" ;
	private String point_3_up = "" ;
	private String point_3_down = "" ;
	private String point_2_up = "" ;
	private String point_2_down = "" ;
	private String point_1 = "" ;
	private String weight = "" ;
	 
	private String  pass_back    ="";  
	private String  inout_gubun  ="";  
	private String each_emp_id   ="";  
	private String group_emp_id  =""; 
	private String cust_gubun_nm ="";
	private String cust_gubun ="";
	
	private String reg_date ="";
	
	
	private String lock_yn = "";     /** 로그인 LOCK 여부  2020.09.14. 추가  */
	private String pass_policy1 = ""; /** 비밀번호정책 정책일수 초과(Y) 여부  2020.09.14. 추가  */
	private String pass_policy2 = ""; /** 비밀번호정책 로그인시 비밀번호 오류횟수제한(Y) 여부  2020.09.14. 추가  */
	private String pass_policy3 = ""; /** 비밀번호정책 동일 비밀번호 체크제한(Y) 여부  2020.09.14. 추가  */	
	
	private String policy1_val = "";  /** 비밀번호정책 정책일수 (90일) 2020.09.15. 추가  */	
	private String policy2_val = "";  /** 비밀번호정책 비밀번호 오류횟수제한 (5) 2020.09.15. 추가  */	
	private String policy3_val = "";  /** 비밀번호정책 동일 비밀번호 체크제한 (4) 2020.09.15. 추가  */			
	
	private String login_f_cnt = ""; /** 비밀번호 오류횟수 로그인화면에 메세지 뿌려주기 위함 2020.09.18. 추가  */
	
	private String pass_chg_date ="";
	
	//2024.03.28 김규민
	private String pass_d_day = ""; /** 비밀번호 변경일까지 남은 일수를 알림창에 띄우기 위함(남은일수) 2024.03.28 추가 */
	private String chg_day_yn = ""; /** 비밀번호 변경일까지 남은 일수를 알림창에 띄우기 위함(알림창 띄우는 유무) 2024.03.28 추가 */
	
	
	public String getLogin_f_cnt() { 
		return login_f_cnt;
	}
	public void setLogin_f_cnt(String login_f_cnt) {
		this.login_f_cnt = login_f_cnt;
	}	
	public String getPass_policy1() {
		return pass_policy1;
	}
	public String getPolicy1_val() {
		return policy1_val;
	}
	public void setPolicy1_val(String policy1_val) {
		this.policy1_val = policy1_val;
	}
	public String getPolicy2_val() {
		return policy2_val;
	}
	public void setPolicy2_val(String policy2_val) {
		this.policy2_val = policy2_val;
	}
	public String getPolicy3_val() {
		return policy3_val;
	}
	public void setPolicy3_val(String policy3_val) {
		this.policy3_val = policy3_val;
	}
	public void setPass_policy1(String pass_policy1) {
		this.pass_policy1 = pass_policy1;
	}
	public String getPass_policy2() {
		return pass_policy2;
	}
	public void setPass_policy2(String pass_policy2) {
		this.pass_policy2 = pass_policy2;
	}
	public String getPass_policy3() {
		return pass_policy3;
	}
	public void setPass_policy3(String pass_policy3) {
		this.pass_policy3 = pass_policy3;
	}	
	public String getLock_yn() {
		return lock_yn;
	}
	public void setLock_yn(String lock_yn) {
		this.lock_yn = lock_yn;
	}
	public String getUse_agree() {
		return use_agree;
	}
	public void setUse_agree(String use_agree) {
		this.use_agree = use_agree;
	}
	public String getPerdata_agree() {
		return perdata_agree;
	}
	public void setPerdata_agree(String perdata_agree) {
		this.perdata_agree = perdata_agree;
	}
	public String getSms_agree() {
		return sms_agree;
	}
	public void setSms_agree(String sms_agree) {
		this.sms_agree = sms_agree;
	}
	public String getEmail_agree() {
		return email_agree;
	}
	public void setEmail_agree(String email_agree) {
		this.email_agree = email_agree;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getCompany_no() {
		return company_no;
	}
	public void setCompany_no(String company_no) {
		this.company_no = company_no;
	}
	public String getUse_type2() {
		return use_type2;
	}
	public void setUse_type2(String use_type2) {
		this.use_type2 = use_type2;
	}
	public String getCust_gubun() {
		return cust_gubun;
	}
	public void setCust_gubun(String cust_gubun) {
		this.cust_gubun = cust_gubun;
	}
	public String getCust_gubun_nm() {
		return cust_gubun_nm;
	}
	public void setCust_gubun_nm(String cust_gubun_nm) {
		this.cust_gubun_nm = cust_gubun_nm;
	}
	public String getPass_back() {
		return pass_back;
	}
	public void setPass_back(String pass_back) {
		this.pass_back = pass_back;
	}
	public String getInout_gubun() {
		return inout_gubun;
	}
	public void setInout_gubun(String inout_gubun) {
		this.inout_gubun = inout_gubun;
	}
	public String getEach_emp_id() {
		return each_emp_id;
	}
	public void setEach_emp_id(String each_emp_id) {
		this.each_emp_id = each_emp_id;
	}
	public String getGroup_emp_id() {
		return group_emp_id;
	}
	public void setGroup_emp_id(String group_emp_id) {
		this.group_emp_id = group_emp_id;
	}
	public String getAs_approval_yn() {
		return as_approval_yn;
	}
	public void setAs_approval_yn(String as_approval_yn) {
		this.as_approval_yn = as_approval_yn;
	}
	public String getApproval_auth() {
		return approval_auth;
	}
	public void setApproval_auth(String approval_auth) {
		this.approval_auth = approval_auth;
	}
	public String getCust_seq() {
		return cust_seq;
	}
	public void setCust_seq(String cust_seq) {
		this.cust_seq = cust_seq;
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
	public String getDept1_cd() {
		return dept1_cd;
	}
	public void setDept1_cd(String dept1_cd) {
		this.dept1_cd = dept1_cd;
	}
	public String getDept2_cd() {
		return dept2_cd;
	}
	public void setDept2_cd(String dept2_cd) {
		this.dept2_cd = dept2_cd;
	}
	public String getDept_grade_nm() {
		return dept_grade_nm;
	}
	public void setDept_grade_nm(String dept_grade_nm) {
		this.dept_grade_nm = dept_grade_nm;
	}
	public String getDept_grade_cd() {
		return dept_grade_cd;
	}
	public void setDept_grade_cd(String dept_grade_cd) {
		this.dept_grade_cd = dept_grade_cd;
	}
	
	public String getWeight() {
		return weight;
	}
	public void setWeight(String weight) {
		this.weight = weight;
	}
	public String getGroup_code() {
		return group_code;
	}
	public void setGroup_code(String group_code) {
		this.group_code = group_code;
	}
	public String getPoint_5() {
		return point_5;
	}
	public void setPoint_5(String point_5) {
		this.point_5 = point_5;
	}
	public String getPoint_4_up() {
		return point_4_up;
	}
	public void setPoint_4_up(String point_4_up) {
		this.point_4_up = point_4_up;
	}
	public String getPoint_4_down() {
		return point_4_down;
	}
	public void setPoint_4_down(String point_4_down) {
		this.point_4_down = point_4_down;
	}
	public String getPoint_3_up() {
		return point_3_up;
	}
	public void setPoint_3_up(String point_3_up) {
		this.point_3_up = point_3_up;
	}
	public String getPoint_3_down() {
		return point_3_down;
	}
	public void setPoint_3_down(String point_3_down) {
		this.point_3_down = point_3_down;
	}
	public String getPoint_2_up() {
		return point_2_up;
	}
	public void setPoint_2_up(String point_2_up) {
		this.point_2_up = point_2_up;
	}
	public String getPoint_2_down() {
		return point_2_down;
	}
	public void setPoint_2_down(String point_2_down) {
		this.point_2_down = point_2_down;
	}
	public String getPoint_1() {
		return point_1;
	}
	public void setPoint_1(String point_1) {
		this.point_1 = point_1;
	}
	public String getHis_basic_code() {
		return his_basic_code;
	}
	public void setHis_basic_code(String his_basic_code) {
		this.his_basic_code = his_basic_code;
	}
	public String getHis_treat_code() {
		return his_treat_code;
	}
	public void setHis_treat_code(String his_treat_code) {
		this.his_treat_code = his_treat_code;
	}
	public String getHis_work_code() {
		return his_work_code;
	}
	public void setHis_work_code(String his_work_code) {
		this.his_work_code = his_work_code;
	}
	public String getHis_claim_code() {
		return his_claim_code;
	}
	public void setHis_claim_code(String his_claim_code) {
		this.his_claim_code = his_claim_code;
	}
	public String getChangePass() {
		return changePass;
	}
	public void setChangePass(String changePass) {
		this.changePass = changePass;
	}
	public String getCrm_code() {
		return crm_code;
	}
	public void setCrm_code(String crm_code) {
		this.crm_code = crm_code;
	}
	public String getTreat_no() {
		return treat_no;
	}
	public void setTreat_no(String treat_no) {
		this.treat_no = treat_no;
	}
	public String getCust_nm() {
		return cust_nm;
	}
	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}
	public String getAs_no() {
		return as_no;
	}
	public void setAs_no(String as_no) {
		this.as_no = as_no;
	}
	public String getAccept_dt() {
		return accept_dt;
	}
	public void setAccept_dt(String accept_dt) {
		this.accept_dt = accept_dt;
	}
	public String getProc_status() {
		return proc_status;
	}
	public void setProc_status(String proc_status) {
		this.proc_status = proc_status;
	}
	public String getProc_dt() {
		return proc_dt;
	}
	public void setProc_dt(String proc_dt) {
		this.proc_dt = proc_dt;
	}
	public String getInquiry_service() {
		return inquiry_service;
	}
	public void setInquiry_service(String inquiry_service) {
		this.inquiry_service = inquiry_service;
	}
	public String getInquiry_type() {
		return inquiry_type;
	}
	public void setInquiry_type(String inquiry_type) {
		this.inquiry_type = inquiry_type;
	}
	public String getDam_emp_name() {
		return dam_emp_name;
	}
	public void setDam_emp_name(String dam_emp_name) {
		this.dam_emp_name = dam_emp_name;
	}
	public String getDam_tel_no() {
		return dam_tel_no;
	}
	public void setDam_tel_no(String dam_tel_no) {
		this.dam_tel_no = dam_tel_no;
	}
	public String getCeo() {
		return ceo;
	}
	public void setCeo(String ceo) {
		this.ceo = ceo;
	}
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getCust_address() {
		return cust_address;
	}
	public void setCust_address(String cust_address) {
		this.cust_address = cust_address;
	}
	public String getZip_code() {
		return zip_code;
	}
	public void setZip_code(String zip_code) {
		this.zip_code = zip_code;
	}
	public String getCust_no() {
		return cust_no;
	}
	public void setCust_no(String cust_no) {
		this.cust_no = cust_no;
	}
	public String getSeq_arr() {
		return seq_arr;
	}
	public void setSeq_arr(String seq_arr) {
		this.seq_arr = seq_arr;
	}
	public String getCust_kor_name() {
		return cust_kor_name;
	}
	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}
	public String getEmp_grade_name() {
		return emp_grade_name;
	}
	public void setEmp_grade_name(String emp_grade_name) {
		this.emp_grade_name = emp_grade_name;
	}
	public String getUse_type_name() {
		return use_type_name;
	}
	public void setUse_type_name(String use_type_name) {
		this.use_type_name = use_type_name;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getEmp_id() {
		return emp_id;
	}
	public void setEmp_id(String emp_id) {
		this.emp_id = emp_id;
	}
	public String getCust_code() {
		return cust_code;
	}
	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}
	public String getEmp_grade() {
		return emp_grade;
	}
	public void setEmp_grade(String emp_grade) {
		this.emp_grade = emp_grade;
	}
	public String getUse_type() {
		return use_type;
	}
	public void setUse_type(String use_type) {
		this.use_type = use_type;
	}
	public String getJoin_date() {
		return join_date;
	}
	public void setJoin_date(String join_date) {
		this.join_date = join_date;
	}
	public String getEmp_name() {
		return emp_name;
	}
	public void setEmp_name(String emp_name) {
		this.emp_name = emp_name;
	}
	public String getDept_name() {
		return dept_name;
	}
	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}
	public String getDept_grade() {
		return dept_grade;
	}
	public void setDept_grade(String dept_grade) {
		this.dept_grade = dept_grade;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getTel_no() {
		return tel_no;
	}
	public void setTel_no(String tel_no) {
		this.tel_no = tel_no;
	}
	public List<UserVO> getOUTCURSOR() {
		return OUTCURSOR;
	}
	public void setOUTCURSOR(List<UserVO> oUTCURSOR) {
		OUTCURSOR = oUTCURSOR;
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
	public String getDept_duty() {
		return dept_duty;
	}
	public void setDept_duty(String dept_duty) {
		this.dept_duty = dept_duty;
	}
	public String getE_mail() {
		return e_mail;
	}
	public void setE_mail(String e_mail) {
		this.e_mail = e_mail;
	}
	public String getMobile_no() {
		return mobile_no;
	}
	public void setMobile_no(String mobile_no) {
		this.mobile_no = mobile_no;
	}
	public String getRetire_date() {
		return retire_date;
	}
	public void setRetire_date(String retire_date) {
		this.retire_date = retire_date;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getDept_nm() {
		return dept_nm;
	}
	public void setDept_nm(String dept_nm) {
		this.dept_nm = dept_nm;
	}
	public String getDept_duty_nm() {
		return dept_duty_nm;
	}
	public void setDept_duty_nm(String dept_duty_nm) {
		this.dept_duty_nm = dept_duty_nm;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getPass_chg_date() {
		return pass_chg_date;
	}
	public void setPass_chg_date(String pass_chg_date) {
		this.pass_chg_date = pass_chg_date;
	}
	public String getPass_d_day() {
		return pass_d_day;
	}
	public void setPass_d_day(String pass_d_day) {
		this.pass_d_day = pass_d_day;
	}
	public String getChg_day_yn() {
		return chg_day_yn;
	}
	public void setChg_day_yn(String chg_day_yn) {
		this.chg_day_yn = chg_day_yn;
	}
}