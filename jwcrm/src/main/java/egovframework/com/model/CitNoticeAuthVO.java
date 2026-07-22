package egovframework.com.model;

import java.io.Serializable;

import egovframework.com.comm.model.PagingVO;

public class CitNoticeAuthVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 2511688451089663792L;
	
	private int notice_id;
	private String all_open_yn = "N";
	private String group_code;
	private String customer_code;
	private String cit_emp_yn = "N";
	private String notice_fix = "N";
	public int getNotice_id() {
		return notice_id;
	}
	public void setNotice_id(int notice_id) {
		this.notice_id = notice_id;
	}
	public String getAll_open_yn() {
		return all_open_yn;
	}
	public void setAll_open_yn(String all_open_yn) {
		this.all_open_yn = all_open_yn;
	}
	public String getGroup_code() {
		return group_code;
	}
	public void setGroup_code(String group_code) {
		this.group_code = group_code;
	}
	public String getCustomer_code() {
		return customer_code;
	}
	public void setCustomer_code(String customer_code) {
		this.customer_code = customer_code;
	}
	public String getCit_emp_yn() {
		return cit_emp_yn;
	}
	public void setCit_emp_yn(String cit_emp_yn) {
		this.cit_emp_yn = cit_emp_yn;
	}
	public String getNotice_fix() {
		return notice_fix;
	}
	public void setNotice_fix(String notice_fix) {
		this.notice_fix = notice_fix;
	}
	
	
}
