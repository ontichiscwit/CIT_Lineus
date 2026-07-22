package egovframework.com.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.model.Code2VO;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.service.ApiAsService;
import egovframework.com.service.AsService;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.service.LoginService;
import egovframework.com.comm.dao.CommonDao;

/**
 * @Class Name : ApiAsController.java
 * @
 * @  수정일      	   		수정자       		 수정내용
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

@RestController
public class ApiAsController {
	
	@Autowired ApiAsService apiAsService;
	@Autowired AsService asService;
	@Autowired CommonFileService commonFileService;
	@Autowired LoginService loginService;
	@Autowired CommonDao commonDAO;
	
	
	
	/**
	 * 로그인
	 * http://localhost:8080/api/procLogin.do
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/procLogin.do", method = RequestMethod.POST) 
	public Map<String , Object> procLogin(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		UserVO userInfo = (UserVO) commonDAO.selectOne(vo, "apiAsDAO.selectUserInfo");
		
		if(userInfo != null ){
			if("N".equals(SsStringUtil.normalizeNull(userInfo.getUse_yn()))) {returnMap.put("returnFlag" , "002"); } /**	사용할수 없는 아이디 입니다.	*/
			else{
				
				HttpSession session = request.getSession(); 
				session.setAttribute("adUserInfo", userInfo);
				System.out.println(session.getAttribute("adUserInfo"));
				
				returnMap.put("vo",userInfo);
				returnMap.put("returnFlag" , "000");}/**	정상 처리	*/
				
		}else {
			returnMap.put("returnFlag" , "001"); /** 아이디, 비밀번호 확인 */
		}
		return returnMap;
		
	}
	
	
	/**
	 * A/S 접수, 처리정보
	 * http://localhost:8080/api/getListProcessInfo.do
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/getListProcessInfo.do", method = RequestMethod.POST) 
	public Map<String , Object> getListProcessInfo(@ModelAttribute("vo") AsVO vo) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		int count = 0;
		
		resultList = apiAsService.getListProcessInfo(vo) ;
		
		for(int i =0 ; i < resultList.size() ; i++) {
			if(resultList != null) {
				Map<String , Object> returnMap1 = new HashMap<String , Object>() ;
				Map<String , Object> returnMap2 = new HashMap<String , Object>() ;
				
				
				FileVO fileVO = new FileVO() ; 
				FileVO fileVO2 = new FileVO() ; 
				
				
				if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getFile_seq(), "0"))) {
					fileVO.setAttach_seq(Integer.parseInt(resultList.get(i).getFile_seq()));
					returnMap1.put("attachList", commonFileService.getFileList(fileVO)) ; 
					resultList.get(i).setAttach_list1(returnMap1);
				}
				
				if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getAttach_seq2(), "0"))) {
					fileVO2.setAttach_seq(resultList.get(i).getAttach_seq2());
					returnMap2.put("attachList", commonFileService.getFileList(fileVO2)) ; 
					resultList.get(i).setAttach_list2(returnMap2);
				}
				
				
				//조치 내용 첨부파일 유무
				count = apiAsService.getAttach2(resultList.get(i)) ;
				if(count > 0) {resultList.get(i).setAttach2_flag("1");}else {resultList.get(i).setAttach2_flag("0");}
				
				
				//답변내역리스트
				@SuppressWarnings("unchecked")
				List<AsVO> answerList = (List<AsVO>) commonDAO.list( resultList.get(i).getAs_no(), "asDAO.getAwsList");
				Map<String , Object> returnMap3 = new HashMap<String , Object>() ;
				for(int answerCnt = 0 ;  answerCnt < answerList.size() ; answerCnt++) {
					Map<String , Object> fileMap = new HashMap<String , Object>() ;
					FileVO emfileVO = new FileVO() ; 
					int is_File = 0;
					//답변내 파일 리스트
					if(!"0".equals(SsStringUtil.normalize(answerList.get(answerCnt).getAttach_seq(), "0"))) {
						is_File = 1;
						emfileVO.setAttach_seq(answerList.get(answerCnt).getAttach_seq());
						fileMap.put("attachList", commonFileService.getFileList(emfileVO)) ; 
						answerList.get(answerCnt).setAttach_list3(fileMap);
					}
					if(is_File == 1) {answerList.get(answerCnt).setAttach3_flag("1");}else {answerList.get(answerCnt).setAttach3_flag("0");}
				}
				
				
				returnMap3.put("answerList" ,answerList);
				resultList.get(i).setAnswer_list(returnMap3);	
			}
		}
		
		
		returnMap.put("resultList", resultList) ;
		
		return returnMap;
		
	}
	
	/**
	 * 조치 이력정보
	 * http://localhost:8080/api/getListProcessHistInfo.do
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/getListProcessHistInfo.do", method = RequestMethod.POST) 
	public Map<String , Object> getListProcessHistInfo(@ModelAttribute("vo") AsVO vo) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		int count = 0 ;
		
		
		resultList = apiAsService.getListProcessHistInfo(vo) ;
		
		for(int i =0 ; i < resultList.size() ; i++) {
			if(resultList != null) {
				Map<String , Object> returnMap1 = new HashMap<String , Object>() ;
				Map<String , Object> returnMap2 = new HashMap<String , Object>() ;
				FileVO fileVO = new FileVO() ; 
				FileVO fileVO2 = new FileVO() ; 
				
				if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getFile_seq(), "0"))) {
					fileVO.setAttach_seq(Integer.parseInt(resultList.get(i).getFile_seq()));
					returnMap1.put("attachList", commonFileService.getFileList(fileVO)) ; 
					resultList.get(i).setAttach_list1(returnMap1);
				}
				
				if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getAttach_seq2(), "0"))) {
					fileVO2.setAttach_seq(resultList.get(i).getAttach_seq2());
					returnMap2.put("attachList", commonFileService.getFileList(fileVO2)) ; 
					resultList.get(i).setAttach_list2(returnMap2);
				}
				
				//조치 내용 첨부파일 유무
				count = apiAsService.getAttach2(resultList.get(i)) ;
				if(count > 0) {resultList.get(i).setAttach2_flag("1");}else {resultList.get(i).setAttach2_flag("0");}
				
				//답변내역리스트
				@SuppressWarnings("unchecked")
				List<AsVO> answerList = (List<AsVO>) commonDAO.list( resultList.get(i).getAs_no(), "asDAO.getAwsList");
				Map<String , Object> returnMap3 = new HashMap<String , Object>() ;
				for(int answerCnt = 0 ;  answerCnt < answerList.size() ; answerCnt++) {
					Map<String , Object> fileMap = new HashMap<String , Object>() ;
					FileVO emfileVO = new FileVO() ; 
					int is_File = 0;
					//답변내 파일 리스트
					if(!"0".equals(SsStringUtil.normalize(answerList.get(answerCnt).getAttach_seq(), "0"))) {
						is_File = 1;
						emfileVO.setAttach_seq(answerList.get(answerCnt).getAttach_seq());
						fileMap.put("attachList", commonFileService.getFileList(emfileVO)) ; 
						answerList.get(answerCnt).setAttach_list3(fileMap);
					}
					if(is_File == 1) {answerList.get(answerCnt).setAttach3_flag("1");}else {answerList.get(answerCnt).setAttach3_flag("0");}
				}
				
				
				returnMap3.put("answerList" ,answerList);
				resultList.get(i).setAnswer_list(returnMap3);
			}
		}
		
		returnMap.put("resultList", resultList) ;
		return returnMap;
	}
	
	
	
	/**
	 * 조치이력정보
	 * http://localhost:8080/api/getActionHistInfo.do
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/getActionHistInfo.do", method = RequestMethod.POST) 
	public Map<String , Object> getActionHistInfo(@ModelAttribute("vo") AsVO vo) throws Exception {
		
		Map<String, Object> returnMap= new HashMap<String,Object>();
		
		//조치이력 내역  List
		List<AsVO> resultList  = apiAsService.getActionHistInfo(vo) ;
		if(resultList != null) {
			for(int i = 0 ; i < resultList.size(); i ++) {
				Map<String , Object> fileMap = new HashMap<String , Object>() ;
				FileVO fileVO = new FileVO() ;
				if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getFile_seq(), "0"))) {
					fileVO.setAttach_seq(Integer.parseInt(resultList.get(i).getFile_seq()));
					fileMap.put("attachList", commonFileService.getFileList(fileVO)) ; 
					resultList.get(i).setAttach_list1(fileMap);
				}
			}
		}
		returnMap.put("actionHistList" ,resultList);
		
		//답변내역 List
		List<AsVO> answerList = apiAsService.getListAnswerInfo(vo) ;
		for(int i = 0 ;  i < answerList.size() ; i++) {
			Map<String , Object> fileMap = new HashMap<String , Object>() ;
			FileVO emfileVO = new FileVO() ; 
			if(!"0".equals(SsStringUtil.normalize(answerList.get(i).getAttach_seq(), "0"))) {
				emfileVO.setAttach_seq(answerList.get(i).getAttach_seq());
				fileMap.put("attachList", commonFileService.getFileList(emfileVO)) ; 
				answerList.get(i).setAttach_list3(fileMap);
			}
		}
		
		returnMap.put("answerList" ,answerList);
		
		return returnMap;
		
	}
	
	
	
	/**
	 * 처리상태 코드
	 * http://localhost:8080/api/getListProcessStatus.do
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/getListProcessStatus.do", method = RequestMethod.POST) 
	public Map<String , Object> getListProcessStatus() throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<Code2VO> resultList = null ;
		resultList = apiAsService.getListProcessStatus(null) ;
		returnMap.put("resultList", resultList) ;
		return returnMap;
	}
	
	/**
	 * 원인유형 코드
	 * http://localhost:8080/api/getListCauseType.do
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/getListCauseType.do", method = RequestMethod.POST) 
	public Map<String , Object> getListCauseType() throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<Code2VO> resultList = null ;
		resultList = apiAsService.getListCauseType(null) ;
		returnMap.put("resultList", resultList) ;
		return returnMap;
	}
	
	/**
	 * 조치유형 코드
	 * http://localhost:8080/api/getListActionType.do
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/getListActionType.do", method = RequestMethod.POST) 
	public Map<String , Object> getListActionType() throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<Code2VO> resultList = null ;
		resultList = apiAsService.getListActionType(null) ;
		returnMap.put("resultList", resultList) ;
		return returnMap;
	}
	
	/**
	 * 중요도 코드
	 * http://localhost:8080/api/getListPriorityProcessStatus.do
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/getListPriorityProcessStatus.do", method = RequestMethod.POST) 
	public Map<String , Object> getListPriorityProcessStatus() throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<Code2VO> resultList = null ;
		resultList = apiAsService.getListPriorityProcessStatus(null) ;
		returnMap.put("resultList", resultList) ;
		return returnMap;
	}
	
	/**
	 * 처리상태 업데이트
	 * http://localhost:8080/api/updateProcessStatus.do
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/api/updateProcessStatus.do") 
	public void updateProcessStatus(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<FileVO> fileList = null ;
		List<AsVO> resultList = null ;
		String script = "" ;
		int returnValue = 0 ;
		
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ;
		if(!"delete".equals(pageType)) {
			fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
		}
		
		
		vo.setReg_id(vo.getAssign_id());
		
		/* 하위작업 등록을 할때 */
		if (pageType.startsWith("sub")) {
			
			AsVO tempVO = new AsVO();
			if("subUpdate".equals(pageType)) {
				tempVO.setAs_no(vo.getAs_no());				/**	cn_as_no	*/
				tempVO.setCn_as_no(vo.getCn_as_no());	/**	as_no		*/
				tempVO.setSearch_type1("selfExcept");
			}else {
				tempVO.setAs_no(vo.getAs_no());			/**	cn_as_no	*/
			}
			
			resultList = asService.getList(tempVO, "asDAO.getCnAsList") ;
			
			String statusArray[] = new String[resultList.size()+1];
			statusArray[0] = vo.getProc_status();
			
			if (resultList != null && resultList.size()>0) {
				for (int i=0; i<resultList.size(); i++) {
					AsVO temp = resultList.get(i) ; 
					statusArray[i+1]  = temp.getProc_status();
				}
			}
			
			if(Arrays.asList(statusArray).contains("C002")){ 
				if(Arrays.asList(statusArray).contains("C004")) tempVO.setProc_status("C004");
				else tempVO.setProc_status("C002");
			}else if(Arrays.asList(statusArray).contains("C003")){
				if(Arrays.asList(statusArray).contains("C004")) tempVO.setProc_status("C004");
				else tempVO.setProc_status("C003");
			}else if(Arrays.asList(statusArray).contains("C004")){
				tempVO.setProc_status("C004");
			}else if(Arrays.asList(statusArray).contains("C005")){
				tempVO.setProc_status("C005");
			} else {
				tempVO.setProc_status(vo.getProc_status());
			}
			
			/* 원건 상태값 업데이트 (1건이라도 있을때) */
			vo.setProc_status2(tempVO.getProc_status());
			vo.setAs_no2(vo.getAs_no());
			
		}
		
		
		if ("update".equals(pageType)) returnValue = apiAsService.updateAsInfo(vo, request, fileList) ;
		//else if ("subUpdate".equals(pageType)) returnValue = asService.updateAsCnInfo(vo, request, fileList) ;
		
		if(returnValue > 0) script = "parent.procReturn('success');" ;
		else script = "parent.procReturn('fail');" ;
		if(returnValue > 0) {returnMap.put("result", "success") ;}else{returnMap.put("result", "fail") ;}
		
		
		CommonExecute.returnJson(response, returnMap);
		
	}
	
	
    @RequestMapping(value = "/api/asRegisterVoiceBot.do", method = RequestMethod.POST)
    public String asRegisterVoicebot(@RequestBody AsVO vo, HttpServletRequest request) {
    	int returnValue = 0 ;
    	try {
    		returnValue = asService.insertVoicebotAsInfo(vo, request);
    		
    		// 결과 처리
    		if (returnValue > 0) {
    			return "접수번호: " + vo.getAs_no() + "가 정상적으로 등록되었습니다.";
    		} else {
    			return "보이스봇 히스토리 테이블에 정상적으로 등록되었습니다.";
    		}
    	} catch (Exception e) {
    		return "오류 발생: " + e.getMessage();
    	}
    }
	
}
