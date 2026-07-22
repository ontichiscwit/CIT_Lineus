package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("downHistVO")
public class DownHistVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = -9029345120548404409L;

	// field data
	private int seq;
	private int attach_seq;
	private int attach_ord;
	private String crm_code = "";
	private String reg_id = "";
	private String reg_date = "";
	
	
	// view added data
	private String attach_ori_nm = "";
	private String cust_kor_name = "";
	private String emp_nm = "";
	private String reg_dt = "";
	
	
	public String getAttach_ori_nm() {
		return attach_ori_nm;
	}
	public void setAttach_ori_nm(String attach_ori_nm) {
		this.attach_ori_nm = attach_ori_nm;
	}
	public String getCust_kor_name() {
		return cust_kor_name;
	}
	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}
	public String getEmp_nm() {
		return emp_nm;
	}
	public void setEmp_nm(String emp_nm) {
		this.emp_nm = emp_nm;
	}
	public String getReg_dt() {
		return reg_dt;
	}
	public void setReg_dt(String reg_dt) {
		this.reg_dt = reg_dt;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getAttach_seq() {
		return attach_seq;
	}
	public void setAttach_seq(int attach_seq) {
		this.attach_seq = attach_seq;
	}
	public int getAttach_ord() {
		return attach_ord;
	}
	public void setAttach_ord(int attach_ord) {
		this.attach_ord = attach_ord;
	}
	public String getCrm_code() {
		return crm_code;
	}
	public void setCrm_code(String crm_code) {
		this.crm_code = crm_code;
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
	
	@Override
	public String toString() {
		return "DownHistVO [seq=" + seq + ", attach_seq=" + attach_seq
				+ ", attach_ord=" + attach_ord + ", crm_code=" + crm_code
				+ ", reg_id=" + reg_id + ", reg_date=" + reg_date
				+ ", attach_ori_nm=" + attach_ori_nm + ", cust_kor_name="
				+ cust_kor_name + ", emp_nm=" + emp_nm + ", reg_dt=" + reg_dt
				+ "]";
	}
	
	
	
}
