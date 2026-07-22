package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("boardVO")
public class BoardVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 8270977273658995518L;

	private String seq = "";
	private String board_gbn = "";
	private String title = "";
	private String content = "";
	private String cnt = "";
	private String reg_date = "";
	private String reg_id = "";
	private String upd_date = "";
	private String upd_id = "";
	private String emp_nm = "";
	private String listNum = "";
	private String emp_id = "";
	private String del_attach_seq = "" ; 
    private String del_attach_ord = "" ; 
    private String del_seq = "";
    private String prev_seq = "";
    private String next_seq = "";
    private String erpCodeArr = "";
    
    
    // 20171109 공지사항 수정건 적용 시작
    private String crmCode = ""; // 조회시 fr 접근 사용자의 crm_code
    private String work_type = ""; // 업무유형 추가 필드
    private String work_type2 = ""; // 업무유형 세부 추가 필드
    private String crmCodeArr = ""; // 등 록시 접근가능한 crmCode String "구분자 '|' 구분된 리스트
    private String open_type = "";
    private String open_type_nm = "";
    private String notice_num = "";
    private String system_type = "";
    private String work_type_nm = ""; // 업무유형 명 추가 필드
    private String system_type_nm = ""; // 업무유형 명 추가 필드
    private String work_type2_nm = ""; // 업무유형 세부 명 추가 필드
    private String readUserId = "";
    private String notice_cnt ="";
    private String erp_code ="";
    
    
    
    
    public String getErp_code() {
		return erp_code;
	}
	public void setErp_code(String erp_code) {
		this.erp_code = erp_code;
	}
	public String getErpCodeArr() {
		return erpCodeArr;
	}
	public void setErpCodeArr(String erpCodeArr) {
		this.erpCodeArr = erpCodeArr;
	}
	public String getSystem_type() {
		return system_type;
	}
	public void setSystem_type(String system_type) {
		this.system_type = system_type;
	}
	public String getSystem_type_nm() {
		return system_type_nm;
	}
	public void setSystem_type_nm(String system_type_nm) {
		this.system_type_nm = system_type_nm;
	}
	public String getNotice_cnt() {
		return notice_cnt;
	}
	public void setNotice_cnt(String notice_cnt) {
		this.notice_cnt = notice_cnt;
	}
	
	public String getEmp_id() {
		return emp_id;
	}
	public void setEmp_id(String emp_id) {
		this.emp_id = emp_id;
	}
    
    public String getReadUserId() {
		return readUserId;
	}
	public void setReadUserId(String readUserId) {
		this.readUserId = readUserId;
	}
	public String getOpen_type_nm() {
		return open_type_nm;
	}
	public void setOpen_type_nm(String open_type_nm) {
		this.open_type_nm = open_type_nm;
	}
	public String getWork_type2() {
		return work_type2;
	}
	public void setWork_type2(String work_type2) {
		this.work_type2 = work_type2;
	}
	public String getWork_type_nm() {
		return work_type_nm;
	}
	public void setWork_type_nm(String work_type_nm) {
		this.work_type_nm = work_type_nm;
	}
	public String getWork_type2_nm() {
		return work_type2_nm;
	}
	public void setWork_type2_nm(String work_type2_nm) {
		this.work_type2_nm = work_type2_nm;
	}
	public String getNotice_num() {
		return notice_num;
	}
	public void setNotice_num(String notice_num) {
		this.notice_num = notice_num;
	}
	public String getOpen_type() {
		return open_type;
	}
	public void setOpen_type(String open_type) {
		this.open_type = open_type;
	}
	private String test = "";
    

	public String getTest() {
		return test;
	}
	public void setTest(String test) {
		this.test = test;
	}
	public String getCrmCodeArr() {
		return crmCodeArr;
	}
	public void setCrmCodeArr(String crmCodeArr) {
		this.crmCodeArr = crmCodeArr;
	}
	public String getWork_type() {
		return work_type;
	}
	public void setWork_type(String work_type) {
		this.work_type = work_type;
	}
	public String getCrmCode() {
		return crmCode;
	}
	public void setCrmCode(String crmCode) {
		this.crmCode = crmCode;
	}
	// 20171109 공지사항 수정건 적용 끝
	
	public String getPrev_seq() {
		return prev_seq;
	}
	public void setPrev_seq(String prev_seq) {
		this.prev_seq = prev_seq;
	}
	public String getNext_seq() {
		return next_seq;
	}
	public void setNext_seq(String next_seq) {
		this.next_seq = next_seq;
	}
	public String getListNum() {
		return listNum;
	}
	public void setListNum(String listNum) {
		this.listNum = listNum;
	}
	public String getEmp_nm() {
		return emp_nm;
	}
	public void setEmp_nm(String emp_nm) {
		this.emp_nm = emp_nm;
	}
	public String getDel_seq() {
		return del_seq;
	}
	public void setDel_seq(String del_seq) {
		this.del_seq = del_seq;
	}
	public String getDel_attach_seq() {
		return del_attach_seq;
	}
	public void setDel_attach_seq(String del_attach_seq) {
		this.del_attach_seq = del_attach_seq;
	}
	public String getDel_attach_ord() {
		return del_attach_ord;
	}
	public void setDel_attach_ord(String del_attach_ord) {
		this.del_attach_ord = del_attach_ord;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getBoard_gbn() {
		return board_gbn;
	}
	public void setBoard_gbn(String board_gbn) {
		this.board_gbn = board_gbn;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getCnt() {
		return cnt;
	}
	public void setCnt(String cnt) {
		this.cnt = cnt;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getUpd_date() {
		return upd_date;
	}
	public void setUpd_date(String upd_date) {
		this.upd_date = upd_date;
	}
	public String getUpd_id() {
		return upd_id;
	}
	public void setUpd_id(String upd_id) {
		this.upd_id = upd_id;
	}
	@Override
	public String toString() {
		return "BoardVO [seq=" + seq + ", board_gbn=" + board_gbn + ", title="
				+ title + ", content=" + content + ", cnt=" + cnt
				+ ", reg_date=" + reg_date + ", reg_id=" + reg_id
				+ ", upd_date=" + upd_date + ", upd_id=" + upd_id + ", emp_nm="
				+ emp_nm + ", listNum=" + listNum + ", del_attach_seq="
				+ del_attach_seq + ", del_attach_ord=" + del_attach_ord
				+ ", del_seq=" + del_seq + ", prev_seq=" + prev_seq
				+ ", next_seq=" + next_seq + ", crmCode=" + crmCode
				+ ", work_type=" + work_type + ", work_type2=" + work_type2
				+ ", crmCodeArr=" + crmCodeArr + ", open_type=" + open_type
				+ ", open_type_nm=" + open_type_nm + ", notice_num="
				+ notice_num + ", work_type_nm=" + work_type_nm
				+ ", work_type2_nm=" + work_type2_nm + ", test=" + test + "]";
	}
	
	
}
