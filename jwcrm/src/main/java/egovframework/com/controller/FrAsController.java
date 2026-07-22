package egovframework.com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.service.AsService;
import egovframework.com.comm.dao.CommonDao;

/**
 * @Class Name : FrAsController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.09.08	정철구		           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class FrAsController {
	
	private static final Logger logger = LoggerFactory.getLogger(FrAsController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired AsService asService ;
	@Autowired CommonDao commonDao ;
	/**
	 * A/S 접수 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/form.do")
	public String form(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("weight",  "AF");
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		
		return "fr/as/form";
	}
	
	/**
	 * A/S 목록 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/list.do")
	public String list(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("weight",  "AL");
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/as/list";
	}
	

	/**
	 * A/S 등록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/proc.do")
	public String proc(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String script = "" ; 
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		if("C011".equals(SsStringUtil.normalizeNull(vo.getRequest_type()))) {
			vo.setService_cate("P010") ;
		}
		
		/**	입력 데이터 생성		*/
		vo.setAccept_dt(DateTimeUtil.getDate()) ;			/**	신청일자				*/
		vo.setAccept_time(DateTimeUtil.getTime());			/**	신청시간				*/
		vo.setAccept_route("C001");							/**	접수경로 - CRM			*/
		vo.setCust_code(userInfo.getCust_code());			/**	거래처 코드				*/
		vo.setApply_nm(userInfo.getEmp_name());				/**	접수자 명				*/
		vo.setApply_id(userInfo.getEmp_id());				/**	접수자 아이디			*/
		vo.setProc_status("C001");							/**	접수상태				*/		
		vo.setReg_id(userInfo.getEmp_id());					/**	접수자 id				*/
		vo.setCust_kor_name(userInfo.getCust_kor_name());	/**	병원명				*/
		
		List<FileVO> fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
		int returnValue = asService.insertAsInfo(vo, request, fileList) ;	
		
		if(returnValue > 0) script = "parent.procReturn('success', 'A/S신청이 완료되었습니다!\\n담당자가 자동 배정되었습니다.');" ;
		else script = "parent.procReturn('fail', '비정상적으로 처리 되었습니다.');" ;
		
		return CommonExecute.execute(model, script);
	}
	
	/**
	 * A/S 수정
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/procLayer.do")
	public String procLayer(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String script = "" ; 
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		
		vo.setReg_id(userInfo.getEmp_id());					/**	접수자 id				*/
		
		List<FileVO> fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
		int returnValue = asService.updateAsLayer(vo, request, fileList) ;	
		
		if(returnValue > 0) script = "parent.procReturn('success', '정상적으로 처리 되었습니다.');" ;
		else script = "parent.procReturn('fail', '비정상적으로 처리 되었습니다.');" ;
		
		return CommonExecute.execute(model, script);
	}
	
	/**
	 * A/S - 연락처 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/getEmpTelList.do")
	public void getEmpTelList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		vo.setCust_code(userInfo.getCust_code());
		
		returnMap.put("asDamTel", asService.getSelectInfo(vo, "asDAO.getEmpTel")) ;
		returnMap.put("asMyTel", SsStringUtil.normalizeNull(userInfo.getTel_no())) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * A/S - 목록 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/getAsList.do")
	public void getAsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
		vo.setCust_code(userInfo.getCust_code());
		int totalCount = asService.getTotalCnt(vo,"asDAO.getAsFrListCnt") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			vo.setJson_paging(vo.getJsonPaging("goList"));
			returnMap.put("resultList", asService.getList(vo,"asDAO.getAsFrList")) ;
			returnMap.put("vo",vo);
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * A/S - 목록 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/registAs.do")
	public void registAs(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ; 
		String returnCode = "" ; 
		String script ="";
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()) ;
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_id());
		
		//List<FileVO> fileList = commonFileService.uploadFormFile(multiRequest, "as_answer") ;
		
		
		if("changeStatus".equals(pageType)) returnValue = asService.registChangeStatus(vo) ;		/**	철회처리		*/  
		else if("starUpdate".equals(pageType)) returnValue = asService.registChangeStar(vo) ;		/**	철회처리		*/  
		//else if("insertContent".equals(pageType)) returnValue = asService.registContents(vo, request, fileList) ;		/**	답변내역 등록	*/  
		else if("delComment".equals(pageType)) returnValue = asService.registDelContents(vo) ;	/**	답변내역 삭제	*/  
		
		
		if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
		
		
		if("insertContent".equals(pageType)) {
			if(returnValue > 0) script = "parent.aswProcReturn('success', '정상적으로 처리 되었습니다.');" ;
			else script = "parent.aswProcReturn('fail', '비정상적으로 처리 되었습니다.');" ;
		  CommonExecute.execute(model, script);
		}
		
		returnMap.put("returnCode", returnCode) ; 
		returnMap.put("pageType", pageType) ; 
		CommonExecute.returnJson(response, returnMap);
		
		
		
	}
	
	
	
	/**
	 * A/S - 답변
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/aswRegistAs.do")
	public String aswRegistAs(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ; 
		String returnCode = "" ; 
		String script ="";
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()) ;
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_id());
		
		List<FileVO> fileList = commonFileService.uploadFormFile(multiRequest, "as_answer") ;
		
		
		if("insertContent".equals(pageType)) returnValue = asService.registContents(vo, request, fileList) ;		/**	답변내역 등록	*/  
		
		
		if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
		
		
		if("insertContent".equals(pageType)) {
			if(returnValue > 0) script = "parent.aswProcReturn('success', '정상적으로 처리 되었습니다.');" ;
			else script = "parent.aswProcReturn('fail', '비정상적으로 처리 되었습니다.');" ;
		  
		}
		return CommonExecute.execute(model, script);
	}
	
	
	/**
	 * A/S - 미처리 A/S조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
		@RequestMapping(value = "/fr/as/getUnprocessedAsList.do")
		public void getAnswerListbyRecent(@RequestParam("user_id") String user_id, @RequestParam("asGubunFlag") String asGubunFlag,@RequestParam("cust_code") String cust_code,@RequestParam("as_str_dt") String as_str_dt,@RequestParam("as_end_dt") String as_end_dt,@RequestParam("search_text") String search_text, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
			
			Map<String , Object> returnMap = new HashMap<String , Object>() ;
			
			HashMap<String,String> param = new HashMap<String, String>();
			param.put("cust_code", cust_code);
			param.put("as_str_dt", as_str_dt.replaceAll("/", ""));
			param.put("as_end_dt", as_end_dt.replaceAll("/", ""));
			param.put("asGubunFlag", asGubunFlag);
			param.put("user_id", user_id);
			param.put("search_text", search_text);
			
			
			returnMap.put("resultList", commonDao.list(param, "asDAO.getUnprocessedAsList"));
			CommonExecute.returnJson(response, returnMap);
		}

	/**
	 * A/S - 고객평가 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/getStarInfo.do")
	public void getStarInfo(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		returnMap.put("resultVO", asService.getSelectInfo(vo, "asDAO.getStarInfo")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * A/S - 기본 정보
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/getAsInfo.do")
	public void getAsInfo(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		int totalCount = asService.getTotalCnt(vo, "asDAO.getAwsListCnt") ;
		AsVO resultVO = asService.getSelectInfo(vo, "asDAO.getAsInfo") ;
		
		returnMap.put("resultVO", resultVO) ;
		
		if(resultVO != null) {
			FileVO fileVO = new FileVO() ; 
			if(!"0".equals(SsStringUtil.normalize(resultVO.getFile_seq(), "0"))) {
				fileVO.setAttach_seq(Integer.parseInt(resultVO.getFile_seq()));
				returnMap.put("attachList", commonFileService.getFileList(fileVO)) ; 
			}
			
			//returnMap.put("resultList", asService.getList(vo, "asDAO.getAwsList") ) ;
			resultList = asService.getList(vo, "asDAO.getAwsList");
			for(int i = 0;  i < totalCount; i++) {
				if(resultList != null) {
					
					Map<String , Object> returnMap1 = new HashMap<String , Object>() ;
					FileVO fileVO2 = new FileVO() ; 
					if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getAttach_seq(), "0"))) {
						fileVO2.setAttach_seq(resultList.get(i).getAttach_seq());
						returnMap1.put("attachList", commonFileService.getFileList(fileVO2)) ; 
						resultList.get(i).setAmap(returnMap1);
					}
				}
				 
			}  //
			returnMap.put("resultList", resultList) ;
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 배정구분 및 2차분류구분 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/getTaskType.do")
	public void getTaskType(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		AsVO resultList = null ;
		
		resultList = asService.getOneList(vo,"asDAO.getTaskType") ;
		
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo",vo);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 배정담당자(처리담당자) 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/as/getWorker.do")
	public void getWorker(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		AsVO resultList = null ;
		
		resultList = asService.getOneList(vo,"asDAO.getWorker") ;
		
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo",vo);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
}




