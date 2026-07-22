package egovframework.com.controller;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.model.RoleVO;
import egovframework.com.comm.model.UserUtilVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.LoginUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.LoginService;

/**
 * @Class Name : AdLoginController.java
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
public class AdLoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdLoginController.class) ;
	
	@Autowired LoginService loginService ;
	
	@Autowired CommonDao commonDao;
	
	/**
	 * 로그인 화면 호출 - O
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/login/form.do")
	public String form(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession() ; 
		session.invalidate();  
		
		return "ad/login/form";
	}
	
	/**
	 * 로그아웃 처리 - O
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/login/out.do")
	public void removeOut(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession() ; 
		session.invalidate(); 
		
		response.sendRedirect("/ad/login/form.do");
	}
	

	
	/**
	 * 관리자 로그인 처리 - O
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/ad/login/proc.do")
	public void proc(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		loginService.selectUserInfo(vo) ;
		
		List<UserVO> userList = vo.getOUTCURSOR() ; 
		
		if(userList != null && userList.size() > 0){
			UserVO userVO = userList.get(0);
			
			if("N".equals(SsStringUtil.normalizeNull(userVO.getUse_yn()))) returnMap.put("returnFlag" , "002") ; /**	사용할수 없는 아이디 입니다.	*/
			else {
				HttpSession session = request.getSession(); 
				session.setAttribute("adUserInfo", userVO);
				
				// 세션에 사용자 메뉴 등록하기
				List<MenuVO> menuList = (List<MenuVO>) commonDao.list(userVO, "loginDAO.getAdUserMenuList");
				
				StringBuffer sb = new StringBuffer() ; 
				String p_menu_code = "0000" ; 
				
				for(int i = 0 ;!menuList.isEmpty() && i < menuList.size() ; i++) {
					MenuVO temp = menuList.get(i) ; 
					
					if("0000".equals(p_menu_code) && "0000".equals(SsStringUtil.normalizeNull(temp.getP_menu_code()))) {
						if(i > 0) sb.append("</li>") ; 
						sb.append("<li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a>") ; 
					} else if("0000".equals(p_menu_code) && !"0000".equals(SsStringUtil.normalizeNull(temp.getP_menu_code()))) {
						sb.append("<ul style=\"display:none;\"><li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a></li>") ;
					} else if(!"0000".equals(p_menu_code) && "0000".equals(SsStringUtil.normalizeNull(temp.getP_menu_code()))) {
						sb.append("</ul></li><li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a>") ;
					}else {
						sb.append("<li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a></li>") ;
					}
					
					p_menu_code = SsStringUtil.normalizeNull(temp.getP_menu_code()) ; 
				}
				
				// 접근 가능 메뉴리스트 셋팅
				session.setAttribute("adUserMenuList",menuList);
				// 메뉴 tag 셋팅
				session.setAttribute("MENULIST",sb.toString());
				// 접근 가능 url 셋팅
				session.setAttribute("acceptUrlList", commonDao.list(userVO, "loginDAO.getAdAcceptUrl"));
				// 사용중인 ROLE 셋팅
				List<RoleVO> roleList = (List<RoleVO>) commonDao.list(userVO, "loginDAO.getRoleUserByEmpNo");
				session.setAttribute("roleList", roleList);
				
				returnMap.put("returnFlag" , "000");			/**	정상 처리	*/
				
				String defaultUrl = "/ad/as/list.do";
				
				if (hasRole("01_DASHBOARD_ADMIN",roleList)){
					defaultUrl = "/ad/main/list.do";
				}else if (hasRole("02_DASHBOARD_SALES",roleList)){
					defaultUrl = "/ad/main/list.do";
				}else if (hasRole("03_DASHBOARD_AS",roleList)){
					defaultUrl = "/ad/main/list1.do";
				}else if (hasRole("04_DASHBOARD_MANAGE",roleList)){
					defaultUrl = "/ad/main/list2.do";
				}else if (hasRole("05_DASHBOARD_USER",roleList)){
					defaultUrl = "/ad/main/list1.do";
				}
				
				// 초기 기본 접근 URL 등록
				session.setAttribute("defaultUrl", defaultUrl);
				
				returnMap.put("returnUrl" , defaultUrl);
			}
		}else{
			returnMap.put("returnFlag" , "001") ; 				/**	아이디 혹은 비밀번호를 확인해 주세요.	*/  
		}
		
		response.setHeader("Access-Control-Allow-Origin", "https://newsfe.cwit.co.kr:8443");
	    response.setHeader("Access-Control-Allow-Credentials", "true");
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * CIT 통합로그인 (관리자 로그인) 처리 
	 * 2019.07.16
	 * 김민지
	 * */
	@RequestMapping(value="/ad/login/OnePassOn.do")
	public String loginCit(@RequestBody UserUtilVO userVO, HttpServletRequest request , HttpServletResponse response)throws Exception {
		
		UserUtilVO paramVO = new UserUtilVO();
		paramVO.setUrl("https://dev.cwit.co.kr:8443/checkAuth");
		paramVO.setToken(userVO.getAccess_token().getToken());
		paramVO.setRefreshToken(userVO.getAccess_token().getRefreshToken());
				
		LoginUtil loginUtil = new LoginUtil();
		UserUtilVO resultVO = loginUtil.checkAuth(paramVO);	
	
	    String result = "";
		
		if(resultVO.getStatus() != null && resultVO.getStatus().equals("fail")){
			//로그인화면 로그인 실패
			Map<String , Object> returnMap = new HashMap<String , Object>() ; 
			
			String defaultUrl = "/ad/login/form.do";
			returnMap.put("returnFlag" , "001") ;
			returnMap.put("returnUrl" , defaultUrl);
			
			result = "redirect:/ad/login/form.do";
			
		}else if(resultVO.getId() != null){  
			//로그인처리 로그인 성공
			
			UserVO vo = new UserVO();
			Map<String , Object> returnMap = new HashMap<String , Object>() ; 
			vo.setEmp_no(resultVO.getId());
			
			loginService.selectUserInfoById(vo);
			List<UserVO> userList = vo.getOUTCURSOR() ; 
			
			if(userList != null && userList.size() > 0){
				UserVO userVO2 = userList.get(0);
				
				if("N".equals(SsStringUtil.normalizeNull(userVO2.getUse_yn()))) returnMap.put("returnFlag" , "002") ; /**	사용할수 없는 아이디 입니다.	*/
				else {
					
					HttpSession session = request.getSession(); 
					session.setAttribute("adUserInfo", userVO2);
					
					// 세션에 사용자 메뉴 등록하기
					List<MenuVO> menuList = (List<MenuVO>) commonDao.list(userVO2, "loginDAO.getAdUserMenuList");
					
					StringBuffer sb = new StringBuffer() ; 
					String p_menu_code = "0000" ; 
					
					for(int i = 0 ;!menuList.isEmpty() && i < menuList.size() ; i++) {
						MenuVO temp = menuList.get(i) ; 
						
						if("0000".equals(p_menu_code) && "0000".equals(SsStringUtil.normalizeNull(temp.getP_menu_code()))) {
							if(i > 0) sb.append("</li>") ; 
							sb.append("<li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a>") ; 
						} else if("0000".equals(p_menu_code) && !"0000".equals(SsStringUtil.normalizeNull(temp.getP_menu_code()))) {
							sb.append("<ul style=\"display:none;\"><li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a></li>") ;
						} else if(!"0000".equals(p_menu_code) && "0000".equals(SsStringUtil.normalizeNull(temp.getP_menu_code()))) {
							sb.append("</ul></li><li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a>") ;
						}else {
							sb.append("<li><a href=\""+SsStringUtil.normalize(temp.getMenu_url(), "#")+"\">"+SsStringUtil.normalizeNull(temp.getMenu_nm())+"</a></li>") ;
						}
						
						p_menu_code = SsStringUtil.normalizeNull(temp.getP_menu_code()) ; 
					}
					
					// 접근 가능 메뉴리스트 셋팅
					session.setAttribute("adUserMenuList",menuList);
					// 메뉴 tag 셋팅
					session.setAttribute("MENULIST",sb.toString());
					// 접근 가능 url 셋팅
					session.setAttribute("acceptUrlList", commonDao.list(userVO2, "loginDAO.getAdAcceptUrl"));
					// 사용중인 ROLE 셋팅
					List<RoleVO> roleList = (List<RoleVO>) commonDao.list(userVO2, "loginDAO.getRoleUserByEmpNo");
					session.setAttribute("roleList", roleList);
					
					returnMap.put("returnFlag" , "000");			/**	정상 처리	*/
					
					String defaultUrl = "/ad/as/list.do";
					
					if (hasRole("01_DASHBOARD_ADMIN",roleList)){
						defaultUrl = "/ad/main/list.do";
					}else if (hasRole("02_DASHBOARD_SALES",roleList)){
						defaultUrl = "/ad/main/list.do";
					}else if (hasRole("03_DASHBOARD_AS",roleList)){
						defaultUrl = "/ad/main/list1.do";
					}else if (hasRole("04_DASHBOARD_MANAGE",roleList)){
						defaultUrl = "/ad/main/list2.do";
					}else if (hasRole("05_DASHBOARD_USER",roleList)){
						defaultUrl = "/ad/main/list1.do";
					}
					
					// 초기 기본 접근 URL 등록
					session.setAttribute("defaultUrl", defaultUrl);
					returnMap.put("returnUrl" , defaultUrl);
					
					result = "redirect:" + defaultUrl;
					
				}
			
			
			}else {
				
				result = "redirect:/ad/login/form.do";
				returnMap.put("returnFlag" , "001") ; 				/**	아이디 혹은 비밀번호를 확인해 주세요.	*/  
				
			}
			
		}
		
		return result;
	} 
	
	
	
	
	
	
	
	
	
	
	
	
	private boolean hasRole(String roleCode, List<RoleVO> roleList) {
		if (roleCode == null) return false;
		for (RoleVO vo : roleList){
			if (roleCode.equals(vo.getRole_code())) return true;
		}
		
		return false;
	}

	/**
	 * 계정찾기 - O
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/login/search.do")
	public String search(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession() ; 
		session.invalidate();  
		
		return "ad/login/search";
	}
	
	/**
	 * 관리자 계정찾기 - O
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/login/searchProc.do")
	public void searchProc(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		loginService.selectSearchInfo(vo) ;
		
		List<UserVO> userList = vo.getOUTCURSOR() ; 
		
		if(userList != null && userList.size() > 0){
			UserVO userVO = userList.get(0) ; 
			
			if("N".equals(SsStringUtil.normalizeNull(userVO.getUse_yn()))) returnMap.put("returnFlag" , "002") ; /**	사용할수 없는 아이디 입니다.	*/
			else {
				HttpSession session = request.getSession() ; 
				session.setAttribute("adUserInfo", userVO);
				returnMap.put("returnFlag" , "000") ;			/**	정상 처리	*/
			}
		}else{
			returnMap.put("returnFlag" , "001") ; 				/**	일치 하는 정보가 없습니다.	*/  
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 관리자 계정찾기 - 패스워드변경 처리
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/login/proc2.do")
	public void passProc(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		int returnValue = loginService.updatePass(vo); 
		
		if(returnValue > 0){
			returnMap.put("returnFlag" , "000") ;			/**	정상 처리	*/
		}else{
			returnMap.put("returnFlag" , "001") ; 		/**	일치 하는 정보가 없습니다.	*/  
		}
		CommonExecute.returnJson(response, returnMap);
		
	}
	
	/**
	 * 찾기실패
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/login/fail.do")
	public String fail(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession() ; 
		session.invalidate();  
		
		return "ad/login/fail";
	}
}
