package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

@Alias("interfaceVO")
public class InterfaceVO implements Serializable {

	private static final long serialVersionUID = 1914767475448012918L;

	private String code_gubun;
	private String asis_code1;
	private String tobe_code1;
	private String tobe_code2;
	
	
	public String getCode_gubun() {
		return code_gubun;
	}
	public void setCode_gubun(String code_gubun) {
		this.code_gubun = code_gubun;
	}
	public String getAsis_code1() {
		return asis_code1;
	}
	public void setAsis_code1(String asis_code1) {
		this.asis_code1 = asis_code1;
	}
	public String getTobe_code1() {
		return tobe_code1;
	}
	public void setTobe_code1(String tobe_code1) {
		this.tobe_code1 = tobe_code1;
	}
	public String getTobe_code2() {
		return tobe_code2;
	}
	public void setTobe_code2(String tobe_code2) {
		this.tobe_code2 = tobe_code2;
	}

		


}
