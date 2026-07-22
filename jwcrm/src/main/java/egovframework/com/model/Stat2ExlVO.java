package egovframework.com.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.controller.AdCustController;

public class Stat2ExlVO implements Serializable {
	private static final Logger logger = LoggerFactory.getLogger(AdCustController.class) ;
	
	private static final long serialVersionUID = -6783361604436122697L;
	
	private List<Map<String,String>> headerList;
	private List<Map<String,String>> dataList;
	public List<Map<String, String>> getHeaderList() {
		return headerList;
	}
	public void setHeaderList(List<Map<String, String>> headerList) {
		this.headerList = headerList;
	}
	public List<Map<String, String>> getDataList() {
		return dataList;
	}
	public void setDataList(List<Map<String, String>> dataList) {
		this.dataList = dataList;
	}
}
