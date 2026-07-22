package egovframework.com.comm.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;
import javax.mail.internet.MimeMessage;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.internet.MimeUtility;

import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sun.star.io.IOException;

import egovframework.com.comm.JwConstants;
import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.controller.BoardController;
import egovframework.com.model.DownHistVO;
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
	@Autowired CommonFileService commonFileService ;
	
	@Autowired JavaMailSenderImpl mailSender ; 
	

	@Override
	public int sendSms(String SMS_CODE_GRP , String SMS_CODE , String GUBUN , String CUST_CODE , String apply_tel , String strContent,  String subject) throws Exception ,
	 MalformedURLException , IOException {
		
		BufferedReader br = null;
        int statusCode;
        int result = 1;
        String json = "";
        String strMsg = "";
        String strCustMsg = "";
        
		String RECV_PHONE = "" ;
		String SENDV_PHONE = "" ;
		String V_SEND_PHONE ="";
		String USE_YN ="";
		
		SmsVO vo = new SmsVO() ; 
		
		if("".equals(SsStringUtil.normalizeNull(SMS_CODE_GRP))) return -1 ; 
		if("".equals(SsStringUtil.normalizeNull(SMS_CODE))) return -1 ; 
		if("".equals(SsStringUtil.normalizeNull(GUBUN))) return -1 ; 
		
		vo.setSms_code_grp(SMS_CODE_GRP);
		vo.setSms_code(SMS_CODE);
		vo.setGubun(GUBUN);
		vo.setCust_code(CUST_CODE);
		
		/** 회원가입, 계정상태 사용 */
		SmsVO resultVO = smsService.getDetail(vo) ;
		if(resultVO != null){
			/**	사용여부  */
			if("Y".equals(SsStringUtil.normalizeNull(resultVO.getUse_yn()))){
				/**	수신 정보 확인	*/
				if(!"".equals(SsStringUtil.normalizeNull(apply_tel))) {
					RECV_PHONE = apply_tel ; 
				}else {
					return -1;
				}
				
				/**	송신 정보 확인	*/
				SmsVO SenderInfo =  smsService.getSenderTel(vo);
				if(SenderInfo != null) {
					if(!"".equals(SsStringUtil.normalizeNull(SenderInfo.getCharger_tel()))) {
						SENDV_PHONE = SenderInfo.getCharger_tel() ; 
					}
				}else {
					return -1;
				}
				
				if(!"".equals(RECV_PHONE) && !"".equals(SENDV_PHONE)){
					
					HttpURLConnection connection = null;
					URL url = new URL(JwConstants.SMS_SEND_URL);
					
					connection = (HttpURLConnection) url.openConnection();
					JSONObject jsonObject = new JSONObject();

					if(GUBUN == "AS") {
						
						logger.debug("sms url : " + JwConstants.SMS_SEND_URL);
			            logger.debug("mmsPhone : " + RECV_PHONE.replaceAll("-", ""));
			            logger.debug("mmsCallback : " + SENDV_PHONE.replaceAll("-", ""));
			            logger.debug("mmsSubject : " + subject );
			            logger.debug("mmsMsg : " + strContent);
			            logger.debug("mmsStatus : " + JwConstants.SMS_STATUS );
			            logger.debug("mmsType : " + JwConstants.SMS_TYPE);
			            logger.debug("mmsEtc1 : " + JwConstants.PRODUCT_NAME);
			            
			            jsonObject.put("mmsPhone", RECV_PHONE.replaceAll("-", ""));
			            jsonObject.put("mmsCallback",  SENDV_PHONE.replaceAll("-", ""));
			            jsonObject.put("mmsSubject", subject);
			            jsonObject.put("mmsMsg", strContent);
			            jsonObject.put("mmsStatus", JwConstants.SMS_STATUS);            
			            jsonObject.put("mmsType", JwConstants.SMS_TYPE);            
			            jsonObject.put("mmsEtc1", JwConstants.PRODUCT_NAME);
						
					}else if (GUBUN == "MEMBER") {
					
			            logger.debug("sms url : " + JwConstants.SMS_SEND_URL);
			            logger.debug("mmsPhone : " + RECV_PHONE.replaceAll("-", ""));
			            logger.debug("mmsCallback : " + SENDV_PHONE.replaceAll("-", ""));
			            logger.debug("mmsSubject : " + SsStringUtil.normalizeNull(resultVO.getTitle()) );
			            logger.debug("mmsMsg : " + SsStringUtil.normalizeNull(resultVO.getCntn()));
			            logger.debug("mmsStatus : " + JwConstants.SMS_STATUS );
			            logger.debug("mmsType : " + JwConstants.SMS_TYPE);
			            logger.debug("mmsEtc1 : " + JwConstants.PRODUCT_NAME);
			            
			            jsonObject.put("mmsPhone", RECV_PHONE.replaceAll("-", ""));
			            jsonObject.put("mmsCallback",  SENDV_PHONE.replaceAll("-", ""));
			            jsonObject.put("mmsSubject", SsStringUtil.normalizeNull(resultVO.getTitle()));
			            jsonObject.put("mmsMsg", SsStringUtil.normalizeNull(resultVO.getCntn()));
			            jsonObject.put("mmsStatus", JwConstants.SMS_STATUS);            
			            jsonObject.put("mmsType", JwConstants.SMS_TYPE);            
			            jsonObject.put("mmsEtc1", JwConstants.PRODUCT_NAME);
		            }
					
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

	@SuppressWarnings({ "null", "unused" })
	@Override
	public int sendMail(String GUBUN, String CUST_CODE, String senderId, String receiverId, String subject, String body, String attach_file, String file_ori_name, int attach_seq2) throws Exception {
		int returnValue = 0 ; 
		
		SmsVO vo = new SmsVO() ; 
		FileVO fileVO = new FileVO() ; 
		List<FileVO> fileList = null ;
		
		if(!"".equals(GUBUN)){
			try{
				System.setProperty("mail.mime.splitlongparameters", "false");
				
				MimeMessage message = mailSender.createMimeMessage() ; 
				MimeMessageHelper messageHelper = new MimeMessageHelper(message , true , "UTF-8") ; 
				
				vo.setCust_code(CUST_CODE);
				
				/* 송시자 이메일 확인**/
				/*if("MEMBER".equals(GUBUN)) {
					SmsVO SenderInfo =  smsService.getSenderEmail(vo);
					messageHelper.setFrom(SenderInfo.getV_send_email());
				}else if("AS".equals(GUBUN)) {
					messageHelper.setFrom(senderId);
				}*/
				
				messageHelper.setFrom(JwConstants.MAIL_SEND_ADDR); // "admin@cwit.co.kr" 
				messageHelper.setTo(receiverId);
				messageHelper.setSubject(subject);
				messageHelper.setText(body , true);				
				
				
				if(!"".equals(attach_seq2) || attach_seq2 > 0){
					
					fileVO.setAttach_seq(attach_seq2);
					
					fileList = (List<FileVO>)commonFileService.getFileList(fileVO) ;
					
					if(fileList != null && fileList.size() > 0){						
						for(FileVO temp : fileList) {  
							
							fileVO.setAttach_ord(temp.getAttach_ord());							
							FileVO fileDetail = commonFileService.fileInfo(fileVO) ;
							
							if(fileDetail != null){							
								
								BufferedInputStream fin =  null ;
								BufferedOutputStream outs = null ; 								
									
								//File f = new File(fileDetail.getAttach_path_dtl() + fileDetail.getAttach_save_nm()) ;
								
								//attach_file = fileDetail.getAttach_path_dtl() + fileDetail.getAttach_save_nm();
								//file_ori_name = fileDetail.getAttach_ori_nm();  
								File file = new File(fileDetail.getAttach_path_dtl() + fileDetail.getAttach_save_nm());
							    String originalName = fileDetail.getAttach_ori_nm();

								logger.debug("attach_seq ("+fileDetail.getAttach_seq()+") : " + fileDetail.getAttach_seq());								
								logger.debug("attach_file ("+fileDetail.getAttach_ord()+") : " + attach_file);
								logger.debug("file_ori_name ("+fileDetail.getAttach_ord()+") : " + file_ori_name);  																	
								
								
								 if(file.exists()) {
								        
								        String encodedFileName = MimeUtility.encodeText(originalName, "UTF-8", "B");

								        // FileDataSource + DataHandler 사용
								        FileDataSource fds = new FileDataSource(file);
								        messageHelper.addAttachment(encodedFileName, fds);
								        mailSender.getJavaMailProperties().put("mail.mime.charset", "UTF-8");
								        mailSender.getJavaMailProperties().put("mail.mime.encodefilename", "true");
								        mailSender.getJavaMailProperties().put("mail.mime.decodefilename", "true");
								    } else {
								        logger.warn("첨부파일 없음: " + file.getAbsolutePath());
								    }
								 
								 
								
								//FileSystemResource fsr = new FileSystemResource(attach_file) ; 
								//messageHelper.addAttachment(file_ori_name, fsr);								
																																					
							}							
						}	
					}	
					
				}
				
				mailSender.send(message);
				
				returnValue = 1 ; 
				
			}catch(Exception e){
				e.printStackTrace();  
				returnValue = -100 ; 
			}
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



                             