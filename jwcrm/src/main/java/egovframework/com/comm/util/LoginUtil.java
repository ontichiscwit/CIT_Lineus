package egovframework.com.comm.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;

import org.codehaus.jettison.json.JSONObject;
import egovframework.com.comm.model.UserUtilVO;

/**
 * <B>LoginUtil.java<B><br>
 * 
 * @author  김민지
 * @version V1.0    2019.07.16	김민지 최초 작성 
 */
public class LoginUtil {
	
	public UserUtilVO checkAuth(UserUtilVO userVO) throws ParseException, IOException {
		String url =  userVO.getUrl();
		
		InputStream is = null;
        int statusCode;
        UserUtilVO resultvo = new UserUtilVO();
        
        try
        {
			 URL urlCon = new URL(url);
	         HttpURLConnection httpCon = (HttpURLConnection)urlCon.openConnection();
	 	
	         String json = "";

	         JSONObject jsonObject = new JSONObject();
	         jsonObject.put("refreshToken", userVO.getRefreshToken());
	         
	         json = jsonObject.toString();
	
	         httpCon.setRequestProperty("Accept", "application/json");
	         httpCon.setRequestProperty("Content-type", "application/json");
	         httpCon.setRequestProperty("authorization", "Bearer " + userVO.getToken());
	         
	         httpCon.setRequestMethod("POST");
	         httpCon.setDoOutput(true);
	         httpCon.setDoInput(true);
			    
	         OutputStreamWriter wr= new OutputStreamWriter(httpCon.getOutputStream());
	         wr.write(json);
	         wr.flush();
	         
	         // receive response as inputStream
	         statusCode = httpCon.getResponseCode();
	         System.out.println("httpCon.getURL():"+httpCon.getURL());
	         try {
	         	
	         	if (statusCode >= 200 && statusCode < 400) {
	     		   is = httpCon.getInputStream();
	     		   
	     		    ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
					byte[] byteBuffer = new byte[1024];
				    byte[] byteData = null;
				    int nLength = 0;

				    while((nLength = is.read(byteBuffer, 0, byteBuffer.length)) != -1) {
				    	byteArray.write(byteBuffer, 0, nLength);
				    }

				    byteData = byteArray.toByteArray();
				    String response = new String(byteData);
				    
				    JSONObject responseJSON = new JSONObject(response);
				    JSONObject responseToken = responseJSON.getJSONObject("TokenInfo");
				    
				    resultvo.setId(responseToken.getString("id"));

	     		}
	     		else {
	     		   is = httpCon.getErrorStream();
	     		   resultvo.setStatus("fail");
	     		}
	
	         }
	         catch(Exception ex){
	        	 resultvo.setStatus("fail");
	         }
	         finally {
	             httpCon.disconnect();
	         }
	
	     }
	     catch (Exception e) {
	    	 resultvo.setStatus("fail");
	     }
		return resultvo;
		
	}
	
	
	public UserUtilVO checkCitLogin(UserUtilVO userVO) throws ParseException, IOException{
		String url =  userVO.getUrl();
		
		InputStream is = null;
        int statusCode;
        UserUtilVO resultvo = new UserUtilVO();
        
        try
        {
			 URL urlCon = new URL(url);
	         HttpURLConnection httpCon = (HttpURLConnection)urlCon.openConnection();
	 	
	         String json = "";

	         JSONObject jsonObject = new JSONObject();
	         jsonObject.put("email", userVO.getUserId());
	         jsonObject.put("password", userVO.getUserPw());
	         
	         json = jsonObject.toString();
	
	         httpCon.setRequestProperty("Accept", "application/json");
	         httpCon.setRequestProperty("Content-type", "application/json");
	         
	         httpCon.setRequestMethod("POST");
	         httpCon.setDoOutput(true);
	         httpCon.setDoInput(true);
			    
	         OutputStreamWriter wr= new OutputStreamWriter(httpCon.getOutputStream());
	         wr.write(json);
	         wr.flush();
	         
	         // receive response as inputStream
	         statusCode = httpCon.getResponseCode();
	         System.out.println("httpCon.getURL():"+httpCon.getURL());
	         try {
	         	
	         	if (statusCode >= 200 && statusCode < 400) {
	     		   is = httpCon.getInputStream();
	     		   
	     		    ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
					byte[] byteBuffer = new byte[1024];
				    byte[] byteData = null;
				    int nLength = 0;

				    while((nLength = is.read(byteBuffer, 0, byteBuffer.length)) != -1) {
				    	byteArray.write(byteBuffer, 0, nLength);
				    }

				    byteData = byteArray.toByteArray();
				    String response = new String(byteData);

				    resultvo = new UserUtilVO();
				    
				    JSONObject responseJSON = new JSONObject(response);
				    JSONObject responseToken = responseJSON.getJSONObject("access_token");
				    
				    resultvo.setUserId(responseToken.getString("userId"));
				    resultvo.setUserNm(responseToken.getString("userNm"));
				    if(resultvo.getUserId() == null || resultvo.getUserId().equals("")){
				    	resultvo.setStatus("fail");
				    }
				    else{
				    	resultvo.setStatus("success");
				    }
	     		}
	     		else {
	     		   is = httpCon.getErrorStream();
	     		   resultvo.setStatus("fail");
	     		}
	
	         }
	         catch(Exception ex){
	        	 resultvo.setStatus("fail");
	         }
	         finally {
	             httpCon.disconnect();
	         }
	
	     }
	     catch (Exception e) {
	    	 resultvo.setStatus("fail");
	     }
		return resultvo;
		
	}
    
}

