package egovframework.com.comm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLSyntaxErrorException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.logging.jdbc.PreparedStatementLogger;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;


import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.DateTimeUtil;


public class LineusExceptionHandler extends SimpleMappingExceptionResolver {

	private static final Logger logger = LoggerFactory.getLogger(LineusExceptionHandler.class);
	
	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object obj, Exception ex) {

		String userId = "unknown";
		String userNm = "unknown";
		String crmCode = "unknown";
		
		HttpSession session = request.getSession();
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		if (userInfo == null){
			userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null;
		}
		
		if (userInfo != null){
			
			if(!"".equals(userInfo.getEmp_nm())){
				userNm = userInfo.getEmp_nm();
			}else if (!"".equals(userInfo.getEmp_name())){
				userNm = userInfo.getEmp_name();
			}
			
			if(!"".equals(userInfo.getEmp_no())){
				userId = userInfo.getEmp_no();
			}else if (!"".equals(userInfo.getEmp_id())){
				userId = userInfo.getEmp_id();
			}
			
			if (!"".equals(userInfo.getCust_code())){
				crmCode = userInfo.getCust_code();
			}else{
				crmCode = "9999";
			}
		}
		
		String classInfo = "";
		if (obj instanceof HandlerMethod){
			HandlerMethod hm = (HandlerMethod)obj;
			classInfo = hm.getBeanType().getName();
		}
		
		String errorCtn = ex.getMessage();
		if (errorCtn == null){
			errorCtn = ex.getClass().getSimpleName();
		}
		
		StringWriter sw = new StringWriter();
		ex.printStackTrace(new PrintWriter(sw));
		StringReader sr = new StringReader(sw.toString());
		BufferedReader br = new BufferedReader(sr);
		String newLine = null;
		
		String sqlCtn = "";
		
		try {
			int i=0;
			while ((newLine = br.readLine()) != null){
				i++;
				logger.debug(i + " : " + newLine);
				if (newLine.startsWith("### SQL")){
					sqlCtn = newLine.substring(8);
				}else if (newLine.startsWith("### Error")){
					errorCtn = newLine.substring(10);
				}else if (newLine.contains(classInfo)){
					errorCtn += newLine;
				}
			}
		} catch (IOException e) {
			logger.error("Error infomation sending error!!");
		}
		
		String errorCode = ""; // 정해지지 않았음
		
		ErrorSend runnable = new ErrorSend(request, errorCode, errorCtn, sqlCtn, classInfo, userId, userNm, crmCode);
		new Thread(runnable).start();
		
		logger.debug("sqlCtn : " + sqlCtn);
		logger.debug("errorCtn : " + errorCtn);
		logger.debug("classInfo : " + classInfo);
		logger.debug("userId : " + userId);
		logger.debug("userNm : " + userNm);
		logger.debug("crmCode : " + crmCode);
		logger.debug("-----------------------------");

		return super.doResolveException(request, response, obj, ex);
	}
	
	
	class ErrorSend implements Runnable{
		
		private HttpServletRequest request;
		private String errorCode;
		private String errorCtn;
		private String sqlCtn;
		private String classInfo;
		private String userId;
		private String userNm;
		private String crmCode;
		

		public ErrorSend(HttpServletRequest request, String errorCode, String errorCtn, String sqlCtn
				, String classInfo, String userId, String userNm, String crmCode) {
			this.request = request;
			this.errorCode = errorCode;
			this.errorCtn = errorCtn;
			this.sqlCtn = sqlCtn;
			this.classInfo = classInfo;
			this.userId = userId;
			this.userNm = userNm;
			this.crmCode = crmCode;
		}

		@Override
		public void run() {
			HttpURLConnection connection = null;
			try{
				URL url = new URL("http://sensedata.cwit.co.kr:8089/resourceWebservice/rest/serverMngt/insertErrorLog");
				connection = (HttpURLConnection) url.openConnection();
				
				String pathUri = request.getRequestURI();
				JSONObject jsonObject = new JSONObject();

				if(pathUri.indexOf("/ad/") != -1) {
					jsonObject.put("userId", 			userId);
					jsonObject.put("userNm", 			userNm);
					jsonObject.put("hospitalCode", 		crmCode);
					jsonObject.put("errorIp", 			getUserIP(request));
					jsonObject.put("errorPcNm", 		"");
					jsonObject.put("errorCode", 		errorCode);
					jsonObject.put("productType", 		"LineUS");
					jsonObject.put("sqlCtn", 			sqlCtn);
					jsonObject.put("errorCtn", 			errorCtn);
					jsonObject.put("programNm", 		"ADM");
					jsonObject.put("formNm", 			pathUri);
					jsonObject.put("classInfo", 		classInfo);
					jsonObject.put("errorRegDate", 		DateTimeUtil.toDate("yyyy-MM-dd") + " " + DateTimeUtil.getTimeText());
				} else {
	
					jsonObject.put("userId", 			userId);
					jsonObject.put("userNm", 			userNm);
					jsonObject.put("hospitalCode", 		crmCode);
					jsonObject.put("errorIp", 			getUserIP(request));
					jsonObject.put("errorPcNm", 		"");
					jsonObject.put("errorCode", 		errorCode);
					jsonObject.put("productType", 		"LineUS");
					jsonObject.put("sqlCtn", 			sqlCtn);
					jsonObject.put("errorCtn", 			errorCtn);
					jsonObject.put("programNm", 		(pathUri.indexOf("/fr/") != -1 ? "WEB" : "MOB"));
					jsonObject.put("formNm", 			pathUri);
					jsonObject.put("classInfo", 		classInfo);
					jsonObject.put("errorRegDate", 		DateTimeUtil.toDate("yyyy-MM-dd") + " " + DateTimeUtil.getTimeText());
				}
			
				String sendMsg = jsonObject.toString();

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
		        
		        logger.info(sendMsg);
		        
			} catch (Exception e) {
				logger.error("exceptionInterface error", e);
			} finally {
				connection.disconnect();
			}
		}
		
		private String getUserIP(HttpServletRequest request) {
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
}
