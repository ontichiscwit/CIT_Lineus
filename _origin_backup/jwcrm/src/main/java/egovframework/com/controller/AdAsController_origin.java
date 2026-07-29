// [AX Lab] 원본 경로: jwcrm/src/main/java/egovframework/com/controller/AdAsController.java (백업 2026-07-24)
package egovframework.com.controller;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.OperateVO;
import egovframework.com.service.AsService;
import egovframework.com.service.LoginService;
import egovframework.com.comm.dao.CommonDao;
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
 *
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class AdAsController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdAsController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired LoginService loginService ; 
	@Autowired AsService asService ; 
	@Autowired CommonDao commonDAO ;
	
	
	
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
	 * 처리담당자 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/list.do")
	public String operate(@ModelAttribute("vo") OperateVO vo, HttpServletRequest request) throws Exception {

		return "ad/operate/list";
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
	 * 처라담당자 관리 상세 - 처리담당자 관리 
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/form.do")
	public String operateForm(@ModelAttribute("vo") OperateVO vo, Model model, HttpServletRequest request) throws Exception {
		
		return "ad/operate/form";
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
		
		String[] procSelectArray =  vo.getProcSelect().split(",");
		vo.setProcSelectArray(procSelectArray);
		int totalCount = asService.getTotalCnt(vo,"asDAO.getAsListCnt") ;
		
		if(totalCount > 0){
			logger.debug("pageSize : " + vo.getPageSize());
			logger.debug("startRow : " + vo.getStartRow());
			logger.debug("endRow : " + vo.getEndRow());
			vo.setPaging(totalCount);
			logger.debug("startRow : " + vo.getStartRow());
			logger.debug("endRow : " + vo.getEndRow());
			
			resultList = asService.getList(vo,"asDAO.getAsList") ;
			
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
		String a = "" ;
		
		if("C011".equals(SsStringUtil.normalizeNull(vo.getRequest_type()))) {
			vo.setService_cate("P010") ;
		}

		if("insertcopy".equals(pageType)) {pageType = "insert";  vo.setPageType("insert");};
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))) vo.setProc_dt(vo.getProc_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getComplete_dt()))) vo.setComplete_dt(vo.getComplete_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAccept_dt()))) vo.setAccept_dt(vo.getAccept_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAccept_time()))) vo.setAccept_time(vo.getAccept_time().replaceAll(":", "")) ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		if(!"delete".equals(pageType)) {
			fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
		}
		
		/* 상태값 변경 로직 */
		
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
		
		if("insert".equals(pageType)) {
			vo.setAs_no((String)commonDAO.selectOne(vo, "asDAO.getMaxSeq"));
		}
		if("subInsert".equals(pageType)) {
			vo.setCn_as_no(vo.getAs_no());
			vo.setAs_no((String)commonDAO.selectOne(vo, "asDAO.getMaxSubSeq"));
		}
		
		
		
		if ("insert".equals(pageType)) returnValue = asService.insertAsInfo(vo, request, fileList) ;	
		else if ("update".equals(pageType)) returnValue = asService.updateAsInfo(vo, request, fileList, adUserInfo) ;
		else if ("subInsert".equals(pageType)) returnValue = asService.insertAsCnInfo(vo, request, fileList) ;
		else if ("subUpdate".equals(pageType)) returnValue = asService.updateAsCnInfo(vo, request, fileList, adUserInfo) ;
		
		String param_as_no = SsStringUtil.normalizeNull(vo.getAs_no());  
		String param_cn_as_no = SsStringUtil.normalizeNull(vo.getCn_as_no());
		String save_gubun = SsStringUtil.normalizeNull(vo.getSave_gubun());
		if(returnValue > 0) script = "parent.procReturn('success','"+ param_as_no +"','" +pageType+"','"+param_cn_as_no +"','" +save_gubun+"');" ;
		else script = "parent.procReturn('fail');" ;
		
		return CommonExecute.execute(model, script);
	}
	
	
	
	@RequestMapping(value = "/ad/as/updateProcDetailByChecked.do")
	public String updateProcDetailByChecked(
	        @ModelAttribute("vo") AsVO vo,
	        ModelMap model,
	        HttpServletRequest request,
	        HttpServletResponse response,
	        HttpSession session) throws Exception {

	    UserVO adUserInfo = (UserVO) session.getAttribute("adUserInfo");

	    if (adUserInfo == null) {
	        return CommonExecute.execute(model, "parent.procReturn('session');");
	    }

	    String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim();
	    String script = "";

	    List<String> successList = new ArrayList<>();
	    List<String> failList = new ArrayList<>();

	    // 날짜 정리
	    if (!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))) {
	        vo.setProc_dt(vo.getProc_dt().replaceAll("/", ""));
	    }
	    if (!"".equals(SsStringUtil.normalizeNull(vo.getComplete_dt()))) {
	        vo.setComplete_dt(vo.getComplete_dt().replaceAll("/", ""));
	    }

	    // 공통 세팅
	    vo.setUpd_id(adUserInfo.getEmp_no());
	    vo.setReg_id(adUserInfo.getEmp_no());
	    vo.setW_id(adUserInfo.getEmp_no());
	    vo.setAssign_id(adUserInfo.getEmp_no());
	    vo.setW_content(vo.getW_content_pop());
	    vo.setW_gubun("A");

	    // 체크된 AS 목록
	    String asNoLink = SsStringUtil.normalizeNull(vo.getAs_no_link()).trim();

	    List<String> asNoList = Arrays.stream(asNoLink.split(","))
	            .map(String::trim)
	            .filter(s -> !s.isEmpty())
	            .collect(Collectors.toList());

	    int returnValue = 0;
	    boolean isFirst = true;
	    

	    for (String asNo : asNoList) {
	        try {
	            vo.setAs_no(asNo);
	            
	            commonDAO.update(vo, "asDAO.updateAsNoLinkToBlankByAsNo");
	            
	            String curProcStatus = SsStringUtil.normalizeNull((String) commonDAO.selectOne(vo, "asDAO.selectProcStatusByAsNo"));
	            
	            //조치이력추가 : 연결된 접수번호
	            vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	            vo.setProc_status("C005");
        	    vo.setAction_content2(vo.getAs_no_link());
        	    commonDAO.insert(vo, "asDAO.insertAsInfoHist2");
	            
	            if ("C005".equals(curProcStatus)) {
	                continue;
	            }
	            
	            returnValue += asService.updateAsInfoAll(vo, request, null, adUserInfo);
	            
	            // ✅ 첫 건 처리 끝난 뒤부터는 work_time을 0으로 고정
	            if (isFirst) {
	                isFirst = false;
	                vo.setWork_time("0");
	            }
	            

	            // 답변 처리도 Service에서 하게 만들거나
	            // 여기서 유지하고 싶으면 유지
	            asService.insertAws(vo, request);

	            successList.add(asNo);

	        } catch (Exception e) {
	            failList.add(asNo);
	            continue;
	        }
	    }

	    script =
	        "parent.procReturn('batch'," +
	        "'" + String.join(",", successList) + "'," +
	        "'" + String.join(",", failList) + "','" +
	        pageType + "');";

	    return CommonExecute.execute(model, script);
	}
	
	
	
	/**
	 * AS 관리 - 조치이력 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsHistList.do")
	public void getAsHistList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		AsVO resultVO = asService.getSelectInfo(vo, "asDAO.getAsInfo") ;
		
		returnMap.put("resultVO", resultVO) ;
		
		if(resultVO != null) {
			returnMap.put("asHistList", asService.getList(vo, "asDAO.getAsHistList")) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * AS 관리 -  조치이력 수정
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/histProc.do")
	public void histProc(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		String returnCode = "" ; 
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		int returnValue = 0;
		if("updateHistActionContent".equals(vo.getPageType())) {
			returnValue = asService.updateAsHistAction(vo) ;
		} else if("deleteFileSeqHist".equals(vo.getPageType())) {
			returnValue = asService.updateAsHistFileSeq(vo) ;
			FileVO fileVO = new FileVO();
			if(!"0".equals(SsStringUtil.normalize(vo.getFile_seq(), "0"))) {
				fileVO.setAttach_seq(Integer.parseInt(vo.getFile_seq()));
				returnValue += commonFileService.deleteFileByAttachSeq(fileVO) ; 
			}
		}
		
		if(returnValue > 0) returnCode = "000" ;				
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
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
		
		String exl_title = "AS 관리" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setPageType("exl");
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		String[] procSelectArray =  vo.getProcSelect().split(",");
		vo.setProcSelectArray(procSelectArray);
	
		List<AsVO> resultList = asService.getList(vo, "asDAO.getAsList");
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		HSSFRow row = null ; 
		HSSFCell cell = null ; 
		
		String[] title = { "No" 
				, "접수번호" 
				, "하위작업" 
				, "처리상태" 
				, "접수일" 
				, "CRM코드"
				, "거래처명"
				, "A/S신청자 이름"
				, "접수경로"
				, "챗봇ID"
				, "문의유형"
				, "시스템(대)"
				, "시스템(소)" 
				, "중요도" 
				, "전화확인 완료"
				, "전화 부재중"
				, "전화 부재중 횟수"
				, "원인유형" 
				, "조치유형" 
				, "부서명"
				, "처리담당자"
				, "처리완료예정일"
				, "처리완료일"
				, "작업시간"
				, "처리구분"
				, "빌드순번"
				, "개발처리서(테스트케이스)"
				, "프로세스정의서"
				, "화면정의서"
				, "테이블정의서"
				, "기능분해도"
				, "인터페이스정의서"
				, "검수일"
				, "고객평가"
				, "요청내용"
				, "조치 및 처리 의견(내부직원만 확인가능)"
				, "내부직원 최신댓글내용"
				
				};
		String[] refColumn = { "rnum" 
				, "as_no" 
				, "cn_as_no" 
				, "proc_status_nm" 
				, "as_accept_dt" 
				, "cust_code"
				, "cust_kor_name"
				, "rl_apply_nm"
				, "accept_route_nm"
				, "chatbot_id"
				, "request_type_nm"
				, "service_cate_nm"
				, "inquiry_type_nm" 
				, "inportance_nm" 
				, "tel_confirm" 
				, "tel_absence" 
				, "tel_absence_cnt" 
				, "cause_type_nm" 
				, "action_type_nm" 
				, "dept_nm"
				, "emp_nm"
				, "as_proc_dt"
				, "as_complete_dt"
				, "work_time"
				, "proc_gubun_nm"
				, "proc_build_info"
				, "proc_test_info"
				, "proc_process_sp"
				, "proc_screen_sp"
				, "proc_table_sp"
				, "proc_function_sp"
				, "proc_interface_sp"
				, "star_state_date"
				, "star_state"
				, "call_content"
				, "action_content"
				, "w_content"
				
				};
		
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		rowNum++  ;
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
		}
		
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
				
				for(int a = 0 ; a < title.length ; a++){

					cell = row.createCell(a) ;
					String cellValue = "" ; 

					cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
//						
//						if(a == 0) cellValue = SsStringUtil.normalizeNull(temp.getRnum()) ; 
//						else if(a == 1) cellValue = SsStringUtil.normalizeNull(temp.getAs_no()) ;
//						else if(a == 2) cellValue = SsStringUtil.normalizeNull(temp.getCn_as_no()) ;
//						else if(a == 3) cellValue = SsStringUtil.normalizeNull(temp.getProc_status_nm()) ;
//						else if(a == 4) cellValue = SsStringUtil.normalizeNull(temp.getAccept_dt()) ;
//						else if(a == 5) cellValue = SsStringUtil.normalizeNull(temp.getCust_kor_name()) ;
//						else if(a == 6) cellValue = SsStringUtil.normalizeNull(temp.getService_cate_nm() + "/" + temp.getInquiry_type_nm()); //문의서비스
//						else if(a == 7) cellValue = SsStringUtil.normalizeNull(temp.getInportance_nm()) ;
//						else if(a == 8) cellValue = SsStringUtil.normalizeNull(temp.getCause_type_nm()) ;
//						else if(a == 9) cellValue = SsStringUtil.normalizeNull(temp.getAction_type_nm()) ;
//						else if(a == 10) cellValue = SsStringUtil.normalizeNull(temp.getEmp_nm()) ;
//						else if(a == 11) cellValue = SsStringUtil.normalizeNull(temp.getAws_cnt()) ;
//						else if(a == 12) cellValue = SsStringUtil.normalizeNull(temp.getStar_state_date()) ; //검수일 데이터 확인
//						else if(a == 13) cellValue = SsStringUtil.normalizeNull(temp.getStar_state()) ; //고객평가 데이터 확인
					
					cell.setCellValue(cellValue);
				}
			}
			
			String usrClient = request.getHeader("User-Agent") ; 
			
			exl_title = exl_title + ".xls" ; 
			
			if(usrClient.indexOf("MSIE 5.5") > -1){
				response.setHeader("Content-Disposition", "filename="+ new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			}else{
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader("Content-Disposition", "attachment;filename=" + new String(exl_title.getBytes("euc-kr"), "8859_1")+";");
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
					resultList.get(i).setW_content( resultList.get(i).getW_content().replace("\r\n", "<br>" ));	/*2021.07.18 이설아*/
					
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
	public String awsProc(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

	    List<FileVO> fileList = null;
	    int attach_seq = 0;

	    UserVO adUserInfo = session.getAttribute("adUserInfo") != null
	            ? (UserVO) session.getAttribute("adUserInfo")
	            : null;

	    int returnValue = 0;
	    String resultCode = "";

	    // delete 가 아니면 파일 업로드
	    if (!"delete".equals(vo.getPageType())) {
	        fileList = commonFileService.uploadFormFile(multiRequest, "as_answer");
	    }

	    // 업로드된 파일 처리
	    if (fileList != null && fileList.size() > 0) {
	        for (FileVO temp : fileList) {
	            if (temp.getAttach_tag_name().startsWith("uploadFile")) {

	                if (attach_seq == 0) {
	                    attach_seq = commonFileService.getMaxFileSeq();
	                    temp.setAttach_seq(attach_seq);
	                } else {
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

	    // 우선 현재 as_no 에 대해 기존 로직 수행
	    if ("insert".equals(vo.getPageType())) {
	        returnValue = asService.insertAws(vo, request);
	    } else if ("update".equals(vo.getPageType())) {
	        returnValue = asService.updateAws(vo, request);
	    } else if ("delete".equals(vo.getPageType())) {
	        returnValue = asService.deleteAws(vo, request);
	    }

	    // 1건이라도 성공하면 성공 코드
	    if (returnValue > 0) {
	        resultCode = "000";
	    } else {
	        resultCode = "001";
	    }

	    // ===============================
	    // as_no_link 에 있는 접수건에도 답변 복사 (답변 작성 시에만)
	    // ===============================
	    if ("insert".equals(vo.getPageType()) && returnValue > 0) {

	        String currentAsNo = vo.getAs_no() != null ? vo.getAs_no().trim() : "";
	        String linkStr = vo.getAs_no_link() != null ? vo.getAs_no_link().trim() : "";

	        if (!"".equals(linkStr)) {
	            String[] linkArr = linkStr.split(",");

	            for (String linkNoRaw : linkArr) {
	                if (linkNoRaw == null) continue;

	                String linkNo = linkNoRaw.trim();
	                if ("".equals(linkNo)) continue;

	                // 내 접수번호는 이미 insert 했으니 제외
	                if (linkNo.equals(currentAsNo)) continue;

	                AsVO linkVo = new AsVO();

	                // 복사할 값들 세팅
	                linkVo.setAs_no(linkNo);                     // 대상 접수번호
	                linkVo.setW_content(vo.getW_content());      // 동일한 답변 내용
	                linkVo.setW_gubun("A");
	                linkVo.setReg_id(vo.getReg_id());
	                linkVo.setAttach_seq(vo.getAttach_seq());    // 위에서 생성한 첨부파일 SEQ 공유
	                linkVo.setPageType("insert");

	                try {
	                    asService.insertAws(linkVo, request);
	                } catch (Exception e) {
	                    // 연관 건 중 일부 실패해도 로그인 화면이 터지지 않게 로그만 남김
	                    // 필요하면 logger 사용
	                    e.printStackTrace();
	                }
	            }
	        }
	    }

	    return CommonExecute.execute(model, "parent.awsProcReturn('" + resultCode + "');");
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
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		int result;
	    if ("ALL_LINKED".equals(vo.getDel_type())) {
	        result = asService.deleteAsProcAllLinked(vo, request);
	    } else {
	        result = asService.deleteAsProc(vo, request);
	    }

	    returnMap.put("resultCode", result > 0 ? "000" : "001");
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
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		
		returnMap.put("resultList", asService.getList(vo, "asDAO.getAsEmpList")) ;
		CommonExecute.returnJson(response, returnMap);
	}	
	
	/**
	 * AS 직원목록 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsEmpList2.do")
	public void getAsEmpList2(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		
		returnMap.put("resultList", asService.getList(vo, "asDAO.getAsEmpList2")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/ad/as/getUnprocessedAsList.do")
	public void getUnprocessedAsListAdmin(
	        @RequestParam("asGubunFlag") String asGubunFlag,
	        @RequestParam("as_str_dt") String asStrDt,
	        @RequestParam("as_end_dt") String asEndDt,
	        @RequestParam("search_text") String search_text,
	        HttpServletResponse response,
	        HttpSession session) throws Exception {

	    Map<String, Object> returnMap = new HashMap<>();
	    HashMap<String, String> param = new HashMap<>();

	    String userId = "";
	    if ("2".equals(asGubunFlag)) { // 나의AS 일 때만 사용
	        UserVO adUserInfo = (UserVO) session.getAttribute("adUserInfo");
	        if (adUserInfo != null) {
	            userId = adUserInfo.getEmp_no();
	        }
	    }

	    param.put("as_str_dt", asStrDt.replaceAll("/", ""));
	    param.put("as_end_dt", asEndDt.replaceAll("/", ""));
	    param.put("asGubunFlag", asGubunFlag);
	    param.put("user_id", userId);
	    param.put("search_text", search_text);

	    @SuppressWarnings("unchecked")
	    List<AsVO> list = (List<AsVO>) commonDAO.list(param, "asDAO.getUnprocessedAsListAdmin");
	    returnMap.put("resultList", list);

	    CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/as/getprocessedAsList.do")
	public void getprocessedAsListAdmin(
	        @RequestParam("as_str_dt") String asStrDt,
	        @RequestParam("as_end_dt") String asEndDt,
	        @RequestParam("search_text") String search_text,
	        HttpServletResponse response,
	        HttpSession session) throws Exception {

	    Map<String, Object> returnMap = new HashMap<>();
	    HashMap<String, String> param = new HashMap<>();
	    
	    String userId = "";
	    UserVO adUserInfo = (UserVO) session.getAttribute("adUserInfo");
	    if (adUserInfo != null) {
	        userId = adUserInfo.getEmp_no();
	    }
	    
	    param.put("as_str_dt", asStrDt.replaceAll("/", ""));
	    param.put("as_end_dt", asEndDt.replaceAll("/", ""));
	    param.put("user_id", userId);
	    param.put("search_text", search_text);

	    @SuppressWarnings("unchecked")
	    List<AsVO> list = (List<AsVO>) commonDAO.list(param, "asDAO.getprocessedAsListAdmin");
	    returnMap.put("resultList", list);

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
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		
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
	 * 배정구분 및 2차분류구분 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getTaskType.do")
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
	@RequestMapping(value = "/ad/as/getWorker.do")
	public void getWorker(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		AsVO resultList = null ;
		
		resultList = asService.getOneList(vo,"asDAO.getWorker") ;
		
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo",vo);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 처리담당자 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/getOperateList.do")
	public void getOperateList(@ModelAttribute("vo") OperateVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<OperateVO> resultList = null ;
		
		int totalCount = asService.getOperateCnt(vo,"asDAO.getOperateCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = asService.getOperateList(vo,"asDAO.getOperateList") ;
			vo.setJson_paging(vo.getJsonPaging("getOperateList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	
	/**
	 * 처리담당자 관리 - 처리담당자정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/getOperateInfo.do")
	public void getOperateInfo(@ModelAttribute("vo") OperateVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = asService.getOperateInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 운영정보 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/proc.do")
	public void operateProc(@ModelAttribute("vo") OperateVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;
		
		if("C011".equals(SsStringUtil.normalizeNull(vo.getRequest_type()))) {
			vo.setService_cate("P010") ;
		}
		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = asService.updateOperate(vo,request) ;	
		
		if (returnValue > 0) {
			returnMap.put("returnCode", "000");
		}else if(returnValue == -3) {
			returnMap.put("returnCode", "003");
		}else if(returnValue == -99) {
			returnMap.put("returnCode", "099");
		}

		CommonExecute.returnJson(response, returnMap);
	}
}

















