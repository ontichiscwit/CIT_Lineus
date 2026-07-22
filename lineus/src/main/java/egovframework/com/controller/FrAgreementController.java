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
public class FrAgreementController{
	
	@Autowired LoginService loginService ; 
	
	@RequestMapping(value = "/fr/agreement/form.do")
	public String list(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/agreement/form";
	}
	
	@RequestMapping(value = "/fr/agreement/form2.do")
	public String form2(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/agreement/form2";
	}
	
	@RequestMapping(value = "/fr/agreement/form3.do")
	public String form3(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/agreement/form3";
	}
	
	
	/**
	 * 약관동의 처리
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/agreement/agree.do")
	public void proc(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO userInfo = (UserVO) session.getAttribute("tempUserInfo");
		
		if(userInfo != null){
			userInfo.setUse_agree(vo.getUse_agree());
			userInfo.setPerdata_agree(vo.getPerdata_agree());
			userInfo.setSms_agree(vo.getSms_agree());
			userInfo.setEmail_agree(vo.getEmail_agree());
			userInfo.setUse_type("C001");
			session.setAttribute("frUserInfo", userInfo);
			returnMap.put("returnFlag" , "000") ;
			loginService.updateAgreement(userInfo);
		}else{
			returnMap.put("returnFlag" , "비정상적인 접근 입니다.") ;  
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
}