package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("erpMtHistVO")
public class ErpMtHistVO implements Serializable {

	private static final long serialVersionUID = -8540253370682496830L;
	
	private String vw_pk;
	private String t_code;
	private String pk_seq;
	private String erp_code;
	private String item_cd;
	private String item_nm;
	private String item_grp1_nm;
	private String item_grp2_nm;
	private String item_grp3_nm;
	private String supp_amt;
	private String vat;
	private String tot_amt;
	private String st_date;
	private String end_date;
	private String contract_date;
	private String memo;
	private String reg_id;
	private String reg_nm;
	private String reg_date;
	
	// 20171220 추가
	private String mtac_code;
	
	// 20221007추가
	private String cust_code ="";	//계약서 종류
	private String cust_nm ="";	//계약서 종류
	private String contract_kind ="";	//계약서 종류
	private String code_item ="";		//품목코드
	private String maint_month_amt ="";	//유지보수 금액
	
	public String getVw_pk() {
		return vw_pk;
	}
	public void setVw_pk(String vw_pk) {
		this.vw_pk = vw_pk;
	}
	public String getT_code() {
		return t_code;
	}
	public void setT_code(String t_code) {
		this.t_code = t_code;
	}
	
	public String getPk_seq() {
		return pk_seq;
	}
	public void setPk_seq(String pk_seq) {
		this.pk_seq = pk_seq;
	}
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getItem_cd() {
		return item_cd;
	}
	public void setItem_cd(String item_cd) {
		this.item_cd = item_cd;
	}
	public String getItem_nm() {
		return item_nm;
	}
	public void setItem_nm(String item_nm) {
		this.item_nm = item_nm;
	}
	public String getItem_grp1_nm() {
		return item_grp1_nm;
	}
	public void setItem_grp1_nm(String item_grp1_nm) {
		this.item_grp1_nm = item_grp1_nm;
	}
	public String getItem_grp2_nm() {
		return item_grp2_nm;
	}
	public void setItem_grp2_nm(String item_grp2_nm) {
		this.item_grp2_nm = item_grp2_nm;
	}
	public String getItem_grp3_nm() {
		return item_grp3_nm;
	}
	public void setItem_grp3_nm(String item_grp3_nm) {
		this.item_grp3_nm = item_grp3_nm;
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
	public String getTot_amt() {
		return tot_amt;
	}
	public void setTot_amt(String tot_amt) {
		this.tot_amt = tot_amt;
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
	public String getContract_date() {
		return contract_date;
	}
	public void setContract_date(String contract_date) {
		this.contract_date = contract_date;
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
	public String getMtac_code() {
		return mtac_code;
	}
	public void setMtac_code(String mtac_code) {
		this.mtac_code = mtac_code;
	}
	public String getReg_nm() {
		return reg_nm;
	}
	public void setReg_nm(String reg_nm) {
		this.reg_nm = reg_nm;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getCust_code() {
		return cust_code;
	}
	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}
	public String getCust_nm() {
		return cust_nm;
	}
	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}
	public String getContract_kind() {
		return contract_kind;
	}
	public void setContract_kind(String contract_kind) {
		this.contract_kind = contract_kind;
	}
	public String getCode_item() {
		return code_item;
	}
	public void setCode_item(String code_item) {
		this.code_item = code_item;
	}
	public String getMaint_month_amt() {
		return maint_month_amt;
	}
	public void setMaint_month_amt(String maint_month_amt) {
		this.maint_month_amt = maint_month_amt;
	}
	
}
