package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("serverVO")
public class ServerVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	/*서버관리*/
	private String server_type           ="";
	private String server_nm             ="";
	private String server_mnf            ="";
	private String server_model          ="";
	private String server_pass           ="";
	private String server_status         ="";
	private String pb_ip                 ="";
	private String unsed_status          ="";
	private String serial_number         ="";
	private String main_mng              ="";
	private String worker_nm             ="";
	private String worker_id             ="";
	private String cust_worker           ="";
	private String cust_tel              ="";
	private String take_dt               ="";
	private String location_pc           ="";
	private String mng_cust              ="";
	private String contract_condition    ="";
	private String free_start_dt         ="";
	private String free_end_dt           ="";
	private String access_type           ="";
	private String ram_type              ="";
	private String ram_num               ="";
	private String vaccine_type          ="";
	private String dbms_type             ="";
	private String dbms_version          ="";
	private String disk_type             ="";
	private String disk_volume           ="";
	private String duplex_cdt            ="";
	private String third_solution        ="";
	private String raid_type             ="";
	private String disk_num              ="";
	private String disk_info             ="";
	private String use_vpn               ="";
	private String vpn_addr              ="";
	private String vpn_id                ="";
	private String vpn_pass              ="";
	private String storage_volume        ="";
	private String storage_host          ="";
	private String  seq                  ="";  
	private String server_id             ="";  
	private String server_ip             ="";  
	private String term_start_dt         ="";  
	private String term_end_dt           ="";  
	private String os                    ="";  
	private String dur_ip                =""; 
	private String  reg_date             ="";
	private String  reg_id               ="";
	
	private String  server_seq               ="";
	
	/*서버이력관리*/
	private String   infra_type         = "";
	private String   work_type          = "";
	private String   equipment_nm       = "";
	private String   work_content       = "";
	private String   work_charge        = "";
	private String   work_cust          = "";
	private String   cust_charge        = "";
	private String   end_dt             = "";
	private String   work_time          = "";
	private String   hist_etc           = "";
	private String   upd_id             = "";
	private String   upd_date           = "";
	
	
	private String   db_cnt           = "";
	private String   app_cnt           = "";
	private String   service_cnt           = "";
	private String   etc_cnt           = "";
	
	
	private String   cust_kor_name           = ""; 
	private String   cust_gubun_nm           = ""; 
	private String   erp_code                = ""; 
	private String   server_type_nm          = ""; 
	private String   server_status_nm        = ""; 
	private String   os_nm                   = ""; 
	private String   dbms_type_nm            = ""; 
	private String   emp_nm                  = ""; 
	private String   contract_condition_nm   = ""; 
	private String main_mng_nm			     ="";
	
	
	
	
	
	
	
	
	public String getServer_seq() {
		return server_seq;
	}

	public void setServer_seq(String server_seq) {
		this.server_seq = server_seq;
	}

	public String getMain_mng_nm() {
		return main_mng_nm;
	}

	public void setMain_mng_nm(String main_mng_nm) {
		this.main_mng_nm = main_mng_nm;
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

	public String getErp_code() {
		return erp_code;
	}

	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
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

	public String getOs_nm() {
		return os_nm;
	}

	public void setOs_nm(String os_nm) {
		this.os_nm = os_nm;
	}

	public String getDbms_type_nm() {
		return dbms_type_nm;
	}

	public void setDbms_type_nm(String dbms_type_nm) {
		this.dbms_type_nm = dbms_type_nm;
	}

	public String getEmp_nm() {
		return emp_nm;
	}

	public void setEmp_nm(String emp_nm) {
		this.emp_nm = emp_nm;
	}

	public String getContract_condition_nm() {
		return contract_condition_nm;
	}

	public void setContract_condition_nm(String contract_condition_nm) {
		this.contract_condition_nm = contract_condition_nm;
	}

	public String getApp_cnt() {
		return app_cnt;
	}

	public void setApp_cnt(String app_cnt) {
		this.app_cnt = app_cnt;
	}

	public String getService_cnt() {
		return service_cnt;
	}

	public void setService_cnt(String service_cnt) {
		this.service_cnt = service_cnt;
	}

	public String getEtc_cnt() {
		return etc_cnt;
	}

	public void setEtc_cnt(String etc_cnt) {
		this.etc_cnt = etc_cnt;
	}

	public String getDb_cnt() {
		return db_cnt;
	}

	public void setDb_cnt(String db_cnt) {
		this.db_cnt = db_cnt;
	}

	public String getInfra_type() {
		return infra_type;
	}

	public void setInfra_type(String infra_type) {
		this.infra_type = infra_type;
	}

	public String getWork_type() {
		return work_type;
	}

	public void setWork_type(String work_type) {
		this.work_type = work_type;
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

	public String getHist_etc() {
		return hist_etc;
	}

	public void setHist_etc(String hist_etc) {
		this.hist_etc = hist_etc;
	}

	public String getUpd_id() {
		return upd_id;
	}

	public void setUpd_id(String upd_id) {
		this.upd_id = upd_id;
	}

	public String getUpd_date() {
		return upd_date;
	}

	public void setUpd_date(String upd_date) {
		this.upd_date = upd_date;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	
	public String getServer_id() {
		return server_id;
	}

	public void setServer_id(String server_id) {
		this.server_id = server_id;
	}

	public String getServer_ip() {
		return server_ip;
	}

	public void setServer_ip(String server_ip) {
		this.server_ip = server_ip;
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

	public String getOs() {
		return os;
	}

	public void setOs(String os) {
		this.os = os;
	}

	public String getDur_ip() {
		return dur_ip;
	}

	public void setDur_ip(String dur_ip) {
		this.dur_ip = dur_ip;
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

	public String getServer_type() {
		return server_type;
	}

	public void setServer_type(String server_type) {
		this.server_type = server_type;
	}

	public String getServer_nm() {
		return server_nm;
	}

	public void setServer_nm(String server_nm) {
		this.server_nm = server_nm;
	}

	public String getServer_mnf() {
		return server_mnf;
	}

	public void setServer_mnf(String server_mnf) {
		this.server_mnf = server_mnf;
	}

	public String getServer_model() {
		return server_model;
	}

	public void setServer_model(String server_model) {
		this.server_model = server_model;
	}

	public String getServer_pass() {
		return server_pass;
	}

	public void setServer_pass(String server_pass) {
		this.server_pass = server_pass;
	}

	public String getServer_status() {
		return server_status;
	}

	public void setServer_status(String server_status) {
		this.server_status = server_status;
	}

	public String getPb_ip() {
		return pb_ip;
	}

	public void setPb_ip(String pb_ip) {
		this.pb_ip = pb_ip;
	}

	public String getUnsed_status() {
		return unsed_status;
	}

	public void setUnsed_status(String unsed_status) {
		this.unsed_status = unsed_status;
	}

	public String getSerial_number() {
		return serial_number;
	}

	public void setSerial_number(String serial_number) {
		this.serial_number = serial_number;
	}

	public String getMain_mng() {
		return main_mng;
	}

	public void setMain_mng(String main_mng) {
		this.main_mng = main_mng;
	}

	public String getWorker_nm() {
		return worker_nm;
	}

	public void setWorker_nm(String worker_nm) {
		this.worker_nm = worker_nm;
	}

	public String getWorker_id() {
		return worker_id;
	}

	public void setWorker_id(String worker_id) {
		this.worker_id = worker_id;
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

	public String getTake_dt() {
		return take_dt;
	}

	public void setTake_dt(String take_dt) {
		this.take_dt = take_dt;
	}

	public String getLocation_pc() {
		return location_pc;
	}

	public void setLocation_pc(String location_pc) {
		this.location_pc = location_pc;
	}

	public String getMng_cust() {
		return mng_cust;
	}

	public void setMng_cust(String mng_cust) {
		this.mng_cust = mng_cust;
	}

	public String getContract_condition() {
		return contract_condition;
	}

	public void setContract_condition(String contract_condition) {
		this.contract_condition = contract_condition;
	}

	public String getFree_start_dt() {
		return free_start_dt;
	}

	public void setFree_start_dt(String free_start_dt) {
		this.free_start_dt = free_start_dt;
	}

	public String getFree_end_dt() {
		return free_end_dt;
	}

	public void setFree_end_dt(String free_end_dt) {
		this.free_end_dt = free_end_dt;
	}

	public String getAccess_type() {
		return access_type;
	}

	public void setAccess_type(String access_type) {
		this.access_type = access_type;
	}

	public String getRam_type() {
		return ram_type;
	}

	public void setRam_type(String ram_type) {
		this.ram_type = ram_type;
	}

	public String getRam_num() {
		return ram_num;
	}

	public void setRam_num(String ram_num) {
		this.ram_num = ram_num;
	}

	public String getVaccine_type() {
		return vaccine_type;
	}

	public void setVaccine_type(String vaccine_type) {
		this.vaccine_type = vaccine_type;
	}

	public String getDbms_type() {
		return dbms_type;
	}

	public void setDbms_type(String dbms_type) {
		this.dbms_type = dbms_type;
	}

	public String getDbms_version() {
		return dbms_version;
	}

	public void setDbms_version(String dbms_version) {
		this.dbms_version = dbms_version;
	}

	public String getDisk_type() {
		return disk_type;
	}

	public void setDisk_type(String disk_type) {
		this.disk_type = disk_type;
	}

	public String getDisk_volume() {
		return disk_volume;
	}

	public void setDisk_volume(String disk_volume) {
		this.disk_volume = disk_volume;
	}

	public String getDuplex_cdt() {
		return duplex_cdt;
	}

	public void setDuplex_cdt(String duplex_cdt) {
		this.duplex_cdt = duplex_cdt;
	}

	public String getThird_solution() {
		return third_solution;
	}

	public void setThird_solution(String third_solution) {
		this.third_solution = third_solution;
	}

	public String getRaid_type() {
		return raid_type;
	}

	public void setRaid_type(String raid_type) {
		this.raid_type = raid_type;
	}

	public String getDisk_num() {
		return disk_num;
	}

	public void setDisk_num(String disk_num) {
		this.disk_num = disk_num;
	}

	public String getDisk_info() {
		return disk_info;
	}

	public void setDisk_info(String disk_info) {
		this.disk_info = disk_info;
	}

	public String getUse_vpn() {
		return use_vpn;
	}

	public void setUse_vpn(String use_vpn) {
		this.use_vpn = use_vpn;
	}

	public String getVpn_addr() {
		return vpn_addr;
	}

	public void setVpn_addr(String vpn_addr) {
		this.vpn_addr = vpn_addr;
	}

	public String getVpn_id() {
		return vpn_id;
	}

	public void setVpn_id(String vpn_id) {
		this.vpn_id = vpn_id;
	}

	public String getVpn_pass() {
		return vpn_pass;
	}

	public void setVpn_pass(String vpn_pass) {
		this.vpn_pass = vpn_pass;
	}

	public String getStorage_volume() {
		return storage_volume;
	}

	public void setStorage_volume(String storage_volume) {
		this.storage_volume = storage_volume;
	}

	public String getStorage_host() {
		return storage_host;
	}

	public void setStorage_host(String storage_host) {
		this.storage_host = storage_host;
	}
	
	
	
	
}
