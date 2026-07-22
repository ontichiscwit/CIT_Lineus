package egovframework.com.comm.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.FrameworkServlet;

import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonMenuService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.controller.AdCustController;

public class MenuAuthFilter implements Filter{
	
	private static final Logger logger = LoggerFactory.getLogger(MenuAuthFilter.class);

	protected FilterConfig filterConfig = null ;

	@Override
	public void destroy() {
		this.filterConfig = null ;
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		try{
			HttpServletRequest req = (HttpServletRequest) request ;
			HttpServletResponse res = (HttpServletResponse) response ;
			res.setHeader("Content-Security-Policy", "frame-ancestors 'self' https://newsfe.cwit.co.kr:8443");
			
			HttpSession session = req.getSession() ;

			String pathUri = req.getRequestURI();
			String[] path = pathUri.split("/") ; 
			
			String sendRidirect = "" ; 

			boolean ajaxFlag = false ; 
			boolean adAjaxFlag = false ; 
			
			if("fr".equals(SsStringUtil.normalizeNull(req.getParameter("is_page_gbn")))){
				if("XMLHttpRequest".equals(req.getHeader("x-requested-with"))) ajaxFlag = true ;
			}
			
			UserVO frUserInfo = session.getAttribute("frUserInfo") != null  ? (UserVO) session.getAttribute("frUserInfo") : null ;
			
			String serverName = req.getServerName();
			
			if(pathUri.startsWith("/ad") && frUserInfo == null) {
				UserVO adUserInfo = session.getAttribute("adUserInfo") != null  ? (UserVO) session.getAttribute("adUserInfo") : null ;  
				if(!pathUri.startsWith("/ad/login")){
					if(adUserInfo == null)  sendRidirect = "/ad/login/form.do" ;
					
					if("XMLHttpRequest".equals(req.getHeader("x-requested-with"))) adAjaxFlag = true ;
					
					if("".equals(sendRidirect)) {
						// 접근 권한 체크
						List<String> acceptUrlList = (List<String>) session.getAttribute("acceptUrlList");
						
						if (isAccept(pathUri,acceptUrlList)){
						
							List<MenuVO> menuList = (List<MenuVO>) session.getAttribute("adUserMenuList");
							/**	메뉴 처리 부분	*/
							if(menuList != null && menuList.size() > 0) {
								req.setAttribute("MENULIST_FORLINEMAP", menuList);
								req.setAttribute("MENULIST", session.getAttribute("MENULIST"));
							}else {
								// System.out.println("null");
							}
							req.setAttribute("QUERYSTRING", (!"".equals(SsStringUtil.normalizeNull(req.getQueryString())) ? "?" + SsStringUtil.normalizeNull(req.getQueryString()) : ""));
						}else{
							if (adAjaxFlag){
								// ajax로 왔을때 권한 없음 표시
								res.setStatus(403);
								return;
							}
							sendRidirect = "/cm/error/view.do" ;
						}
						
						logger.debug("adAjaxFlag : " + adAjaxFlag);
						logger.debug("sendRidirect : " + sendRidirect);
					}
				}
			}else if(pathUri.startsWith("/fr")){
				
				
				if(!(pathUri.startsWith("/fr/login") || pathUri.startsWith("/fr/join") || pathUri.startsWith("/fr/agreement") || pathUri.startsWith("/fr/sso"))){
				    if(frUserInfo == null)  sendRidirect = "/fr/login/form.do" ;
				}
			
			}else if(pathUri.startsWith("/mb")){
				
				// 무조건 
				sendRidirect = "/cm/error/error404.do" ;
				
//				UserVO frUserInfo = session.getAttribute("frUserInfo") != null  ? (UserVO) session.getAttribute("frUserInfo") : null ;
//				
//				if(!(pathUri.startsWith("/mb/login"))){
//					if(frUserInfo == null)  sendRidirect = "/mb/login/form.do" ;
//				}
			}
			
			if(!"".equals(sendRidirect)){
				res.sendRedirect(sendRidirect);
				return;
			}
			
			req.setAttribute("CURRENT_MENU_URL", pathUri);
			req.setAttribute("NOW_PRI", path[2]);
			chain.doFilter(request, response);

		}catch(Exception e){
			logger.debug("MenuAuthFilter exception : ",e);
		}
	}

	private boolean isAccept(String pathUri, List<String> acceptUrlList) {
		
		logger.debug("user request url : " + pathUri);
		
		if (acceptUrlList == null || acceptUrlList.isEmpty()) return false;
		
		for (String acceptUrl : acceptUrlList){
			//logger.debug("user accepted url : " + acceptUrl);
			
			if (acceptUrl.equals(pathUri)) return true;
		}
		
		logger.debug("user request url has not Auth !!");
		
		return false;
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		this.filterConfig = arg0 ;
	}

}
