package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

@Alias("systemHistVO")
public class SystemHistVO implements Serializable {
	private static final long serialVersionUID = 4906168389704011820L;
	
	
	private String seq;
	private String dtl_seq;
	private String erp_code;
	private String action_type;
	private String group_code1;
	private String group_code2;
	private String group_code3;
	private String item_nm;
	private String reg_date;
	private String reg_id;
	private String reg_nm;
	private String etc;
	private String serial_no;
	private List<SystemHistVO> list;
	
	
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
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
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
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	public String getSerial_no() {
		return serial_no;
	}
	public void setSerial_no(String serial_no) {
		this.serial_no = serial_no;
	}
	
	public List<SystemHistVO> getList() {
		return list;
	}
	public void setList(List<SystemHistVO> list) {
		this.list = list;
	}
	public String getAction_type() {
		return action_type;
	}
	public void setAction_type(String action_type) {
		this.action_type = action_type;
	}
	public String getItem_nm() {
		return item_nm;
	}
	public void setItem_nm(String item_nm) {
		this.item_nm = item_nm;
	}
	
	
	
	public String getReg_nm() {
		return reg_nm;
	}
	public void setReg_nm(String reg_nm) {
		this.reg_nm = reg_nm;
	}
	@Override
	public String toString() {
		return "SystemHistVO [seq=" + seq + ", dtl_seq=" + dtl_seq
				+ ", erp_code=" + erp_code + ", action_type=" + action_type
				+ ", group_code1=" + group_code1 + ", group_code2="
				+ group_code2 + ", group_code3=" + group_code3 + ", item_nm="
				+ item_nm + ", reg_date=" + reg_date + ", reg_id=" + reg_id
				+ ", reg_nm=" + reg_nm + ", etc=" + etc + ", list=" + list
				+ "]";
	}
}
