package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("retireVO")
public class RetireVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	
	/* etc */
	private String code = "";
	private String code_name = "";
	
	/* CWC_USER_NEW@DL_JWHR_H552  -통합HR */
	private String seq = "";
	private String companyid = "";		//그룹사 코드
	private String company_nm = "";		//그룹사명
	private String userid = "";			//퇴사자 사번
	private String usernm = "";			//퇴사자 이름
	private String deptid = "";			//부서 코드
	private String deptnm = "";			//부서명
	private String retiredt = "";		//퇴사일
	private String retire_flag = "";	//퇴사 flag (Y : 사간이동, N : 퇴사)
	private String retire_flag_nm = "";	//퇴사 flag 명
	
	/* 검색조건 */
	private String pageType = "" ; 
	private String search_type1 = "" ; 
	private String search_type2 = "" ; 
	private String search_type3 = "" ; 
	private String search_text = "" ; 
	private String search_start = "";
	private String search_end = "";
	
	/* CRM_RETIRE_MGT */
	private String  emp_no = "";		//퇴사자 사번
	private String  retire_date = "";	//퇴사일
	private String  check_cd = "";		//체크리스트 항목 코드
	private String  check_nm = "";		//체크리스트 항목 코드 이름
	private String  check_yn = "";		//체크
	private String  reg_id = "";		//확인자 사번
	private String  reg_nm = "";		//확인자 이름
	private String  reg_date = "";		//확인일자
	private String  note = "";			//비고
	private String  conf = "";			//확인완료 여부
	
	private String  cdCnt = "";	
	
	
	
	
	public String getConf() {
		return conf;
	}
	public void setConf(String conf) {
		this.conf = conf;
	}
	public String getRetire_flag_nm() {
		return retire_flag_nm;
	}
	public void setRetire_flag_nm(String retire_flag_nm) {
		this.retire_flag_nm = retire_flag_nm;
	}
	public String getCheck_nm() {
		return check_nm;
	}
	public void setCheck_nm(String check_nm) {
		this.check_nm = check_nm;
	}
	public String getCdCnt() {
		return cdCnt;
	}
	public void setCdCnt(String cdCnt) {
		this.cdCnt = cdCnt;
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
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getCompanyid() {
		return companyid;
	}
	public void setCompanyid(String companyid) {
		this.companyid = companyid;
	}
	public String getCompany_nm() {
		return company_nm;
	}
	public void setCompany_nm(String company_nm) {
		this.company_nm = company_nm;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUsernm() {
		return usernm;
	}
	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}
	public String getDeptid() {
		return deptid;
	}
	public void setDeptid(String deptid) {
		this.deptid = deptid;
	}
	public String getDeptnm() {
		return deptnm;
	}
	public void setDeptnm(String deptnm) {
		this.deptnm = deptnm;
	}
	public String getRetiredt() {
		return retiredt;
	}
	public void setRetiredt(String retiredt) {
		this.retiredt = retiredt;
	}
	public String getRetire_flag() {
		return retire_flag;
	}
	public void setRetire_flag(String retire_flag) {
		this.retire_flag = retire_flag;
	}
	public String getPageType() {
		return pageType;
	}
	public void setPageType(String pageType) {
		this.pageType = pageType;
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
	public String getSearch_text() {
		return search_text;
	}
	public void setSearch_text(String search_text) {
		this.search_text = search_text;
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
	public String getEmp_no() {
		return emp_no;
	}
	public void setEmp_no(String emp_no) {
		this.emp_no = emp_no;
	}
	public String getRetire_date() {
		return retire_date;
	}
	public void setRetire_date(String retire_date) {
		this.retire_date = retire_date;
	}
	public String getCheck_cd() {
		return check_cd;
	}
	public void setCheck_cd(String check_cd) {
		this.check_cd = check_cd;
	}
	public String getCheck_yn() {
		return check_yn;
	}
	public void setCheck_yn(String check_yn) {
		this.check_yn = check_yn;
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
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getReg_nm() {
		return reg_nm;
	}
	public void setReg_nm(String reg_nm) {
		this.reg_nm = reg_nm;
	}
	
	
}
