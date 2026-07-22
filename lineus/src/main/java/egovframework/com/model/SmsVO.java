package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("smsVO")
public class SmsVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = -8468599165198529387L;
	
	private String sms_code_grp = "";
	private String sms_code = "";
	private String use_yn = "";
	private String title = "";
	private String cntn = "";
	private String reg_id = "";
	private String reg_date = "";
	private String upd_id = "";
	private String upd_date = "";
	private String gubun = "";
	private String cust_code = "";
	
	
	
	private String v_send_phone = "" ; 
	private String v_recv_phone = "" ; 
	private String v_send_email = "" ; 
	private String v_title = "" ; 
	private String v_bigo = "" ; 
	
	private String charger_email ="";
	private String charger_tel ="";
	
	
	public String getCharger_email() {
		return charger_email;
	}
	public void setCharger_email(String charger_email) {
		this.charger_email = charger_email;
	}
	public String getCharger_tel() {
		return charger_tel;
	}
	public void setCharger_tel(String charger_tel) {
		this.charger_tel = charger_tel;
	}
	public String getV_send_email() {
		return v_send_email;
	}
	public void setV_send_email(String v_send_email) {
		this.v_send_email = v_send_email;
	}
	public String getCust_code() {
		return cust_code;
	}
	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}
	public String getV_send_phone() {
		return v_send_phone;
	}
	public void setV_send_phone(String v_send_phone) {
		this.v_send_phone = v_send_phone;
	}
	public String getV_recv_phone() {
		return v_recv_phone;
	}
	public void setV_recv_phone(String v_recv_phone) {
		this.v_recv_phone = v_recv_phone;
	}
	public String getV_title() {
		return v_title;
	}
	public void setV_title(String v_title) {
		this.v_title = v_title;
	}
	public String getV_bigo() {
		return v_bigo;
	}
	public void setV_bigo(String v_bigo) {
		this.v_bigo = v_bigo;
	}
	public String getSms_code_grp() {
		return sms_code_grp;
	}
	public void setSms_code_grp(String sms_code_grp) {
		this.sms_code_grp = sms_code_grp;
	}
	public String getSms_code() {
		return sms_code;
	}
	public void setSms_code(String sms_code) {
		this.sms_code = sms_code;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCntn() {
		return cntn;
	}
	public void setCntn(String cntn) {
		this.cntn = cntn;
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
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
}
