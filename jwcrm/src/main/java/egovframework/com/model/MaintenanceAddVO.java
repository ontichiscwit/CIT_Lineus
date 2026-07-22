package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("maintenanceAddVO")
public class MaintenanceAddVO implements Serializable {

	private static final long serialVersionUID = -5212125222096921845L;
	
	private String vw_pk;
	private String contract_seq;
	private String contract_nm;
	private String bill_code;
	private String mtac_code;
	private String mon_off_amt;
	private String year_off_amt;
	private String etc;
	private String reg_id;
	private String reg_nm;
	private String reg_date;
	private String deal_code;
	private String buy_busi_name;
	private String buy_cost;
	private String service_period;
	private String service_method;
	private String auto_renew_yn;
	public String getVw_pk() {
		return vw_pk;
	}
	public void setVw_pk(String vw_pk) {
		this.vw_pk = vw_pk;
	}
	public String getContract_seq() {
		return contract_seq;
	}
	public void setContract_seq(String contract_seq) {
		this.contract_seq = contract_seq;
	}
	public String getContract_nm() {
		return contract_nm;
	}
	public void setContract_nm(String contract_nm) {
		this.contract_nm = contract_nm;
	}
	public String getBill_code() {
		return bill_code;
	}
	public void setBill_code(String bill_code) {
		this.bill_code = bill_code;
	}
	public String getMtac_code() {
		return mtac_code;
	}
	public void setMtac_code(String mtac_code) {
		this.mtac_code = mtac_code;
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
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getReg_nm() {
		return reg_nm;
	}
	public void setReg_nm(String reg_nm) {
		this.reg_nm = reg_nm;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getDeal_code() {
		return deal_code;
	}
	public void setDeal_code(String deal_code) {
		this.deal_code = deal_code;
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
	@Override
	public String toString() {
		return "MaintenanceAdd [vw_pk=" + vw_pk + ", contract_seq=" + contract_seq + ", contract_nm=" + contract_nm + ", bill_code=" + bill_code
				+ ", mtac_code=" + mtac_code + ", mon_off_amt=" + mon_off_amt + ", year_off_amt=" + year_off_amt + ", etc=" + etc + ", reg_id=" + reg_id
				+ ", reg_nm=" + reg_nm + ", reg_date=" + reg_date + ", deal_code=" + deal_code + ", buy_busi_name=" + buy_busi_name + ", buy_cost=" + buy_cost
				+ ", service_period=" + service_period + ", service_method=" + service_method + ", auto_renew_yn=" + auto_renew_yn + "]";
	}
	
	
}
