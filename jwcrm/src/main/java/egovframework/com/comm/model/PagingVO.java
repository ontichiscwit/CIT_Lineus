package egovframework.com.comm.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import egovframework.com.model.CommonVO;

@Alias("pageingVO")
public class PagingVO extends CommonVO implements Serializable{

	private static final long serialVersionUID = 5127935324938357967L;
	
	int rnum ; 
	
	int firstIndex ; 
	
	int lastIndex ; 
	
	/** 전체 게시물 수 */
	int rowCnt;
	
	/** 페이지 수 */
	int pageCnt;
	
	/** 블럭 수 */
	int blockCnt;
	
	/** 현재 페이지 */
	int page = 1;

	/** 페이지 사이즈 : 한페이지에서 보여줄 로우수 */
	int pageSize = 10;
	
	/** 블럭 사이즈 : 한블럭에서 보여줄 페이지 수 */
	int blockSize = 10;
	
	/** 시작 게시물 */
	int startRow = 0;
	
	/** 마지막 게시물 */
	int endRow = 10;
	
	int rownumLast ;
	
	int my_startRow = 0 ; 
	
	int form_page = 0 ; 
	
	String paging_location = "" ; 
	
	private String json_paging = "" ;
	
	public int getLastIndex() {
		return lastIndex;
	}

	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}

	public int getFirstIndex() {
		return firstIndex;
	}

	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}

	public int getRnum() {
		return rnum;
	}

	public void setRnum(int rnum) {
		this.rnum = rnum;
	}

	public int getForm_page() {
		return form_page;
	}

	public void setForm_page(int form_page) {
		this.form_page = form_page;
	}

	public String getPaging_location() {
		return paging_location;
	}

	public void setPaging_location(String paging_location) {
		this.paging_location = paging_location;
	}

	public int getMy_startRow() {
		return my_startRow;
	}

	public void setMy_startRow(int my_startRow) {
		this.my_startRow = my_startRow;
	}

	/** 파일 ID */
	private String attach_file_id;
	
	
	
	public int getRowCnt() {
		return rowCnt;
	}

	public void setRowCnt(int rowCnt) {
		this.rowCnt = rowCnt;
	}

	public int getPageCnt() {
		return ((rowCnt-1)/pageSize+1);
	}

	public void setPageCnt(int pageCnt) {
		this.pageCnt = pageCnt;
	}

	public int getBlockCnt() {
		return ((rowCnt-1)/pageSize+1)/blockSize+1;
	}

	public void setBlockCnt(int blockCnt) {
		this.blockCnt = blockCnt;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		if (page < 1) {
			page = 1;
		}
		this.page = page;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getBlockSize() {
		return this.blockSize;
	}

	public void setBlockSize(int blockSize) {
		this.blockSize = blockSize;
	}

	public int getStartRow() {
		return this.startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return this.endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}
	
	public void setPaging(int rowCnt) {
		
		setRowCnt(rowCnt);
		
		if(this.pageSize != 10){
			setPageSize(this.pageSize);
		}else{
			setPageSize(10);
		}
		
		setBlockSize(10);
		
		this.pageCnt = (rowCnt  / this.pageSize);
		
		if(this.pageCnt > 0){
			if((rowCnt  % this.pageSize) > 0)this.pageCnt = this.pageCnt + 1;
		}
		
		this.blockCnt = (((rowCnt - 1)/ this.pageSize) + 1) / this.blockSize + 1 ; 
		
		this.startRow = (rowCnt - (this.page * this.pageSize)) + 1 ; 
		this.endRow = rowCnt - (this.page - 1) * this.pageSize ; 
		
		if(this.startRow < 0) this.startRow = 1 ;
		if(this.endRow > this.rowCnt) this.endRow = this.rowCnt ;
		
		setStartRow(this.startRow) ;
		setEndRow(this.endRow) ;
		
		if(this.pageSize == 1){
			this.rownumLast = this.page ; 
		}else{
			this.rownumLast = this.rowCnt -  (this.page - 1) * this.pageSize ; 
		}
	}
	
	public String getPaging(){
		StringBuffer sb = new StringBuffer() ; 
		
		int pre10 = this.getPage() - 1; 
		int next10 = this.getPage() + 1 ; 
		
		if(pre10 < 1) pre10 = 1; 
		if(next10 > this.getPageCnt() ) next10 = this.getPageCnt();
		
		int beginLinkPage = (this.getPage() - 1) / this.getBlockSize() * this.getBlockSize() + 1;
		
		if(this.getPageCnt() != 0){
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList(1)\">&lt;&lt;</a>");
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList("+pre10+")\">&lt;</a>") ;	
		}
		
		for(int i = beginLinkPage; i < beginLinkPage + this.getBlockSize() ; i++ ){
			if(i > this.getPageCnt()) break ; 
			if(i == this.getPage()) {
				sb.append("			<a href=\"javascript:void(0);\" onclick=\"goList("+i+")\" class=\"on\">"+i+"</a>");
			}else{
				sb.append("			<a href=\"javascript:void(0);\" onclick=\"goList("+i+")\">"+i+"</a>");
			}
		}
		
		if(this.getPageCnt() != 0){
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList("+next10+")\">&gt;</a>") ;	
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList("+this.getPageCnt()+")\">&gt;&gt;</a>");
		}
		
		return sb.toString() ; 
	}
	
	public String getJsonPaging(String funcNm){
		StringBuffer sb = new StringBuffer() ; 
			
		int pre10 = this.page - 1 ; 
		int next10 = this.page + 1 ; 
		
		if(pre10 < 1) pre10 = 1 ; 
		if(next10 > this.pageCnt) next10 = this.pageCnt ;
		
		
		if(this.pageCnt != 0){
			sb.append("	<button type=\"button\" class=\"btn_first\" onclick=\""+funcNm+"(1)\">첫번째 목록으로</button>	");
			sb.append("	<button type=\"button\" class=\"btn_before\" onclick=\""+funcNm+"("+pre10+")\">이전 목록으로</button>	");
		}
		
		int beginLinkPage = (this.getPage() - 1) / this.getBlockSize() * this.getBlockSize() + 1;
		
		for(int i = beginLinkPage; i < beginLinkPage + this.getBlockSize() ; i++ ){
			if(i > this.pageCnt) break ; 
			if(i == this.page) {
				sb.append("			<a href=\"#\" class=\"active\">"+i+"</a>");
			}else{
				sb.append("			<a href=\"javascript:void(0);\" onclick=\""+funcNm+"("+i+");\">"+i+"</a>");
			}
		}
		
		if(this.pageCnt != 0){
			sb.append("		<button type=\"button\" class=\"btn_next\" onclick=\""+funcNm+"("+next10+")\">다음 목록으로</button>") ;
			sb.append("		<button type=\"button\" class=\"btn_last\" onclick=\""+funcNm+"("+this.pageCnt+")\">마지막 목록으로</button>") ;
		}
		
		return sb.toString() ; 
	}
	
	public String getAttach_file_id() {
		return attach_file_id;
	}

	public void setAttach_file_id(String attach_file_id) {
		this.attach_file_id = attach_file_id;
	}

	public int getRownumLast() {
		return rownumLast;
	}

	public void setRownumLast(int rownumLast) {
		this.rownumLast = rownumLast;
	}

	public String getJson_paging() {
		return json_paging;
	}

	public void setJson_paging(String json_paging) {
		this.json_paging = json_paging;
	}

	
}
