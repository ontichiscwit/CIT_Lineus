package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.model.CommonVO;

@Alias("menuVO")
public class MenuVO extends CommonVO implements Serializable{
	private static final long serialVersionUID = -7030846024891158125L;
	
	private String menu_code = "" ; 
	private String usr_grade = "" ; 
	private String sel_yn = "" ; 
	private String reg_yn = "" ; 
	private String upd_yn = "" ; 
	private String del_yn = "" ; 
	
	private String menu_nm = "" ; 
	private String ord_num = "" ; 
	private String menu_url = "" ; 
	private String menu_depth = "" ; 
	private String t_yn = "" ; 
	private String n_yn = "" ;
	
	private String p_menu_code = "" ; 
	private String p_menu_url = "" ; 
	
	private String post_code = "" ; 
	
	private String gubun = "" ; 
	
	private String list_menu_code = "" ; 
	private String list_depth = "" ; 
	
	private String[] del_menu_code = null ; 
	
	private List<MenuVO> OUTCURSOR = null ; 
	
	
	public List<MenuVO> getOUTCURSOR() {
		return OUTCURSOR;
	}
	public void setOUTCURSOR(List<MenuVO> oUTCURSOR) {
		OUTCURSOR = oUTCURSOR;
	}
	public String[] getDel_menu_code() {
		return del_menu_code;
	}
	public void setDel_menu_code(String[] del_menu_code) {
		this.del_menu_code = del_menu_code;
	}
	public String getList_menu_code() {
		return list_menu_code;
	}
	public void setList_menu_code(String list_menu_code) {
		this.list_menu_code = list_menu_code;
	}
	public String getList_depth() {
		return list_depth;
	}
	public void setList_depth(String list_depth) {
		this.list_depth = list_depth;
	}
	public String getPost_code() {
		return post_code;
	}
	public void setPost_code(String post_code) {
		this.post_code = post_code;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getP_menu_code() {
		return p_menu_code;
	}
	public void setP_menu_code(String p_menu_code) {
		this.p_menu_code = p_menu_code;
	}
	public String getP_menu_url() {
		return p_menu_url;
	}
	public void setP_menu_url(String p_menu_url) {
		this.p_menu_url = p_menu_url;
	}
	public String getMenu_code() {
		return menu_code;
	}
	public void setMenu_code(String menu_code) {
		this.menu_code = menu_code;
	}
	public String getUsr_grade() {
		return usr_grade;
	}
	public void setUsr_grade(String usr_grade) {
		this.usr_grade = usr_grade;
	}
	public String getSel_yn() {
		return sel_yn;
	}
	public void setSel_yn(String sel_yn) {
		this.sel_yn = sel_yn;
	}
	public String getReg_yn() {
		return reg_yn;
	}
	public void setReg_yn(String reg_yn) {
		this.reg_yn = reg_yn;
	}
	public String getUpd_yn() {
		return upd_yn;
	}
	public void setUpd_yn(String upd_yn) {
		this.upd_yn = upd_yn;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	public String getMenu_nm() {
		return menu_nm;
	}
	public void setMenu_nm(String menu_nm) {
		this.menu_nm = menu_nm;
	}
	public String getOrd_num() {
		return ord_num;
	}
	public void setOrd_num(String ord_num) {
		this.ord_num = ord_num;
	}
	public String getMenu_url() {
		return menu_url;
	}
	public void setMenu_url(String menu_url) {
		this.menu_url = menu_url;
	}
	public String getMenu_depth() {
		return menu_depth;
	}
	public void setMenu_depth(String menu_depth) {
		this.menu_depth = menu_depth;
	}
	public String getT_yn() {
		return t_yn;
	}
	public void setT_yn(String t_yn) {
		this.t_yn = t_yn;
	}
	public String getN_yn() {
		return n_yn;
	}
	public void setN_yn(String n_yn) {
		this.n_yn = n_yn;
	} 
	
	
	
}
