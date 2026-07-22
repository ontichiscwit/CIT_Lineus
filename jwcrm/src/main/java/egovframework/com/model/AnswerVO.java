package egovframework.com.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("answerVO")
public class AnswerVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 8270977273658995518L;
	
	private String seq = "";
	private String as_no = "";
	private String w_id = "";
	private String w_content = "";
	private String w_date = "";
	private String w_gubun = "";
	private int attach_seq = 0;
	private String w_nm = "";
	
	
	public String getW_nm(){
		return w_nm;
	}
	public void setW_nm(String w_nm) {
		this.w_nm = w_nm;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getAs_no() {
		return as_no;
	}
	public void setAs_no(String as_no) {
		this.as_no = as_no;
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
	public int getAttach_seq() {
		return attach_seq;
	}
	public void setAttach_seq(int attach_seq) {
		this.attach_seq = attach_seq;
	}
	

}
