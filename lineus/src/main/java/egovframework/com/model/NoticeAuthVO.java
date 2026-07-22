package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("noticeAuthVO")
public class NoticeAuthVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 1186352926159866954L;
	
	private int seq;
	private int notice_seq;
	private String all_open_yn = "Y";
	private String cit_emp_yn = "N";
	private String erp_code = "";

	
	
	
	
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getCit_emp_yn() {
		return cit_emp_yn;
	}
	public void setCit_emp_yn(String cit_emp_yn) {
		this.cit_emp_yn = cit_emp_yn;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getNotice_seq() {
		return notice_seq;
	}
	public void setNotice_seq(int notice_seq) {
		this.notice_seq = notice_seq;
	}
	
	public String getAll_open_yn() {
		return all_open_yn;
	}
	public void setAll_open_yn(String all_open_yn) {
		this.all_open_yn = all_open_yn;
	}

}
