package egovframework.com.comm.service.impl;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import javax.mail.internet.MimeMessage;

import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.sun.star.io.IOException;

import egovframework.com.comm.JwConstants;
import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.controller.BoardController;
import egovframework.com.model.SmsVO;
import egovframework.com.service.MemberService;
import egovframework.com.service.SmsService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("commonSmsService")
public class CommonSmsServiceImpl extends EgovAbstractServiceImpl implements CommonSmsService{
	
	private static final Logger logger = LoggerFactory.getLogger(CommonSmsServiceImpl.class) ;

	@Autowired CommonDao commonDAO ;
	@Autowired SmsService smsService ; 
	@Autowired MemberService memberService ;
	
	@Autowired JavaMailSenderImpl mailSender ; 

	@Override
	public int sendSms(String SMS_CODE_GRP , String SMS_CODE , String GUBUN , String EMP_ID , String apply_tel) throws Exception ,
	 MalformedURLException , IOException {
		
		BufferedReader br = null;
        int statusCode;
        int result = 1;
        String json = "";
        String strMsg = "";
        String strCustMsg = "";
        
		String RECV_PHONE = "" ; 
		SmsVO vo = new SmsVO() ; 
		
		if("".equals(SsStringUtil.normalizeNull(SMS_CODE_GRP))) return -1 ; 
		if("".equals(SsStringUtil.normalizeNull(SMS_CODE))) return -1 ; 
		if("".equals(SsStringUtil.normalizeNull(GUBUN))) return -1 ; 
		
		vo.setSms_code_grp(SMS_CODE_GRP);
		vo.setSms_code(SMS_CODE);
		vo.setGubun(GUBUN);
		
		SmsVO resultVO = smsService.getDetail(vo) ; 
		if(resultVO != null){
			if("Y".equals(SsStringUtil.normalizeNull(resultVO.getUse_yn()))){
				
				/**	발송 정보	*/
				if(!"".equals(SsStringUtil.normalizeNull(apply_tel))) {
					RECV_PHONE = apply_tel ; 
				}else {
					UserVO paramVO = new UserVO() ; 
					
					if("SEQ".equals(GUBUN)) paramVO.setSeq(EMP_ID);
					else paramVO.setEmp_id(EMP_ID);
					
					UserVO temp = memberService.getSelectOne(paramVO , "memberDAO.getEmpInfo") ; 
					
					if(!"".equals(SsStringUtil.normalizeNull(temp.getTel_no()))) RECV_PHONE = temp.getTel_no().replaceAll("-", "") ;
				}
				
				
				if(!"".equals(RECV_PHONE)){
					HttpURLConnection connection = null;
					URL url = new URL(JwConstants.SMS_SEND_URL);
						
					connection = (HttpURLConnection) url.openConnection();
					
					strMsg = SsStringUtil.normalizeNull(resultVO.getCntn());
					strCustMsg = subStringBytes(strMsg, 88, 2);
					
		            JSONObject jsonObject = new JSONObject();

		            logger.debug("sms url : " + JwConstants.SMS_SEND_URL);
		            logger.debug("trPhone : " + RECV_PHONE.replaceAll("-", ""));
		            logger.debug("trCallback : " + JwConstants.SMS_SEND_PHONE);
		            
		            jsonObject.put("trSenddate", "");
		            jsonObject.put("trSendstat", "0");
		            jsonObject.put("trMsgtype",  "0");
		            jsonObject.put("trPhone", RECV_PHONE.replaceAll("-", ""));
		            jsonObject.put("trCallback", JwConstants.SMS_SEND_PHONE);
		            jsonObject.put("trMsg", strCustMsg);            
		            jsonObject.put("trEtc1", "LineUs");
		            json = jsonObject.toString();
					
					connection.setRequestProperty("Accept", "application/json");
					connection.setRequestProperty("Content-Type", "application/json");
					connection.setRequestMethod("POST");
					connection.setDoOutput(true);
					connection.setDoInput(true);
					
		            OutputStream wr= connection.getOutputStream();
		            wr.write(json.getBytes("utf-8"));
		            wr.flush();
		            wr.close();
					
		            statusCode = connection.getResponseCode();
		            logger.debug("connection.getResponseMessage() : " + connection.getResponseMessage());
		            logger.debug("SMS 등록 결과코드:"+statusCode);
					
					try {
		            	if (statusCode >= 200 && statusCode < 400) {
		            		br = new BufferedReader( new InputStreamReader( connection.getInputStream(), "utf-8" ), connection.getContentLength() );
		            		String buf;
		            		// 표준출력으로 한 라인씩 출력
		            		while( ( buf = br.readLine() ) != null ) {
		            			logger.debug( buf );
		            		}

		            		result = 1;
		         		} else {
		         			br = new BufferedReader( new InputStreamReader( connection.getErrorStream(), "utf-8" ), connection.getContentLength() );
		         			String buf;
		            		// 표준출력으로 한 라인씩 출력
		            		while( ( buf = br.readLine() ) != null ) {
		            			logger.debug( buf );
		            		}
		         			result = -1;
		         		}
					} catch (Exception e) {
						
					} finally {
						connection.disconnect();
						if (br != null) br.close();
					}
				}
			}
		}
		return result;
	}

	@Override
	public int sendMail(String senderId, String receiverId, String subject, String body, String attach_file, String file_ori_name) throws Exception {
		int returnValue = 0 ; 
		
		try{
			MimeMessage message = mailSender.createMimeMessage() ; 
			MimeMessageHelper messageHelper = new MimeMessageHelper(message , true , "UTF-8") ; 
			
			messageHelper.setFrom(JwConstants.MAIL_SEND_ADDR);
			messageHelper.setTo(receiverId);
			messageHelper.setSubject(subject);
			messageHelper.setText(body , true);
			
			if(!"".equals(attach_file)){
				
				logger.debug("attach_file : " + attach_file);
				logger.debug("file_ori_name : " + file_ori_name);
				
				FileSystemResource fsr = new FileSystemResource(attach_file) ; 
				messageHelper.addAttachment(file_ori_name, fsr);
			}
			
			mailSender.send(message);
			
			returnValue = 1 ; 
			
		}catch(Exception e){
			e.printStackTrace();  
			returnValue = -100 ; 
		}
		
		return returnValue;
	}
	
	public String subStringBytes(String str, int byteLength, int sizePerLetter) 
	{
		int retLength = 0; 
		int tempSize = 0; 
		int asc; 
		if (str == null || "".equals(str) || "null".equals(str)) 
		{ 
			str = ""; 
		} 
		int length = str.length(); 
		
		for (int i = 1; i <= length; i++) 
		{ 
			asc = (int) str.charAt(i - 1); 
			if (asc > 127) { 
				if (byteLength >= tempSize + sizePerLetter) { 
					tempSize += sizePerLetter; retLength++; 
					} 
				} else { 
					if (byteLength > tempSize) { 
						tempSize++; retLength++; 
						} 
					} 
		} 
		return str.substring(0, retLength); 
	} 
}
