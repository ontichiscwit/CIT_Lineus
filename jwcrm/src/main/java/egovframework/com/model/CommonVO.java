package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("commonVO")
public class CommonVO implements Serializable {
	private static final long serialVersionUID = 1431359149091539261L;
	
	private int attach_seq = 0 ; 
	private int attach_ord = 0 ; 
	private String attach_ori_nm = "" ; 
	private String attach_save_nm = "" ; 
	private String attach_path = "" ; 
	private String attach_path_dtl = "" ; 
	private String reg_id = "" ; 
	private String reg_date = "" ; 
	private String upd_id = "" ; 
	private String upd_date = "" ;
	
	private String search_type1 = "" ; 
	private String search_type2 = "" ; 
	private String search_type3 = "" ; 
	private String search_type4 = "" ; 
	private String search_type5 = "" ; 
	private String search_type6 = "" ; 
	private String search_type7 = "" ; 
	private String search_type8 = "" ; 
	private String search_type9 = "" ; 
	private String search_type10 = "" ; 
	private String search_type11 = "" ; 
	private String search_type12 = "" ; 
	private String search_type13 = "" ; 
	private String search_type14 = "" ; 
	private String search_type15 = "" ; 
	private String search_type16 = "" ;
	private String search_type17 = "" ;

	private String search_text = "" ; 
	private String search_text2 = "" ; 
	private String search_text3 = "" ; 
	private String search_text4 = "" ; 
	private String search_text5 = "" ;
	private String search_start = "" ; 
	private String search_end = "" ; 
	private String[] search_text_arr = null ; 
	private String[] search_text_arr2 = null ; 
	
	private String pageType = "" ; 
	private String pageType2 = "" ; 
	
	private String start_date = "" ; 
	private String end_date = "" ;
	
	private int attach_seq1 = 0 ; 
	private int attach_seq2 = 0 ; 
	private int attach_seq3 = 0 ; 
	
	private String is_page_gbn = "" ; 
	private String search_gubun = "" ; 
	
	private String isTab = "" ; 
	private String gubun_nm = "" ; 
	private String delord = "" ; 
	
	private String v_return_seq = "" ;
	private String v_message = "" ;
	private String paramString = "" ; 
	
	private String search_start2 ="";
	private String search_end2 ="";
	
	private String search_start3 ="";
	private String search_end3 ="";
	
	
	
	private String tel_type ="";
	private String cust_seq ="";
	private String dtl_seq ="";
	
	
	
	public String getSearch_start3() {
		return search_start3;
	}

	public void setSearch_start3(String search_start3) {
		this.search_start3 = search_start3;
	}

	public String getSearch_end3() {
		return search_end3;
	}

	public void setSearch_end3(String search_end3) {
		this.search_end3 = search_end3;
	}

	public String getCust_seq() {
		return cust_seq;
	}

	public void setCust_seq(String cust_seq) {
		this.cust_seq = cust_seq;
	}

	
	public String getDtl_seq() {
		return dtl_seq;
	}

	public void setDtl_seq(String dtl_seq) {
		this.dtl_seq = dtl_seq;
	}
	
	
	public String getTel_type() {
		return tel_type;
	}

	public void setTel_type(String tel_type) {
		this.tel_type = tel_type;
	}
	
	
	public String getSearch_start() {
		return search_start;
	}
	public void setSearch_start(String search_start) {
		this.search_start = search_start;
	}
	public String getSearch_end() {
		return search_end;
	}
	public void setSearch_end(String search_end) {
		this.search_end = search_end;
	}
	
	
	public String getSearch_start2() {
		return search_start2;
	}
	public void setSearch_start2(String search_start2) {
		this.search_start2 = search_start2;
	}
	public String getSearch_end2() {
		return search_end2;
	}
	public void setSearch_end2(String search_end2) {
		this.search_end2 = search_end2;
	}
	
	
	public String getSearch_text3() {
		return search_text3;
	}
	public void setSearch_text3(String search_text3) {
		this.search_text3 = search_text3;
	}
	public String getSearch_text4() {
		return search_text4;
	}
	public void setSearch_text4(String search_text4) {
		this.search_text4 = search_text4;
	}
	public String getSearch_text5() {
		return search_text5;
	}
	public void setSearch_text5(String search_text5) {
		this.search_text5 = search_text5;
	}
	public String getParamString() {
		return paramString;
	}
	public void setParamString(String paramString) {
		this.paramString = paramString;
	}
	public String getV_return_seq() {
		return v_return_seq;
	}
	public void setV_return_seq(String v_return_seq) {
		this.v_return_seq = v_return_seq;
	}
	public String getV_message() {
		return v_message;
	}
	public void setV_message(String v_message) {
		this.v_message = v_message;
	}
	public int getAttach_seq3() {
		return attach_seq3;
	}
	public void setAttach_seq3(int attach_seq3) {
		this.attach_seq3 = attach_seq3;
	}
	public String getDelord() {
		return delord;
	}
	public void setDelord(String delord) {
		this.delord = delord;
	}
	public String getPageType2() {
		return pageType2;
	}
	public void setPageType2(String pageType2) {
		this.pageType2 = pageType2;
	}
	public String getSearch_text2() {
		return search_text2;
	}
	public void setSearch_text2(String search_text2) {
		this.search_text2 = search_text2;
	}
	public String getGubun_nm() {
		return gubun_nm;
	}
	public void setGubun_nm(String gubun_nm) {
		this.gubun_nm = gubun_nm;
	}
	public String getIsTab() {
		return isTab;
	}
	public void setIsTab(String isTab) {
		this.isTab = isTab;
	}
	public String getSearch_gubun() {
		return search_gubun;
	}
	public void setSearch_gubun(String search_gubun) {
		this.search_gubun = search_gubun;
	}
	public String getIs_page_gbn() {
		return is_page_gbn;
	}
	public void setIs_page_gbn(String is_page_gbn) {
		this.is_page_gbn = is_page_gbn;
	}
	public int getAttach_seq1() {
		return attach_seq1;
	}
	public void setAttach_seq1(int attach_seq1) {
		this.attach_seq1 = attach_seq1;
	}
	public int getAttach_seq2() {
		return attach_seq2;
	}
	public void setAttach_seq2(int attach_seq2) {
		this.attach_seq2 = attach_seq2;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getPageType() {
		return pageType;
	}
	public void setPageType(String pageType) {
		this.pageType = pageType;
	}
	public String[] getSearch_text_arr() {
		return search_text_arr;
	}
	public void setSearch_text_arr(String[] search_text_arr) {
		this.search_text_arr = search_text_arr;
	}
	public String getSearch_type1() {
		return search_type1;
	}
	public void setSearch_type1(String search_type1) {
		this.search_type1 = search_type1;
	}
	public String getSearch_type2() {
		return search_type2;
	}
	public void setSearch_type2(String search_type2) {
		this.search_type2 = search_type2;
	}
	public String getSearch_type3() {
		return search_type3;
	}
	public void setSearch_type3(String search_type3) {
		this.search_type3 = search_type3;
	}
	public String getSearch_type4() {
		return search_type4;
	}
	public void setSearch_type4(String search_type4) {
		this.search_type4 = search_type4;
	}
	public String getSearch_type5() {
		return search_type5;
	}
	public void setSearch_type5(String search_type5) {
		this.search_type5 = search_type5;
	}
	public String getSearch_type6() {
		return search_type6;
	}
	public void setSearch_type6(String search_type6) {
		this.search_type6 = search_type6;
	}
	public String getSearch_type7() {
		return search_type7;
	}
	public void setSearch_type7(String search_type7) {
		this.search_type7 = search_type7;
	}
	public String getSearch_type8() {
		return search_type8;
	}
	public void setSearch_type8(String search_type8) {
		this.search_type8 = search_type8;
	}
	public String getSearch_type9() {
		return search_type9;
	}
	public void setSearch_type9(String search_type9) {
		this.search_type9 = search_type9;
	}
	public String getSearch_type10() {
		return search_type10;
	}
	public void setSearch_type10(String search_type10) {
		this.search_type10 = search_type10;
	}
	public String getSearch_text() {
		return search_text;
	}
	public void setSearch_text(String search_text) {
		this.search_text = search_text;
	}
	public int getAttach_seq() {
		return attach_seq;
	}
	public void setAttach_seq(int attach_seq) {
		this.attach_seq = attach_seq;
	}
	public int getAttach_ord() {
		return attach_ord;
	}
	public void setAttach_ord(int attach_ord) {
		this.attach_ord = attach_ord;
	}
	public String getAttach_ori_nm() {
		return attach_ori_nm;
	}
	public void setAttach_ori_nm(String attach_ori_nm) {
		this.attach_ori_nm = attach_ori_nm;
	}
	public String getAttach_save_nm() {
		return attach_save_nm;
	}
	public void setAttach_save_nm(String attach_save_nm) {
		this.attach_save_nm = attach_save_nm;
	}
	public String getAttach_path() {
		return attach_path;
	}
	public void setAttach_path(String attach_path) {
		this.attach_path = attach_path;
	}
	public String getAttach_path_dtl() {
		return attach_path_dtl;
	}
	public void setAttach_path_dtl(String attach_path_dtl) {
		this.attach_path_dtl = attach_path_dtl;
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
	public String getSearch_type11() {
		return search_type11;
	}
	public void setSearch_type11(String search_type11) {
		this.search_type11 = search_type11;
	}
	public String getSearch_type12() {
		return search_type12;
	}
	public void setSearch_type12(String search_type12) {
		this.search_type12 = search_type12;
	}
	public String getSearch_type13() {
		return search_type13;
	}
	public void setSearch_type13(String search_type13) {
		this.search_type13 = search_type13;
	}
	public String getSearch_type14() {
		return search_type14;
	}
	public void setSearch_type14(String search_type14) {
		this.search_type14 = search_type14;
	}
	public String getSearch_type15() {
		return search_type15;
	}
	public void setSearch_type15(String search_type15) {
		this.search_type15 = search_type15;
	}
	public String getSearch_type16() {
		return search_type16;
	}
	public void setSearch_type16(String search_type16) {
		this.search_type16 = search_type16;
	}
	public String getSearch_type17() {
		return search_type17;
	}
	public void setSearch_type17(String search_type17) {
		this.search_type17 = search_type17;
	}
	public String[] getSearch_text_arr2() {
		return search_text_arr2;
	}
	public void setSearch_text_arr2(String[] search_text_arr2) {
		this.search_text_arr2 = search_text_arr2;
	} 
	
}
