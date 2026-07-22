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

/**
 * @Class Name : MbLoginController.java
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
public class MbLoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(MbLoginController.class) ;
	
	@Autowired LoginService loginService ; 
	/**
	 * 로그인 화면 호출 - O
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mb/login/form.do")
	public String form(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession() ; 
		session.invalidate();  
		
		return "mb/login/form";
	}
	
	/**
	 * 개인정보 이용방침
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mb/policy/list.do")
	public String list(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "mb/policy/list";
	}
	
	/**
	 * 이용약관
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mb/policy/list2.do")
	public String list2(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "mb/policy/list2";
	}
}
