package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("projectVO")
public class ProjectVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	
	/*프로젝트관리*/
	private String seq  ="";    
	private String pro_seq  ="";    
	private String cust_seq ="";  
	private String open_dt    ="";
	private String package_code="";
	private String term_start_dt ="";
	private String term_end_dt="";
	private String mtac_month ="";
	private String test_dt    ="";
	private String erp_code   ="";
	private String p_lock     ="";
	private String project_nm ="";
	private String system_code="";
	private String system_nm ="";
	private String state_type_nm ="";
	private String state_type ="";
	private String cust_nm ="";
	private String pjt_code ="";
	private String worker_fix ="";
	
	
	
	/*서버 정보 */
	private String server_seq="";    
	private String project_seq="";    
	private String os_nm="";    
	private String server_type_nm="";    
	private String server_status_nm="";    
	private String main_mng_nm="";    
	private String emp_nm="";    
	private String server_nm="";    
	private String pb_ip="";    
	private String server_ip="";    
	
	/*참여인력이력 관리*/
	private String wk_seq         ="";
	private String task_code    ="";
	private String worker_nm      ="";
	private String work_start_dt  ="";
	private String work_end_dt    ="";
	private String wk_hp_no          ="";
	private String wk_email          ="";
	private String wk_company        ="";
	private String wk_etc        ="";
	private String cust_address ="";
	              
	/*담당자 관리*/                    
	private String ch_seq         ="";
	private String charge_code    ="";
	private String charge_nm      ="";
	private String company_tel_no ="";
	private String hp_no          ="";
	private String email          ="";
	private String ch_etc            ="";
	private String company_nm     ="";
	
	/*기타 */
	private String dtl_seq    ="";
	private String del_dtl_seq    ="";
	private String del_dtl_seq1    ="";
	private String del_dtl_seq2    ="";
	private String del_dtl_seq3    ="";
	private String cg_cnt    ="";
	private String wk_cnt    ="";
	private String sv_cnt    ="";
	private String cust_kor_name ="";
	private String cust_gubun_nm ="";
	private String deal_code_nm ="";
	private String system_code_nm ="";
	
	private String search_start1 ="";
	private String search_start2 ="";
	
	private String search_end1 ="";
	private String search_end2 ="";
	
	
	
	
	public String getWorker_fix() {
		return worker_fix;
	}
	public void setWorker_fix(String worker_fix) {
		this.worker_fix = worker_fix;
	}
	public String getPjt_code() {
		return pjt_code;
	}
	public void setPjt_code(String pjt_code) {
		this.pjt_code = pjt_code;
	}
	public String getSearch_start1() {
		return search_start1;
	}
	public void setSearch_start1(String search_start1) {
		this.search_start1 = search_start1;
	}
	public String getSearch_start2() {
		return search_start2;
	}
	public void setSearch_start2(String search_start2) {
		this.search_start2 = search_start2;
	}
	public String getSearch_end1() {
		return search_end1;
	}
	public void setSearch_end1(String search_end1) {
		this.search_end1 = search_end1;
	}
	public String getSearch_end2() {
		return search_end2;
	}
	public void setSearch_end2(String search_end2) {
		this.search_end2 = search_end2;
	}
	public String getDtl_seq() {
		return dtl_seq;
	}
	public void setDtl_seq(String dtl_seq) {
		this.dtl_seq = dtl_seq;
	}
	public String getCust_address() {
		return cust_address;
	}
	public void setCust_address(String cust_address) {
		this.cust_address = cust_address;
	}
	public String getCust_nm() {
		return cust_nm;
	}
	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}
	public String getCust_kor_name() {
		return cust_kor_name;
	}
	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}
	public String getCust_gubun_nm() {
		return cust_gubun_nm;
	}
	public void setCust_gubun_nm(String cust_gubun_nm) {
		this.cust_gubun_nm = cust_gubun_nm;
	}
	public String getDeal_code_nm() {
		return deal_code_nm;
	}
	public void setDeal_code_nm(String deal_code_nm) {
		this.deal_code_nm = deal_code_nm;
	}
	public String getSystem_code_nm() {
		return system_code_nm;
	}
	public void setSystem_code_nm(String system_code_nm) {
		this.system_code_nm = system_code_nm;
	}
	public String getWk_etc() {
		return wk_etc;
	}
	public void setWk_etc(String wk_etc) {
		this.wk_etc = wk_etc;
	}
	public String getCg_cnt() {
		return cg_cnt;
	}
	public void setCg_cnt(String cg_cnt) {
		this.cg_cnt = cg_cnt;
	}
	public String getWk_cnt() {
		return wk_cnt;
	}
	public void setWk_cnt(String wk_cnt) {
		this.wk_cnt = wk_cnt;
	}
	public String getSv_cnt() {
		return sv_cnt;
	}
	public void setSv_cnt(String sv_cnt) {
		this.sv_cnt = sv_cnt;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getProject_seq() {
		return project_seq;
	}
	public void setProject_seq(String project_seq) {
		this.project_seq = project_seq;
	}
	public String getOs_nm() {
		return os_nm;
	}
	public void setOs_nm(String os_nm) {
		this.os_nm = os_nm;
	}
	public String getServer_type_nm() {
		return server_type_nm;
	}
	public void setServer_type_nm(String server_type_nm) {
		this.server_type_nm = server_type_nm;
	}
	public String getServer_status_nm() {
		return server_status_nm;
	}
	public void setServer_status_nm(String server_status_nm) {
		this.server_status_nm = server_status_nm;
	}
	public String getMain_mng_nm() {
		return main_mng_nm;
	}
	public void setMain_mng_nm(String main_mng_nm) {
		this.main_mng_nm = main_mng_nm;
	}
	public String getEmp_nm() {
		return emp_nm;
	}
	public void setEmp_nm(String emp_nm) {
		this.emp_nm = emp_nm;
	}
	public String getServer_nm() {
		return server_nm;
	}
	public void setServer_nm(String server_nm) {
		this.server_nm = server_nm;
	}
	public String getPb_ip() {
		return pb_ip;
	}
	public void setPb_ip(String pb_ip) {
		this.pb_ip = pb_ip;
	}
	public String getSystem_nm() {
		return system_nm;
	}
	public void setSystem_nm(String system_nm) {
		this.system_nm = system_nm;
	}
	public String getState_type_nm() {
		return state_type_nm;
	}
	public void setState_type_nm(String state_type_nm) {
		this.state_type_nm = state_type_nm;
	}
	public String getState_type() {
		return state_type;
	}
	public void setState_type(String state_type) {
		this.state_type = state_type;
	}
	public String getDel_dtl_seq() {
		return del_dtl_seq;
	}
	public void setDel_dtl_seq(String del_dtl_seq) {
		this.del_dtl_seq = del_dtl_seq;
	}
	public String getPro_seq() {
		return pro_seq;
	}
	public void setPro_seq(String pro_seq) {
		this.pro_seq = pro_seq;
	}
	public String getCust_seq() {
		return cust_seq;
	}
	public void setCust_seq(String cust_seq) {
		this.cust_seq = cust_seq;
	}
	public String getOpen_dt() {
		return open_dt;
	}
	public void setOpen_dt(String open_dt) {
		this.open_dt = open_dt;
	}
	public String getPackage_code() {
		return package_code;
	}
	public void setPackage_code(String package_code) {
		this.package_code = package_code;
	}
	public String getTerm_start_dt() {
		return term_start_dt;
	}
	public void setTerm_start_dt(String term_start_dt) {
		this.term_start_dt = term_start_dt;
	}
	public String getTerm_end_dt() {
		return term_end_dt;
	}
	public void setTerm_end_dt(String term_end_dt) {
		this.term_end_dt = term_end_dt;
	}
	public String getMtac_month() {
		return mtac_month;
	}
	public void setMtac_month(String mtac_month) {
		this.mtac_month = mtac_month;
	}
	public String getTest_dt() {
		return test_dt;
	}
	public void setTest_dt(String test_dt) {
		this.test_dt = test_dt;
	}
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getP_lock() {
		return p_lock;
	}
	public void setP_lock(String p_lock) {
		this.p_lock = p_lock;
	}
	public String getProject_nm() {
		return project_nm;
	}
	public void setProject_nm(String project_nm) {
		this.project_nm = project_nm;
	}
	public String getSystem_code() {
		return system_code;
	}
	public void setSystem_code(String system_code) {
		this.system_code = system_code;
	}
	public String getServer_seq() {
		return server_seq;
	}
	public void setServer_seq(String server_seq) {
		this.server_seq = server_seq;
	}
	
	public String getServer_ip() {
		return server_ip;
	}
	public void setServer_ip(String server_ip) {
		this.server_ip = server_ip;
	}
	
	public String getWk_seq() {
		return wk_seq;
	}
	public void setWk_seq(String wk_seq) {
		this.wk_seq = wk_seq;
	}
	public String getTask_code() {
		return task_code;
	}
	public void setTask_code(String task_code) {
		this.task_code = task_code;
	}
	public String getWorker_nm() {
		return worker_nm;
	}
	public void setWorker_nm(String worker_nm) {
		this.worker_nm = worker_nm;
	}
	public String getWork_start_dt() {
		return work_start_dt;
	}
	public void setWork_start_dt(String work_start_dt) {
		this.work_start_dt = work_start_dt;
	}
	public String getWork_end_dt() {
		return work_end_dt;
	}
	public void setWork_end_dt(String work_end_dt) {
		this.work_end_dt = work_end_dt;
	}
	public String getWk_hp_no() {
		return wk_hp_no;
	}
	public void setWk_hp_no(String wk_hp_no) {
		this.wk_hp_no = wk_hp_no;
	}
	
	
	
	
	public String getWk_email() {
		return wk_email;
	}
	public void setWk_email(String wk_email) {
		this.wk_email = wk_email;
	}
	public String getWk_company() {
		return wk_company;
	}
	public void setWk_company(String wk_company) {
		this.wk_company = wk_company;
	}
	public String getCh_seq() {
		return ch_seq;
	}
	public void setCh_seq(String ch_seq) {
		this.ch_seq = ch_seq;
	}
	public String getCharge_code() {
		return charge_code;
	}
	public void setCharge_code(String charge_code) {
		this.charge_code = charge_code;
	}
	public String getCharge_nm() {
		return charge_nm;
	}
	public void setCharge_nm(String charge_nm) {
		this.charge_nm = charge_nm;
	}
	public String getCompany_tel_no() {
		return company_tel_no;
	}
	public void setCompany_tel_no(String company_tel_no) {
		this.company_tel_no = company_tel_no;
	}
	public String getHp_no() {
		return hp_no;
	}
	public void setHp_no(String hp_no) {
		this.hp_no = hp_no;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	
	public String getCh_etc() {
		return ch_etc;
	}
	public void setCh_etc(String ch_etc) {
		this.ch_etc = ch_etc;
	}
	public String getCompany_nm() {
		return company_nm;
	}
	public void setCompany_nm(String company_nm) {
		this.company_nm = company_nm;
	}
	public String getDel_dtl_seq1() {
		return del_dtl_seq1;
	}
	public void setDel_dtl_seq1(String del_dtl_seq1) {
		this.del_dtl_seq1 = del_dtl_seq1;
	}
	public String getDel_dtl_seq2() {
		return del_dtl_seq2;
	}
	public void setDel_dtl_seq2(String del_dtl_seq2) {
		this.del_dtl_seq2 = del_dtl_seq2;
	}
	public String getDel_dtl_seq3() {
		return del_dtl_seq3;
	}
	public void setDel_dtl_seq3(String del_dtl_seq3) {
		this.del_dtl_seq3 = del_dtl_seq3;
	}

	
}
