package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("stat2VO")
public class Stat2VO implements Serializable {

	private static final long serialVersionUID = 8861432772804131655L;
	
	private String search_start;
	private String search_end;
	private String search_type;
	
	private String col_str;
	
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
	public String getSearch_type() {
		return search_type;
	}
	public void setSearch_type(String search_type) {
		this.search_type = search_type;
	}
	
	public String getCol_str() {
		return col_str;
	}
	public void setCol_str(String col_str) {
		this.col_str = col_str;
	}
	@Override
	public String toString() {
		return "Stat2VO [search_start=" + search_start + ", search_end=" + search_end + ", search_type=" + search_type + ", col_str=" + col_str + "]";
	}
	
	
	
}
