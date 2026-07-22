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
	private String part_type = "" ; 
	private String send_sms = "" ; 
	
	/**	CRM_CUST_ERP	*/
	private String seq = "" ;
	private String emp_id = "" ;
	private String cust_code = "" ;
	private String emp_grade = "" ;
	private String use_type = "" ;
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
	
	private String his_treat_name = "" ; 		
	
	
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
	
	
	
	public String getHis_treat_name() {
		return his_treat_name;
	}
	public void setHis_treat_name(String his_treat_name) {
		this.his_treat_name = his_treat_name;
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
	public String getPart_type() {
		return part_type;
	}
	public void setPart_type(String part_type) {
		this.part_type = part_type;
	}
	public String getSend_sms() {
		return send_sms;
	}
	public void setSend_sms(String send_sms) {
		this.send_sms = send_sms;
	}
	
}