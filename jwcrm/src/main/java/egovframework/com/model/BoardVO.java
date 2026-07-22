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
    
    
    // 20171109 공지사항 수정건 적용 시작
    private String crmCode = ""; // 조회시 fr 접근 사용자의 crm_code
    private String work_type = ""; // 업무유형 추가 필드
    private String work_type2 = ""; // 업무유형 세부 추가 필드
    private String crmCodeArr = ""; // 등 록시 접근가능한 crmCode String "구분자 '|' 구분된 리스트
    private String open_type = "";
    private String open_type_nm = "";
    private String notice_num = "";
    
    private String work_type_nm = ""; // 업무유형 명 추가 필드
    private String work_type2_nm = ""; // 업무유형 세부 명 추가 필드
    
    private String readUserId = "";
    
    private String notice_cnt ="";
    
    private String onlyme_open_yn = "";
    
    private String imp_type = "";
    private String imp_yn = "";
    
    private String latest_post = ""; //최신글 구분 필드
    
    private String like_yn = ""; //좋아요 구분 필드
    private String like_cnt = ""; //좋아요 개수
    private String w_id = ""; //사용자 아이디
    private String crm_code = "";
    
    private String search_start = "";
    private String search_end = "";
    private String search_text = ""; //검색키워드
    
    private String deadline = ""; //중요공지 마감일자
    private String highlight_words = ""; //게시물 제목 강조할 키워드
    
    private String cust_code = ""; //거래처코드
    private String search_date = ""; //검색일
    private String searchview_date = ""; //검색후조회일
    
    private String best_faq = ""; //베스트 상담사례
    private String best_type = "";
    
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
	
	public String getOnlyme_open_yn() {
		return onlyme_open_yn;
	}
	public void setOnlyme_open_yn(String onlyme_open_yn) {
		this.onlyme_open_yn = onlyme_open_yn;
	}
	
	public String getImp_type() {
		return imp_type;
	}
	public void setImp_type(String imp_type) {
		this.imp_type = imp_type;
	}
	
	public String getImp_yn() {
		return imp_yn;
	}
	public void setImp_yn(String imp_yn) {
		this.imp_yn = imp_yn;
	}
	
	public String getLatest_post() {
		return latest_post;
	}
	public void setLatest_post(String latest_post) {
		this.latest_post = latest_post;
	}
	public String getLike_yn() {
		return like_yn;
	}
	public void setLike_yn(String like_yn) {
		this.like_yn = like_yn;
	}
	public String getLike_cnt() {
		return like_cnt;
	}
	public void setLike_cnt(String like_cnt) {
		this.like_cnt = like_cnt;
	}
	public String getW_id() {
		return w_id;
	}
	public void setW_id(String w_id) {
		this.w_id = w_id;
	}
	public String getCrm_code() {
		return crm_code;
	}
	public void setCrm_code(String crm_code) {
		this.crm_code = crm_code;
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
	public String getSearch_text() {
		return search_text;
	}
	public void setSearch_text(String search_text) {
		this.search_text = search_text;
	}
	public String getDeadline() {
		return deadline;
	}
	public void setDeadline(String deadline) {
		this.deadline = deadline;
	}
	public String getHighlight_words() {
		return highlight_words;
	}
	public void setHighlight_words(String highlight_words) {
		this.highlight_words = highlight_words;
	}
	public String getCust_code() {
		return cust_code;
	}
	public void setCust_code(String cust_code) {
		this.cust_code = cust_code;
	}
	public String getSearch_date() {
		return search_date;
	}
	public void setSearch_date(String search_date) {
		this.search_date = search_date;
	}
	public String getSearchview_date() {
		return searchview_date;
	}
	public void setSearchview_date(String searchview_date) {
		this.searchview_date = searchview_date;
	}
	public String getBest_faq() {
		return best_faq;
	}
	public void setBest_faq(String best_faq) {
		this.best_faq = best_faq;
	}
	public String getBest_type() {
		return best_type;
	}
	public void setBest_type(String best_type) {
		this.best_type = best_type;
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
