package egovframework.com.comm.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("progVO")
public class ProgVO implements Serializable{

	private static final long serialVersionUID = -3779260370611172765L;
	
	private String prog_code;
	private String prog_name;
	private String reg_id;
	private String reg_date;
	private String upd_id;
	private String upd_date;
	public String getProg_code() {
		return prog_code;
	}
	public void setProg_code(String prog_code) {
		this.prog_code = prog_code;
	}
	public String getProg_name() {
		return prog_name;
	}
	public void setProg_name(String prog_name) {
		this.prog_name = prog_name;
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
	@Override
	public String toString() {
		return "ProgVO [prog_code=" + prog_code + ", prog_name=" + prog_name + ", reg_id=" + reg_id + ", reg_date=" + reg_date + ", upd_id=" + upd_id
				+ ", upd_date=" + upd_date + "]";
	}
	
}
