package egovframework.com.comm.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.comm.model.CommonCodeVO;
import egovframework.com.comm.model.FileVO;
import egovframework.com.model.AsVO;


public interface CommonCodeService {
	public List<CommonCodeVO> getCodeList(CommonCodeVO vo) throws Exception ;
	public List<CommonCodeVO> getList(CommonCodeVO vo, String query) throws Exception;
	public CommonCodeVO getCodeNm(CommonCodeVO vo) throws Exception ;
	
	public int registCodeInfo(CommonCodeVO vo , HttpServletRequest request) throws Exception ;
}
