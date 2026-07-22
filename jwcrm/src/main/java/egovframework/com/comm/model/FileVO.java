package egovframework.com.comm.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import egovframework.com.model.CommonVO;

@Alias("fileVO")
public class FileVO extends CommonVO implements Serializable{
	private static final long serialVersionUID = 2685732238364717218L;
	
	private String attach_tag_name ;
	private int max_seq = 0 ;
	
	public String getAttach_tag_name() {
		return attach_tag_name;
	}
	public void setAttach_tag_name(String attach_tag_name) {
		this.attach_tag_name = attach_tag_name;
	}
	public int getMax_seq() {
		return max_seq;
	}
	public void setMax_seq(int max_seq) {
		this.max_seq = max_seq;
	} 
	
	
}
