package egovframework.com.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.service.LoginService;

@Controller
public class FrChattingController{
	
	@Autowired LoginService loginService ; 
	
	@RequestMapping(value = "/fr/chatting/form.do")
	public String list(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/chatting/form";
	}
	
}