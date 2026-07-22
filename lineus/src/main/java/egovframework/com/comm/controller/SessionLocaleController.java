package egovframework.com.comm.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

@Controller
public class SessionLocaleController {
	
	@RequestMapping(value = "/comm/setChangeLocale.do")
	public String changeLocale(@RequestParam(required=false) String locale ,ModelMap model , HttpServletRequest request, HttpServletResponse response){
		
		HttpSession session = request.getSession() ; 
		
		Locale locales = null ; 
		
		if(locale.matches("ko")) locales = Locale.KOREAN ; 
		else locales = Locale.ENGLISH ; 
		
		session.setAttribute("LOCALE", locales);
		session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locales);
		
		String redirectURL = "redirect:" + request.getHeader("referer") ; 
		
		
		
		return redirectURL ; 
	}
}
