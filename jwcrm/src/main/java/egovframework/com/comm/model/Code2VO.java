package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

@Alias("code2VO")
public class Code2VO implements Serializable {

	private static final long serialVersionUID = 1914767475448012918L;

	private String p_code;
	private String code;
	private String code_type;
	private String code_nm;
	private int ord_no;
	private String reg_id;
	private String reg_date;
	private String up_id;
	private String up_date;
	private String use_yn;
	private int level;
	
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	private List<Code2VO> list;
	
	public String getP_code() {
		return p_code;
	}
	public void setP_code(String p_code) {
		this.p_code = p_code;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCode_type() {
		return code_type;
	}
	public void setCode_type(String code_type) {
		this.code_type = code_type;
	}
	public String getCode_nm() {
		return code_nm;
	}
	public void setCode_nm(String code_nm) {
		this.code_nm = code_nm;
	}
	public int getOrd_no() {
		return ord_no;
	}
	public void setOrd_no(int ord_no) {
		this.ord_no = ord_no;
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
	public String getUp_id() {
		return up_id;
	}
	public void setUp_id(String up_id) {
		this.up_id = up_id;
	}
	public String getUp_date() {
		return up_date;
	}
	public void setUp_date(String up_date) {
		this.up_date = up_date;
	}
	
	
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	@Override
	public String toString() {
		return "Code2VO [p_code=" + p_code + ", code=" + code + ", code_type="
				+ code_type + ", code_nm=" + code_nm + ", ord_no=" + ord_no
				+ ", reg_id=" + reg_id + ", reg_date=" + reg_date + ", up_id="
				+ up_id + ", up_date=" + up_date + "]";
	}
	public List<Code2VO> getList() {
		return list;
	}
	public void setList(List<Code2VO> list) {
		this.list = list;
	}
}
