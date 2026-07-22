package egovframework.com.comm.service;

public interface CommonSmsService {
	public int sendSms(String SMS_CODE_GRP , String SMS_CODE , String GUBUN , String EMP_ID , String apply_tel) throws Exception ;
	public int sendMail(String senderId , String receiverId , String subject , String body , String attach_file , String file_ori_name) throws Exception ;
}
