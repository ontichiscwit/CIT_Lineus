package egovframework.com.comm.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.comm.model.FileVO;



public interface CommonExlService {
	public List<HashMap<String, Object>> getExlReadList(FileVO vo) throws Exception ;
}
