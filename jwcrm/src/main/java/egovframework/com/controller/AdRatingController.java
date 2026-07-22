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
import egovframework.com.service.MemberService;

/**
 * @Class Name : AdRatingController.java
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
public class AdRatingController {
	private static final Logger logger = LoggerFactory.getLogger(AdRatingController.class) ;
	
	@Autowired MemberService memberService ; 
	
	/**
	 * 시스템 관리 - 고객등급 관리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/rating/list.do")
	public String list(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "ad/rating/list";
	}
	
	/**
	 * 시스템 관리 - 채권등급 관리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/rating/list2.do")
	public String list2(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "ad/rating/list2";
	}
	
	/**
	 * 시스템 관리 - 고객등급 정보 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/rating/getRatingInfo.do")
	public void getRatingInfo(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		returnMap.put("resultList", memberService.getList(vo, "memberDAO.getRatingList")) ; 
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 시스템 관리 - 고객등급 정보 저장
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/rating/registRating.do")
	public void registRating(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ;
		
		// 권한 확인 하여 권한 없을시 메시지 처리
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		
		if (!"C001".equals(adUserInfo.getEmp_grade())){
			returnMap.put("returnCode", "gradeNot");
		}else{
			returnValue = memberService.registRatingInfo(vo) ;  
			if(returnValue > 0) returnMap.put("returnCode", "000") ;
			else returnMap.put("returnCode", "999");
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
}
