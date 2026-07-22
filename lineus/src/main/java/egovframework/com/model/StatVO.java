package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("statVO")
public class StatVO extends CustVO implements Serializable {
	private static final long serialVersionUID = 8270977273658995518L;
	
	private String opCnt = "";
	private String gubun = "";
	private String cust_nm = "";
	private String cust_gubun = "";
	private String foundation_dt1 = "";
	private String foundation_dt2 = "";
	private String contract_dt1 = "";
	private String contract_dt2 = "";
	private String gubun_code = "";
	private String open_dt1 = "";
	private String open_dt2 = "";
	private String term_person_count = "";
	private String pm = "";
	private String test_dt1 = "";
	private String test_dt2 = "";
	private String version = "";
	private String formation_code = "";
	private String os = "";
	private String mtac_contract_dt1 = "";
	private String mtac_contract_dt2 = "";
	private String cust_kor_name = "";
	private String basic_etc = "";
	private String bed_count = "";
	private String veterans_yn = "";
	private String military_yn = "";
	private String old_company_nm = "";
	private String outside_cust_code = "";
	private String charge_code = "";
	private String charge_nm = "";
	private String deal_code = "";
	private String his_basic_code = "";
	private String his_treat_code = "";
	private String his_work_code = "";
	private String his_claim_code = "";
	private String choice_yn = "";
	private String dentist_yn = "";
	private String mental_yn = "";
	private String oriental_yn = "";
	private String hemodialysis_yn = "";
	private String care_yn = "";
	private String care_grade = "";
	private String contents = "";
	private String n_etc = "";
	private String version_nm = "";
	private String os_nm = "";
	private String outside_cust_code_nm = "";
	private String charge_code_nm = "";
	private String action_result_code_nm = "";
	
	private String queryWhere = "";
	
	private String mtac_calc = "" ; 
	private String receive_amt = "" ; 
	
	
	public String getMtac_calc() {
		return mtac_calc;
	}
	public void setMtac_calc(String mtac_calc) {
		this.mtac_calc = mtac_calc;
	}
	public String getReceive_amt() {
		return receive_amt;
	}
	public void setReceive_amt(String receive_amt) {
		this.receive_amt = receive_amt;
	}
	public String getAction_result_code_nm() {
		return action_result_code_nm;
	}
	public void setAction_result_code_nm(String action_result_code_nm) {
		this.action_result_code_nm = action_result_code_nm;
	}
	public String getVersion_nm() {
		return version_nm;
	}
	public void setVersion_nm(String version_nm) {
		this.version_nm = version_nm;
	}
	public String getOs_nm() {
		return os_nm;
	}
	public void setOs_nm(String os_nm) {
		this.os_nm = os_nm;
	}
	public String getOutside_cust_code_nm() {
		return outside_cust_code_nm;
	}
	public void setOutside_cust_code_nm(String outside_cust_code_nm) {
		this.outside_cust_code_nm = outside_cust_code_nm;
	}
	public String getCharge_code_nm() {
		return charge_code_nm;
	}
	public void setCharge_code_nm(String charge_code_nm) {
		this.charge_code_nm = charge_code_nm;
	}
	public String getOpCnt() {
		return opCnt;
	}
	public void setOpCnt(String opCnt) {
		this.opCnt = opCnt;
	}
	public String getQueryWhere() {
		return queryWhere;
	}
	public void setQueryWhere(String queryWhere) {
		this.queryWhere = queryWhere;
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
	public String getCust_gubun() {
		return cust_gubun;
	}
	public void setCust_gubun(String cust_gubun) {
		this.cust_gubun = cust_gubun;
	}
	public String getFoundation_dt1() {
		return foundation_dt1;
	}
	public void setFoundation_dt1(String foundation_dt1) {
		this.foundation_dt1 = foundation_dt1;
	}
	public String getFoundation_dt2() {
		return foundation_dt2;
	}
	public void setFoundation_dt2(String foundation_dt2) {
		this.foundation_dt2 = foundation_dt2;
	}
	public String getContract_dt1() {
		return contract_dt1;
	}
	public void setContract_dt1(String contract_dt1) {
		this.contract_dt1 = contract_dt1;
	}
	public String getContract_dt2() {
		return contract_dt2;
	}
	public void setContract_dt2(String contract_dt2) {
		this.contract_dt2 = contract_dt2;
	}
	public String getGubun_code() {
		return gubun_code;
	}
	public void setGubun_code(String gubun_code) {
		this.gubun_code = gubun_code;
	}
	public String getOpen_dt1() {
		return open_dt1;
	}
	public void setOpen_dt1(String open_dt1) {
		this.open_dt1 = open_dt1;
	}
	public String getOpen_dt2() {
		return open_dt2;
	}
	public void setOpen_dt2(String open_dt2) {
		this.open_dt2 = open_dt2;
	}
	public String getTerm_person_count() {
		return term_person_count;
	}
	public void setTerm_person_count(String term_person_count) {
		this.term_person_count = term_person_count;
	}
	public String getPm() {
		return pm;
	}
	public void setPm(String pm) {
		this.pm = pm;
	}
	public String getTest_dt1() {
		return test_dt1;
	}
	public void setTest_dt1(String test_dt1) {
		this.test_dt1 = test_dt1;
	}
	public String getTest_dt2() {
		return test_dt2;
	}
	public void setTest_dt2(String test_dt2) {
		this.test_dt2 = test_dt2;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getFormation_code() {
		return formation_code;
	}
	public void setFormation_code(String formation_code) {
		this.formation_code = formation_code;
	}
	public String getOs() {
		return os;
	}
	public void setOs(String os) {
		this.os = os;
	}
	public String getMtac_contract_dt1() {
		return mtac_contract_dt1;
	}
	public void setMtac_contract_dt1(String mtac_contract_dt1) {
		this.mtac_contract_dt1 = mtac_contract_dt1;
	}
	public String getMtac_contract_dt2() {
		return mtac_contract_dt2;
	}
	public void setMtac_contract_dt2(String mtac_contract_dt2) {
		this.mtac_contract_dt2 = mtac_contract_dt2;
	}
	public String getCust_kor_name() {
		return cust_kor_name;
	}
	public void setCust_kor_name(String cust_kor_name) {
		this.cust_kor_name = cust_kor_name;
	}
	public String getBasic_etc() {
		return basic_etc;
	}
	public void setBasic_etc(String basic_etc) {
		this.basic_etc = basic_etc;
	}
	public String getBed_count() {
		return bed_count;
	}
	public void setBed_count(String bed_count) {
		this.bed_count = bed_count;
	}
	public String getVeterans_yn() {
		return veterans_yn;
	}
	public void setVeterans_yn(String veterans_yn) {
		this.veterans_yn = veterans_yn;
	}
	public String getMilitary_yn() {
		return military_yn;
	}
	public void setMilitary_yn(String military_yn) {
		this.military_yn = military_yn;
	}
	public String getOld_company_nm() {
		return old_company_nm;
	}
	public void setOld_company_nm(String old_company_nm) {
		this.old_company_nm = old_company_nm;
	}
	public String getOutside_cust_code() {
		return outside_cust_code;
	}
	public void setOutside_cust_code(String outside_cust_code) {
		this.outside_cust_code = outside_cust_code;
	}
	public String getCharge_code() {
		return charge_code;
	}
	public void setCharge_code(String charge_code) {
		this.charge_code = charge_code;
	}
	public String getCharge_nm() {
		return charge_nm;
	}
	public void setCharge_nm(String charge_nm) {
		this.charge_nm = charge_nm;
	}
	public String getDeal_code() {
		return deal_code;
	}
	public void setDeal_code(String deal_code) {
		this.deal_code = deal_code;
	}
	public String getHis_basic_code() {
		return his_basic_code;
	}
	public void setHis_basic_code(String his_basic_code) {
		this.his_basic_code = his_basic_code;
	}
	public String getHis_treat_code() {
		return his_treat_code;
	}
	public void setHis_treat_code(String his_treat_code) {
		this.his_treat_code = his_treat_code;
	}
	public String getHis_work_code() {
		return his_work_code;
	}
	public void setHis_work_code(String his_work_code) {
		this.his_work_code = his_work_code;
	}
	public String getHis_claim_code() {
		return his_claim_code;
	}
	public void setHis_claim_code(String his_claim_code) {
		this.his_claim_code = his_claim_code;
	}
	public String getChoice_yn() {
		return choice_yn;
	}
	public void setChoice_yn(String choice_yn) {
		this.choice_yn = choice_yn;
	}
	public String getDentist_yn() {
		return dentist_yn;
	}
	public void setDentist_yn(String dentist_yn) {
		this.dentist_yn = dentist_yn;
	}
	public String getMental_yn() {
		return mental_yn;
	}
	public void setMental_yn(String mental_yn) {
		this.mental_yn = mental_yn;
	}
	public String getOriental_yn() {
		return oriental_yn;
	}
	public void setOriental_yn(String oriental_yn) {
		this.oriental_yn = oriental_yn;
	}
	public String getHemodialysis_yn() {
		return hemodialysis_yn;
	}
	public void setHemodialysis_yn(String hemodialysis_yn) {
		this.hemodialysis_yn = hemodialysis_yn;
	}
	public String getCare_yn() {
		return care_yn;
	}
	public void setCare_yn(String care_yn) {
		this.care_yn = care_yn;
	}
	public String getCare_grade() {
		return care_grade;
	}
	public void setCare_grade(String care_grade) {
		this.care_grade = care_grade;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getN_etc() {
		return n_etc;
	}
	public void setN_etc(String n_etc) {
		this.n_etc = n_etc;
	}
	
	
}
