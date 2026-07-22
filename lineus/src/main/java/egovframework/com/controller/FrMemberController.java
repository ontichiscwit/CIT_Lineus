package egovframework.com.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.MemberService;

/**
 * @Class Name : FrMemberController.java
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
public class FrMemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(FrMemberController.class) ;
	
	@Autowired MemberService memberService ;
	
	/**
	 * 계정 관리 목록 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/member/list.do")
	public String list(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/member/list";
	}
	
	/**
	 * 계정 관리 목록 데이터
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/member/getList.do")
	public void getList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ; 
		
		if(userInfo != null) {
			vo.setErp_code(userInfo.getErp_code());
		}
		
		int totalCount = memberService.getSelectInt(vo , "memberDAO.getFrMemberListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("goList"));
			returnMap.put("resultList", memberService.getList(vo , "memberDAO.getFrMemberList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	

	/**
	 * 계정 관리 등록 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/member/form.do")
	public String form(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/member/form";
	}
	
	
	/**
	 * 계정 관리 등록 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/member/regist.do")
	public void registMember(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ; 
		String returnCode = "" ; 
		
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()) ;
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		logger.debug("emp_id",vo.getEmp_id());  
		
		vo.setReg_id(userInfo.getEmp_id());
		vo.setErp_code(userInfo.getErp_code());
		if(!"changeIndividual".equals(pageType)) vo.setEmp_grade("C002");
		
		if("insert".equals(pageType)) returnValue = memberService.registMemberInsert(vo) ;  					/**	저장		*/
		else if("update".equals(pageType)) returnValue = memberService.registMemberUpdate(vo) ;  		/**	수정		*/
		else if("passChange".equals(pageType)) returnValue = memberService.registMemberPassChange(vo) ;  	/**	거래처 고객 비번 초기화	*/
		else if("changeIndividual".equals(pageType)) returnValue = memberService.registMemberPUpdate(vo) ;  	/**	거래처 고객 개인정보수정 비번변경	*/
		
		
		if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue == -500) returnCode = "500" ;		/**	아이디 비밀번호를 확인해 주세요.*/
		else if(returnValue == -600) returnCode = "600" ;		/**	비밀번호 체계 : 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요.	*/ 				
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
			
		returnMap.put("returnCode", returnCode) ; 
		returnMap.put("pageType", pageType) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 개인정보 수정
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/member/form2.do")
	public String form2(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/member/form2";
	}
	
	@RequestMapping(value = "/fr/member/checkId.do")
	public void checkId(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		String returnCode = "1" ;
		
		try{
			int result = memberService.custErpEmpId(vo);
			
			if (result == 0) returnCode = "0";
			
		}catch(Exception e){
			logger.debug("",e);  
			returnCode = "999" ;
		}
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
}
