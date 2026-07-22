package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("networkVO")
public class NetworkVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	
	/*네트워크관리*/                       
	 private String seq           ="";  
	 private String adopt_dt      ="";
	 private String equipment     ="";
	 private String network_mnf   ="";
	 private String network_model ="";
	 private String serial_number ="";
	 private String network_type  ="";
	 private String ip            ="";
	 private String id            ="";
	 private String pass          ="";
	 private String port_num      ="";
	 private String access_type   ="";
	 private String network_nm    ="";
	 private String unsed_status  ="";
	 private String location_net  ="";
	 private String cust_worker   ="";
	 private String cust_tel      ="";
	 private String contract_condition=""; 
	 private String free_end_dt   ="";
	 private String free_start_dt =""; 
	 private String use_type      ="";
	 
	 private String cg_cnt 		  ="";
	 private String ht_cnt 		  ="";	
	    
	/*네트워크이력 관리*/
	private String hist_seq            ="";
	private String cust_seq       ="";
	private String work_type      ="";
	private String infra_gubun    ="";
	private String equipment_nm   ="";
	private String work_content   ="";
	private String work_charge    ="";
	private String work_cust      ="";
	private String cust_charge    ="";
	private String end_dt         ="";
	private String work_time      ="";
	private String time_gubun     ="";
	private String hist_etc       ="";
	private String reg_id         ="";
	private String reg_date       ="";
	private String network_seq    ="";
	private String str_dt         ="";
	private String infra_type_nm	 ="";
	private String work_type_nm		 ="";
	
	private String del_dtl_seq1    ="";
	private String del_dtl_seq2    ="";
	
	
	/*담당자 관리*/
	private String ch_seq            ="";
	private String charge_code    ="";
	private String charge_nm      ="";
	private String company_tel_no ="";
	private String hp_no          ="";
	private String email          ="";
	private String ch_etc            ="";
	private String company_nm     ="";
	
	
	
	private String cust_address ="";
	private String erp_code ="";
	private String dam_emp_name ="";
	private String dam_tel_no   ="";
	private String cust_nm   ="";
	private String cust_gubun_nm ="";
	private String cust_kor_name ="";
	private String dopt_dt ="";
	private String network_mnf_nm ="";
	private String network_model_nm ="";
	private String use_type_nm ="";
	private String unsed_status_nm ="";
	private String contract_condition_nm ="";
	
	
	
	public String getCust_gubun_nm() {
		return cust_gubun_nm;
	}
	public void setCust_gubun_nm(String cust_gubun_nm) {
		this.cust_gubun_nm = cust_gubun_nm;
	}
	public String getCust_kor_name() {
		return cust_kor_name;
	}
	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}
	public String getDopt_dt() {
		return dopt_dt;
	}
	public void setDopt_dt(String dopt_dt) {
		this.dopt_dt = dopt_dt;
	}
	public String getNetwork_mnf_nm() {
		return network_mnf_nm;
	}
	public void setNetwork_mnf_nm(String network_mnf_nm) {
		this.network_mnf_nm = network_mnf_nm;
	}
	public String getNetwork_model_nm() {
		return network_model_nm;
	}
	public void setNetwork_model_nm(String network_model_nm) {
		this.network_model_nm = network_model_nm;
	}
	public String getUse_type_nm() {
		return use_type_nm;
	}
	public void setUse_type_nm(String use_type_nm) {
		this.use_type_nm = use_type_nm;
	}
	public String getUnsed_status_nm() {
		return unsed_status_nm;
	}
	public void setUnsed_status_nm(String unsed_status_nm) {
		this.unsed_status_nm = unsed_status_nm;
	}
	public String getContract_condition_nm() {
		return contract_condition_nm;
	}
	public void setContract_condition_nm(String contract_condition_nm) {
		this.contract_condition_nm = contract_condition_nm;
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
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
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
	public String getCh_seq() {
		return ch_seq;
	}
	public void setCh_seq(String ch_seq) {
		this.ch_seq = ch_seq;
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
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getAdopt_dt() {
		return adopt_dt;
	}
	public void setAdopt_dt(String adopt_dt) {
		this.adopt_dt = adopt_dt;
	}
	public String getEquipment() {
		return equipment;
	}
	public void setEquipment(String equipment) {
		this.equipment = equipment;
	}
	public String getNetwork_mnf() {
		return network_mnf;
	}
	public void setNetwork_mnf(String network_mnf) {
		this.network_mnf = network_mnf;
	}
	public String getNetwork_model() {
		return network_model;
	}
	public void setNetwork_model(String network_model) {
		this.network_model = network_model;
	}
	public String getSerial_number() {
		return serial_number;
	}
	public void setSerial_number(String serial_number) {
		this.serial_number = serial_number;
	}
	public String getNetwork_type() {
		return network_type;
	}
	public void setNetwork_type(String network_type) {
		this.network_type = network_type;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getPort_num() {
		return port_num;
	}
	public void setPort_num(String port_num) {
		this.port_num = port_num;
	}
	public String getAccess_type() {
		return access_type;
	}
	public void setAccess_type(String access_type) {
		this.access_type = access_type;
	}
	public String getNetwork_nm() {
		return network_nm;
	}
	public void setNetwork_nm(String network_nm) {
		this.network_nm = network_nm;
	}
	public String getUnsed_status() {
		return unsed_status;
	}
	public void setUnsed_status(String unsed_status) {
		this.unsed_status = unsed_status;
	}
	public String getLocation_net() {
		return location_net;
	}
	public void setLocation_net(String location_net) {
		this.location_net = location_net;
	}
	public String getCust_worker() {
		return cust_worker;
	}
	public void setCust_worker(String cust_worker) {
		this.cust_worker = cust_worker;
	}
	public String getCust_tel() {
		return cust_tel;
	}
	public void setCust_tel(String cust_tel) {
		this.cust_tel = cust_tel;
	}
	public String getContract_condition() {
		return contract_condition;
	}
	public void setContract_condition(String contract_condition) {
		this.contract_condition = contract_condition;
	}
	public String getFree_end_dt() {
		return free_end_dt;
	}
	public void setFree_end_dt(String free_end_dt) {
		this.free_end_dt = free_end_dt;
	}
	public String getFree_start_dt() {
		return free_start_dt;
	}
	public void setFree_start_dt(String free_start_dt) {
		this.free_start_dt = free_start_dt;
	}
	public String getUse_type() {
		return use_type;
	}
	public void setUse_type(String use_type) {
		this.use_type = use_type;
	}
	public String getHist_seq() {
		return hist_seq;
	}
	public void setHist_seq(String hist_seq) {
		this.hist_seq = hist_seq;
	}
	
	public String getInfra_type_nm() {
		return infra_type_nm;
	}
	public void setInfra_type_nm(String infra_type_nm) {
		this.infra_type_nm = infra_type_nm;
	}
	public String getWork_type_nm() {
		return work_type_nm;
	}
	public void setWork_type_nm(String work_type_nm) {
		this.work_type_nm = work_type_nm;
	}
	public String getCg_cnt() {
		return cg_cnt;
	}
	public void setCg_cnt(String cg_cnt) {
		this.cg_cnt = cg_cnt;
	}
	public String getHt_cnt() {
		return ht_cnt;
	}
	public void setHt_cnt(String ht_cnt) {
		this.ht_cnt = ht_cnt;
	}
	public String getCust_seq() {
		return cust_seq;
	}
	public void setCust_seq(String cust_seq) {
		this.cust_seq = cust_seq;
	}
	public String getWork_type() {
		return work_type;
	}
	public void setWork_type(String work_type) {
		this.work_type = work_type;
	}
	public String getInfra_gubun() {
		return infra_gubun;
	}
	public void setInfra_gubun(String infra_gubun) {
		this.infra_gubun = infra_gubun;
	}
	public String getEquipment_nm() {
		return equipment_nm;
	}
	public void setEquipment_nm(String equipment_nm) {
		this.equipment_nm = equipment_nm;
	}
	public String getWork_content() {
		return work_content;
	}
	public void setWork_content(String work_content) {
		this.work_content = work_content;
	}
	public String getWork_charge() {
		return work_charge;
	}
	public void setWork_charge(String work_charge) {
		this.work_charge = work_charge;
	}
	public String getWork_cust() {
		return work_cust;
	}
	public void setWork_cust(String work_cust) {
		this.work_cust = work_cust;
	}
	public String getCust_charge() {
		return cust_charge;
	}
	public void setCust_charge(String cust_charge) {
		this.cust_charge = cust_charge;
	}
	public String getEnd_dt() {
		return end_dt;
	}
	public void setEnd_dt(String end_dt) {
		this.end_dt = end_dt;
	}
	public String getWork_time() {
		return work_time;
	}
	public void setWork_time(String work_time) {
		this.work_time = work_time;
	}
	public String getTime_gubun() {
		return time_gubun;
	}
	public void setTime_gubun(String time_gubun) {
		this.time_gubun = time_gubun;
	}
	public String getHist_etc() {
		return hist_etc;
	}
	public void setHist_etc(String hist_etc) {
		this.hist_etc = hist_etc;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getNetwork_seq() {
		return network_seq;
	}
	public void setNetwork_seq(String network_seq) {
		this.network_seq = network_seq;
	}
	public String getStr_dt() {
		return str_dt;
	}
	public void setStr_dt(String str_dt) {
		this.str_dt = str_dt;
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
		          
	
	
	
						                
	
}
