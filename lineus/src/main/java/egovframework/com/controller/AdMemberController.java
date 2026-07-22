package egovframework.com.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.CustVO;
import egovframework.com.service.MemberService;

/**
 * @Class Name : AdMemberController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2018.11.23	김민지		           최초생성
 *
 * @author 기업운영팀 
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by 중외정보기술 All right reserved.
 */

@Controller
public class AdMemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdMemberController.class) ;
	
	@Autowired MemberService memberService ; 
	
	/**
	 * 계정관리 - 거래처 직원 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/list.do")
	public String list(@ModelAttribute("vo") UserVO vo, Model model, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO sUser = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		model.addAttribute("vo", vo);
		model.addAttribute("su", sUser);
		
		return "ad/member/list";
	}
	
	/**
	 * 계정관리 - 사원 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/list2.do")
	public String list2(@ModelAttribute("vo") UserVO vo, Model model, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO sUser = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		model.addAttribute("vo", vo);
		model.addAttribute("su", sUser);
		
		return "ad/member/list2";
	}
	
	/**
	 * 계정관리 - 거래처 직원 등록/ 수정
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/form.do")
	public String form(@ModelAttribute("vo") UserVO vo, Model model, HttpServletRequest request, HttpSession session) throws Exception {
		UserVO sUser = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		model.addAttribute("vo", vo);
		model.addAttribute("su", sUser);
		return "ad/member/form";
	}
	
	/**
	 * 계정관리 - 직원 등록/ 수정
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/form2.do")
	public String form2(@ModelAttribute("vo") UserVO vo, Model model, HttpServletRequest request, HttpSession session) throws Exception {
		UserVO sUser = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		model.addAttribute("vo", vo);
		model.addAttribute("su", sUser);
		return "ad/member/form2";
	}
	
	/**
	 * 계정관리 - 개인정보 수정
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/form3.do")
	public String form3(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "ad/member/form3";
	}
	
	/**
	 * 계정관리 - 거래처 계정 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getMemberList.do")
	public void getMemberList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
			
		/**	parameter 설정	*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		int totalCount = memberService.getSelectInt(vo , "memberDAO.getMemberListCnt") ;
		
		if(totalCount>  0) {
			logger.debug("pageSize : " + vo.getPageSize());
			vo.setPaging(totalCount);
			vo.setJson_paging(vo.getJsonPaging("goList"));
			returnMap.put("resultList", memberService.getList(vo , "memberDAO.getMemberList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 사원 계정 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getEmpList.do")
	public void getEmpList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
			
		/**	parameter 설정	*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		int totalCount = memberService.getSelectInt(vo , "memberDAO.getEmpListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("goList"));
			returnMap.put("resultList", memberService.getList(vo , "memberDAO.getEmpList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 거래처 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getCustList.do")
	public void getCustList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		
		/**	parameter 설정	*/
		int totalCount = memberService.getSelectInt(vo , "memberDAO.getCustListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("custList"));
			returnMap.put("resultList", memberService.getList(vo , "memberDAO.getCustList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
		
	/**
	 * 계정관리 - 직원조회 레이어 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getPostList.do")
	public void getPostList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		
		/**	parameter 설정	*/
		int totalCount = memberService.getSelectInt(vo , "memberDAO.getPostListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("custList"));
			returnMap.put("resultList", memberService.getList(vo , "memberDAO.getPostList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 거래처 정보조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getCustInfo.do")
	public void getCustInfo(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultVO", memberService.getSelectOne(vo , "memberDAO.getCustInfo")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 거래처 정보조회2
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getCustInfo2.do")
	public void getCustInfo2(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultVO", memberService.getSelectOne(vo , "memberDAO.getCustInfo2")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 거래처 회원 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/registMember.do")
	public void registMember(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ; 
		String returnCode = "" ; 
		
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()) ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		
		if("change".equals(pageType)) returnValue = memberService.registMemberChange(vo) ;					/**	탈퇴처리	*/  
		else if("passChange".equals(pageType)) returnValue = memberService.registMemberPassChange(vo) ;  	/**	거래처 고객 비번 초기화	*/
		else if("insert".equals(pageType)) returnValue = memberService.registMemberInsert(vo) ;  			/**	저장		*/
		else if("update".equals(pageType)) returnValue = memberService.registMemberUpdate(vo) ;  			/**	수정		*/
		
		else if("erpChange".equals(pageType)) returnValue = memberService.registErpChange(vo) ;  			/**	직원탈퇴	*/
		else if("erpPassChange".equals(pageType)) returnValue = memberService.registErpPassChange(vo) ;  	/**	직원 비번 초기화	 */
		else if("erpinsert".equals(pageType)) returnValue = memberService.registErpInsert(vo) ;  			/**	직원 등록	*/
		else if("erpupdate".equals(pageType)) returnValue = memberService.registErpUpdate(vo) ;  			/**	직원 수정	*/
		else if("erpIndividual".equals(pageType)) returnValue = memberService.registErpUpdate2(vo) ;  		/**	개인정보수정 비번변경 및 직원 수정 	*/
		
		if(returnValue == -100) returnCode = "100" ;			/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue == -500) returnCode = "500" ;		/**	현재 비밀번호를 정확히 입력해 주세요.	*/
		else if(returnValue == -600) returnCode = "600" ;		/**	비밀번호 체계 : 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요.	*/ 				
		else if(returnValue == -700) returnCode = "700" ;		/**	최근에 사용한 비밀번호는 사용할 수 없습니다.*/ 				
		else if(returnValue > 0) returnCode = "000" ;			/**	정상처리 되었습니다.				*/ 
			
		returnMap.put("returnCode", returnCode) ; 
		returnMap.put("pageType", pageType) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 계정관리 - 거래처 회원 엑셀 다운로드
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/exl.do")
	public void exl(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		String exl_title = "거래처회원관리" ; 
		
		vo.setPageType("exl");
		/**	parameter 설정	*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		List<UserVO> resultList = memberService.getList(vo , "memberDAO.getMemberList");
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		
		HSSFRow row = null ; 
		HSSFCell cell = null ; 
		
		String[] title = { "No" , "회원유형" , "아이디" , "이름" , "소속거래처" , "근무부서명" , "직책" , "연락처" , "이메일" , "계정상태" , "계정생성일"} ;
		
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		rowNum++  ;
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
		}
		
		if(resultList != null && resultList.size() > 0){
			for(int i = 0 ; i < resultList.size() ; i++){
				UserVO temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				for(int a = 0 ; a < title.length ; a++){
					cell = row.createCell(a) ;
					String cellValue = "" ; 
					
					if(a == 0) cellValue = SsStringUtil.normalizeNull(temp.getRnum()) ; 
					else if(a == 1) cellValue = SsStringUtil.normalizeNull(temp.getEmp_grade_name()) ;
					else if(a == 2) cellValue = SsStringUtil.normalizeNull(temp.getEmp_id()) ;
					else if(a == 3) cellValue = SsStringUtil.normalizeNull(temp.getEmp_name()) ;
					else if(a == 4) cellValue = SsStringUtil.normalizeNull(temp.getCust_kor_name()) ;
					else if(a == 5) cellValue = SsStringUtil.normalizeNull(temp.getDept_name()) ;
					else if(a == 6) cellValue = SsStringUtil.normalizeNull(temp.getDept_grade());
					else if(a == 7) cellValue = SsStringUtil.normalizeNull(temp.getTel_no()) ;
					else if(a == 8) cellValue = SsStringUtil.normalizeNull(temp.getEmail()) ;
					else if(a == 9) cellValue = SsStringUtil.normalizeNull(temp.getUse_type_name()) ;
					else if(a == 10) cellValue = SsStringUtil.normalizeNull(temp.getJoin_date()) ;
					
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
	 * 계정관리 - 직원 엑셀 다운로드
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/exl2.do")
	public void exl2(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		String exl_title = "사원관리" ; 
		
		vo.setPageType("exl");
		/**	parameter 설정	*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", ""));
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		List<UserVO> resultList = memberService.getList(vo , "memberDAO.getEmpList") ; 
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		
		HSSFRow row = null ; 
		HSSFCell cell = null ; 
		
		String[] title = { "No" , "직원등급" , "아이디" , "이름" , "부서명" , "연락처" , "이메일" , "사용여부"} ;
		
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		rowNum++  ;
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
		}
		
		if(resultList != null && resultList.size() > 0){
			for(int i = 0 ; i < resultList.size() ; i++){
				UserVO temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				for(int a = 0 ; a < title.length ; a++){
					cell = row.createCell(a) ;
					String cellValue = "" ; 
					
					if(a == 0) cellValue = SsStringUtil.normalizeNull(temp.getRnum()) ; 
					else if(a == 1) cellValue = SsStringUtil.normalizeNull(temp.getEmp_grade_name()) ;
					else if(a == 2) cellValue = SsStringUtil.normalizeNull(temp.getEmp_no()) ;
					else if(a == 3) cellValue = SsStringUtil.normalizeNull(temp.getEmp_nm()) ;
					else if(a == 4) cellValue = SsStringUtil.normalizeNull(temp.getDept_nm()) ;
					else if(a == 5) cellValue = SsStringUtil.normalizeNull(temp.getMobile_no()) ;
					else if(a == 6) cellValue = SsStringUtil.normalizeNull(temp.getE_mail());
					else if(a == 7) cellValue = SsStringUtil.normalizeNull(temp.getUse_yn()) ;
					
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
	 * 계정관리 - 직원 정보조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getPostInfo.do")
	public void getPostInfo(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultVO", memberService.getSelectOne(vo , "memberDAO.getPostInfo")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 부서코드 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getPostSelect.do")
	public void getPostSelect(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultList", memberService.getList(vo , "memberDAO.getPostSelect")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 등록된 거래처 직원 정보
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getMemberInfo.do")
	public void getMemberInfo(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultVO", memberService.getSelectOne(vo , "memberDAO.getMemberInfo")) ;
		//returnMap.put("tab1List", memberService.getList(vo , "memberDAO.getMemberSubList")) ;
		//returnMap.put("tab2List", memberService.getList(vo , "memberDAO.getMemberAsList")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 등록된 직원 정보
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getErpInfo.do")
	public void getErpInfo(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultVO", memberService.getSelectOne(vo , "memberDAO.getErpInfo")) ;
		returnMap.put("tab1List", memberService.getList(vo , "memberDAO.getErpAsList")) ;
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * AS관리 AS 신청자 이름 검색
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getCustEmpList.do")
	public void getCustEmpList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		
		/**	parameter 설정	*/
		int totalCount = memberService.getSelectInt(vo , "memberDAO.getCustEmpCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("empList"));
			returnMap.put("resultList", memberService.getList(vo , "memberDAO.getCustEmpList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	
	/**
	 *  A/S관리 > 고객사정보 > A/S신청자 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/member/getEmpInfo.do")
	public void getEmpInfo(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultVO", memberService.getSelectOne(vo , "memberDAO.getEmpInfo")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
}
