package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("virtualContactVO")
public class VirtualContactVO implements Serializable {

	private static final long serialVersionUID = 8316102244104657829L;
	
	private String seq;
	private String cust_code;
	private String code_item;
	private String supp_amt;
	private String vat;
	private String st_date;
	private String end_date;
	private String gyeyag_il;
	private String memo;
	private String reg_id;
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getCust_code() {
		return cust_code;
	}
	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}
	public String getCode_item() {
		return code_item;
	}
	public void setCode_item(String code_item) {
		this.code_item = code_item;
	}
	public String getSupp_amt() {
		return supp_amt;
	}
	public void setSupp_amt(String supp_amt) {
		this.supp_amt = supp_amt;
	}
	public String getVat() {
		return vat;
	}
	public void setVat(String vat) {
		this.vat = vat;
	}
	public String getSt_date() {
		return st_date;
	}
	public void setSt_date(String st_date) {
		this.st_date = st_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getGyeyag_il() {
		return gyeyag_il;
	}
	public void setGyeyag_il(String gyeyag_il) {
		this.gyeyag_il = gyeyag_il;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	@Override
	public String toString() {
		return "VirtualContactVO [seq=" + seq + ", cust_code=" + cust_code + ", code_item=" + code_item + ", supp_amt=" + supp_amt + ", vat=" + vat
				+ ", st_date=" + st_date + ", end_date=" + end_date + ", gyeyag_il=" + gyeyag_il + ", memo=" + memo + ", reg_id=" + reg_id + "]";
	}
	
	
}
