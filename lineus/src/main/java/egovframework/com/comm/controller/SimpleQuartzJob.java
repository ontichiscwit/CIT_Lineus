package egovframework.com.comm.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.stereotype.Controller;

import egovframework.com.comm.ApplicationContextProvider;
import egovframework.com.comm.dao.CommonDao;
//import egovframework.com.comm.dao.CommonMsDao;
import egovframework.com.comm.dao.impl.CommonDaoImpl;
//import egovframework.com.comm.dao.impl.CommonMsDaoImpl;
import egovframework.com.comm.model.CommonCodeVO;
import egovframework.com.comm.model.InterfaceVO;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.service.impl.CommonSmsServiceImpl;
import egovframework.com.comm.util.SendMailForm;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.controller.AdAsController;
import egovframework.com.model.AsVO;
import egovframework.com.model.CommonVO;
import egovframework.com.model.MssqlVO;
import egovframework.com.model.OperateVO;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
 

@SuppressWarnings("unused")
public class SimpleQuartzJob extends QuartzJobBean{		
	
    /** @SuppressWarnings("unused") */
	
	@Autowired CommonDaoImpl commonDAO;
	//@Autowired CommonMsDaoImpl commonMsDAO;	
	@Autowired CommonSmsService commonSmsService; 		
	
	public SimpleQuartzJob() {
		commonDAO = ApplicationContextProvider.getBean(CommonDaoImpl.class);
		//commonMsDAO = ApplicationContextProvider.getBean(CommonMsDaoImpl.class);	
		commonSmsService = (CommonSmsService) ApplicationContextProvider.getBean(CommonSmsService.class);			
		
	}
	
		
	private static final Logger logger = LoggerFactory.getLogger(SimpleQuartzJob.class) ;
		
	
	
	/** @SuppressWarnings("null") */	
	/** @SuppressWarnings("unchecked") */
	@SuppressWarnings({ "null", "unchecked" }) 
	public void executeInternal(JobExecutionContext ex)throws JobExecutionException {			//10분마다 돈다
		
		HashMap<String,String> param = new HashMap<String, String>();
		int returnValue = 0; 
		try {
			//SELECT SHARED SERVICE
			List<MssqlVO> resultList = null ;
			MssqlVO dump = new MssqlVO();
			MssqlVO dump2 = new MssqlVO();
			//resultList = (List<MssqlVO>) commonMsDAO.list(dump, "asDAO.getEzSharedServiceSelect");//as.DAO라서 egov-as-query.xml로 찾음 //미접수된 s/s 리스트 조회
			
			//INSERT INTO CRM_AS_MGT 
			if(resultList != null && resultList.size() > 0){
				for(MssqlVO resultVo : resultList){
					
					InterfaceVO tempVo = new InterfaceVO();
					InterfaceVO tempVo1 = new InterfaceVO();
					InterfaceVO tempVo2 = new InterfaceVO();
					
					OperateVO tempVo3 = new OperateVO();
					OperateVO tempVo3G = new OperateVO();
					
					OperateVO tempVo4 = new OperateVO();
					OperateVO tempVo4G = new OperateVO();
					
					OperateVO tempVo5 = new OperateVO();
					OperateVO tempVo6 = new OperateVO();
					OperateVO tempVo7 = new OperateVO();
					
					
					AsVO asVo = new AsVO();
					AsVO tempasVo1 = new AsVO();
					
					int returnVal = 0;		
					int snedSMSResult = 0;
					int snedEMAILResult = 0;						
					
					//GET SHARED SERVICE & LINEUS CODE MAPPING(SYSTEM CODE,INQUIRY CODE)
					tempVo.setCode_gubun("LEVEL2");  
					tempVo.setAsis_code1(SsStringUtil.trim(resultVo.getLevel2())); //LEVEL2의 값을 가져옴71-70-67   //{afc61410-3754-4c70-b508-c550b64d2a2b}
					tempVo = (InterfaceVO) commonDAO.selectOne(tempVo, "asDAO.selectInterfaceCode"); //tempVo= {TOBE_CODE1:S006,TOBE_CODE2:C000}
					if(tempVo == null) {tempVo.setTobe_code1(""); tempVo.setTobe_code2("");}
					
					//GET SHARED SERVICE & LINEUS CODE MAPPING(REQUEST CODE)
					tempVo1.setCode_gubun("LEVEL3");
					tempVo1.setAsis_code1(SsStringUtil.trim(resultVo.getLevel3()));  //{36f9f51f-6d19-4fa2-bf5d-8152ba06ec3f}
					tempVo1 = (InterfaceVO) commonDAO.selectOne(tempVo1, "asDAO.selectInterfaceCode"); //tempVo1= {TOBE_CODE1:C001}
					if(tempVo1 == null) {tempVo1.setTobe_code1("");}
					
					
					//GET CUST CODE(EPR CODE)
					tempVo2.setCode_gubun("CUST");
					tempVo2.setAsis_code1(SsStringUtil.trim(resultVo.getRegcomid()));  //0
					tempVo2 = (InterfaceVO) commonDAO.selectOne(tempVo2, "asDAO.selectInterfaceCode");//tempVo2= {TOBE_COME1:02565,TOBE_COME2:JW홀딩스}
					if(tempVo2 == null) {tempVo2.setTobe_code1("");} 
					
					//GET OPERATE SEQ
					tempVo3.setErp_code(tempVo2.getTobe_code1()); //CUST CODE
					tempVo3.setSystem_code(tempVo.getTobe_code1()); //SYSTEM CODE
					tempVo4.setErp_code(tempVo2.getTobe_code1()); // CUST CODE
					tempVo3 = (OperateVO) commonDAO.selectOne(tempVo3, "asDAO.selectOperateSeq");
					
					if(tempVo3 == null) {tempVo3G.setOper_seq("");
					}else {
						tempVo3G.setOper_seq(tempVo3.getOper_seq());
					} 
					asVo.setOper_seq(tempVo3G.getOper_seq());
					
					
					//GET CUST SEQ
					tempVo4 = (OperateVO) commonDAO.selectOne(tempVo4, "asDAO.selectCustSeq");
					asVo.setCust_seq(tempVo4.getSeq());
					
					
					//INSERT INTO A/S INFO FROM SHARED SERVICE
					//resultVo.getRcvrdate(); //예상완료일시
					//resultVo.getRcvedate(); //접수처리완료일시
					//resultVo.getWorktime(); //소요일
					
					
					//GET WORKER(TASK CHARGER)
					tempVo5.setOper_seq(SsStringUtil.normalizeNull(tempVo3G.getOper_seq()));
					tempVo5.setTask_code(SsStringUtil.normalizeNull(tempVo.getTobe_code2()));
					tempVo5 = (OperateVO)commonDAO.selectOne(tempVo5,"asDAO.getAsAssignMaster");
					if(tempVo5 == null) {tempVo6.setWk_emp_no("");
					}else {
						tempVo6.setWk_emp_no(tempVo5.getWk_emp_no());
					} 
					
					asVo.setShared_doc_idx(SsStringUtil.normalizeNull(resultVo.getIdx())); //순번
					asVo.setShared_doc_id(SsStringUtil.normalizeNull(resultVo.getDocid())); //문서 ID
					
					
					//수정 전 : asVo.setCall_content((SsStringUtil.normalizeNull(resultVo.getDocttl()) +"\r" +SsStringUtil.normalizeNull(resultVo.getDoctxt()))
					//수정 후
					asVo.setCall_content((SsStringUtil.normalizeNull(resultVo.getDocttl()) +"\r" +SsStringUtil.normalizeNull(resultVo.getDoctxt())).replace("※ 결재선 : 소속본부 또는 부서 상위 직책자\r\n" + 
							"   - 다음의 경우 반려처리 1) 결재자 없음  2) 상위직책자가 결재자 아님  3) 결재선에 정보전략본부 인원 포함시\r\n" + 
							"\r\n" + 
							"※ 작성 방법에 대한 참고 사항\r\n" + 
							"   - 요청사항, 요청목적에 내용을 상세하게 작성하지 않을 경우 처리 불가\r\n" + 
							"   - 보안예외는 그룹웨어 → 공지게시판 → 그룹공지 → [보안정책] 예외신청방법 및 기준 공지 참고하여 작성\r\n" + 
							"   - SAP 관련 의뢰 작성 시 반드시 'SAP ID' 기입"," ")); //제목+내용
					
					
					if(  "1".equals(SsStringUtil.normalizeNull(resultVo.getDocattach())) ) {
						
						//int checkDocattach = commonMsDAO.selectOneInt(resultVo, "asDAO.getDocattachCnt");
						
						/*if(checkDocattach == 0){
							logger.error("getDocattach Fail");
						}else{
							asVo.setShared_attach("Y"); //첨부파일
						//	dump2 = (MssqlVO)commonMsDAO.selectOne(resultVo,"asDAO.getDocattach");
							asVo.setShared_filenm(dump2.getFilenm2()); //첨부파일 이름.
							asVo.setShared_filepath(dump2.getFilepath()); //첨부파일 경로.
						}*/
							
					}
					
					String mDate = SsStringUtil.normalizeNull(resultVo.getDocdate());
					mDate = mDate.substring(0,10);
					mDate = mDate.replaceAll("-", "");
					//asVo.setAccept_dt(SsStringUtil.normalizeNull(mDate)); //의뢰일시(접수일자)
					
					String mTime = SsStringUtil.normalizeNull(resultVo.getDocdate());
					mTime = mTime.trim();
					mTime = mTime.substring(11, 19);
					mTime = mTime.replaceAll(":", "");
					//asVo.setAccept_time(SsStringUtil.normalizeNull(mTime)); //의뢰시각(접수시각) 
										
					String iqDt = SsStringUtil.normalizeNull(resultVo.getRcvsdate());
					iqDt = iqDt.substring(0,10);
					iqDt = iqDt.replaceAll("-", "");					
					
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
					LocalDate date = LocalDate.parse(iqDt, formatter);

					date = date.plusDays(3); //3일 추가
					iqDt = date.format(formatter); //다시 문자열로 변환
					asVo.setInquiry_dt(SsStringUtil.normalizeNull(iqDt)); //처리요청일
					asVo.setProc_dt(SsStringUtil.normalizeNull(iqDt)); //처리예정일
					
					asVo.setApply_id(SsStringUtil.normalizeNull(resultVo.getRegid()));//의뢰자ID
					asVo.setApply_nm(SsStringUtil.normalizeNull(resultVo.getRegnm()));//의뢰자이름
					asVo.setCust_code(SsStringUtil.normalizeNull(tempVo2.getTobe_code1()));//거래처코드
					
					asVo.setApproval_id(SsStringUtil.normalizeNull(resultVo.getRcvid())); //최종결재자 ID(접수자)
					asVo.setApproval_nm(SsStringUtil.normalizeNull(resultVo.getRcvnm())); //최종결재자 ID(접수자)
					asVo.setShared_tag(SsStringUtil.normalizeNull(resultVo.getTag()));	  //접수자(승인자)의 접수의견(검토의견)
					
					String mDate1 = SsStringUtil.normalizeNull(resultVo.getRcvsdate());
					mDate1 = mDate1.substring(0,10);
					mDate1 = mDate1.replaceAll("-", "");
					asVo.setApproval_dt(SsStringUtil.normalizeNull(mDate1)); //최종결재날짜(승인일자)
					asVo.setAccept_dt(SsStringUtil.normalizeNull(mDate1)); //의뢰일시(접수일자)	접수일자=승인일자 되도록!! 2020.06.24.				
					
					
					String mTime1 = SsStringUtil.normalizeNull(resultVo.getRcvsdate());
					mTime1 = mTime1.trim();
					mTime1 = mTime1.substring(11, 19);
					mTime1 = mTime1.replaceAll(":", "");
					asVo.setApproval_time(SsStringUtil.normalizeNull(mTime1)); //최종결재시각(승인시각)
					asVo.setAccept_time(SsStringUtil.normalizeNull(mTime1)); //의뢰시각(접수시각) 접수시간=승인시간 되도록!!  2020.06.24. 					
					
					asVo.setApply_email(resultVo.getMail()); //의뢰자 이메일
					asVo.setSend_email("Y"); //의뢰자 이메일
					asVo.setSystem_type(SsStringUtil.normalizeNull(tempVo.getTobe_code1()));
					asVo.setInquiry_type(SsStringUtil.normalizeNull(tempVo.getTobe_code2()));
					asVo.setRequest_type(SsStringUtil.normalizeNull(tempVo1.getTobe_code1()));
					asVo.setAssign_id(SsStringUtil.normalizeNull(tempVo6.getWk_emp_no()));
					
					asVo.setAccept_route("C001");
					asVo.setProc_status("C000");  //처리상태 C001 접수 -> C000 대기 2020.09.03. 추가  
												
					
					////문의유형 기준으로 AS승인프로세스 추가에 따른 거래처구분, 승인대상1(팀장), 승인대상2(배포), 승인자1(팀장), 승인자2(배포) 2020.08.03. 추가					                    
					if(asVo.getRequest_type() == null) {	    									
						asVo.setGyul_gb1("N");
						//asVo.setGyul_gb2("N");	
					}else {
						tempasVo1.setRequest_type(SsStringUtil.normalizeNull(tempVo1.getTobe_code1())); //문의유형					
						asVo.setGyul_gb1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb1Yn"));  //승인대상1(팀장)													
						//asVo.setGyul_gb2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb2Yn"));  //승인대상2(배포)		2023.08.22. 배포 조건 변경(문의유형 --> 조치유형)에 따른 주석처리			
					}
					
					asVo.setGyul_gb2("N");        //2023.08.22. 배포 조건 변경(문의유형 --> 조치유형)에 따른 코드 추가
					
					if(tempVo5 == null) {  //유지보수 담당자정보 없으면 (JW그룹웨어 전산업무의뢰서 거래처 및 시스템유형 오등록건)  2020.08.18. 보완 
						asVo.setCust_gubun("C001");
						asVo.setGyul_emp1("");
						asVo.setGyul_emp2("");	
					}else {		
						tempasVo1.setCust_code(SsStringUtil.normalizeNull(tempVo2.getTobe_code1()));  //거래처코드						
						asVo.setCust_gubun((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsCustGubun"));  //거래처구분	
						
						tempasVo1.setAssign_id(SsStringUtil.normalizeNull(tempVo6.getWk_emp_no())); //처리담당자
						asVo.setGyul_emp1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)											
						asVo.setGyul_emp2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp2"));  //승인자2(배포)	2023.08.21. 배포 조건 변경(문의유형 --> 조치유형)에 따른 주석처리								
					} 	
					 
					//(JW Shared service) 인터페이스 모두 JW그룹 인걸로 간주 
					//if ("C001".equals(SsStringUtil.normalizeNull(asVo.getCust_gubun()))) { //거래처구분이 C001 JW그룹 인경우 
						if ("Y".equals(SsStringUtil.normalizeNull(asVo.getGyul_gb1()))) { //승인대상1(팀장) 해당시 
						    asVo.setAppr_yn1("N");  //팀장승인여부					
							asVo.setAppr_emp1(SsStringUtil.normalizeNull(asVo.getGyul_emp1()));	 //팀장승인 승인자 					
						}
	 
						if ("Y".equals(SsStringUtil.normalizeNull(asVo.getGyul_gb2()))) { //승인대상2(배포) 해당시   
						    asVo.setAppr_yn2("N");  //배포승인여부									
							asVo.setAppr_emp2(SsStringUtil.normalizeNull(asVo.getGyul_emp2()));  //배포승인 승인자	 					
						}else {
							asVo.setAppr_yn2("");  //배포승인여부					
							asVo.setAppr_emp2(""); //배포승인 승인자 				
						}	
					//}		 					
					////
						
							
					//(JW Shared service) JOB스케줄러에 의해 인터페이스 AS접수시 그룹웨어문서번호 중복체크 쿼리 getSharedDocIdCnt  2020.08.25. 추가	
					//그룹웨어문서번호 동일건 2건이상 인터페이스 접수건 발생되지않게 중복체크 2020.08.25. 김민규부장님 요청 
					tempasVo1.setShared_doc_id(SsStringUtil.normalizeNull(resultVo.getDocid())); //문서 ID		
					int checkExistDocid = commonDAO.selectOneInt(tempasVo1,"asDAO.getSharedDocIdCnt") ;					
					if(checkExistDocid == 0) { // (if 시작) 그룹웨어문서번호 중복체크 (이미 그룹웨어문서번호가 AS번호 생성되어있으면 타지않도록!!)
					
						asVo.setAs_no((String)commonDAO.selectOne(asVo, "asDAO.getMaxSeq"));
						returnValue = commonDAO.insert(asVo, "asDAO.insertAsInfo");
						
						if(returnValue == 1) { 
							//commonMsDAO.update(resultVo, "asDAO.updateEzSharedServiceFlag");
						}
						
						
						////(JW Shared service) AS접수시 유지보수 담당자에게 이메일발송 (처리상태 C001 접수, C000 대기) 2020.07.08. 추가     						  					
						AsVO emailvo = (AsVO) commonDAO.selectOne(asVo, "asDAO.getAsEmailInfo");   
						AsVO retirevo = (AsVO) commonDAO.selectOne(asVo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.07.08.
						//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.07.08. 
						if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {    
							String title = "(JW Shared service)ONTIC LineUs에서 A/S 처리 대기 안내 메일을 보내드립니다.";  
							snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), emailvo.getSender_email(), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;					
							
							if(snedEMAILResult == 1){  			
								asVo.setMemo("(JW Shared service)AS대기 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
								asVo.setSeq(String.valueOf(commonDAO.selectOneInt(asVo, "asDAO.getAsHistMaxSeq")));
								commonDAO.insert(asVo, "asDAO.insertAsInfoHist");
							}	
						}
					
					} //(if 끝) 그룹웨어문서번호 중복체크 (이미 그룹웨어문서번호가 AS번호 생성되어있으면 타지않도록!!)					
					
				}
			}//for문
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		/*slqlsession disconnection*/
		
    }


	
}

