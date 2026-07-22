package egovframework.com.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.comm.model.Code2VO;
import egovframework.com.comm.model.FileVO;
import egovframework.com.model.AsVO;

/**
 * @Class Name : ApiAsService.java
 * @
 * @  수정일      	                      수정자                       수정내용
 * @ ---------   	---------   -------------------------------
 * @ 2019.05.28		CMC11	 	First create
 *
 * @author CMC11
 * @since 2019.05.28	
 * @version 1.0
 * @see
 *
 *  Copyright (C) by CMC All right reserved.
 */

public interface ApiAsService {
	
	/**
	 * A/S 접수, 처리정보
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<AsVO> getListProcessInfo(AsVO vo) throws Exception;
	
	/**
	 * 조치 이력정보
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<AsVO> getListProcessHistInfo(AsVO vo) throws Exception;
	
	
	/**
	 * 처리정보 이력
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<AsVO> getActionHistInfo(AsVO vo) throws Exception;
	
	
	/**
	 * 답변
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<AsVO> getListAnswerInfo(AsVO vo) throws Exception;
	
	
	/**
	 * 처리상태 코드
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<Code2VO> getListProcessStatus(Code2VO vo) throws Exception;

	/**
	 * 원인유형 코드
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<Code2VO> getListCauseType(Code2VO vo) throws Exception;

	/**
	 * 조치유형 코드
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<Code2VO> getListActionType(Code2VO vo) throws Exception;
	
	/**
	 * 중요도 코드
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<Code2VO> getListPriorityProcessStatus(Code2VO vo) throws Exception;
	
	/**
	 * 처리상태 업데이트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	//public int updateProcessStatus(AsVO vo) throws Exception; 
	
	
	public int updateAsInfo(AsVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	
	
	/**
	 * 조치내용 첨부파일 존재여부
	 * 
	 * 
	 */
	 
	public int getAttach2(AsVO vo) throws Exception;
	 
	
	
	
}
