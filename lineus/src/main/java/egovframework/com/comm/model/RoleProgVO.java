package egovframework.com.comm.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("roleProgVO")
public class RoleProgVO implements Serializable {

	private static final long serialVersionUID = -6654356112839049005L;
	
	private String role_code;
	private String prog_code;
	public String getRole_code() {
		return role_code;
	}
	public void setRole_code(String role_code) {
		this.role_code = role_code;
	}
	public String getProg_code() {
		return prog_code;
	}
	public void setProg_code(String prog_code) {
		this.prog_code = prog_code;
	}
	

}
