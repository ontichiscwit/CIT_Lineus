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

import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.service.AsService;
import egovframework.com.service.LoginService;

/**
 * @Class Name : MbAsController.java
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
public class MbAsController {
	
	private static final Logger logger = LoggerFactory.getLogger(MbAsController.class) ;
	
	@Autowired AsService asService ;
	
	/**
	 * 메인화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mb/as/main.do")
	public String main(@ModelAttribute("vo") AsVO vo, HttpServletRequest request) throws Exception {
		return "mb/as/main";
	}
	
	/**
	 * 등록화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mb/as/form.do")
	public String form(@ModelAttribute("vo") AsVO vo, HttpServletRequest request) throws Exception {
		return "mb/as/form";
	}

	/**
	 * 목록 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mb/as/list.do")
	public String list(@ModelAttribute("vo") AsVO vo, HttpServletRequest request) throws Exception {
		return "mb/as/list";
	}
	
	/**
	 * A/S - 목록 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mb/as/getAsList.do")
	public void getAsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		vo.setCust_code(userInfo.getCust_code());
		returnMap.put("resultList", asService.getList(vo,"asDAO.getAsMbList")) ;
		CommonExecute.returnJson(response, returnMap);
	}
}
