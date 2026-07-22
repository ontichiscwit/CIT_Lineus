package egovframework.com.model;

import java.io.Serializable;
import java.util.List;
import org.apache.ibatis.type.Alias;

@Alias("asStatsVo")
public class AsStatsVo extends CommonVO implements Serializable {

	private static final long serialVersionUID = -1201733194103278510L;
			
	private String rnum; 			/*순번*/
	private String system_type; 	/*시스템 타입*/
	private String system_type_nm;	/*시스템 이름*/
	private String jcnt1;			/*전년도 프로그램*/
	private String jcnt2;			/*전년도 데이터*/
	private String jcnt3;			/*전년도 권한*/
	private String jcnt4;			/*전년도 기타*/
	private String jcnt_tot;		/*전년도 합계*/
	private String cnt1;			/*조회기간 프로그램*/
	private String cnt2;			/*조회기간 데이터*/
	private String cnt3;			/*조회기간 권한*/
	private String cnt4;			/*조회기간 기타*/
	private String cnt_tot;			/*조회기간 합계*/
	private String ncnt1;			/*누적 프로그램*/
	private String ncnt2;			/*누적 데이터*/
	private String ncnt3;			/*누적 권한*/
	private String ncnt4;			/*누적 기타*/
	private String ncnt_tot;		/*누적 합계*/	
	private int rowCnt;				/*전체 게시물 수*/
	
	
	public String getRnum() {
		return rnum;
	}
	public void setRnum(String rnum) {
		this.rnum = rnum;
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
	public String getJcnt1() {
		return jcnt1;
	}
	public void setJcnt1(String jcnt1) {
		this.jcnt1 = jcnt1;
	}
	public String getJcnt2() {
		return jcnt2;
	}
	public void setJcnt2(String jcnt2) {
		this.jcnt2 = jcnt2;
	}
	public String getJcnt3() {
		return jcnt3;
	}
	public void setJcnt3(String jcnt3) {
		this.jcnt3 = jcnt3;
	}
	public String getJcnt4() {
		return jcnt4;
	}
	public void setJcnt4(String jcnt4) {
		this.jcnt4 = jcnt4;
	}
	public String getJcnt_tot() {
		return jcnt_tot;
	}
	public void setJcnt_tot(String jcnt_tot) {
		this.jcnt_tot = jcnt_tot;
	}
	public String getCnt1() {
		return cnt1;
	}
	public void setCnt1(String cnt1) {
		this.cnt1 = cnt1;
	}
	public String getCnt2() {
		return cnt2;
	}
	public void setCnt2(String cnt2) {
		this.cnt2 = cnt2;
	}
	public String getCnt3() {
		return cnt3;
	}
	public void setCnt3(String cnt3) {
		this.cnt3 = cnt3;
	}
	public String getCnt4() {
		return cnt4;
	}
	public void setCnt4(String cnt4) {
		this.cnt4 = cnt4;
	}
	public String getCnt_tot() {
		return cnt_tot;
	}
	public void setCnt_tot(String cnt_tot) {
		this.cnt_tot = cnt_tot;
	}
	public String getNcnt1() {
		return ncnt1;
	}
	public void setNcnt1(String ncnt1) {
		this.ncnt1 = ncnt1;
	}
	public String getNcnt2() {
		return ncnt2;
	}
	public void setNcnt2(String ncnt2) {
		this.ncnt2 = ncnt2;
	}
	public String getNcnt3() {
		return ncnt3;
	}
	public void setNcnt3(String ncnt3) {
		this.ncnt3 = ncnt3;
	}
	public String getNcnt4() {
		return ncnt4;
	}
	public void setNcnt4(String ncnt4) {
		this.ncnt4 = ncnt4;
	}
	public String getNcnt_tot() {
		return ncnt_tot;
	}
	public void setNcnt_tot(String ncnt_tot) {
		this.ncnt_tot = ncnt_tot;
	}
	public int getRowCnt() {
		return rowCnt;
	}
	public void setRowCnt(int rowCnt) {
		this.rowCnt = rowCnt;
	}
	


	
	
}
