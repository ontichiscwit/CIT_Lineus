package egovframework.com.comm.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.model.CommonVO;

@Alias("partsVO")
public class PartsVO extends PagingVO implements Serializable{
	private static final long serialVersionUID = -7030846024891158125L;
	
	private String gubun1 = "" ; 
	private String gubun2 = "" ; 
	private String gubun3 = "" ; 
	private String gubun4 = "" ; 
	private String val1 = "" ; 
	private String val2 = "" ; 
	private String val3 = "" ; 
	private String val4 = "" ;
	private String seq = "" ;
	
	
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	
	public String getGubun1() {
		return gubun1;
	}
	public void setGubun1(String gubun1) {
		this.gubun1 = gubun1;
	}
	public String getGubun2() {
		return gubun2;
	}
	public void setGubun2(String gubun2) {
		this.gubun2 = gubun2;
	}
	public String getGubun3() {
		return gubun3;
	}
	public void setGubun3(String gubun3) {
		this.gubun3 = gubun3;
	}
	public String getGubun4() {
		return gubun4;
	}
	public void setGubun4(String gubun4) {
		this.gubun4 = gubun4;
	}
	public String getVal1() {
		return val1;
	}
	public void setVal1(String val1) {
		this.val1 = val1;
	}
	public String getVal2() {
		return val2;
	}
	public void setVal2(String val2) {
		this.val2 = val2;
	}
	public String getVal3() {
		return val3;
	}
	public void setVal3(String val3) {
		this.val3 = val3;
	}
	public String getVal4() {
		return val4;
	}
	public void setVal4(String val4) {
		this.val4 = val4;
	} 
	 
	
	
}