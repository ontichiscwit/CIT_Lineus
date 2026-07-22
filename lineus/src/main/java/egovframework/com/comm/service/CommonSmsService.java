package egovframework.com.comm.service;

public interface CommonSmsService {
	public int sendSms(String SMS_CODE_GRP , String SMS_CODE , String GUBUN ,  String  CUST_CODE,  String apply_tel , String content, String title) throws Exception ;
	public int sendMail(String GUBUN, String CUST_CODE, String senderId , String receiverId , String subject , String body , String attach_file , String file_ori_name , int attach_seq2) throws Exception ;
}
