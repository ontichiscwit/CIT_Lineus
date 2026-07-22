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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.OperateVO;
import egovframework.com.model.CustVO;
import egovframework.com.service.AsService;
import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.CommonCodeVO;


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
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
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
		
		/**거래처-승인프로세스여부확인 (문의유형)*/
		CustVO temp1 = new CustVO();
		CustVO temp2 = new CustVO();
		UserVO temp3 = new UserVO();
		
		CommonCodeVO codevo = new CommonCodeVO();
		
		codevo.setP_code("CD03");
		codevo.setCode(vo.getRequest_type());
		codevo.setCust_code(userInfo.getCust_code());
		
		//거래처 AS 승인 프로세스 사용여부
		temp1 = (CustVO) commonDao.selectOne( codevo, "custDAO.selectIsAsApproval1");
		//문의 유형에 따른 승인 프로세스 사용여부
		temp2 = (CustVO) commonDao.selectOne( codevo, "custDAO.selectIsAsApproval2");
		//AS 신청자 결재자 권한 확인(결재인 경우 처리 상태는 '승인대기'가 아닌 '접속')
		temp3 = (UserVO) commonDao.selectOne( userInfo.getEmp_id(), "custDAO.selectIsAsApproval3");
		
		
		int IS_APPROVAL = 0;
		if("C001".equals(SsStringUtil.normalizeNull(temp1.getAs_approval_yn())) && Integer.parseInt(temp2.getCnt()) > 0 && "C002".equals(SsStringUtil.normalizeNull(temp3.getApproval_auth())) ) {
			vo.setProc_status("C007");
			IS_APPROVAL = 1; 
		}else{ vo.setProc_status("C000");}
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))) vo.setProc_dt(vo.getProc_dt().replaceAll("/", "")) ;		/**	처리예정일*/
											
		/**	입력 데이터 생성		*/
		vo.setAccept_dt(DateTimeUtil.getDate()) ;			/**	신청일자*/
		vo.setAccept_time(DateTimeUtil.getTime());			/**	신청시간*/
		vo.setAccept_route("C001");							/**	접수경로 - CRM*/
		vo.setCust_code(userInfo.getCust_code());			/**	거래처 코드*/
		vo.setApply_nm(userInfo.getEmp_name());				/**	접수자 명*/
		vo.setApply_id(userInfo.getEmp_id());				/**	접수자 아이디*/
		vo.setReg_id(userInfo.getEmp_id());					/**	접수자 id*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getInquiry_dt()))) vo.setInquiry_dt(vo.getInquiry_dt().replaceAll("/", "")) ;
		
		List<FileVO> fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
		
		String allowedExtensions = "bmp, zip, tar, gz, bz2, rar, alz, ace, txt, png, jpeg, jpg, gif, pdf, ppt, pptx, csv, xls, xlsx, doc, docx, hwp";
		
		long maxSize = 100 * 1024 * 1024; // 100MB
		
	    for (FileVO file : fileList) {
	    	double fileSizeMB = (double) file.getFile_size() / (1024 * 1024);
	    	
	    	long fileSize = file.getFile_size(); // FileVO에 저장된 파일 사이즈
	        if (fileSize > maxSize) {
	        	script = "alert('파일 크기가 100MB를 초과하였습니다: " + String.format("%.2f", fileSizeMB) + "MB\\n허용된 용량은 100MB 입니다.');";
	            return CommonExecute.execute(model, script);
	        }
	    	
	        String fileName = file.getAttach_ori_nm();
	        if (fileName != null && fileName.contains(".")) {
	            String ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
	            if (!allowedExtensions.contains(ext)) {
	            	script = "alert('허용되지 않은 파일 확장자입니다: " + ext + "\\n허용된 확장자: " + allowedExtensions + "');";
	                return CommonExecute.execute(model, script);
	            }
	        } else {
	        	script = "alert('파일에 확장자가 없습니다: " + fileName + "\\n허용된 확장자: " + allowedExtensions + "');";
	            return CommonExecute.execute(model, script);
	        }
	    }
		
		int returnValue = asService.insertAsInfo(vo, request, fileList) ;	
		
		if (returnValue > 0 && IS_APPROVAL == 1 ) { script = "parent.procReturn('success', '정상적으로 처리 되었습니다. 결재자로부터 승인이 필요합니다.');" ;}
		else if (returnValue > 0 && IS_APPROVAL == 0 ) { script = "parent.procReturn('success', '정상적으로 처리 되었습니다.');" ;}
		else {script = "parent.procReturn('fail', '비정상적으로 처리 되었습니다.');" ;}
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
		int returnValue = 0;
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()) ;
		
		vo.setReg_id(userInfo.getEmp_id());					/**	접수자 id*/
		
		if("layerApproval".equals(pageType)) {
			
			returnValue = asService.updateAsApproval(vo, request) ;
		}else {
			List<FileVO> fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
			returnValue = asService.updateAsLayer(vo, request, fileList) ;
		}
		
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
		returnMap.put("asMyCpTel", SsStringUtil.normalizeNull(userInfo.getCompany_no())) ;
		returnMap.put("asMyEmail", SsStringUtil.normalizeNull(userInfo.getEmail())) ;
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
		
		//신청자 본인 공란 건(CIT에서 직접등록건중 일부)으로 인한 조회누락발생!! 김종호 부장님 요청으로 주석처리 2021.01.11.
		//고객사 신청자 본인 AS신청현황만 조회되도록 추가 cmg제약 인사담당자 서영웅주임 요청 2020.12.01. 
		//vo.setApply_id(userInfo.getEmp_id());
		
		vo.setLogin_id(userInfo.getEmp_id());			//CITMASTER
		vo.setLogin_grade(userInfo.getEmp_grade());		//C001
		vo.setLogin_name(userInfo.getEmp_name()); 		//(주)중외정보기술
		
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
	 * A/S - 시스템유형조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/cust/getSystemInfo.do")
	public void getSystemInfo(@ModelAttribute("vo") OperateVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDao.list(vo, "custDAO.selectSystemInfoBySeq"));
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * A/S - 시스템이름
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/cust/getSystemName.do")
	public void getSystemName(@ModelAttribute("vo") OperateVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("vo", commonDao.list(vo, "custDAO.selectSystemNameBySeq"));
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * A/S - 운영 유형 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/operate/getOperTask.do")
	public void getOperTask(@ModelAttribute("vo") OperateVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		
		returnMap.put("resultList", commonDao.list(vo, "custDAO.getOperTasks"));
		
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
			
			if(!"0".equals(SsStringUtil.normalize(resultVO.getAttach_seq2(), "0"))) {
				fileVO.setAttach_seq(resultVO.getAttach_seq2());
				returnMap.put("attachList2", commonFileService.getFileList(fileVO)) ; 
			}
			
			
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
				 
			} 
			returnMap.put("resultList", resultList) ;
		}
		CommonExecute.returnJson(response, returnMap);
	}
}




