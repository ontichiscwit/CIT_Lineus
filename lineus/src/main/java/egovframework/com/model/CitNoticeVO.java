package egovframework.com.model;

import java.io.Serializable;

import net.sf.log4jdbc.DriverSpy;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("citNoticeVo")
public class CitNoticeVO extends PagingVO implements Serializable {

	private static final long serialVersionUID = -4422122885410418248L;
	
	private int notice_id;
	private String title=""; // 제목
	private String detail = ""; // 내용
	private String reg_id = ""; // 등록자
	private String task_flag = "006"; // 업무유형 (기본 기타)
	
	public int getNotice_id() {
		return notice_id;
	}
	public void setNotice_id(int notice_id) {
		this.notice_id = notice_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getTask_flag() {
		return task_flag;
	}
	public void setTask_flag(String task_flag) {
		this.task_flag = task_flag;
	}
	
	
}
