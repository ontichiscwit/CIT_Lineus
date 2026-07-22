package egovframework.com.service.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.Code2VO;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.service.ApiAsService;

/**
 * @Class Name : ApiAsServiceImpl.java
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

@Service("apiAsService")	
public class ApiAsServiceImpl implements ApiAsService {
	@Autowired CommonDao commonDAO;
	@Autowired CommonFileService commonFileService ;
	@Autowired CommonSmsService commonSmsService ;

	
	/**
	 * A/S 접수, 처리정보
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<AsVO> getListProcessInfo(AsVO vo) throws Exception {
		return (List<AsVO>) commonDAO.list(vo, "apiAsDAO.getListProcessInfo");
	}

	/**
	 * 조치 이력정보
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<AsVO> getListProcessHistInfo(AsVO vo) throws Exception {
		return (List<AsVO>) commonDAO.list(vo, "apiAsDAO.getListProcessHistInfo");
	}

	
	/**
	 * 처리 이력정보
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<AsVO> getActionHistInfo(AsVO vo) throws Exception {
		return (List<AsVO>) commonDAO.list(vo, "apiAsDAO.getActionHistInfo");
	}

	
	
	/**
	 * 처리 이력정보
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<AsVO> getListAnswerInfo(AsVO vo) throws Exception {
		return (List<AsVO>) commonDAO.list(vo, "asDAO.getAwsList");
	}
	
	/**
	 * 처리상태 코드
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Code2VO> getListProcessStatus(Code2VO vo) throws Exception {
		return (List<Code2VO>) commonDAO.list(vo, "apiAsDAO.getListProcessStatus");
	}

	/**
	 * 원인유형 코드
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Code2VO> getListCauseType(Code2VO vo) throws Exception {
		return (List<Code2VO>) commonDAO.list(vo, "apiAsDAO.getListCauseType");
	}

	/**
	 * 조치유형 코드
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Code2VO> getListActionType(Code2VO vo) throws Exception {
		return (List<Code2VO>) commonDAO.list(vo, "apiAsDAO.getListActionType");
	}

	/**
	 * 중요도 코드
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Code2VO> getListPriorityProcessStatus(Code2VO vo) throws Exception {
		return (List<Code2VO>) commonDAO.list(vo, "apiAsDAO.getListPriorityProcessStatus");
	}

	/**
	 * 처리상태 업데이트
	 */
	/*@Override
	public int updateProcessStatus(AsVO vo) throws Exception {
		return commonDAO.update(vo, "apiAsDAO.updateProcessStatus");
	}*/
	
	
	@Override
	public int updateAsInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		
		int returnValue = 0;
		int attach_seq = 0 ; 
		int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0")) ; 
		int attach_seq2 = vo.getAttach_seq2() ;    
		
		boolean flag_attach_2 = false ; 
		String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1()) ; 
		
		if(file_seq > 0) {
			if(!"".equals(delAttach1)) {
				String[] del_attach_seq = delAttach1.split("@") ; 
				
				if(del_attach_seq != null && del_attach_seq.length > 0) {
					for(String temp : del_attach_seq) {
						FileVO fileVO = new FileVO() ; 
						
						fileVO.setAttach_seq(file_seq);
						fileVO.setAttach_ord(Integer.parseInt(temp));
						
						commonFileService.deleteFileInfo(fileVO);
					}
				}
			}
		}
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile_")){
					if(file_seq == 0) file_seq = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(file_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				}else if(temp.getAttach_tag_name().startsWith("upFile_")){
					if(attach_seq2  == 0) attach_seq2 = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
					flag_attach_2 = true ; 
				}
				
			}
		}
		
		vo.setFile_seq(String.valueOf(file_seq));
		vo.setAttach_seq2(attach_seq2) ;
		
		returnValue = commonDAO.update(vo, "apiAsDAO.updateAsInfo");
		
		//답변 *once_flag Y 인 경우 조치 내역을 답변으로 동일하게 등록한다*
		if( "Y".equals(SsStringUtil.normalize(vo.getOnce_flag(),""))) {
			
			vo.setW_content(vo.getAction_content());
			
			if(fileList != null && fileList.size() > 0){
				for(FileVO temp : fileList){
					if(temp.getAttach_tag_name().startsWith("upFile_")){
						
						if(attach_seq  == 0){
							attach_seq = commonFileService.getMaxFileSeq() ;
							temp.setAttach_seq(attach_seq);
						}else{
							temp.setAttach_seq(attach_seq);
						}
						temp.setAttach_ord(commonFileService.getMaxFileOrd(temp));
						commonFileService.insertFile(temp);
					}
				}
				
				vo.setAttach_seq(attach_seq);
				
			}
			
			vo.setW_gubun("A");
			vo.setSeq(String.valueOf(commonDAO.selectOneInt(null, "asDAO.getAwsMaxSeq")));
			commonDAO.update(vo, "asDAO.insertAws");
			
		}
		
		if(returnValue > 0) {
			
			    if(!"".equals(SsStringUtil.normalizeNull(vo.getApply_id())) || !"".equals(SsStringUtil.normalizeNull(vo.getApply_tel()))) {
				if (!"".equals(vo.getChg_assign_id())) commonSmsService.sendSms("CD06", "C002", "0", vo.getApply_id() , vo.getApply_tel()) ;  /* A/S 담당자 배정 완료 */
				if (!"".equals(vo.getChg_assign_id()) && !vo.getChg_assign_id().equals(vo.getAssign_id())) commonSmsService.sendSms("CD06", "C003", "0", vo.getApply_id() , vo.getApply_tel()) ;  /* A/S 담당자 배정 중 (변경) */
				if ("C004".equals(vo.getProc_status())) commonSmsService.sendSms("CD06", "C004", "0", vo.getApply_id() , vo.getApply_tel()) ;  /* A/S 처리 중 */ 
				if ("C005".equals(vo.getProc_status())) commonSmsService.sendSms("CD06", "C005", "0", vo.getApply_id() , vo.getApply_tel()) ;  /* A/S 처리 완료 */
			}
			
			commonDAO.update(vo, "asDAO.updateCnAsState");
			
			boolean his_flag = false ;
			if(flag_attach_2) his_flag = true ; 
			
			if(!his_flag) {
				AsVO maxHisVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsHistMaxInfo") ; 
				
				if(maxHisVO != null) {
					if(!SsStringUtil.normalizeNull(vo.getProc_status()).equals(SsStringUtil.normalizeNull(maxHisVO.getProc_status()))) his_flag = true ;
					if(!SsStringUtil.normalizeNull(vo.getAction_content()).equals(SsStringUtil.normalizeNull(maxHisVO.getAction_content())) && !"".equals(SsStringUtil.normalizeNull(vo.getAction_content()))) his_flag = true ;
					
				}else {
					his_flag = true ;
				}
				
			}
			if(his_flag) {
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
		}
		
		return returnValue;
	}
	
	
	/**
	 * 조치 첨부파일
	 */
	@SuppressWarnings("unchecked")
	@Override
	public int getAttach2(AsVO vo) throws Exception {
		return (int) commonDAO.selectOneInt(vo, "apiAsDAO.getAttach2");
	}

}
