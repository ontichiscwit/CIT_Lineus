package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.model.CommonVO;

@Alias("mainVO")
public class MainVO extends CommonVO implements Serializable{
	private static final long serialVersionUID = 1975154714624929846L;
	
	private String firstFlag = "" ; 
	private String secondFlag = "" ;
	private String thirdFlag = "" ;
	
	private String tot_count = "" ; 
	private String flag1 = "" ; 
	private String flag2 = "" ; 
	private String flag3 = "" ; 
	private String flag4 = "" ; 
	private String flag5 = "" ; 
	
	private String dept_cd = "" ; 
	private String accept_dt = "" ; 
	private String his_gubun = "" ; 
	private String as_gubun = "" ; 
	private String code_name = "" ; 
	private String cnt = "" ;
	private String cust_gubun = "" ;
	
	private String a1 = "" ; 
	private String a2 = "" ; 
	private String a3 = "" ; 
	private String a4 = "" ; 
	private String a5 = "" ; 
	private String a6 = "" ;
	
	private String b1 = "" ;
	private String b2 = "" ;
	private String b3 = "" ;
	private String b4 = "" ;
	private String b5 = "" ;
	private String b6 = "" ;
	private String b7 = "" ;
	private String b8 = "" ;
	
	private String c1 = "" ;
	private String c2 = "" ;
	private String c3 = "" ;
	private String c4 = "" ;
	private String c5 = "" ;
	
	
	private String f1 = "" ;
	private String f2 = "" ;
	private String f3 = "" ;
	private String f4 = "" ;
	private String f5 = "" ;
	
	
	
	private String gubun = "";
	private String cust_nm = "";
	private String cnt1 = "";
	private String crm_code = "";
	private String cust_kor_name = "";
	private String misu_amt = "";
	private String grade = "";
	private String mtac_code_nm = "";
	private String gradeFlag = "";
	private String bondFlag = "";
	
	private String seq = "";
	
	
	private String str_dt ="";
	private String end_dt ="";
	private String item_code ="";
	private String bill_code ="";
	
	private String erp_code ="";
	private String master_yn ="";
	private String system_nm ="";
	private String wk_emp_no ="";
	private String system_code_nm ="";
    private String task_code_nm ="";
    private String cust_code ="";
    private String yyyymm ="";
    private String approval ="";
    
    
    
    
    
	
	public String getApproval() {
		return approval;
	}
	public void setApproval(String approval) {
		this.approval = approval;
	}
	public String getYyyymm() {
		return yyyymm;
	}
	public void setYyyymm(String yyyymm) {
		this.yyyymm = yyyymm;
	}
	public String getCust_code() {
		return cust_code;
	}
	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}
	public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getMaster_yn() {
		return master_yn;
	}
	public void setMaster_yn(String master_yn) {
		this.master_yn = master_yn;
	}
	public String getSystem_nm() {
		return system_nm;
	}
	public void setSystem_nm(String system_nm) {
		this.system_nm = system_nm;
	}
	public String getWk_emp_no() {
		return wk_emp_no;
	}
	public void setWk_emp_no(String wk_emp_no) {
		this.wk_emp_no = wk_emp_no;
	}
	public String getSystem_code_nm() {
		return system_code_nm;
	}
	public void setSystem_code_nm(String system_code_nm) {
		this.system_code_nm = system_code_nm;
	}
	public String getTask_code_nm() {
		return task_code_nm;
	}
	public void setTask_code_nm(String task_code_nm) {
		this.task_code_nm = task_code_nm;
	}
	public String getCust_gubun() {
		return cust_gubun;
	}
	public void setCust_gubun(String cust_gubun) {
		this.cust_gubun = cust_gubun;
	}
	public String getBill_code() {
		return bill_code;
	}
	public void setBill_code(String bill_code) {
		this.bill_code = bill_code;
	}
	
	public String getStr_dt() {
		return str_dt;
	}
	public void setStr_dt(String str_dt) {
		this.str_dt = str_dt;
	}
	public String getEnd_dt() {
		return end_dt;
	}
	public void setEnd_dt(String end_dt) {
		this.end_dt = end_dt;
	}
	public String getItem_code() {
		return item_code;
	}
	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}
	public String getBondFlag() {
		return bondFlag;
	}
	public void setBondFlag(String bondFlag) {
		this.bondFlag = bondFlag;
	}
	public String getGradeFlag() {
		return gradeFlag;
	}
	public void setGradeFlag(String gradeFlag) {
		this.gradeFlag = gradeFlag;
	}
	
	
	public String getF1() {
		return f1;
	}
	public void setF1(String f1) {
		this.f1 = f1;
	}
	
	public String getF2() {
		return f2;
	}
	public void setF2(String f2) {
		this.f2 = f2;
	}
	
	public String getF3() {
		return f3;
	}
	public void setF3(String f3) {
		this.f3 = f3;
	}
	public String getF4() {
		return f4;
	}
	public void setF4(String f4) {
		this.f4 = f4;
	}
	public String getF5() {
		return f5;
	}
	public void setF5(String f5) {
		this.f5 = f5;
	}
	
	
	public String getC1() {
		return c1;
	}
	public void setC1(String c1) {
		this.c1 = c1;
	}
	public String getC2() {
		return c2;
	}
	public void setC2(String c2) {
		this.c2 = c2;
	}
	public String getC3() {
		return c3;
	}
	public void setC3(String c3) {
		this.c3 = c3;
	}
	public String getC4() {
		return c4;
	}
	public void setC4(String c4) {
		this.c4 = c4;
	}
	public String getC5() {
		return c5;
	}
	public void setC5(String c5) {
		this.c5 = c5;
	}
	public String getMtac_code_nm() {
		return mtac_code_nm;
	}
	public void setMtac_code_nm(String mtac_code_nm) {
		this.mtac_code_nm = mtac_code_nm;
	}
	public String getGrade() {
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public String getCrm_code() {
		return crm_code;
	}
	public void setCrm_code(String crm_code) {
		this.crm_code = crm_code;
	}
	public String getCust_kor_name() {
		return cust_kor_name;
	}
	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}
	public String getMisu_amt() {
		return misu_amt;
	}
	public void setMisu_amt(String misu_amt) {
		this.misu_amt = misu_amt;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getCust_nm() {
		return cust_nm;
	}
	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}
	public String getCnt1() {
		return cnt1;
	}
	public void setCnt1(String cnt1) {
		this.cnt1 = cnt1;
	}
	public String getA1() {
		return a1;
	}
	public void setA1(String a1) {
		this.a1 = a1;
	}
	public String getA2() {
		return a2;
	}
	public void setA2(String a2) {
		this.a2 = a2;
	}
	public String getA3() {
		return a3;
	}
	public void setA3(String a3) {
		this.a3 = a3;
	}
	public String getA4() {
		return a4;
	}
	public void setA4(String a4) {
		this.a4 = a4;
	}
	public String getA5() {
		return a5;
	}
	public void setA5(String a5) {
		this.a5 = a5;
	}
	public String getA6() {
		return a6;
	}
	public void setA6(String a6) {
		this.a6 = a6;
	}
	public String getB1() {
		return b1;
	}
	public void setB1(String b1) {
		this.b1 = b1;
	}
	public String getB2() {
		return b2;
	}
	public void setB2(String b2) {
		this.b2 = b2;
	}
	public String getB3() {
		return b3;
	}
	public void setB3(String b3) {
		this.b3 = b3;
	}
	public String getB4() {
		return b4;
	}
	public void setB4(String b4) {
		this.b4 = b4;
	}
	public String getB5() {
		return b5;
	}
	public void setB5(String b5) {
		this.b5 = b5;
	}
	public String getB6() {
		return b6;
	}
	public void setB6(String b6) {
		this.b6 = b6;
	}
	public String getB7() {
		return b7;
	}
	public void setB7(String b7) {
		this.b7 = b7;
	}
	public String getB8() {
		return b8;
	}
	public void setB8(String b8) {
		this.b8 = b8;
	}
	public String getAs_gubun() {
		return as_gubun;
	}
	public void setAs_gubun(String as_gubun) {
		this.as_gubun = as_gubun;
	}
	public String getFirstFlag() {
		return firstFlag;
	}
	public void setFirstFlag(String firstFlag) {
		this.firstFlag = firstFlag;
	}
	public String getSecondFlag() {
		return secondFlag;
	}
	public void setSecondFlag(String secondFlag) {
		this.secondFlag = secondFlag;
	}
	public String getTot_count() {
		return tot_count;
	}
	public void setTot_count(String tot_count) {
		this.tot_count = tot_count;
	}
	public String getFlag1() {
		return flag1;
	}
	public void setFlag1(String flag1) {
		this.flag1 = flag1;
	}
	public String getFlag2() {
		return flag2;
	}
	public void setFlag2(String flag2) {
		this.flag2 = flag2;
	}
	public String getFlag3() {
		return flag3;
	}
	public void setFlag3(String flag3) {
		this.flag3 = flag3;
	}
	public String getFlag4() {
		return flag4;
	}
	public void setFlag4(String flag4) {
		this.flag4 = flag4;
	}
	public String getFlag5() {
		return flag5;
	}
	public void setFlag5(String flag5) {
		this.flag5 = flag5;
	}
	public String getThirdFlag() {
		return thirdFlag;
	}
	public void setThirdFlag(String thirdFlag) {
		this.thirdFlag = thirdFlag;
	}
	public String getDept_cd() {
		return dept_cd;
	}
	public void setDept_cd(String dept_cd) {
		this.dept_cd = dept_cd;
	}
	public String getAccept_dt() {
		return accept_dt;
	}
	public void setAccept_dt(String accept_dt) {
		this.accept_dt = accept_dt;
	}
	public String getHis_gubun() {
		return his_gubun;
	}
	public void setHis_gubun(String his_gubun) {
		this.his_gubun = his_gubun;
	}
	public String getCode_name() {
		return code_name;
	}
	public void setCode_name(String code_name) {
		this.code_name = code_name;
	}
	public String getCnt() {
		return cnt;
	}
	public void setCnt(String cnt) {
		this.cnt = cnt;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	
	
}