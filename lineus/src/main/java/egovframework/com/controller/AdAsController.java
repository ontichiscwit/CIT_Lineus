package egovframework.com.controller;

import java.io.OutputStream;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.quartz.Job;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.core.JobKeyGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sun.star.style.HorizontalAlignment;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.CommonCodeVO;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsStatsVo;
import egovframework.com.model.AsVO;
import egovframework.com.service.AsService;
import egovframework.com.service.AsStatsService;
import egovframework.com.service.LoginService;
/**
 * @Class Name : AdAsController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.05.25	정철구		           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2017. 09.07
 * @version 1.0
 * @see
 
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class AdAsController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdAsController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired LoginService loginService ; 
	@Autowired AsService asService ;
	@Autowired AsStatsService asStatsService ;
	@Autowired CommonDao commonDao ; 
	
	
	/**
	 * A/S 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/list.do")
	public String list(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
//		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
//		// 본인의 아이디가 crm_as_mgt.assign_id 에 포함되어 있으면 본인의 이름을 vo.emp_nm에 셋팅해준다.
//		if ("".equals(vo.getEmp_nm()) && adUserInfo != null){
//			logger.debug(adUserInfo.getEmp_id());
//			logger.debug(adUserInfo.getEmp_no());
//			if (asService.selectAsMgtCntByAssignId(adUserInfo.getEmp_no()) > 0){
//				vo.setEmp_nm(adUserInfo.getEmp_nm());
//			}
//		}
		
	
		return "ad/as/list";
	}
	
	/**
	 * A/S현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/list2.do")
	public String list2(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
			
		return "ad/as/list2";
	}
	
	/**
	 * A/S승인
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/list3.do")
	public String list3(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
			
		return "ad/as/list3";
	}
	
	/**
	 * 시스템별 A/S현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/list4.do")
	public String list4(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		return "ad/as/list4";
	}
	
	/**
	 * A/S 처리담당자 조회 
	 * @param request
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAssign.do")
	public void getCustListBySeq(@RequestParam("task_code") String task_code,@RequestParam("system_code") String system_code,@RequestParam("operate_seq") String operate_seq,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		logger.debug(task_code);
		logger.debug(system_code);
		logger.debug(operate_seq);
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("task_code", task_code);
		param.put("system_code", system_code);
		param.put("operate_seq", operate_seq);
		
		returnMap.put("resultList", commonDao.list(param, "asDAO.getAsAssign"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * A/S 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/form.do")
	public String form(@ModelAttribute("vo") AsVO vo, HttpServletRequest request) throws Exception {
		return "ad/as/form";
	}
	
	/**
	 * AS 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsList.do")
	public void getAsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start3()))) vo.setSearch_start3(vo.getSearch_start3().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end3()))) vo.setSearch_end3(vo.getSearch_end3().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start4()))) vo.setSearch_start4(vo.getSearch_start4().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end4()))) vo.setSearch_end4(vo.getSearch_end4().replaceAll("/", "")) ;

		String[] procSelectArray =  vo.getProcSelect().split(",");
		vo.setProcSelectArray(procSelectArray);
		int totalCount = asService.getTotalCnt(vo,"asDAO.getAsListCnt") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = asService.getList(vo,"asDAO.getAsList") ;
			vo.setJson_paging(vo.getJsonPaging("getAsList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
			
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * AS 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsList2.do")
	public void getAsList2(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		
		int totalCount = asService.getTotalCnt(vo,"asDAO.getAsListCnt2") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			System.out.println(vo.getSearch_type13());
			System.out.println(vo.getSearch_type12());
			resultList = asService.getList(vo,"asDAO.getAsList2") ;
			vo.setJson_paging(vo.getJsonPaging("getAsList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsApprList.do")
	public void getAsApprList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
	
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		int totalCount = asService.getTotalCnt(vo,"asDAO.getAsApprListCnt") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			System.out.println(vo.getSearch_type13());
			System.out.println(vo.getSearch_type12());
			resultList = asService.getList(vo,"asDAO.getAsApprList") ;
			vo.setJson_paging(vo.getJsonPaging("getAsList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 고객사 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsCustMaster.do")
	public void getCustMaster(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		asService.getAsCustInfo(vo) ; 
		returnMap.put("resultList", vo.getOUTCURSOR()) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * AS 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/proc.do")
	public String proc(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ; 
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ; 
		List<FileVO> fileList = null ;
		List<AsVO> resultList = null ;
		int returnValue = 0 ;
		String script = "" ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))) vo.setProc_dt(vo.getProc_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAccept_dt()))) vo.setAccept_dt(vo.getAccept_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAccept_time()))) vo.setAccept_time(vo.getAccept_time().replaceAll(":", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getInquiry_dt()))) vo.setInquiry_dt(vo.getInquiry_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getComplete_dt()))) vo.setComplete_dt(vo.getComplete_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getDistr_dt()))) vo.setDistr_dt(vo.getDistr_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getUser_test_dt()))) vo.setUser_test_dt(vo.getUser_test_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getApproval_time()))) vo.setApproval_time(vo.getApproval_time().replaceAll(":", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getApproval_dt()))) vo.setApproval_dt(vo.getApproval_dt().replaceAll("/", "")) ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		if(!"delete".equals(pageType)) {
			fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
		}
		
		/* 상태값 변경 로직 */
		
		/* 하위작업 등록을 할때 */    //2023.07.11. 하위작업등록 시 Main과 Sub간의 처리상태 연동 제거
//		if (pageType.startsWith("sub")) {
//			
//			AsVO tempVO = new AsVO();
//			
//			if("subUpdate".equals(pageType)) {
//				tempVO.setAs_no(vo.getAs_no());			/**	cn_as_no	*/
//				tempVO.setCn_as_no(vo.getCn_as_no());	/**	as_no		*/
//				tempVO.setSearch_type1("selfExcept");
//			}else {
//				tempVO.setAs_no(vo.getAs_no());			/**	cn_as_no	*/
//			}
//			
//			resultList = asService.getList(tempVO, "asDAO.getCnAsList") ;
//			
//			String statusArray[] = new String[resultList.size()+1];
//			statusArray[0] = vo.getProc_status();
//			
//			if (resultList != null && resultList.size()>0) {
//				for (int i=0; i<resultList.size(); i++) {
//					AsVO temp = resultList.get(i) ; 
//					statusArray[i+1]  = temp.getProc_status();
//				}
//			}
//			
//			if(Arrays.asList(statusArray).contains("C002")){ 
//				if(Arrays.asList(statusArray).contains("C004")) tempVO.setProc_status("C004");
//				else tempVO.setProc_status("C002");
//			}else if(Arrays.asList(statusArray).contains("C003")){
//				if(Arrays.asList(statusArray).contains("C004")) tempVO.setProc_status("C004");
//				else tempVO.setProc_status("C003");
//			}else if(Arrays.asList(statusArray).contains("C004")){
//				tempVO.setProc_status("C004");
//			}else if(Arrays.asList(statusArray).contains("C005")){
//				tempVO.setProc_status("C005");
//			} else {
//				tempVO.setProc_status(vo.getProc_status());
//			}
//			
//			/* 원건 상태값 업데이트 (1건이라도 있을때) */
//			vo.setProc_status2(tempVO.getProc_status());
//			vo.setAs_no2(vo.getAs_no());
//			
//		}
		
		if ("insert".equals(pageType)) returnValue = asService.insertAsInfo(vo, request, fileList) ;
		else if ("update".equals(pageType)) returnValue = asService.updateAsInfo(vo, request, fileList) ;
		else if ("subInsert".equals(pageType)) returnValue = asService.insertAsCnInfo(vo, request, fileList) ;
		else if ("subUpdate".equals(pageType)) returnValue = asService.updateAsCnInfo(vo, request, fileList) ;
		
		if(returnValue > 0) script = "parent.procReturn('success');" ; 
		else if(returnValue == -999) script = "parent.procReturn('cnasfail');" ; //2023.08.21. 하위작업의 처리여부가 다 완료되지 않았을 경우 메인 AS에서 띄우는 알림창 추가
		else script = "parent.procReturn('fail');" ;
		
		return CommonExecute.execute(model, script);
	}
	
	/**
	 * 엑셀처리
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/exl.do")
	public void exl(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		
		String isTab = SsStringUtil.normalize(vo.getIsTab(), "1").trim() ; 
		
		String exl_title = "AS관리" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setPageType("exl");
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start3()))) vo.setSearch_start3(vo.getSearch_start3().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end3()))) vo.setSearch_end3(vo.getSearch_end3().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start4()))) vo.setSearch_start4(vo.getSearch_start4().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end4()))) vo.setSearch_end4(vo.getSearch_end4().replaceAll("/", "")) ;
		
		String[] procSelectArray =  vo.getProcSelect().split(",");
		vo.setProcSelectArray(procSelectArray);
		
		List<AsVO> resultList = asService.getList(vo, "asDAO.getAsList");
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		HSSFRow row = null ; 
		HSSFCell cell = null ; 
		HSSFPalette palette = workbook.getCustomPalette();
		
		String[] title = { 
			      "No" 
				, "접수번호" 
				, "하위작업" 
				, "접수일"
				, "접수경로"
					
				, "거래처구분"
				, "거래처코드"
				, "거래처명"
				, "의뢰자명"
				
				, "처리상태"
				, "부서명" 		
				, "처리담당자"
				, "중요도"
				, "모듈"
				, "중분류"
				, "프로그램명"
					
					
				, "처리요청일자"	
				, "시스템유형"
				, "업무유형"
				, "문의유형"	
				, "요청내용"
				, "CMC담당자"
				
				, "처리예정일자" 	
				, "처리예정시각" 	
				, "원인유형" 
				, "조치유형" 
				, "처리등급"	
				, "처리완료일"
				, "예상 작업시간"
				, "진행률"
				, "대상 프로젝트"
				, "작업시간"
				, "조치 및 처리 의견"
				, "프로그램 만족도"
				
					
				, "처리구분"
				, "빌드순번/CTS빌드"
				, "파일명/PBL"
				, "관련DB"
				, "테스트케이스"
				, "프로세스정의서"
				, "기능분해도"
				, "화면정의서"
				, "ERD"
				, "테이블정의서"
				, "인터페이스정의서"
				
				, "승인여부" 		
				, "승인자"	 	
				, "승인일자" 		

				, "승인여부" 		
				, "승인자"		
				, "승인일자" 		

				, "배포경로 및 배포파일명" 
				, "SVN버전"		
				, "배포일자" 		
				
				/*
				, "검수일"
				, "고객평가"
				*/
				
				, "배포승인일시"
				, "배포승인시간"
				
				};
		String[] refColumn = { 
			     "rnum" 
				, "as_no" 
				, "cn_as_no" 
				, "accept_dt"
				, "accept_route_nm"
					
				
				, "cust_gubun"
				, "cust_code"
				, "cust_kor_name"
				, "apply_nm"
				
					
				, "proc_status_nm" 
				, "dept2_nm"
				, "emp_nm"
				, "inportance_nm"
				, "module_name_nm"
				, "category_name" 
				, "program_name"
				
				, "inquiry_dt"
				, "system_type_nm"
				, "inquiry_type_nm" 
				, "request_type_nm"
				, "call_content"
				, "cmc_pic_nm"
				
				
				, "proc_dt"
				, "proc_time"
				, "cause_type_nm"
				, "action_type_nm"
				, "proc_grade_nm"
				, "complete_dt"
				, "expected_work_time"
				, "progress_rate"
				, "target_project"
				, "work_time"
				, "action_content"
				, "program_satisfaction_nm"
				
					
				, "proc_gubun_nm"
				, "proc_build_info"
				, "proc_file_info"
				, "proc_db_info"
				, "proc_test_info"
				, "proc_process_sp"
				, "proc_function_sp"
				, "proc_screen_sp"
				, "proc_erd_sp"
				, "proc_table_sp"
				, "proc_interface_sp"
				
				, "appr_yn1"
				, "appr_emp1_nm"
				, "appr_date1"
				
				, "appr_yn2"
				, "appr_emp2_nm"
				, "appr_date2"
				
				, "distr_filepath"
				, "distr_svn_ver"
				, "distr_dt"
				
				/*
				, "star_state_date"
				, "star_state"
				*/
				
				, "appr_date2"
				, "appr_time2"
				
				};
		
		
		//셀스타일
		CellStyle tStyleOne = workbook.createCellStyle();
		CellStyle tStyleTwo = workbook.createCellStyle();
		CellStyle tStyleThree = workbook.createCellStyle();
		CellStyle tStyleFour = workbook.createCellStyle();
		CellStyle tStyleFive = workbook.createCellStyle();
		CellStyle tStyleSix = workbook.createCellStyle();
		CellStyle tStyleSeven = workbook.createCellStyle();
		CellStyle tStyleEigth = workbook.createCellStyle();
		CellStyle tStyleNine = workbook.createCellStyle();
		CellStyle tStyleTen = workbook.createCellStyle();
		CellStyle titleStyle = workbook.createCellStyle();
		
		tStyleOne.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleOne.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleOne.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleOne.setFillForegroundColor(IndexedColors.LIME.getIndex());
		addBoardStyle(tStyleOne, true);
		
		tStyleTwo.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTwo.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleTwo.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTwo.setFillForegroundColor(IndexedColors.TAN.getIndex());
		addBoardStyle(tStyleTwo, true);
		
		tStyleThree.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleThree.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleThree.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleThree.setFillForegroundColor(IndexedColors.GREEN.getIndex());
		addBoardStyle(tStyleThree, true);
		
		tStyleFour.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFour.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleFour.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFour.setFillForegroundColor(IndexedColors.GOLD.getIndex());
		addBoardStyle(tStyleFour, true);
		
		tStyleFive.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFive.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleFive.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFive.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		addBoardStyle(tStyleFive, true);
		
		tStyleSix.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSix.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleSix.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSix.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());
		addBoardStyle(tStyleSix, true);
		
		tStyleSeven.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSeven.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleSeven.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSeven.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
		addBoardStyle(tStyleSeven, true);
		
		tStyleEigth.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleEigth.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleEigth.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleEigth.setFillForegroundColor(palette.findSimilarColor(248, 203, 173).getIndex());
//		tStyleEigth.setFillForegroundColor(IndexedColors.CORAL.getIndex());
		addBoardStyle(tStyleEigth, true);
		
		tStyleNine.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleNine.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleNine.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleNine.setFillForegroundColor(palette.findSimilarColor(255, 230, 153).getIndex());
//		tStyleNine.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
		addBoardStyle(tStyleNine, true);
		
		tStyleTen.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTen.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleTen.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTen.setFillForegroundColor(IndexedColors.PLUM.getIndex());
		addBoardStyle(tStyleTen, true);
		
		
		titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
		titleStyle.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		titleStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		titleStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
		addBoardStyle(titleStyle, true);
		
		
		//첫번째행
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		
		//sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 4));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 5, 8));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 9, 15));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 16, 21));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 22, 33));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 34, 44));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 45, 47));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 48, 50));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 51, 53));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 54, 55));
		
		
		cell = row.createCell(0);
		cell.setCellValue("접수정보");
		cell.setCellStyle(tStyleOne);
		
		cell = row.createCell(5);
		cell.setCellValue("고객사정보");
		cell.setCellStyle(tStyleTwo);
		
		cell = row.createCell(9);
		cell.setCellValue("문의 유형 정보");
		cell.setCellStyle(tStyleThree);
		
		cell = row.createCell(16);
		cell.setCellValue("처리상태 정보");
		cell.setCellStyle(tStyleFour);
		
		cell = row.createCell(22);
		cell.setCellValue("처리완료 정보");
		cell.setCellStyle(tStyleFive);
		
		cell = row.createCell(34);
		cell.setCellValue("처리완료 상세 정보");
		cell.setCellStyle(tStyleSix);
		
		cell = row.createCell(45);
		cell.setCellValue("팀장승인");
		cell.setCellStyle(tStyleSeven);
		
		cell = row.createCell(48);
		cell.setCellValue("배포승인");
		cell.setCellStyle(tStyleEigth);
		
		cell = row.createCell(51);
		cell.setCellValue("배포정보");
		cell.setCellStyle(tStyleNine);
		
		/*
		cell = row.createCell(49);
		cell.setCellValue("검수 정보");
		cell.setCellStyle(tStyleTen);
		*/
		
		cell = row.createCell(54);
		cell.setCellValue("배포승인 정보");
		cell.setCellStyle(tStyleTen);
		
		//두번째 행 셋팅
		rowNum++  ;
		row = sheet.createRow(rowNum) ; 
		
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
			
			cell.setCellStyle(titleStyle);
			addBoardStyle(titleStyle, true);
		}
		
		rowNum++  ;
		
		if(resultList != null && resultList.size() > 0){
			for(int i = 0 ; i < resultList.size() ; i++){
				AsVO temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				// 접수번호 및 하위 작업에 대한 데이터 보정
				String asNo = temp.getAs_no();
				String cnAsNo = temp.getCn_as_no();
				
				if (SsStringUtil.isDefined(cnAsNo)){
					temp.setAs_no(cnAsNo);
					temp.setCn_as_no(asNo);
				}
				
				// 처리예정시각 데이터 보정
				if(temp.getProc_time() == ""){
					temp.setProc_time("00:00");
				}
				else{
					temp.setProc_time( temp.getProc_time().substring(0,2) + ":" + temp.getProc_time().substring(2,4) );
				}

				
				String cust_gubun = temp.getCust_gubun();
				if(cust_gubun.equals("C001")){
					temp.setCust_gubun("JW그룹");
				}else if(cust_gubun.equals("C002")){
					temp.setCust_gubun("대외기업");
				}else if(cust_gubun.equals("C003")){
					temp.setCust_gubun("공공기관");
				}else if(cust_gubun.equals("C004")){
					temp.setCust_gubun("본사");
				}
				
				for(int a = 0 ; a < title.length ; a++){

					cell = row.createCell(a) ;
					String cellValue = "" ; 

					cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
					cell.setCellValue(cellValue);
				}
			}
			
			String usrClient = request.getHeader("User-Agent") ; 
			
			exl_title = exl_title + ".xls" ; 
			
			if(usrClient.indexOf("MSIE 5.5") > -1){
				response.setHeader("Content-Disposition", "filename="+ new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			}else{
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(exl_title, "UTF-8") +";");
			}
			
			fileOut = response.getOutputStream() ; 
			
			workbook.write(fileOut);
		}
		
		if(fileOut != null) fileOut.close();  
	}
	
	/**
	 * 엑셀처리
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/exl2.do")
	public void exl2(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		
		
		String exl_title = "AS현황" ; 
		
		vo.setPageType("exl");
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start3()))) vo.setSearch_start3(vo.getSearch_start3().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end3()))) vo.setSearch_end3(vo.getSearch_end3().replaceAll("/", "")) ;
		
		
		List<AsVO> resultList = asService.getList(vo, "asDAO.getAsList2");
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		HSSFRow row = null ; 
		HSSFCell cell = null ;
		HSSFPalette palette = workbook.getCustomPalette();
		
		String[] title = { 
				  "No"
				, "접수번호" 
				, "하위작업" 
				, "접수일"
				, "접수경로"
					
				, "거래처구분"
				, "거래처코드"
				, "거래처명"
				, "의뢰자명"
				
				, "처리상태"
				, "부서명" // added
				, "처리담당자"
				, "중요도"
				, "모듈"
				, "중분류"
				, "프로그램명"
					
					
				, "처리요청일자"	
				, "시스템유형"
				, "업무유형"
				, "문의유형"	
				, "요청내용"
				, "CMC담당자"
				
				, "원인유형" 
				, "조치유형" 
				, "처리등급"	
				, "처리완료일"
				, "작업시간"
				, "조치 및 처리 의견"
				, "프로그램 만족도"
				
					
				, "처리구분"
				, "빌드순번/CTS빌드"
				, "파일명/PBL"
				, "관련DB"
				, "테스트케이스"
				, "프로세스정의서"
				, "기능분해도"
				, "화면정의서"
				, "ERD"
				, "테이블정의서"
				, "인터페이스정의서"
					
				, "승인여부" // added
				, "승인자"	 // added
				, "승인일자" // added

				, "승인여부" // added
				, "승인자"	// added
				, "승인일자" // added

				, "배포경로 및 배포파일명" // added
				, "SVN버전"	// added
				, "배포일자" // added

				, "검수일"
				, "고객평가"
				
				};
		String[] refColumn = { 
			      "rnum" 
				, "as_no" 
				, "cn_as_no" 
				, "accept_dt"
				, "accept_route_nm"
					
				
				, "cust_gubun"
				, "cust_code"
				, "cust_kor_name"
				, "apply_nm"
				
					
				, "proc_status_nm"
				, "dept2_nm"
				, "emp_nm"
				, "inportance_nm"
				, "module_name_nm" 			
				, "category_name"			
				, "program_name" 
				
				, "inquiry_dt"
				, "system_type_nm"
				, "inquiry_type_nm" 
				, "request_type_nm"
				, "call_content"
				, "cmc_pic_nm"
				
				
				, "cause_type_nm"
				, "action_type_nm"
				, "proc_grade_nm"
				, "complete_dt"
				, "work_time"
				, "action_content"
				, "program_satisfaction_nm"
				
					
				, "proc_gubun_nm"
				, "proc_build_info"
				, "proc_file_info"
				, "proc_db_info"
				, "proc_test_info"
				, "proc_process_sp"
				, "proc_function_sp"
				, "proc_screen_sp"
				, "proc_erd_sp"
				, "proc_table_sp"
				, "proc_interface_sp"
					
				, "appr_yn1"
				, "appr_emp1_nm"
				, "appr_date1"
				
				, "appr_yn2"
				, "appr_emp2_nm"
				, "appr_date2"
				
				, "distr_filepath"
				, "distr_svn_ver"
				, "distr_dt"
					
				, "star_state_date"
				, "star_state"
				
				};
		
		
		//셀스타일
		CellStyle tStyleOne = workbook.createCellStyle();
		CellStyle tStyleTwo = workbook.createCellStyle();
		CellStyle tStyleThree = workbook.createCellStyle();
		CellStyle tStyleFour = workbook.createCellStyle();
		CellStyle tStyleFive = workbook.createCellStyle();
		CellStyle tStyleSix = workbook.createCellStyle();
		CellStyle tStyleSeven = workbook.createCellStyle();
		CellStyle tStyleEigth = workbook.createCellStyle();
		CellStyle tStyleNine = workbook.createCellStyle();
		CellStyle tStyleTen = workbook.createCellStyle();
		CellStyle titleStyle = workbook.createCellStyle();
		
		tStyleOne.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleOne.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleOne.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleOne.setFillForegroundColor(IndexedColors.LIME.getIndex());
		addBoardStyle(tStyleOne, true);
		
		tStyleTwo.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTwo.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleTwo.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTwo.setFillForegroundColor(IndexedColors.TAN.getIndex());
		addBoardStyle(tStyleTwo, true);
		
		tStyleThree.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleThree.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleThree.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleThree.setFillForegroundColor(IndexedColors.GREEN.getIndex());
		addBoardStyle(tStyleThree, true);
		
		tStyleFour.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFour.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleFour.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFour.setFillForegroundColor(IndexedColors.GOLD.getIndex());
		addBoardStyle(tStyleFour, true);
		
		tStyleFive.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFive.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleFive.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFive.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		addBoardStyle(tStyleFive, true);
		
		tStyleSix.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSix.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleSix.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSix.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());
		addBoardStyle(tStyleSix, true);
		
		tStyleSeven.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSeven.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleSeven.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSeven.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
		addBoardStyle(tStyleSeven, true);
		
		
		tStyleEigth.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleEigth.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleEigth.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleEigth.setFillForegroundColor(palette.findSimilarColor(248, 203, 173).getIndex());
//		tStyleEigth.setFillForegroundColor(IndexedColors.CORAL.getIndex());
		addBoardStyle(tStyleEigth, true);
		
		tStyleNine.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleNine.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleNine.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleNine.setFillForegroundColor(palette.findSimilarColor(255, 230, 153).getIndex());
//		tStyleNine.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
		addBoardStyle(tStyleNine, true);
		
		tStyleTen.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTen.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleTen.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTen.setFillForegroundColor(IndexedColors.PLUM.getIndex());
		addBoardStyle(tStyleTen, true);
		
		titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
		titleStyle.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		titleStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		titleStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
		addBoardStyle(titleStyle, true);
		
		
		//첫번째행
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		
		//sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 4));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 5, 8));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 9, 15));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 16, 21));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 22, 28));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 29, 39));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 40, 42));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 43, 45));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 46, 48));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 49, 50));
		
		
		cell = row.createCell(0);
		cell.setCellValue("접수정보");
		cell.setCellStyle(tStyleOne);
		
		cell = row.createCell(5);
		cell.setCellValue("고객사정보");
		cell.setCellStyle(tStyleTwo);
		
		cell = row.createCell(9);
		cell.setCellValue("문의 유형 정보");
		cell.setCellStyle(tStyleThree);
		
		cell = row.createCell(16);
		cell.setCellValue("처리상태 정보");
		cell.setCellStyle(tStyleFour);
		
		cell = row.createCell(22);
		cell.setCellValue("처리완료 정보");
		cell.setCellStyle(tStyleFive);
		
		cell = row.createCell(29);
		cell.setCellValue("처리완료 상세 정보");
		cell.setCellStyle(tStyleSix);
		
		cell = row.createCell(40);
		cell.setCellValue("팀장승인");
		cell.setCellStyle(tStyleSeven);
		
		cell = row.createCell(43);
		cell.setCellValue("배포승인");
		cell.setCellStyle(tStyleEigth);
		
		cell = row.createCell(46);
		cell.setCellValue("배포정보");
		cell.setCellStyle(tStyleNine);
		
		cell = row.createCell(49);
		cell.setCellValue("검수 정보");
		cell.setCellStyle(tStyleTen);
		
		//두번째 행 셋팅
		rowNum++  ;
		row = sheet.createRow(rowNum) ; 
		
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
			
			cell.setCellStyle(titleStyle);
			addBoardStyle(titleStyle, true);
		}
		
		rowNum++  ;
		
		if(resultList != null && resultList.size() > 0){
			for(int i = resultList.size() -1 ; i >= 0 ; i--){
				AsVO temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				// 접수번호 및 하위 작업에 대한 데이터 보정
				String asNo = temp.getAs_no();
				String cnAsNo = temp.getCn_as_no();
				
				if (SsStringUtil.isDefined(cnAsNo)){
					temp.setAs_no(cnAsNo);
					temp.setCn_as_no(asNo);
				}
				
				String cust_gubun = temp.getCust_gubun();
				if(cust_gubun.equals("C001")){
					temp.setCust_gubun("JW그룹");
				}else if(cust_gubun.equals("C002")){
					temp.setCust_gubun("대외기업");
				}else if(cust_gubun.equals("C003")){
					temp.setCust_gubun("공공기관");
				}else if(cust_gubun.equals("C004")){
					temp.setCust_gubun("본사");
				}
			
				for(int a = 0 ; a < title.length ; a++){

					cell = row.createCell(a) ;
					String cellValue = "" ; 

					cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
					cell.setCellValue(cellValue);
				}
			}
			
			String usrClient = request.getHeader("User-Agent") ; 
			
			exl_title = exl_title + ".xls" ; 
			
			if(usrClient.indexOf("MSIE 5.5") > -1){
				response.setHeader("Content-Disposition", "filename="+ new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			}else{
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(exl_title, "UTF-8") + ";");
			}
			
			fileOut = response.getOutputStream() ; 
			
			workbook.write(fileOut);
		}
		
		if(fileOut != null) fileOut.close();  
	}
	
	/**
	 * 엑셀처리
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/exl4.do")
	public void exl4(@ModelAttribute("vo") AsStatsVo vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		
		String exl_title = "시스템별AS현황" ; 
		
		vo.setPageType("exl");
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
		List<AsStatsVo> resultList  = asStatsService.getList(vo, "asDAO.getAsList4"); 
		
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		HSSFRow row = null ; 
		HSSFCell cell = null ;
		HSSFPalette palette = workbook.getCustomPalette();
		
		String[] title = { 
				
				 "합계"
				, "프로그램"
				, "데이터"
				, "권한"
				, "기타"
				
				, "합계"
				, "프로그램"
				, "데이터"
				, "권한"
				, "기타"
				
				, "합계"
				, "프로그램"
				, "데이터"
				, "권한"
				, "기타"
				
				};
		String[] refColumn = { 
			      "rnum" 
				, "system_type" 
				, "system_type_nm" 
				
				, "jcnt_tot"
				, "jcnt1"
				, "jcnt2"
				, "jcnt3"
				, "jcnt4"
				
				, "cnt_tot"
				, "cnt1"
				, "cnt2"
				, "cnt3"
				, "cnt4"
				
				, "ncnt_tot"
				, "ncnt1"
				, "ncnt2"
				, "ncnt3"
				, "ncnt4"
				
				};
		
		
		//셀스타일
		CellStyle tStyleOne = workbook.createCellStyle();
		CellStyle tStyleTwo = workbook.createCellStyle();
		CellStyle tStyleThree = workbook.createCellStyle();
		CellStyle tStyleFour = workbook.createCellStyle();
		CellStyle tStyleFive = workbook.createCellStyle();
		CellStyle tStyleSix = workbook.createCellStyle();
		CellStyle tStyleSeven = workbook.createCellStyle();
		CellStyle tStyleEigth = workbook.createCellStyle();
		CellStyle tStyleNine = workbook.createCellStyle();
		CellStyle tStyleTen = workbook.createCellStyle();
		CellStyle titleStyle = workbook.createCellStyle();
		
		tStyleOne.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleOne.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleOne.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleOne.setFillForegroundColor(IndexedColors.LIME.getIndex());
		//addBoardStyle(tStyleOne, true);
		
		tStyleTwo.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTwo.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleTwo.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTwo.setFillForegroundColor(IndexedColors.TAN.getIndex());
		//addBoardStyle(tStyleTwo, true);
		
		tStyleThree.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleThree.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleThree.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleThree.setFillForegroundColor(IndexedColors.GREEN.getIndex());
		//addBoardStyle(tStyleThree, true);
		
		tStyleFour.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFour.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleFour.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFour.setFillForegroundColor(IndexedColors.GOLD.getIndex());
		addBoardStyle(tStyleFour, true);
		
		tStyleFive.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFive.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleFive.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFive.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		addBoardStyle(tStyleFive, true);
		
		tStyleSix.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSix.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleSix.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSix.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());
		addBoardStyle(tStyleSix, true);
		
		tStyleSeven.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSeven.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleSeven.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSeven.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
		addBoardStyle(tStyleSeven, true);
		
		
		tStyleEigth.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleEigth.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleEigth.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleEigth.setFillForegroundColor(palette.findSimilarColor(248, 203, 173).getIndex());
//		tStyleEigth.setFillForegroundColor(IndexedColors.CORAL.getIndex());
		addBoardStyle(tStyleEigth, true);
		
		tStyleNine.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleNine.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleNine.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleNine.setFillForegroundColor(palette.findSimilarColor(255, 230, 153).getIndex());
//		tStyleNine.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
		addBoardStyle(tStyleNine, true);
		
		tStyleTen.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTen.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleTen.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTen.setFillForegroundColor(IndexedColors.PLUM.getIndex());
		addBoardStyle(tStyleTen, true);
		
		titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
		titleStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		titleStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		titleStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
		addBoardStyle(titleStyle, true);
		
		
		//첫번째행
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		
		//셀 병합 (열시작, 열종료, 행시작, 행종료)
		sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));	//순번
		sheet.addMergedRegion(new CellRangeAddress(0, 1, 1, 1));	//시스템타입
		sheet.addMergedRegion(new CellRangeAddress(0, 1, 2, 2));	//시스템
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 3, 7));	//전년도
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 8, 12));	//조회기간
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 13, 17));	//누적
		
		//헤더생성
		cell = row.createCell(0);
		cell.setCellValue("순번");
		cell.setCellStyle(tStyleOne);
		
		cell = row.createCell(1);
		cell.setCellValue("시스템타입");
		cell.setCellStyle(tStyleTwo);
		
		cell = row.createCell(2);
		cell.setCellValue("시스템");
		cell.setCellStyle(tStyleThree);
		
		cell = row.createCell(3);
		cell.setCellValue("전년도");
		cell.setCellStyle(tStyleFour);
		
		cell = row.createCell(8);
		cell.setCellValue("조회기간");
		cell.setCellStyle(tStyleFive);
		
		cell = row.createCell(13);
		cell.setCellValue("누적");
		cell.setCellStyle(tStyleSix);
		
		
		//두번째 행 셋팅
		rowNum++  ;
		row = sheet.createRow(rowNum) ; 
		
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i+3) ;
			cell.setCellValue(title[i]);
			
			cell.setCellStyle(titleStyle);
			addBoardStyle(titleStyle, true);
		}
		
		rowNum++  ;
		
		if(resultList != null && resultList.size() > 0){
			for(int i=0 ; i <resultList.size() ; i++){
				AsStatsVo temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				for(int a = 0 ; a < title.length+3 ; a++){

					cell = row.createCell(a) ;
					String cellValue = "" ; 

					cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
					cell.setCellValue(cellValue);
				}
			}
			
			String usrClient = request.getHeader("User-Agent") ; 
			
			exl_title = exl_title + ".xls" ; 
			
			if(usrClient.indexOf("MSIE 5.5") > -1){
				response.setHeader("Content-Disposition", "filename="+ new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			}else{
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(exl_title, "UTF-8") + ";");
			}
			
			fileOut = response.getOutputStream() ; 
			
			workbook.write(fileOut);
		}
		
		if(fileOut != null) fileOut.close();  
	}
	
	
	/**
	 * AS 상세 답변내역 리스트 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAwsList.do")
	public void getAwsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		int totalCount = asService.getTotalCnt(vo, "asDAO.getAwsListCnt") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = asService.getList(vo, "asDAO.getAwsList");
			vo.setJson_paging(vo.getJsonPaging("getAwsList"));
			
			
			for(int i =0 ; i < totalCount ; i++) {
				if(resultList != null) {
					
					Map<String , Object> returnMap1 = new HashMap<String , Object>() ;
					FileVO fileVO = new FileVO() ; 
					if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getAttach_seq(), "0"))) {
						fileVO.setAttach_seq(resultList.get(i).getAttach_seq());
						returnMap1.put("attachList", commonFileService.getFileList(fileVO)) ; 
						resultList.get(i).setAmap(returnMap1);
					}
				}
				 
			}
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo", vo) ;
		}
		CommonExecute.returnJson(response, returnMap);
		
		
	}	
	
	/**
	 * AS 리스트 신규답변 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/awsProc.do")
	public String awsProc(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		List<FileVO> fileList = null ;
		int attach_seq = 0 ; 
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ; 
		int returnValue = 0 ;
		String resultCode = "" ;
		
		if(!"delete".equals(vo.getPageType())) {
			fileList = commonFileService.uploadFormFile(multiRequest, "as_answer") ;
		}
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile")){
					
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
		
		vo.setReg_id(adUserInfo.getEmp_no());
		vo.setW_gubun("A");
		if ("insert".equals(vo.getPageType())) {
			returnValue = asService.insertAws(vo, request) ;	
		} else if ("update".equals(vo.getPageType())) {
			returnValue = asService.updateAws(vo, request) ;
		} else if ("delete".equals(vo.getPageType())) {
			returnValue = asService.deleteAws(vo, request) ;
		}
		
		if(returnValue > 0) resultCode = "000" ;
		else resultCode = "001" ;
		
	 
		return CommonExecute.execute(model, "parent.awsProcReturn('"+resultCode+"');");
	}
	
	/**
	 * AS 리스트 삭제 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/delProc.do")
	public void delProc(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ; 
		int returnValue = 0 ;
		String resultCode = "" ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = asService.deleteAsProc(vo, request) ;
		
		if(returnValue > 0) resultCode = "000" ;
		else resultCode = "001" ;
		
		returnMap.put("resultCode", resultCode) ; 
		CommonExecute.returnJson(response, returnMap);
		
	}
	
	/**
	
	/**
	 * AS 직원목록 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsEmpList.do")
	public void getAsEmpList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		returnMap.put("resultList", asService.getList(vo, "asDAO.getAsEmpList")) ;
		CommonExecute.returnJson(response, returnMap);
	}	
	
	/**
	 * AS 상세 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsInfo.do")
	public void getAsInfo(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		
		AsVO resultVO = asService.getSelectInfo(vo, "asDAO.getAsInfo") ;
		
		returnMap.put("resultVO", resultVO) ;
		
		if(resultVO != null) {
			
			/*2021.08.19 이설아*/
			resultVO.setCall_content(resultVO.getCall_content().replace("<br>", "\r\n")
															   .replace("&gt;", ">")
															   .replace("&lt;", "<")
															   .replace("&amp;", "&")
															   .replace("&nbsp;", " ")
															   .replace("&quot;", "\""));
															   	
			FileVO fileVO = new FileVO() ; 
			if(!"0".equals(SsStringUtil.normalize(resultVO.getFile_seq(), "0"))) {
				fileVO.setAttach_seq(Integer.parseInt(resultVO.getFile_seq()));
				returnMap.put("attachList", commonFileService.getFileList(fileVO)) ; 
			}
			
			//if(vo.getAttach_seq2() > 0) {
			if(!"0".equals(SsStringUtil.normalize(resultVO.getAttach_seq2(), "0"))) {
				//fileVO.setAttach_seq(vo.getAttach_seq2());
				fileVO.setAttach_seq(resultVO.getAttach_seq2());
				returnMap.put("attachList2", commonFileService.getFileList(fileVO)) ; 
			}
			
			returnMap.put("asHistList", asService.getList(vo, "asDAO.getAsHistList")) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
	}	
	
	
	/**
	 * AS 상세 하위작업번호 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getCnAsList.do")
	public void getCnAsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		int totalCount = asService.getTotalCnt(vo, "asDAO.getCnAsCnt") ;
		
		if(totalCount > 0){
			resultList = asService.getList(vo, "asDAO.getCnAsList") ;
			returnMap.put("resultList", resultList) ;
		}
		CommonExecute.returnJson(response, returnMap);
	}		
	
	
	/**
	 * AS 상세 조치이력 - 파일 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsHistFileInfo.do")
	public void getAsHistFileInfo(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		FileVO fileVO = new FileVO() ; 
		if(!"0".equals(SsStringUtil.normalize(vo.getAttach_seq2(), "0"))) {
			fileVO.setAttach_seq(vo.getAttach_seq2());
			returnMap.put("attach2FileList", commonFileService.getFileList(fileVO)) ; 
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * AS 답변검색 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsAnswerList.do")
	public void getAsAnswerList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAw_search_start1()))) vo.setAw_search_start1(vo.getAw_search_start1().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAw_search_end1()))) vo.setAw_search_end1(vo.getAw_search_end1().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAw_search_start2()))) vo.setAw_search_start2(vo.getAw_search_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAw_search_end2()))) vo.setAw_search_end2(vo.getAw_search_end2().replaceAll("/", "")) ;
		
	
		resultList = asService.getList(vo,"asDAO.getAsAnswerList") ;
		returnMap.put("resultList", resultList) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 문의유형 - 승인권한 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/selectIsAsApproval2.do")
	public void selectIsAsApproval(@ModelAttribute("vo") CommonCodeVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;                                                                                                                                                                                                                                                                                                                                                                                                                                    
		returnMap.put("resultVO", commonDao.selectOne(vo,"custDAO.selectIsAsApproval2")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	

	private void addBoardStyle(CellStyle style, boolean isBold) {

		short border;

		if (isBold) {
			border = CellStyle.BORDER_MEDIUM;
		} else {
			border = CellStyle.BORDER_THIN;
		}

		style.setBorderBottom(border);
		style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderTop(border);
		style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderRight(border);
		style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderLeft(border);
		style.setLeftBorderColor(IndexedColors.BLACK.getIndex());

	}
	
	
	/**
	 * AS승인 - 결재 처리 (팀장승인,배포승인) 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "/ad/code/apprv.do", method=RequestMethod.POST)
	public void approve(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String res_data = "" ; 
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ;
		String returnCode = "400" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
			
		vo.setReg_id(userInfo.getEmp_no());
		returnValue = asService.approve(vo, request) ;
		if(returnValue > 0) returnCode = "000" ; 
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * AS승인 - 부결 처리 (팀장반려,배포반려) 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */		
	@RequestMapping(value = "/ad/code/reject.do", method=RequestMethod.POST)
	public void reject(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ;
		String returnCode = "400" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		
		vo.setReg_id(userInfo.getEmp_no());
		returnValue = asService.reject(vo, request) ;
		if(returnValue > 0) returnCode = "000" ; 
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * AS승인 - 취소 처리 (조회조건 결재화면에서 취소기능) 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */		
	@RequestMapping(value = "/ad/code/cancel.do", method=RequestMethod.POST)
	public void cancel(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String res_data = "" ; 
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ;
		String returnCode = "400" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		
		vo.setReg_id(userInfo.getEmp_no());
		returnValue = asService.cancle(vo, request) ;
		if(returnValue > 0) returnCode = "000" ; 
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * AS상세화면에서 문의유형 기준 승인대상 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/checkTypeQuestion.do")
	public void checkTypeQuestion(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		AsVO voTemp = new AsVO();
		voTemp.setRequest_type(vo.getRequest_type());
		voTemp.setAction_type(vo.getAction_type());
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		returnMap.put("resultList", asService.checkTypeQuestion(voTemp, request)) ;
		returnMap.put("vo",vo);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * A/S 관리 - 상세처리내역 조회 - 중분류
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getCategoryList.do")
	public void getCategoryList(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		/**	parameter 설정	*/
		int totalCount = asService.getTotalCnt(vo, "asDAO.getCategoryListCnt"); 
		
		if(totalCount>  0) {
			vo.setPaging(totalCount);
			returnMap.put("resultList", asService.getList(vo , "asDAO.getCategoryList")) ;
			vo.setJson_paging(vo.getJsonPaging("categoryList"));
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * A/S 관리 - 상세처리내역 조회 - 프로그램명
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getProgramList.do")
	public void getProgramList(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		/**	parameter 설정	*/
		int totalCount = asService.getTotalCnt(vo, "asDAO.getProgramListCnt"); 
		
		if(totalCount>  0) {
			vo.setPaging(totalCount);
			returnMap.put("resultList", asService.getList(vo , "asDAO.getProgramList")) ;
			vo.setJson_paging(vo.getJsonPaging("programList"));
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	@RequestMapping(value = "/ad/as/getAsList4.do")
	public void getAsList4(@ModelAttribute("vo") AsStatsVo vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		//파라미터 vo에는 프론트(list4.jsp)에서 넘긴 search_type7와 search_start가 들어온다
		//@ModelAttribute를 파라미터로 받으면 bean에 만들어진 그릇에 알아서 바인딩된다. 굳이 getParameter로 받아서 setter하지 않아도 된다
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsStatsVo> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		resultList  = asStatsService.getList(vo, "asDAO.getAsList4");   
		
		int totalCount = asStatsService.getTotalCnt(vo,"asDAO.getAsListCnt4") ;
		vo.setRowCnt(totalCount-1);							//ROLLUP한 총계까지 cnt에 포함되므로 -1
		
		
		if(totalCount > 0){
			
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
			
		}
		
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/cm/confirm/view.do", method = RequestMethod.GET)
	public void updateUserTest(String as_no, String apply_id) throws Exception{
		
		int utCnt = 0 ;
		AsVO vo = new AsVO();
		vo.setAs_no(as_no);
		
		/*이전에 사용자테스트확인을 처리한 경우 중복 체크*/
		utCnt = asService.checkUserTestYn(vo, "asDAO.checkUserTestYn");
		
		if(utCnt == 1){
			
			String ipAddress = getClientIp();
			vo.setUser_test_yn("Y");
			vo.setNormal_oper_yn("Y");
			vo.setTest_note("특이사항 없음");
			vo.setUser_test_id(apply_id);
			vo.setUser_test_ip(ipAddress);
			
			asService.updateUserTest(vo,"asDAO.updateUserTest");
		} else {
			
		}
		
		
	}
	
	/*사용자 IP주소 가져오기*/
	public static String getClientIp(){ 
		
        String ip = null;
        HttpServletRequest request = 
        ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();

        ip = request.getHeader("X-Forwarded-For");
        
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getHeader("Proxy-Client-IP"); 
        } 
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getHeader("WL-Proxy-Client-IP"); 
        } 
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getHeader("HTTP_CLIENT_IP"); 
        } 
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getHeader("HTTP_X_FORWARDED_FOR"); 
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getHeader("X-Real-IP"); 
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getHeader("X-RealIP"); 
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getHeader("REMOTE_ADDR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
            ip = request.getRemoteAddr(); 
        }
		
		return ip;
	}
	
	/**
	 * A/S상세페이지 - 처리완료 안내 메일 재전송
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/reSendEmail.do")
	public String reSendEmail(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {	
		int returnValue = 0;
		String script = "";
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ; 
		
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))) vo.setProc_dt(vo.getProc_dt().replaceAll("/", "")) ;
		
		
		
		if ("update".equals(pageType)) returnValue = asService.reSendEmail(vo, request);
		else if ("subUpdate".equals(pageType)){

		String cn_as_no = vo.getAs_no() ; 
		String as_no = vo.getCn_as_no() ; 

		vo.setCn_as_no(cn_as_no);
		vo.setAs_no(as_no);

		returnValue = asService.reSendEmail(vo, request);

		}
		
		if(returnValue > 0) script = "parent.fnReturn('success','list');" ;
		else script = "parent.fnReturn('fail','list');" ;
		
		return CommonExecute.execute(model, script);
		
	}
	
	/**
	 * AS관리 - Update SharedService 버튼 액션(job scheduler 수동실행) 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "/ad/as/schedulerTrigger.do")
	public void getSharedService(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		String resultCode = "" ;
		
		asService.schedulerTrigger();
		
		resultCode = "000" ;
		
		returnMap.put("resultCode", resultCode) ; 
		CommonExecute.returnJson(response, returnMap);
	
	}

	/**
	 * AS상세화면 - 결재 처리 (팀장승인,배포승인) 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "/ad/as/apprv.do")
	public String goApprove(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		int returnValue = 0 ;
		String script = "";
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		
		returnValue = asService.goApprove(vo, request) ;  //2023.07.13. 하위작업 생성 관련 기록용 현재 오류로 인해 returnValue의 값이 0이다
		
		if(returnValue > 0) script = "parent.fnReturn('success','list3');" ;
		else script = "parent.fnReturn('fail','list3');" ;
		
		return CommonExecute.execute(model, script);
	}

	
	
	
}
