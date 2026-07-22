package egovframework.com.comm.util;

import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;

import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.controller.BoardController;

public class CommonExecute {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonExecute.class) ;
	
	public static String execute(ModelMap model, String script) {
		model.addAttribute("script", script);
		return "cm/proc/execute";
	}
	
	public static void returnJson( HttpServletResponse response , Map<String , Object> returnMap) throws Exception {
		String res_data = "" ; 
		try{
			ObjectMapper om = new ObjectMapper() ;
			res_data = om.writeValueAsString(returnMap) ; 
		}catch(Exception e){
			e.printStackTrace();  
		}finally{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter pw = response.getWriter() ; 
			pw.print(res_data);
			pw.flush();  
			pw.close();
		}
	}
	
	@SuppressWarnings("unchecked")
	public static String returnLineMap(HttpServletRequest request) throws Exception {
		
		StringBuffer sb = new StringBuffer() ; 
		// MENULIST_FORLINEMAP
		
		List<MenuVO> menuList = request.getAttribute("MENULIST_FORLINEMAP") != null ? (List<MenuVO>) request.getAttribute("MENULIST_FORLINEMAP") : null ;
		
		if(menuList != null && menuList.size() > 0) {
			String pathUri = (String)request.getAttribute( "javax.servlet.forward.request_uri" );
			String[] path = pathUri.split("/") ;
			String menu_nm = "" ; 
			String menu_url = "" ;
			
			for(int i = 0 ; i < menuList.size() ; i++) {
				if (pathUri != null && pathUri.equals(menuList.get(i).getMenu_url())){
					menu_nm = menuList.get(i).getMenu_nm();
					menu_url = menuList.get(i).getMenu_url();
				}
//				System.out.println("temp : " + menuList.get(i).getMenu_url());
			}
			
//			for(int i = 0 ; i < menuList.size() ; i++) {
//				MenuVO temp = menuList.get(i) ;
//				
//				if("".equals(SsStringUtil.normalizeNull(temp.getMenu_url()))) continue ;
//				
//				
//				
//				if(temp.getMenu_url().indexOf("/" + path[2]) != -1) {
//					if("rating".equals(path[2]) || "stat".equals(path[2])) {
//						if(temp.getMenu_url().indexOf("/" + path[3]) != -1) {
//							menu_nm = temp.getMenu_nm() ; 
//							menu_url = temp.getMenu_url() ;
//							break ;
//						}
//						 
//					}else {
//						menu_nm = temp.getMenu_nm() ; 
//						menu_url = temp.getMenu_url() ;
//						break ; 
//					}
//				}
//			}
			
			String css_name = "tit_ico_customer" ;
			
			if("as".equals(path[2])) css_name = "tit_ico_as" ; 
			else if("member".equals(path[2])) css_name = "tit_ico_admin" ; 
			else if("notice".equals(path[2]) || "cdown".equals(path[2])) css_name = "tit_ico_notice" ; 
			else if("faq".equals(path[2])) css_name = "tit_ico_faq" ; 
			else if("patch".equals(path[2])) css_name = "tit_ico_patch" ; 
			else if("down".equals(path[2])) css_name = "tit_ico_download" ; 
			else if("sms".equals(path[2])) css_name = "tit_ico_sms" ; 
			else if("stat".equals(path[2])) css_name = "tit_ico_graph" ; 
			
			
			sb.append("<h2 class=\""+css_name+"\">"+menu_nm+"</h2>") ; 
			sb.append("<div class=\"location\">") ; 
			sb.append("<a href=\"/ad/main/list.do\" class=\"home\">Home</a>") ; 
			
			if("notice".equals(path[2]) || "faq".equals(path[2]) || "down".equals(path[2]) || "patch".equals(path[2])) {
				sb.append("<a href=\"#\" class=\"depth\">게시판 관리</a>") ;
			}else if("rating".equals(path[2]) || "code".equals(path[2]) || "sms".equals(path[2])  || "system".equals(path[2])) {
					sb.append("<a href=\"#\" class=\"depth\">시스템 관리</a>") ;
			}else if("stat".equals(path[2])) {
				sb.append("<a href=\"#\" class=\"depth\">통계분석</a>") ;
			}else if ("as".equals(path[2])) {
				sb.append("<a href=\"#\" class=\"depth\">A/S관리</a>") ;
			}
			 
			sb.append("<a href=\""+menu_url+"\" class=\"depth\"><span class=\"here\">"+menu_nm+"</span></a>") ; 
			sb.append("</div>") ; 
			
		}
		
		return sb.toString() ; 
	}
	
	/**
	 * 인터페이스 처리
	 * @param request		request 객체
	 * @param errorCode	오류 코드
	 * @param errorCtn		에러 내용
	 * @param classInfo		클래스 명
	 * @throws Exception
	 */
	public static void exceptionInterface( HttpServletRequest request , String errorCode , String errorCtn, String classInfo, String sqlCtn) throws Exception {

		logger.debug("exceptionInterface call!!!!");
		
		HttpURLConnection connection = null;
		URL url = new URL("http://sensedata.cwit.co.kr:8089/resourceWebservice/rest/serverMngt/insertErrorLog");
		connection = (HttpURLConnection) url.openConnection();
		
		String pathUri = request.getRequestURI();
		
		HttpSession session = request.getSession() ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		userInfo =	userInfo == null ? (UserVO)session.getAttribute("frUserInfo") :  userInfo; 
		
		JSONObject jsonObject = new JSONObject();

		
		if(pathUri.indexOf("/ad/") != -1) {

			jsonObject.put("userId", 			userInfo.getEmp_no());
			jsonObject.put("userNm", 			userInfo.getEmp_nm());
			jsonObject.put("hospitalCode", 	"9999");
			jsonObject.put("errorIp", 			getUserIP(request));
			jsonObject.put("errorPcNm", 		"");
			jsonObject.put("errorCode", 		errorCode);
			jsonObject.put("productType", 	"LineUS");
			jsonObject.put("sqlCtn", 				"");
			jsonObject.put("errorCtn", 			errorCtn);
			jsonObject.put("programNm", 		"ADM");
			jsonObject.put("formNm", 			pathUri);
			jsonObject.put("classInfo", 			classInfo);
			jsonObject.put("errorRegDate", 	DateTimeUtil.toDate("yyyy-MM-dd") + " " + DateTimeUtil.getTimeText());
		} else {

			jsonObject.put("userId", 			userInfo.getEmp_id());
			jsonObject.put("userNm", 			userInfo.getEmp_name());
			jsonObject.put("hospitalCode", 	userInfo.getCust_code());
			jsonObject.put("errorIp", 			getUserIP(request));
			jsonObject.put("errorPcNm", 		"");
			jsonObject.put("errorCode", 		errorCode);
			jsonObject.put("productType", 	"LineUS");
			jsonObject.put("sqlCtn", 				"");
			jsonObject.put("errorCtn", 			errorCtn);
			jsonObject.put("programNm", 		(pathUri.indexOf("/fr/") != -1 ? "WEB" : "MOB"));
			jsonObject.put("formNm", 			pathUri);
			jsonObject.put("classInfo", 			classInfo);
			jsonObject.put("errorRegDate", 	DateTimeUtil.toDate("yyyy-MM-dd") + " " + DateTimeUtil.getTimeText());
		}
		
		String sendMsg = jsonObject.toString();
		// System.out.println(sendMsg);
		
		try {
			if(userInfo != null) {
				connection.setRequestProperty("Accept", "application/json");
				connection.setRequestProperty("Content-Type", "application/json");
				connection.setRequestMethod("POST");
				connection.setDoOutput(true);
				connection.setDoInput(true);
				
		        OutputStreamWriter wr= new OutputStreamWriter(connection.getOutputStream());
		        wr.write(sendMsg);
		        wr.flush();
		        logger.info("exceptionInterface response code : " + String.valueOf(connection.getResponseCode()));
		        logger.info("exceptionInterface response message : " + connection.getResponseMessage());
			}
		} catch (Exception e) {
			logger.error("exceptionInterface error", e);
		} finally {
			connection.disconnect();
		}
	}
	
	public static String getUserIP(HttpServletRequest request) {
		String ip = request.getHeader("X-FORWARDED-FOR");
		logger.debug("TEST : X-FORWARDED-FOR : " + ip);
		if (ip == null) {
			ip = request.getHeader("Proxy-Client-IP");
			logger.debug("TEST : Proxy-Client-IP : " + ip);
		}
		if (ip == null) {
			ip = request.getHeader("WL-Proxy-Client-IP");
			logger.debug("TEST : WL-Proxy-Client-IP : " + ip);
		}
		if (ip == null) {
			ip = request.getHeader("HTTP_CLIENT_IP");
			logger.debug("TEST : HTTP_CLIENT_IP : " + ip);
		}
		if (ip == null) {
			ip = request.getHeader("HTTP_X_FORWARDED_FOR");
			logger.debug("TEST : HTTP_X_FORWARDED_FOR : " + ip);
		}
		if (ip == null) {
			ip = request.getRemoteAddr();
			logger.debug("TEST : getRemoteAddr : " + ip);
		}
		return ip;
	}

}
