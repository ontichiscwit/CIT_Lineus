package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("noticeCustSearchVO")
public class NoticeCustSearchVO implements Serializable {
	private static final long serialVersionUID = 1942360063540272483L;
	
	private String erp_code = "";
	private String cust_kor_name = "";
	
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getCust_kor_name() {
		return cust_kor_name;
	}
	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}
	
}
