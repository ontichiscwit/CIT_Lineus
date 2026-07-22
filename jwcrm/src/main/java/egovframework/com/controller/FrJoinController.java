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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.LoginService;
import egovframework.com.service.MemberService;

/**
 * @Class Name : FrJoinController.java
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
public class FrJoinController {
	
	private static final Logger logger = LoggerFactory.getLogger(FrJoinController.class) ;
	
	@Autowired MemberService memberService ; 
	
	/**
	 * 회원가입 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value = "/fr/join/form.do")
	public String form(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		
		return "fr/join/form";
	}
	
	/**
	 * 거래처 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value = "/fr/join/getCustInfo.do")
	public void getCustInfo(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultVO", memberService.getSelectOne(vo , "memberDAO.getJoinCustInfo")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	
	/**
	 * 거래처 정보 조회(이름조회)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value = "/fr/join/getCustList.do")
	public void getCustList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultList", memberService.getList(vo , "memberDAO.getJoinCustList")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	
	/**
	 * 회원가입 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value = "/fr/join/registJoin.do")
	public void registJoin(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		int returnValue = 0 ; 
		String returnCode = "" ; 
		
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()) ;
		String empGrade = SsStringUtil.normalizeNull(vo.getEmp_grade()) ;
		
		
		if("insert".equals(pageType) && "C001".equals(empGrade)) {
			vo.setUse_type("C004");
			returnValue = memberService.registMemberInsert(vo) ; 
		}
		
		if("insert".equals(pageType) && "C002".equals(empGrade)) {
			vo.setUse_type("C006");
			returnValue = memberService.registMemberInsert(vo) ; 
		}
		
		
		if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue == -500) returnCode = "500" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0 && "C001".equals(empGrade)) returnCode = "000" ;/**	정상처리 되었습니다.				*/ 
		else if(returnValue > 0 && "C002".equals(empGrade)) returnCode = "002" ;/**	정상처리 되었습니다.				*/ 
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
}
 