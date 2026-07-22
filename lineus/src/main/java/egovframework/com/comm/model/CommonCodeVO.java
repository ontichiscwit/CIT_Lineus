package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

@Alias("commonCodeVO")
public class CommonCodeVO extends PagingVO implements Serializable{
	private static final long serialVersionUID = 6547730228722254349L;
	
	
	private String code_group = "" ; 
	private String p_code = "" ; 
	private String use_yn = "" ; 
	private String p_code_name = "" ; 
	private String code = "" ; 
	private String code_name = "" ;
	private String val1 = "" ;
	private String val2 = "" ;
	private String val3 = "" ;
	private String val4 = "" ;
	private String val5 = "" ;
	private String val6 = "" ;
	private String val7 = "" ;
	private String val8 = "" ;
	private String val9 = "" ;
	private String val10 = "" ;
	private String sort_ord = "" ;
	private String use_yn_dtl = "" ;
	
	private String del_p_code = "" ; 
	private String del_group_code = "" ; 
	private String group_addCnt = "" ; 
	private String del_code = "" ; 
	private String code_addCnt = "" ; 
	private String gubun = "" ; 
	private String cust_code = "" ; 
	private String reg_id = "" ; 
	private String seq = "" ; 
	
	
	
	private List<CommonCodeVO> OUTCURSOR = null ;
	
	
	

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
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getDel_p_code() {
		return del_p_code;
	}
	public void setDel_p_code(String del_p_code) {
		this.del_p_code = del_p_code;
	}
	public String getGroup_addCnt() {
		return group_addCnt;
	}
	public void setGroup_addCnt(String group_addCnt) {
		this.group_addCnt = group_addCnt;
	}
	public String getDel_code() {
		return del_code;
	}
	public void setDel_code(String del_code) {
		this.del_code = del_code;
	}
	public String getCode_addCnt() {
		return code_addCnt;
	}
	public void setCode_addCnt(String code_addCnt) {
		this.code_addCnt = code_addCnt;
	}
	public String getCode_group() {
		return code_group;
	}
	public void setCode_group(String code_group) {
		this.code_group = code_group;
	}
	public String getP_code() {
		return p_code;
	}
	public void setP_code(String p_code) {
		this.p_code = p_code;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getP_code_name() {
		return p_code_name;
	}
	public void setP_code_name(String p_code_name) {
		this.p_code_name = p_code_name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCode_name() {
		return code_name;
	}
	public void setCode_name(String code_name) {
		this.code_name = code_name;
	}
	public List<CommonCodeVO> getOUTCURSOR() {
		return OUTCURSOR;
	}
	public void setOUTCURSOR(List<CommonCodeVO> oUTCURSOR) {
		OUTCURSOR = oUTCURSOR;
	}
	public String getVal1() {
		return val1;
	}
	public void setVal1(String val1) {
		this.val1 = val1;
	}
	public String getVal2() {
		return val2;
	}
	public void setVal2(String val2) {
		this.val2 = val2;
	}
	public String getVal3() {
		return val3;
	}
	public void setVal3(String val3) {
		this.val3 = val3;
	}
	public String getVal4() {
		return val4;
	}
	public void setVal4(String val4) {
		this.val4 = val4;
	}
	public String getVal5() {
		return val5;
	}
	public void setVal5(String val5) {
		this.val5 = val5;
	}
	public String getVal6() {
		return val6;
	}
	public void setVal6(String val6) {
		this.val6 = val6;
	}
	public String getVal7() {
		return val7;
	}
	public void setVal7(String val7) {
		this.val7 = val7;
	}
	public String getVal8() {
		return val8;
	}
	public void setVal8(String val8) {
		this.val8 = val8;
	}
	public String getVal9() {
		return val9;
	}
	public void setVal9(String val9) {
		this.val9 = val9;
	}
	public String getVal10() {
		return val10;
	}
	public void setVal10(String val10) {
		this.val10 = val10;
	}
	public String getSort_ord() {
		return sort_ord;
	}
	public void setSort_ord(String sort_ord) {
		this.sort_ord = sort_ord;
	}
	public String getUse_yn_dtl() {
		return use_yn_dtl;
	}
	public void setUse_yn_dtl(String use_yn_dtl) {
		this.use_yn_dtl = use_yn_dtl;
	}
	public String getDel_group_code() {
		return del_group_code;
	}
	public void setDel_group_code(String del_group_code) {
		this.del_group_code = del_group_code;
	}
	
	
	
}
