package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("mssqlVO")
public class MssqlVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	
	
	private String idx ="";     	//순번
	private String docid ="";   	//문서ID
	private String docttl ="";  	//문서제목
	private String doctxt ="";  	//문서내용
	private String docdate =""; 	//의뢰일시
	private String docrdate ="";	//요청일시
	private String level1 ="";  	//IT
	private String level2 ="";  	//시스템유형+업무구분
	private String level3 ="";  	//문의유형
	private String regid ="";   	//의뢰자ID
	private String regnm ="";   	//의뢰자이름
	private String regcomnm ="";	//의뢰자회사
	private String regcomid ="";	//의뢰자회사ID
	private String rcvid ="";   	//접수자ID (검토자=최종결재자=결재승인자)
	private String rcvnm ="";   	//접수자이름
	
	private String rcvsdate ="";	//접수일시
	private String rcvrdate ="";	//예상완료일시
	private String rcvedate ="";	//접수처리완료일시
	private String worktime ="";	//소요일
	private String docattach =""; 	//첨부파일여부
	
	private String filenm ="";		//첨부파일
	private String filenm2 =""; 	//첨부파일이름
	private String filepath ="";	//첨부파일 경로
	private String mail ="";		
	private String tag ="";			//접수의견(TBL_DOCLINE)
	
	
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getRcvnm() {
		return rcvnm;
	}
	public void setRcvnm(String rcvnm) {
		this.rcvnm = rcvnm;
	}
	public String getFilenm() {
		return filenm;
	}
	public void setFilenm(String filenm) {
		this.filenm = filenm;
	}
	public String getFilenm2() {
		return filenm2;
	}
	public void setFilenm2(String filenm2) {
		this.filenm2 = filenm2;
	}
	public String getFilepath() {
		return filepath;
	}
	public void setFilepath(String filepath) {
		this.filepath = filepath;
	}
	public String getDocattach() {
		return docattach;
	}
	public void setDocattach(String docattach) {
		this.docattach = docattach;
	}
	public String getDocid() {
		return docid;
	}
	public void setDocid(String docid) {
		this.docid = docid;
	}
	public String getRegcomid() {
		return regcomid;
	}
	public void setRegcomid(String regcomid) {
		this.regcomid = regcomid;
	}
	public String getDoctxt() {
		return doctxt;
	}
	public void setDoctxt(String doctxt) {
		this.doctxt = doctxt;
	}
	public String getIdx() {
		return idx;
	}
	public void setIdx(String idx) {
		this.idx = idx;
	}
	public String getDocttl() {
		return docttl;
	}
	public void setDocttl(String docttl) {
		this.docttl = docttl;
	}
	public String getDocdate() {
		return docdate;
	}
	public void setDocdate(String docdate) {
		this.docdate = docdate;
	}
	public String getDocrdate() {
		return docrdate;
	}
	public void setDocrdate(String docrdate) {
		this.docrdate = docrdate;
	}
	public String getLevel1() {
		return level1;
	}
	public void setLevel1(String level1) {
		this.level1 = level1;
	}
	public String getLevel2() {
		return level2;
	}
	public void setLevel2(String level2) {
		this.level2 = level2;
	}
	public String getLevel3() {
		return level3;
	}
	public void setLevel3(String level3) {
		this.level3 = level3;
	}
	public String getRegid() {
		return regid;
	}
	public void setRegid(String regid) {
		this.regid = regid;
	}
	public String getRegnm() {
		return regnm;
	}
	public void setRegnm(String regnm) {
		this.regnm = regnm;
	}
	public String getRegcomnm() {
		return regcomnm;
	}
	public void setRegcomnm(String regcomnm) {
		this.regcomnm = regcomnm;
	}
	public String getRcvid() {
		return rcvid;
	}
	public void setRcvid(String rcvid) {
		this.rcvid = rcvid;
	}
	public String getRcvsdate() {
		return rcvsdate;
	}
	public void setRcvsdate(String rcvsdate) {
		this.rcvsdate = rcvsdate;
	}
	public String getRcvrdate() {
		return rcvrdate;
	}
	public void setRcvrdate(String rcvrdate) {
		this.rcvrdate = rcvrdate;
	}
	public String getRcvedate() {
		return rcvedate;
	}
	public void setRcvedate(String rcvedate) {
		this.rcvedate = rcvedate;
	}
	public String getWorktime() {
		return worktime;
	}
	public void setWorktime(String worktime) {
		this.worktime = worktime;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}

	
	
	
}
