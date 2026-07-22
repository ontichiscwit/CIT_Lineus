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
	
	private String del_p_code = "" ; 
	private String group_addCnt = "" ; 
	private String del_code = "" ; 
	private String code_addCnt = "" ; 
	
	private List<CommonCodeVO> OUTCURSOR = null ;
	
	

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
	
	
	
}
