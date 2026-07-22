package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

/**
 * @author kimminji
 *
 */
@Alias("custVO")
public class CustVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	
	/* CRM_CUST_MGT */
	private String gubun = "";
	private String seq = "";
	private String cust_code = "";
	private String erp_code = "";
	private String ceo = "";
	private String treat_no = "";
	private String cust_nm = "";
	private String cust_no = "";
	private String law_no = "";
	private String buss_condition = "";
	private String buss_item = "";
	private String zip_code = "";
	private String cust_address = "";
	private String cust_kor_name = "";
	private String crm_code = "";
	private String cust_gubun = "";
	private String foundation_code = "";
	private String foundation_dt = "";
	private String contract_dt = "";
	private String sales = "";
	private String bed_count = "";
	private String payment_code = "";
	private String director_no = "";
	private String director_addr = "";
	private String director_dtl = "";
	private String sales_grade = "";
	private String foundation_grade = "";
	private String detail_etc = "";
	private String detail_etc2 = "";
	private String reg_date = "";
	private String reg_id = "";
	private String upd_date = "";
	private String upd_id = "";
	private String maintenance_raise_dt = "";
	private String is_yn = "";
	private String is_yn_nm = "";
	

	/* crm_cust_mgt_issue */
	private String dtl_seq = "";
	private String gubun_code = "";
	private String contents = "";
	private String action_result_code = "";
	private String action_result_etc = "";
	private String action_change_date = "";
	private String action_emp_id = "";
	
	/* CRM_CUST_OPERATE_CHARGE */
	private String charge_code = "";
	private String charge_nm = "";
	private String company_tel_no = "";
	private String hp_no = "";
	private String email = "";
	
	/* crm_cust_operate_info */
	private String deal_code = "";
	private String ch_deal_code = "";
	private String deal_code_nm = "";
	private String cancel_dt = "";
	private String ch_cancel_dt = "";
	
	private String his_basic_code = "";
	private String his_treat_code = "";
	private String his_work_code = "";
	private String his_claim_code = "";
	private String his_basic_code_nm = "";
	private String his_treat_code_nm = "";
	private String his_work_code_nm = "";
	private String his_claim_code_nm = "";
	private String checkup_yn = "";
	private String his_yn = "";
	
	
	private String choice_yn = "";
	private String dentist_yn = "";
	private String mental_yn = "";
	private String oriental_yn = "";
	private String hemodialysis_yn = "";
	private String care_yn = "";
	private String care_grade = "";
	private String emergencyop_yn = "";
	private String nedis_yn = "";
	private String medicine_info_cust_code = "";
	private String emergency_type_code = "";
	private String card_van_cust_code =""; 
	private String examination_cust_code ="";
	private String pasc_cust_code ="";
	private String narcotics_yn ="";
	private String issmgt_yn ="";
	private String sms_yn ="";
	private String alimtalk_yn ="";
	private String qkact_yn ="";
	
	private String o_formation_code_nm   ="";
	private String o_server_code_nm      ="";
	private String o_model_code_nm       ="";
	private String o_os_nm               ="";
	private String o_ram_nm              ="";
	private String o_sid_nm              ="";
	private String o_server_id           ="";
	private String o_server_pw           ="";
	private String o_dur_ip              ="";
	private String o_mtac_contract_dt    ="";
	private String o_pc                  ="";
	private String o_oracle_version_nm   ="";
	private String o_outside_cust_code_nm="";
	private String o_vc_code             ="";
	private String o_mtac_code           ="";
	private String o_vc_nm               ="";
	private String o_mtac_nm             ="";
	
	private String onticsense_yn ="";
	private String van_yn ="";
	
	private String sid_nm ="";
	

	public String getCh_deal_code(){
		return ch_deal_code;
	}
	
	public void setCh_deal_code(String ch_deal_code) {
		this.ch_deal_code = ch_deal_code;
	}
	
	public String getCh_cancel_dt() {
		return ch_cancel_dt;
	}
	public void setCh_cancel_dt(String ch_cancel_dt) {
		this.ch_cancel_dt = ch_cancel_dt;
	}
	
	public String getHis_yn() {
		return his_yn;
	}

	public void setHis_yn(String his_yn) {
		this.his_yn = his_yn;
	}

	public String getCancel_dt() {
		return cancel_dt;
	}

	public void setCancel_dt(String cancel_dt) {
		this.cancel_dt = cancel_dt;
	}

	public String getCheckup_yn() {
		return checkup_yn;
	}

	public void setCheckup_yn(String checkup_yn) {
		this.checkup_yn = checkup_yn;
	}

	/* crm_cust_operate_note */
	private String etc = "";

	/* crm_cust_project_bd */
	private String bd_code = "";
	private String bd_etc = "";

	/* crm_cust_project_mgt */
	private String open_dt = "";
	private String package_code = "";
	private String term_start_dt = "";
	private String term_end_dt = "";
	private String term_person_count = "";
	private String mtac_month = "";
	private String test_dt = "";
	private String version = "";
	private String formation_code = "";
	private String formation_code_nm = "";
	private String server_code = "";
	private String model_code = "";
	private String model_code_nm = "";
	
	private String os = "";
	private String ram = "";
	private String sid = "";
	private String oracle_version = "";
	private String server_ip = "";
	private String server_id = "";
	private String server_pw = "";
	private String dur_ip = "";
	private String mtac_contract_dt = "";
	private String pc = "";
	private String accident_no = "";
	private String tel_no = "";
	private String fax_no = "";
	private String post_no = "";
	private String buss_open_dt = "";
	private String addr = "";
	private String homepage = "";
	private String basic_etc = "";
	private String medical_office = "";
	private String support_office = "";
	private String medical_office2 = "";
	private String specially_code = "";
	private String specially_code_nm = "";
	private String doctor_count = "";
	private String nurse_count = "";
	private String veterans_yn = "";
	private String military_yn = "";
	private String new_code = "";
	private String old_company_nm = "";
	private String come_count = "";
	private String average_count = "";
	private String outside_cust_code = "";
	private String charge_yn = "";
	private String pm = "";
	private String approval_dt = "";

	/* crm_cust_project_mtac */
	private String mtac_cust_code = "";

	/* crm_cust_project_vc */
	private String vc_code = "";
	
	private List<CustVO> OUTCURSOR = null ; 
	private String cnt = "" ; 
	private String cust_gubun_nm = "" ; 
	private String foundation_code_nm = "" ;
	
	/**	DB LINK	*/
	private String cust_cd = "" ;
	private String represent = "" ;
	private String biz_reg_no = "" ;
	private String corp_reg_no = "" ;
	private String biz_condition = "" ;
	private String biz_type = "" ;
	private String zip_nm = "" ;
	private String zip_cd = "" ;
	private String addr_detail = "" ;
	private String item_cd = "" ; 
	private String item_nm = "" ; 
	
	private String i_cnt = "" ;
	private String mt_cnt = "" ;
	private String vc_cnt = "" ;
	private String bd_cnt = "" ;
	private String cg_cnt = "" ;
	private String nt_cnt = "" ;
	private String ht_cnt = "" ;
	private String ins_cnt = "" ;
	private String del_dtl_seq = "";
	
	private String contract_seq = "" ; 
	private String contract_nm = "" ;
	private String bill_code = "" ;
	private String mtac_code = "" ;
	private String mtac_start_dt = "" ;
	private String mtac_end_dt = "" ;
	private String mon_off_amt = "" ;
	private String year_off_amt = "" ;
	
	private String base_cd = "" ;
	private String base_cd_nm = "" ;
	private String base_cd_grp = "" ;
	
	private String group_code1 = "" ;
	private String group_code2 = "" ;
	private String group_code3 = "" ;
	private String matr_code = "" ;
	private String serial_no = "" ;
	
	private String vc_nm ="";
	private String mtac_nm ="";
		
	private String buy_busi_name = "";
	private String buy_cost = "";
	private String service_period = "";
	private String service_method = "";
	private String auto_renew_yn = "";
	
	private String sale_ym = "";
	private String ubo_amt = "";
	private String su_amt = "";
	
	private String p_lock = "";
	private String procFlag = "";
	private String emp_nm = "" ;
	
	// 20171114 박승모 추가
	private String o_bed_count = "";
	private String new_code_nm = "";
	private String outside_cust_code_nm = "";
	private String p_cust_kor_name = "";
	private String p_crm_code = "";
	private String p_cust_gubun = "";
	private String p_cust_gubun_nm = "";
	private String p_new_code = "";
	private String p_new_code_nm = "";
	private String p_old_company_nm = "";
	private String p_bed_count = "";
	private String server_code_nm = "";
	private String os_nm = "";
	private String ram_nm = "";
	private String oracle_version_nm = "";
	private String p_outside_cust_code = "";
	private String p_outside_cust_code_nm = "";
	private String p_basic_etc = "";
	private String p_detail_etc = "";
	private String p_specially_code = "";
	private String p_doctor_count = "";
	
	/*김민지추가*/
	private String medicine_info_cust_code_nm = "";
	private String emergency_type_code_nm = "";
	private String card_van_cust_code_nm = "";
	private String examination_cust_code_nm = "";
	private String pasc_cust_code_nm = "";
	
	
	/*관리문서*/
	private String doc_seq = "";
	private String d_crm_code = "";
	private String file_seq = "";
	private String d_doc_type = "";
	private String d_detail_type = "";
	private String d_std_dt = "";
	private String d_doc_comment = "";
	private String d_reg_date = "";
	private String d_reg_id = "";
	private String d_del_date = "";
	private String d_del_id = "";
	private String d_del_yn = "";
	private String cust_seq = "";
	private String dc_cnt ="";
	private String attach_save_nm ="";
	private String attach_path ="";
	private String attach_path_dtl ="";
	private String attach_ori_nm ="";
	private String reg_nm ="";
	private String attach_ord ="";
	private String o_server_ip ="";
	
	/*2024.09.26 김규민 추가*/
	private String ecfc ="";
	private String kiosk_usage ="";
	private String eform_usage ="";
	
	/*2025.03.20 김규민 추가*/
	private String hie ="";
	
	public String getIs_yn_nm() {
		return is_yn_nm;
	}

	public void setIs_yn_nm(String is_yn_nm) {
		this.is_yn_nm = is_yn_nm;
	}

	public String getIs_yn() {
		return is_yn;
	}

	public void setIs_yn(String is_yn) {
		this.is_yn = is_yn;
	}

	public String getO_server_ip() {
		return o_server_ip;
	}

	public void setO_server_ip(String o_server_ip) {
		this.o_server_ip = o_server_ip;
	}

	public String getO_formation_code_nm() {
		return o_formation_code_nm;
	}

	public void setO_formation_code_nm(String o_formation_code_nm) {
		this.o_formation_code_nm = o_formation_code_nm;
	}

	public String getO_server_code_nm() {
		return o_server_code_nm;
	}

	public void setO_server_code_nm(String o_server_code_nm) {
		this.o_server_code_nm = o_server_code_nm;
	}

	public String getO_model_code_nm() {
		return o_model_code_nm;
	}

	public void setO_model_code_nm(String o_model_code_nm) {
		this.o_model_code_nm = o_model_code_nm;
	}

	public String getO_os_nm() {
		return o_os_nm;
	}

	public void setO_os_nm(String o_os_nm) {
		this.o_os_nm = o_os_nm;
	}

	public String getO_ram_nm() {
		return o_ram_nm;
	}

	public void setO_ram_nm(String o_ram_nm) {
		this.o_ram_nm = o_ram_nm;
	}

	public String getO_sid_nm() {
		return o_sid_nm;
	}

	public void setO_sid_nm(String o_sid_nm) {
		this.o_sid_nm = o_sid_nm;
	}

	public String getO_server_id() {
		return o_server_id;
	}

	public void setO_server_id(String o_server_id) {
		this.o_server_id = o_server_id;
	}

	public String getO_server_pw() {
		return o_server_pw;
	}

	public void setO_server_pw(String o_server_pw) {
		this.o_server_pw = o_server_pw;
	}

	public String getO_dur_ip() {
		return o_dur_ip;
	}

	public void setO_dur_ip(String o_dur_ip) {
		this.o_dur_ip = o_dur_ip;
	}

	public String getO_mtac_contract_dt() {
		return o_mtac_contract_dt;
	}

	public void setO_mtac_contract_dt(String o_mtac_contract_dt) {
		this.o_mtac_contract_dt = o_mtac_contract_dt;
	}

	public String getO_pc() {
		return o_pc;
	}

	public void setO_pc(String o_pc) {
		this.o_pc = o_pc;
	}

	public String getO_oracle_version_nm() {
		return o_oracle_version_nm;
	}

	public void setO_oracle_version_nm(String o_oracle_version_nm) {
		this.o_oracle_version_nm = o_oracle_version_nm;
	}

	public String getO_outside_cust_code_nm() {
		return o_outside_cust_code_nm;
	}

	public void setO_outside_cust_code_nm(String o_outside_cust_code_nm) {
		this.o_outside_cust_code_nm = o_outside_cust_code_nm;
	}

	public String getO_vc_code() {
		return o_vc_code;
	}

	public void setO_vc_code(String o_vc_code) {
		this.o_vc_code = o_vc_code;
	}

	public String getO_mtac_code() {
		return o_mtac_code;
	}

	public void setO_mtac_code(String o_mtac_code) {
		this.o_mtac_code = o_mtac_code;
	}

	public String getO_vc_nm() {
		return o_vc_nm;
	}

	public void setO_vc_nm(String o_vc_nm) {
		this.o_vc_nm = o_vc_nm;
	}

	public String getO_mtac_nm() {
		return o_mtac_nm;
	}

	public void setO_mtac_nm(String o_mtac_nm) {
		this.o_mtac_nm = o_mtac_nm;
	}

	public String getSid_nm() {
		return sid_nm;
	}

	public void setSid_nm(String sid_nm) {
		this.sid_nm = sid_nm;
	}

	public String getModel_code_nm() {
		return model_code_nm;
	}

	public void setModel_code_nm(String model_code_nm) {
		this.model_code_nm = model_code_nm;
	}

	public String getOnticsense_yn() {
		return onticsense_yn;
	}

	public void setOnticsense_yn(String onticsense_yn) {
		this.onticsense_yn = onticsense_yn;
	}

	public String getVan_yn() {
		return van_yn;
	}

	public void setVan_yn(String van_yn) {
		this.van_yn = van_yn;
	}

	public String getNarcotics_yn() {
		return narcotics_yn;
	}

	public void setNarcotics_yn(String narcotics_yn) {
		this.narcotics_yn = narcotics_yn;
	}
	
	public String getIssmgt_yn() {
		return issmgt_yn;
	}

	public void setIssmgt_yn(String issmgt_yn) {
		this.issmgt_yn = issmgt_yn;
	}
	
	public String getSms_yn() {
		return sms_yn;
	}

	public void setSms_yn(String sms_yn) {
		this.sms_yn = sms_yn;
	}
	
	public String getAlimtalk_yn() {
		return alimtalk_yn;
	}

	public void setAlimtalk_yn(String alimtalk_yn) {
		this.alimtalk_yn = alimtalk_yn;
	}
	
	public String getQkact_yn() {
		return qkact_yn;
	}

	public void setQkact_yn(String qkact_yn) {
		this.qkact_yn = qkact_yn;
	}

	public String getReg_nm() {
		return reg_nm;
	}

	public void setReg_nm(String reg_nm) {
		this.reg_nm = reg_nm;
	}

	public String getAttach_save_nm() {
		return attach_save_nm;
	}

	public void setAttach_save_nm(String attach_save_nm) {
		this.attach_save_nm = attach_save_nm;
	}

	public String getAttach_path() {
		return attach_path;
	}

	public void setAttach_path(String attach_path) {
		this.attach_path = attach_path;
	}

	public String getAttach_path_dtl() {
		return attach_path_dtl;
	}

	public void setAttach_path_dtl(String attach_path_dtl) {
		this.attach_path_dtl = attach_path_dtl;
	}

	public String getAttach_ori_nm() {
		return attach_ori_nm;
	}

	public void setAttach_ori_nm(String attach_ori_nm) {
		this.attach_ori_nm = attach_ori_nm;
	}

	public String getDc_cnt() {
		return dc_cnt;
	}

	public void setDc_cnt(String dc_cnt) {
		this.dc_cnt = dc_cnt;
	}

	public String getCust_seq() {
		return cust_seq;
	}

	public void setCust_seq(String cust_seq) {
		this.cust_seq = cust_seq;
	}

	public String getDoc_seq() {
		return doc_seq;
	}

	public void setDoc_seq(String doc_seq) {
		this.doc_seq = doc_seq;
	}

	public String getD_crm_code() {
		return d_crm_code;
	}

	public void setD_crm_code(String d_crm_code) {
		this.d_crm_code = d_crm_code;
	}

	public String getFile_seq() {
		return file_seq;
	}

	public void setFile_seq(String file_seq) {
		this.file_seq = file_seq;
	}

	public String getD_doc_type() {
		return d_doc_type;
	}

	public void setD_doc_type(String d_doc_type) {
		this.d_doc_type = d_doc_type;
	}

	public String getD_detail_type() {
		return d_detail_type;
	}

	public void setD_detail_type(String d_detail_type) {
		this.d_detail_type = d_detail_type;
	}

	public String getD_std_dt() {
		return d_std_dt;
	}

	public void setD_std_dt(String d_std_dt) {
		this.d_std_dt = d_std_dt;
	}

	public String getD_doc_comment() {
		return d_doc_comment;
	}

	public void setD_doc_comment(String d_doc_comment) {
		this.d_doc_comment = d_doc_comment;
	}

	public String getD_reg_date() {
		return d_reg_date;
	}

	public void setD_reg_date(String d_reg_date) {
		this.d_reg_date = d_reg_date;
	}

	public String getD_reg_id() {
		return d_reg_id;
	}

	public void setD_reg_id(String d_reg_id) {
		this.d_reg_id = d_reg_id;
	}

	public String getD_del_date() {
		return d_del_date;
	}

	public void setD_del_date(String d_del_date) {
		this.d_del_date = d_del_date;
	}

	public String getD_del_id() {
		return d_del_id;
	}

	public void setD_del_id(String d_del_id) {
		this.d_del_id = d_del_id;
	}

	public String getD_del_yn() {
		return d_del_yn;
	}

	public void setD_del_yn(String d_del_yn) {
		this.d_del_yn = d_del_yn;
	}

	public String getP_doctor_count() {
		return p_doctor_count;
	}

	public void setP_doctor_count(String p_doctor_count) {
		this.p_doctor_count = p_doctor_count;
	}

	public String getP_specially_code() {
		return p_specially_code;
	}

	public void setP_specially_code(String p_specially_code) {
		this.p_specially_code = p_specially_code;
	}

	public String getO_bed_count() {
		return o_bed_count;
	}

	public void setO_bed_count(String o_bed_count) {
		this.o_bed_count = o_bed_count;
	}

	public String getNew_code_nm() {
		return new_code_nm;
	}

	public void setNew_code_nm(String new_code_nm) {
		this.new_code_nm = new_code_nm;
	}

	public String getOutside_cust_code_nm() {
		return outside_cust_code_nm;
	}

	public void setOutside_cust_code_nm(String outside_cust_code_nm) {
		this.outside_cust_code_nm = outside_cust_code_nm;
	}

	public String getP_cust_kor_name() {
		return p_cust_kor_name;
	}

	public void setP_cust_kor_name(String p_cust_kor_name) {
		this.p_cust_kor_name = p_cust_kor_name;
	}

	public String getP_crm_code() {
		return p_crm_code;
	}

	public void setP_crm_code(String p_crm_code) {
		this.p_crm_code = p_crm_code;
	}

	public String getP_cust_gubun() {
		return p_cust_gubun;
	}

	public void setP_cust_gubun(String p_cust_gubun) {
		this.p_cust_gubun = p_cust_gubun;
	}

	public String getP_cust_gubun_nm() {
		return p_cust_gubun_nm;
	}

	public void setP_cust_gubun_nm(String p_cust_gubun_nm) {
		this.p_cust_gubun_nm = p_cust_gubun_nm;
	}

	public String getP_new_code() {
		return p_new_code;
	}

	public void setP_new_code(String p_new_code) {
		this.p_new_code = p_new_code;
	}

	public String getP_new_code_nm() {
		return p_new_code_nm;
	}

	public void setP_new_code_nm(String p_new_code_nm) {
		this.p_new_code_nm = p_new_code_nm;
	}

	public String getP_old_company_nm() {
		return p_old_company_nm;
	}

	public void setP_old_company_nm(String p_old_company_nm) {
		this.p_old_company_nm = p_old_company_nm;
	}

	public String getP_bed_count() {
		return p_bed_count;
	}

	public void setP_bed_count(String p_bed_count) {
		this.p_bed_count = p_bed_count;
	}

	public String getServer_code_nm() {
		return server_code_nm;
	}

	public void setServer_code_nm(String server_code_nm) {
		this.server_code_nm = server_code_nm;
	}

	public String getOs_nm() {
		return os_nm;
	}

	public void setOs_nm(String os_nm) {
		this.os_nm = os_nm;
	}

	public String getRam_nm() {
		return ram_nm;
	}

	public void setRam_nm(String ram_nm) {
		this.ram_nm = ram_nm;
	}

	public String getOracle_version_nm() {
		return oracle_version_nm;
	}

	public void setOracle_version_nm(String oracle_version_nm) {
		this.oracle_version_nm = oracle_version_nm;
	}
	

	/*김민지추가*/	
	public String getMedicine_info_cust_code_nm() {
		return medicine_info_cust_code_nm;
	}

	public void setMedicine_info_cust_code_nm(String medicine_info_cust_code_nm) {
		this.medicine_info_cust_code_nm = medicine_info_cust_code_nm;
	}

	public String getEmergency_type_code_nm() {
		return emergency_type_code_nm;
	}

	public void setEmergency_type_code_nm(String emergency_type_code_nm) {
		this.emergency_type_code_nm = emergency_type_code_nm;
	}


	public String getCard_van_cust_code_nm() {
		return card_van_cust_code_nm;
	}

	public void setCard_van_cust_code_nm(String card_van_cust_code_nm) {
		this.card_van_cust_code_nm = card_van_cust_code_nm;
	}
	
	
	public String getExamination_cust_code_nm() {
		return examination_cust_code_nm;
	}

	public void setExamination_cust_code_nm(String examination_cust_code_nm) {
		this.examination_cust_code_nm = examination_cust_code_nm;
	}


	public String getPasc_cust_code_nm () {
		return pasc_cust_code_nm ;
	}

	public void setPasc_cust_code_nm (String pasc_cust_code_nm ) {
		this.pasc_cust_code_nm  = pasc_cust_code_nm ;
	}

	
	
	
	

	public String getP_outside_cust_code() {
		return p_outside_cust_code;
	}

	public void setP_outside_cust_code(String p_outside_cust_code) {
		this.p_outside_cust_code = p_outside_cust_code;
	}

	public String getP_outside_cust_code_nm() {
		return p_outside_cust_code_nm;
	}

	public void setP_outside_cust_code_nm(String p_outside_cust_code_nm) {
		this.p_outside_cust_code_nm = p_outside_cust_code_nm;
	}
	
	
	
	

	public String getP_basic_etc() {
		return p_basic_etc;
	}

	public void setP_basic_etc(String p_basic_etc) {
		this.p_basic_etc = p_basic_etc;
	}

	public String getP_detail_etc() {
		return p_detail_etc;
	}

	public void setP_detail_etc(String p_detail_etc) {
		this.p_detail_etc = p_detail_etc;
	}
	
	// 20171114 박승모 추가 끝

	public String getEmp_nm() {
		return emp_nm;
	}

	public void setEmp_nm(String emp_nm) {
		this.emp_nm = emp_nm;
	}

	public String getProcFlag() {
		return procFlag;
	}

	public void setProcFlag(String procFlag) {
		this.procFlag = procFlag;
	}

	public String getP_lock() {
		return p_lock;
	}

	public void setP_lock(String p_lock) {
		this.p_lock = p_lock;
	}

	public String getSale_ym() {
		return sale_ym;
	}

	public void setSale_ym(String sale_ym) {
		this.sale_ym = sale_ym;
	}

	public String getUbo_amt() {
		return ubo_amt;
	}

	public void setUbo_amt(String ubo_amt) {
		this.ubo_amt = ubo_amt;
	}

	public String getSu_amt() {
		return su_amt;
	}

	public void setSu_amt(String su_amt) {
		this.su_amt = su_amt;
	}

	public String getBuy_busi_name() {
		return buy_busi_name;
	}

	public void setBuy_busi_name(String buy_busi_name) {
		this.buy_busi_name = buy_busi_name;
	}

	public String getBuy_cost() {
		return buy_cost;
	}

	public void setBuy_cost(String buy_cost) {
		this.buy_cost = buy_cost;
	}

	public String getService_period() {
		return service_period;
	}

	public void setService_period(String service_period) {
		this.service_period = service_period;
	}

	public String getService_method() {
		return service_method;
	}

	public void setService_method(String service_method) {
		this.service_method = service_method;
	}

	public String getAuto_renew_yn() {
		return auto_renew_yn;
	}

	public void setAuto_renew_yn(String auto_renew_yn) {
		this.auto_renew_yn = auto_renew_yn;
	}

	public String getFormation_code_nm() {
		return formation_code_nm;
	}

	public void setFormation_code_nm(String formation_code_nm) {
		this.formation_code_nm = formation_code_nm;
	}

	public String getDeal_code_nm() {
		return deal_code_nm;
	}

	public void setDeal_code_nm(String deal_code_nm) {
		this.deal_code_nm = deal_code_nm;
	}

	public String getHis_basic_code_nm() {
		return his_basic_code_nm;
	}

	public void setHis_basic_code_nm(String his_basic_code_nm) {
		this.his_basic_code_nm = his_basic_code_nm;
	}

	public String getHis_treat_code_nm() {
		return his_treat_code_nm;
	}

	public void setHis_treat_code_nm(String his_treat_code_nm) {
		this.his_treat_code_nm = his_treat_code_nm;
	}

	public String getHis_work_code_nm() {
		return his_work_code_nm;
	}

	public void setHis_work_code_nm(String his_work_code_nm) {
		this.his_work_code_nm = his_work_code_nm;
	}

	public String getHis_claim_code_nm() {
		return his_claim_code_nm;
	}

	public void setHis_claim_code_nm(String his_claim_code_nm) {
		this.his_claim_code_nm = his_claim_code_nm;
	}

	public String getSpecially_code_nm() {
		return specially_code_nm;
	}

	public void setSpecially_code_nm(String specially_code_nm) {
		this.specially_code_nm = specially_code_nm;
	}

	public String getZip_code() {
		return zip_code;
	}

	public void setZip_code(String zip_code) {
		this.zip_code = zip_code;
	}

	public String getZip_cd() {
		return zip_cd;
	}

	public void setZip_cd(String zip_cd) {
		this.zip_cd = zip_cd;
	}

	public String getDetail_etc2() {
		return detail_etc2;
	}

	public void setDetail_etc2(String detail_etc2) {
		this.detail_etc2 = detail_etc2;
	}

	public String getVc_nm() {
		return vc_nm;
	}

	public void setVc_nm(String vc_nm) {
		this.vc_nm = vc_nm;
	}

	public String getMtac_nm() {
		return mtac_nm;
	}

	public void setMtac_nm(String mtac_nm) {
		this.mtac_nm = mtac_nm;
	}

	public String getGroup_code1() {
		return group_code1;
	}

	public void setGroup_code1(String group_code1) {
		this.group_code1 = group_code1;
	}

	public String getGroup_code2() {
		return group_code2;
	}

	public void setGroup_code2(String group_code2) {
		this.group_code2 = group_code2;
	}

	public String getGroup_code3() {
		return group_code3;
	}

	public void setGroup_code3(String group_code3) {
		this.group_code3 = group_code3;
	}

	public String getMatr_code() {
		return matr_code;
	}

	public void setMatr_code(String matr_code) {
		this.matr_code = matr_code;
	}

	public String getSerial_no() {
		return serial_no;
	}

	public void setSerial_no(String serial_no) {
		this.serial_no = serial_no;
	}

	public String getIns_cnt() {
		return ins_cnt;
	}

	public void setIns_cnt(String ins_cnt) {
		this.ins_cnt = ins_cnt;
	}

	public String getBase_cd() {
		return base_cd;
	}

	public void setBase_cd(String base_cd) {
		this.base_cd = base_cd;
	}

	public String getBase_cd_nm() {
		return base_cd_nm;
	}

	public void setBase_cd_nm(String base_cd_nm) {
		this.base_cd_nm = base_cd_nm;
	}

	public String getBase_cd_grp() {
		return base_cd_grp;
	}

	public void setBase_cd_grp(String base_cd_grp) {
		this.base_cd_grp = base_cd_grp;
	}

	public String getMtac_start_dt() {
		return mtac_start_dt;
	}

	public void setMtac_start_dt(String mtac_start_dt) {
		this.mtac_start_dt = mtac_start_dt;
	}

	public String getMtac_end_dt() {
		return mtac_end_dt;
	}

	public void setMtac_end_dt(String mtac_end_dt) {
		this.mtac_end_dt = mtac_end_dt;
	}

	public String getMon_off_amt() {
		return mon_off_amt;
	}

	public void setMon_off_amt(String mon_off_amt) {
		this.mon_off_amt = mon_off_amt;
	}

	public String getYear_off_amt() {
		return year_off_amt;
	}

	public void setYear_off_amt(String year_off_amt) {
		this.year_off_amt = year_off_amt;
	}

	public String getMtac_code() {
		return mtac_code;
	}

	public void setMtac_code(String mtac_code) {
		this.mtac_code = mtac_code;
	}

	public String getBill_code() {
		return bill_code;
	}

	public void setBill_code(String bill_code) {
		this.bill_code = bill_code;
	}

	public String getContract_nm() {
		return contract_nm;
	}

	public void setContract_nm(String contract_nm) {
		this.contract_nm = contract_nm;
	}

	public String getContract_seq() {
		return contract_seq;
	}

	public void setContract_seq(String contract_seq) {
		this.contract_seq = contract_seq;
	}

	public String getHt_cnt() {
		return ht_cnt;
	}

	public void setHt_cnt(String ht_cnt) {
		this.ht_cnt = ht_cnt;
	}

	public String getItem_cd() {
		return item_cd;
	}

	public void setItem_cd(String item_cd) {
		this.item_cd = item_cd;
	}

	public String getItem_nm() {
		return item_nm;
	}

	public void setItem_nm(String item_nm) {
		this.item_nm = item_nm;
	}

	public String getNt_cnt() {
		return nt_cnt;
	}

	public void setNt_cnt(String nt_cnt) {
		this.nt_cnt = nt_cnt;
	}

	public String getMt_cnt() {
		return mt_cnt;
	}

	public void setMt_cnt(String mt_cnt) {
		this.mt_cnt = mt_cnt;
	}

	public String getVc_cnt() {
		return vc_cnt;
	}

	public void setVc_cnt(String vc_cnt) {
		this.vc_cnt = vc_cnt;
	}

	public String getBd_cnt() {
		return bd_cnt;
	}

	public void setBd_cnt(String bd_cnt) {
		this.bd_cnt = bd_cnt;
	}

	public String getCg_cnt() {
		return cg_cnt;
	}

	public void setCg_cnt(String cg_cnt) {
		this.cg_cnt = cg_cnt;
	}
	
	public String getDel_dtl_seq() {
		return del_dtl_seq;
	}

	public void setDel_dtl_seq(String del_dtl_seq) {
		this.del_dtl_seq = del_dtl_seq;
	}

	public String getI_cnt() {
		return i_cnt;
	}

	public void setI_cnt(String i_cnt) {
		this.i_cnt = i_cnt;
	}

	public String getCust_cd() {
		return cust_cd;
	}

	public void setCust_cd(String cust_cd) {
		this.cust_cd = cust_cd;
	}

	public String getRepresent() {
		return represent;
	}

	public void setRepresent(String represent) {
		this.represent = represent;
	}

	public String getBiz_reg_no() {
		return biz_reg_no;
	}

	public void setBiz_reg_no(String biz_reg_no) {
		this.biz_reg_no = biz_reg_no;
	}

	public String getCorp_reg_no() {
		return corp_reg_no;
	}

	public void setCorp_reg_no(String corp_reg_no) {
		this.corp_reg_no = corp_reg_no;
	}

	public String getBiz_condition() {
		return biz_condition;
	}

	public void setBiz_condition(String biz_condition) {
		this.biz_condition = biz_condition;
	}

	public String getBiz_type() {
		return biz_type;
	}

	public void setBiz_type(String biz_type) {
		this.biz_type = biz_type;
	}

	public String getZip_nm() {
		return zip_nm;
	}

	public void setZip_nm(String zip_nm) {
		this.zip_nm = zip_nm;
	}

	public String getAddr_detail() {
		return addr_detail;
	}

	public void setAddr_detail(String addr_detail) {
		this.addr_detail = addr_detail;
	}

	public String getCust_gubun_nm() {
		return cust_gubun_nm;
	}

	public void setCust_gubun_nm(String cust_gubun_nm) {
		this.cust_gubun_nm = cust_gubun_nm;
	}

	public String getFoundation_code_nm() {
		return foundation_code_nm;
	}

	public void setFoundation_code_nm(String foundation_code_nm) {
		this.foundation_code_nm = foundation_code_nm;
	}

	public String getCnt() {
		return cnt;
	}

	public void setCnt(String cnt) {
		this.cnt = cnt;
	}

	public List<CustVO> getOUTCURSOR() {
		return OUTCURSOR;
	}

	public void setOUTCURSOR(List<CustVO> oUTCURSOR) {
		OUTCURSOR = oUTCURSOR;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getDtl_seq() {
		return dtl_seq;
	}

	public void setDtl_seq(String dtl_seq) {
		this.dtl_seq = dtl_seq;
	}

	public String getGubun() {
		return gubun;
	}

	public void setGubun(String gubun) {
		this.gubun = gubun;
	}

	public String getCust_code() {
		return cust_code;
	}

	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}

	public String getErp_code() {
		return erp_code;
	}

	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}

	public String getCeo() {
		return ceo;
	}

	public void setCeo(String ceo) {
		this.ceo = ceo;
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

	public String getCust_no() {
		return cust_no;
	}

	public void setCust_no(String cust_no) {
		this.cust_no = cust_no;
	}

	public String getLaw_no() {
		return law_no;
	}

	public void setLaw_no(String law_no) {
		this.law_no = law_no;
	}

	public String getBuss_condition() {
		return buss_condition;
	}

	public void setBuss_condition(String buss_condition) {
		this.buss_condition = buss_condition;
	}

	public String getBuss_item() {
		return buss_item;
	}

	public void setBuss_item(String buss_item) {
		this.buss_item = buss_item;
	}

	public String getCust_address() {
		return cust_address;
	}

	public void setCust_address(String cust_address) {
		this.cust_address = cust_address;
	}

	public String getCust_kor_name() {
		return cust_kor_name;
	}

	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}

	public String getCrm_code() {
		return crm_code;
	}

	public void setCrm_code(String crm_code) {
		this.crm_code = crm_code;
	}

	public String getCust_gubun() {
		return cust_gubun;
	}

	public void setCust_gubun(String cust_gubun) {
		this.cust_gubun = cust_gubun;
	}

	public String getFoundation_code() {
		return foundation_code;
	}

	public void setFoundation_code(String foundation_code) {
		this.foundation_code = foundation_code;
	}

	public String getFoundation_dt() {
		return foundation_dt;
	}

	public void setFoundation_dt(String foundation_dt) {
		this.foundation_dt = foundation_dt;
	}

	public String getContract_dt() {
		return contract_dt;
	}

	public void setContract_dt(String contract_dt) {
		this.contract_dt = contract_dt;
	}
	
	
	public String getMaintenance_raise_dt() {
		return maintenance_raise_dt;
	}

	public void setMaintenance_raise_dt(String maintenance_raise_dt) {
		this.maintenance_raise_dt = maintenance_raise_dt;
	}


	public String getSales() {
		return sales;
	}

	public void setSales(String sales) {
		this.sales = sales;
	}

	public String getBed_count() {
		return bed_count;
	}

	public void setBed_count(String bed_count) {
		this.bed_count = bed_count;
	}

	public String getPayment_code() {
		return payment_code;
	}

	public void setPayment_code(String payment_code) {
		this.payment_code = payment_code;
	}

	public String getDirector_no() {
		return director_no;
	}

	public void setDirector_no(String director_no) {
		this.director_no = director_no;
	}

	public String getDirector_addr() {
		return director_addr;
	}

	public void setDirector_addr(String director_addr) {
		this.director_addr = director_addr;
	}

	public String getDirector_dtl() {
		return director_dtl;
	}

	public void setDirector_dtl(String director_dtl) {
		this.director_dtl = director_dtl;
	}

	public String getSales_grade() {
		return sales_grade;
	}

	public void setSales_grade(String sales_grade) {
		this.sales_grade = sales_grade;
	}

	public String getFoundation_grade() {
		return foundation_grade;
	}

	public void setFoundation_grade(String foundation_grade) {
		this.foundation_grade = foundation_grade;
	}

	public String getDetail_etc() {
		return detail_etc;
	}

	public void setDetail_etc(String detail_etc) {
		this.detail_etc = detail_etc;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}

	public String getReg_id() {
		return reg_id;
	}

	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}

	public String getUpd_date() {
		return upd_date;
	}

	public void setUpd_date(String upd_date) {
		this.upd_date = upd_date;
	}

	public String getUpd_id() {
		return upd_id;
	}

	public void setUpd_id(String upd_id) {
		this.upd_id = upd_id;
	}

	public String getGubun_code() {
		return gubun_code;
	}

	public void setGubun_code(String gubun_code) {
		this.gubun_code = gubun_code;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public String getAction_result_code() {
		return action_result_code;
	}

	public void setAction_result_code(String action_result_code) {
		this.action_result_code = action_result_code;
	}

	public String getAction_result_etc() {
		return action_result_etc;
	}

	public void setAction_result_etc(String action_result_etc) {
		this.action_result_etc = action_result_etc;
	}

	public String getAction_change_date() {
		return action_change_date;
	}

	public void setAction_change_date(String action_change_date) {
		this.action_change_date = action_change_date;
	}

	public String getAction_emp_id() {
		return action_emp_id;
	}

	public void setAction_emp_id(String action_emp_id) {
		this.action_emp_id = action_emp_id;
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

	public String getDeal_code() {
		return deal_code;
	}

	public void setDeal_code(String deal_code) {
		this.deal_code = deal_code;
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

	public String getChoice_yn() {
		return choice_yn;
	}

	public void setChoice_yn(String choice_yn) {
		this.choice_yn = choice_yn;
	}

	public String getDentist_yn() {
		return dentist_yn;
	}

	public void setDentist_yn(String dentist_yn) {
		this.dentist_yn = dentist_yn;
	}

	public String getMental_yn() {
		return mental_yn;
	}

	public void setMental_yn(String mental_yn) {
		this.mental_yn = mental_yn;
	}

	public String getOriental_yn() {
		return oriental_yn;
	}

	public void setOriental_yn(String oriental_yn) {
		this.oriental_yn = oriental_yn;
	}

	public String getHemodialysis_yn() {
		return hemodialysis_yn;
	}

	public void setHemodialysis_yn(String hemodialysis_yn) {
		this.hemodialysis_yn = hemodialysis_yn;
	}

	public String getCare_yn() {
		return care_yn;
	}

	public void setCare_yn(String care_yn) {
		this.care_yn = care_yn;
	}

	public String getCare_grade() {
		return care_grade;
	}

	public void setCare_grade(String care_grade) {
		this.care_grade = care_grade;
	}

	public String getEtc() {
		return etc;
	}

	public void setEtc(String etc) {
		this.etc = etc;
	}

	public String getBd_code() {
		return bd_code;
	}

	public void setBd_code(String bd_code) {
		this.bd_code = bd_code;
	}

	public String getBd_etc() {
		return bd_etc;
	}

	public void setBd_etc(String bd_etc) {
		this.bd_etc = bd_etc;
	}

	public String getOpen_dt() {
		return open_dt;
	}

	public void setOpen_dt(String open_dt) {
		this.open_dt = open_dt;
	}


	public String getApproval_dt() {
		return approval_dt;
	}

	public void setApproval_dt(String approval_dt) {
		this.approval_dt = approval_dt;
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

	public String getTerm_person_count() {
		return term_person_count;
	}

	public void setTerm_person_count(String term_person_count) {
		this.term_person_count = term_person_count;
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

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getFormation_code() {
		return formation_code;
	}

	public void setFormation_code(String formation_code) {
		this.formation_code = formation_code;
	}

	public String getServer_code() {
		return server_code;
	}

	public void setServer_code(String server_code) {
		this.server_code = server_code;
	}

	public String getModel_code() {
		return model_code;
	}

	public void setModel_code(String model_code) {
		this.model_code = model_code;
	}

	public String getOs() {
		return os;
	}

	public void setOs(String os) {
		this.os = os;
	}

	public String getRam() {
		return ram;
	}

	public void setRam(String ram) {
		this.ram = ram;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getOracle_version() {
		return oracle_version;
	}

	public void setOracle_version(String oracle_version) {
		this.oracle_version = oracle_version;
	}

	public String getServer_ip() {
		return server_ip;
	}

	public void setServer_ip(String server_ip) {
		this.server_ip = server_ip;
	}

	public String getServer_id() {
		return server_id;
	}

	public void setServer_id(String server_id) {
		this.server_id = server_id;
	}

	public String getServer_pw() {
		return server_pw;
	}

	public void setServer_pw(String server_pw) {
		this.server_pw = server_pw;
	}

	public String getDur_ip() {
		return dur_ip;
	}

	public void setDur_ip(String dur_ip) {
		this.dur_ip = dur_ip;
	}

	public String getMtac_contract_dt() {
		return mtac_contract_dt;
	}

	public void setMtac_contract_dt(String mtac_contract_dt) {
		this.mtac_contract_dt = mtac_contract_dt;
	}

	public String getPc() {
		return pc;
	}

	public void setPc(String pc) {
		this.pc = pc;
	}

	public String getAccident_no() {
		return accident_no;
	}

	public void setAccident_no(String accident_no) {
		this.accident_no = accident_no;
	}

	public String getTel_no() {
		return tel_no;
	}

	public void setTel_no(String tel_no) {
		this.tel_no = tel_no;
	}

	public String getFax_no() {
		return fax_no;
	}

	public void setFax_no(String fax_no) {
		this.fax_no = fax_no;
	}

	public String getPost_no() {
		return post_no;
	}

	public void setPost_no(String post_no) {
		this.post_no = post_no;
	}

	public String getBuss_open_dt() {
		return buss_open_dt;
	}

	public void setBuss_open_dt(String buss_open_dt) {
		this.buss_open_dt = buss_open_dt;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getHomepage() {
		return homepage;
	}

	public void setHomepage(String homepage) {
		this.homepage = homepage;
	}

	public String getBasic_etc() {
		return basic_etc;
	}

	public void setBasic_etc(String basic_etc) {
		this.basic_etc = basic_etc;
	}

	public String getMedical_office() {
		return medical_office;
	}

	public void setMedical_office(String medical_office) {
		this.medical_office = medical_office;
	}

	public String getSupport_office() {
		return support_office;
	}

	public void setSupport_office(String support_office) {
		this.support_office = support_office;
	}

	public String getMedical_office2() {
		return medical_office2;
	}

	public void setMedical_office2(String medical_office2) {
		this.medical_office2 = medical_office2;
	}

	public String getSpecially_code() {
		return specially_code;
	}

	public void setSpecially_code(String specially_code) {
		this.specially_code = specially_code;
	}

	public String getDoctor_count() {
		return doctor_count;
	}

	public void setDoctor_count(String doctor_count) {
		this.doctor_count = doctor_count;
	}

	public String getNurse_count() {
		return nurse_count;
	}

	public void setNurse_count(String nurse_count) {
		this.nurse_count = nurse_count;
	}
	
	

	public String getEmergencyop_yn() {
		return emergencyop_yn;
	}

	public void setEmergencyop_yn(String emergencyop_yn) {
		this.emergencyop_yn = emergencyop_yn;
	}
	
	public String getNedis_yn() {
		return nedis_yn;
	}
	
	public void setNedis_yn(String nedis_yn) {
		this.nedis_yn = nedis_yn;
	}
	

	public String getVeterans_yn() {
		return veterans_yn;
	}

	public void setVeterans_yn(String veterans_yn) {
		this.veterans_yn = veterans_yn;
	}

	public String getMilitary_yn() {
		return military_yn;
	}

	public void setMilitary_yn(String military_yn) {
		this.military_yn = military_yn;
	}

	public String getNew_code() {
		return new_code;
	}

	public void setNew_code(String new_code) {
		this.new_code = new_code;
	}

	public String getOld_company_nm() {
		return old_company_nm;
	}

	public void setOld_company_nm(String old_company_nm) {
		this.old_company_nm = old_company_nm;
	}

	public String getCome_count() {
		return come_count;
	}

	public void setCome_count(String come_count) {
		this.come_count = come_count;
	}

	public String getAverage_count() {
		return average_count;
	}

	public void setAverage_count(String average_count) {
		this.average_count = average_count;
	}


	
	public String getMedicine_info_cust_code() {
		return medicine_info_cust_code;
	}

	public void setMedicine_info_cust_code(String medicine_info_cust_code) {
		this.medicine_info_cust_code = medicine_info_cust_code;
	}

	public String getEmergency_type_code() {
		return emergency_type_code;
	}

	public void setEmergency_type_code(String emergency_type_code) {
		this.emergency_type_code = emergency_type_code;
	}

	public String getCard_van_cust_code() {
		return card_van_cust_code;
	}

	public void setCard_van_cust_code(String card_van_cust_code) {
		this.card_van_cust_code = card_van_cust_code;
	}

	public String getExamination_cust_code() {
		return examination_cust_code;
	}

	public void setExamination_cust_code(String examination_cust_code) {
		this.examination_cust_code = examination_cust_code;
	}

	public String getPasc_cust_code() {
		return pasc_cust_code;
	}

	public void setPasc_cust_code(String pasc_cust_code) {
		this.pasc_cust_code = pasc_cust_code;
	}

	

	
	public String getOutside_cust_code() {
		return outside_cust_code;
	}

	public void setOutside_cust_code(String outside_cust_code) {
		this.outside_cust_code = outside_cust_code;
	}

	public String getCharge_yn() {
		return charge_yn;
	}

	public void setCharge_yn(String charge_yn) {
		this.charge_yn = charge_yn;
	}

	public String getPm() {
		return pm;
	}

	public void setPm(String pm) {
		this.pm = pm;
	}

	public String getMtac_cust_code() {
		return mtac_cust_code;
	}

	public void setMtac_cust_code(String mtac_cust_code) {
		this.mtac_cust_code = mtac_cust_code;
	}

	public String getVc_code() {
		return vc_code;
	}

	public void setVc_code(String vc_code) {
		this.vc_code = vc_code;
	}
	
	public String getEcfc() {
		return ecfc;
	}

	public void setEcfc(String ecfc) {
		this.ecfc = ecfc;
	}
	
	public String getKiosk_usage() {
		return kiosk_usage;
	}

	public void setKiosk_usage(String kiosk_usage) {
		this.kiosk_usage = kiosk_usage;
	}
	
	public String getEform_usage() {
		return eform_usage;
	}

	public void setEform_usage(String eform_usage) {
		this.eform_usage = eform_usage;
	}
	
	public String getHie() {
		return hie;
	}

	public void setHie(String hie) {
		this.hie = hie;
	}
	
}
