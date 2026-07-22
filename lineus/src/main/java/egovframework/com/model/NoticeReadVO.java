package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("noticeReadVO")
public class NoticeReadVO implements Serializable {
	
	private static final long serialVersionUID = 10012019727084435L;
	
	private String notice_seq;
	private String user_id;
	private String last_dt;
	public String getNotice_seq() {
		return notice_seq;
	}
	public void setNotice_seq(String notice_seq) {
		this.notice_seq = notice_seq;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getLast_dt() {
		return last_dt;
	}
	public void setLast_dt(String last_dt) {
		this.last_dt = last_dt;
	}
}
