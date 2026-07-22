package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.model.CommonVO;

@Alias("roleMenuVO")
public class RoleMenuVO implements Serializable{
	
	private static final long serialVersionUID = -2156367647103982857L;
	private String role_code;
	private String menu_code;
	private String reg_id;
	private String reg_date;
	private String upd_id;
	private String upd_date;
	public String getRole_code() {
		return role_code;
	}
	public void setRole_code(String role_code) {
		this.role_code = role_code;
	}
	public String getMenu_code() {
		return menu_code;
	}
	public void setMenu_code(String menu_code) {
		this.menu_code = menu_code;
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
	
	
	
}
