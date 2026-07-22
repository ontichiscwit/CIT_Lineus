package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("boardAswVO")
public class BoardAswVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = -9029345120548404409L;

    
    private String seq=""; // 댓글 seq
    private String notice_seq=""; // 공지사항 seq
	private String w_id=""; // 작성자
	private String w_content=""; // 댓글내용
	private String w_date=""; // 작성날짜
	private String w_gubun=""; // 구분
	private String crm_code=""; // 거래처코드
	private String w_nm=""; //작성자이름
	private String w_cust_nm=""; // 거래처이름
	
	private String erp_code=""; // 
	
	
	
    public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getNotice_seq() {
		return notice_seq;
	}
	public void setNotice_seq(String notice_seq) {
		this.notice_seq = notice_seq;
	}
	public String getW_id() {
		return w_id;
	}
	public void setW_id(String w_id) {
		this.w_id = w_id;
	}
	public String getW_content() {
		return w_content;
	}
	public void setW_content(String w_content) {
		this.w_content = w_content;
	}
	public String getW_date() {
		return w_date;
	}
	public void setW_date(String w_date) {
		this.w_date = w_date;
	}
	public String getW_gubun() {
		return w_gubun;
	}
	public void setW_gubun(String w_gubun) {
		this.w_gubun = w_gubun;
	}
	public String getW_nm() {
		return w_nm;
	}
	public void setW_nm(String w_nm) {
		this.w_nm = w_nm;
	}
	public String getCrm_code() {
		return crm_code;
	}
	public void setCrm_code(String crm_code) {
		this.crm_code = crm_code;
	}
	public String getW_cust_nm() {
		return w_cust_nm;
	}
	public void setW_cust_nm(String w_cust_nm) {
		this.w_cust_nm = w_cust_nm;
	}
	
		
	
	
	
	
}
