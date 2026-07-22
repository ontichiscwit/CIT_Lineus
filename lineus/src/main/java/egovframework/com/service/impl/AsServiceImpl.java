/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.com.service.impl;

import java.io.Console;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.dao.CommonDao;
//import egovframework.com.comm.dao.CommonMsDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.InterfaceVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SendMailForm;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.MssqlVO;
import egovframework.com.model.OperateVO;
import egovframework.com.service.AsService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : AsServiceImpl.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.09.08             최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Service("asService")	
public class AsServiceImpl extends EgovAbstractServiceImpl implements AsService {

	@Autowired CommonDao commonDAO ;
	//@Autowired CommonMsDao commonMsDAO;
	@Autowired CommonFileService commonFileService ;
	@Autowired CommonSmsService commonSmsService ;

	@Override
	public Map<String , Object> getAsCustInfo(AsVO vo) throws Exception {
		
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		commonDAO.selectOne(vo, "asDAO.getAsCustInfo");
		returnMap.put("info", vo.getOUTCURSOR());	
	
		return returnMap;
	}
	
	@Override
	public int getMaxSeq() throws Exception {
		return commonDAO.selectOneInt(null, "asDAO.getMaxSeq");
	}

	@Override
	public int insertAsInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		
		int returnValue = 0;
		int attach_seq = 0;
		int attach_seq2 = 0 ;
		int snedSMSResult = 0;
		int snedEMAILResult = 0;
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile_")){
					if(attach_seq == 0) attach_seq = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(attach_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				}else if(temp.getAttach_tag_name().startsWith("upFile_")){
					if(attach_seq2  == 0) attach_seq2 = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
				}
			}
		}
		
		
		
		vo.setFile_seq(String.valueOf(attach_seq));
		vo.setAttach_seq2(attach_seq2);
		vo.setAs_no((String)commonDAO.selectOne(vo, "asDAO.getMaxSeq"));
		vo.setSystem_type(vo.getSystem_type().split("@")[0]);
		
		//vo.setAccept_dt(DateTimeUtil.getDate());		2021.06.01 
		vo.setAccept_time(DateTimeUtil.getTime());		
		
				
		////문의유형 기준으로 AS승인프로세스 추가에 따른 거래처구분, 승인대상1(팀장), 승인대상2(배포), 승인자1(팀장), 승인자2(배포) 2020.08.25. 추가
		//if("C001".equals(SsStringUtil.normalizeNull(vo.getProc_status()))) { //처리상태 접수인 경우에만 팀장승인여부, 팀장승인자, 배포승인여부, 배포승인자 지정되도록 셋팅  		
			AsVO tempasVo1 = new AsVO();     
			tempasVo1.setCust_code(SsStringUtil.normalizeNull(vo.getCust_code()));  //거래처코드			
			vo.setCust_gubun((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsCustGubun")); //거래처구분
			
			tempasVo1.setRequest_type(SsStringUtil.normalizeNull(vo.getRequest_type()));  //문의유형				/C002	
			vo.setGyul_gb1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb1Yn"));  //승인대상1(팀장)
			
			if("".equals(SsStringUtil.normalizeNull(vo.getAction_type()))) {
				vo.setGyul_gb2("N");
			}else {
				tempasVo1.setAction_type(SsStringUtil.normalizeNull(vo.getAction_type()));  //조치유형					//2023.08.22. 배포승인 조건 변경(문의유형-->조치유형)
				vo.setGyul_gb2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb2Yn"));  //승인대상2(배포)
			}
			
						
			tempasVo1.setAssign_id(SsStringUtil.normalizeNull(vo.getAssign_id())); //처리담당자
			vo.setGyul_emp1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)									
			vo.setGyul_emp2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp2"));  //승인자2(배포)										
			 
			////거래처구분이 C001 JW그룹 인경우    (JW그룹인 경우, JW그룹이 아닌경우에도 모두 동일하게 AS승인프로세스 2020.09.03.)    
			//if ("C001".equals(SsStringUtil.normalizeNull(vo.getCust_gubun()))) { 					
						
				if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1()))) { //팀장승인여부 
					//팀장승인, 팀장반려 건은 팀장승인여부, 팀장승인자 셋팅안되게
					
				} else { //팀장승인여부 N 이거나 NULL 이면 팀장승인여부, 팀장승인자 지정되도록 셋팅
					if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb1()))) { //승인대상1(팀장) 해당시 
					    vo.setAppr_yn1("N");  //팀장승인여부				>>팀장승인을Y, 팀장승인일자 추가 	
						vo.setAppr_emp1(SsStringUtil.normalizeNull(vo.getGyul_emp1()));	 //팀장승인 승인자 	
						
						//직접 입력건은 신규등록시 (JW그룹 및 문의유형 기준) 해당시 무조건 대기상태로 저장 되도록 2020.09.03. 보완 
						vo.setProc_status("C000");  							
						
					}else {
					    vo.setAppr_yn1("");  //팀장승인여부					
						vo.setAppr_emp1(""); //팀장승인 승인자 				 
					}
				}
	
				if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2()))) { //배포승인여부 
					//배포승인, 배포반려 건은 배포승인여부, 배포승인자 셋팅안되게
					
				} else { //배포승인여부 N 이거나 NULL 이면 배포승인여부, 배포승인자 지정되도록 셋팅
					if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb2()))) { //승인대상1(배포) 해당시 
					    vo.setAppr_yn2("N");  //배포승인여부					
						vo.setAppr_emp2(SsStringUtil.normalizeNull(vo.getGyul_emp2()));	 //배포승인 승인자 	
						
						//직접 입력건은 신규등록시 (JW그룹 및 문의유형 기준) 해당시 무조건 대기상태로 저장 되도록 2020.09.03. 보완 
						vo.setProc_status("C000");	 						
						
					}else {
					    vo.setAppr_yn2("");  //배포승인여부					
						vo.setAppr_emp2(""); //배포승인 승인자 				
					}
				}
				
			////거래처구분이 C001 JW그룹이 아닌경우 	
			//}else {
			//    vo.setAppr_yn1("");  //팀장승인여부					
			//	vo.setAppr_emp1(""); //팀장승인 승인자 			
			//    vo.setAppr_yn2("");  //배포승인여부					
			//	vo.setAppr_emp2(""); //배포승인 승인자 					
			//}	
		//}
		////			
			
		
		
		returnValue = commonDAO.update(vo, "asDAO.insertAsInfo");
		if(returnValue > 0) {
			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_sms())) ) {
				
				String title = "[LineUs] A/S처리 완료 안내"; 
				String strMsg = vo.getApply_nm()+" 고객님! 중외정보기술입니다.\r\n" + 
						"요청하신 AS건이 처리완료 되었음을 알려드립니다.\r\n" + 
						"접수번호(AS번호):" + vo.getAs_no() +"\r\n" + 
						"자세한 서비스는 LineUs상세보기를 이용하여 주시기 바랍니다.\r\n" + 
						"항상 중외정보기술 LineUs를 이용해주셔서 감사합니다.\r\n" + 
						"";
				snedSMSResult = commonSmsService.sendSms("CD06", "C005", "AS", vo.getCust_code(), vo.getApply_sms_tel(), strMsg,title) ;
			}
			
			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {
				
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 A/S 처리 완료 안내 메일을 보내드립니다."; 
				snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), vo.getApply_email(), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
				
			}
		
			
			if(snedSMSResult == 1){
				vo.setMemo("AS처리완료  SMS(메시전)가 " + vo.getApply_sms_tel() + "번호로 발송되었습니다.");
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			if(snedEMAILResult == 1){
				vo.setMemo("AS처리완료 EMAIL이 " + vo.getApply_email() + "주소로 발송되었습니다.");
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			if(!"C001".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || !"".equals(SsStringUtil.normalizeNull(vo.getMemo()))|| !SsStringUtil.normalizeNull(vo.getReg_id()).equals(SsStringUtil.normalizeNull(vo.getAssign_id()))) {
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			
			//반려시 요청자에게 반려 안내 이메일발송 2020.10.27. (C009 반려, C011 팀장반려, C005 처리완료) 
			if(("C009".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || 
			    "C011".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {
				
				snedEMAILResult = 0;	
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 (반려) A/S 반려 안내 메일을 보내드립니다.";          
				snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), SsStringUtil.normalizeNull(emailvo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
				
				if(snedEMAILResult == 1){ 
					vo.setMemo("(반려) AS반려 EMAIL이 요청자 메일 " + vo.getApply_email() + "주소로 발송되었습니다.");
					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
					commonDAO.insert(vo, "asDAO.insertAsInfoHist");
				} 				
			}
			
			
			//접수시 유지보수 담당자에게 이메일발송 (처리상태 C001 접수, C002 담당자배정중(변경), C003 배정완료, C004 처리중, C012 배포승인)
			if("C001".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ||   
			   "C002".equals(SsStringUtil.normalizeNull(vo.getProc_status()))  ) {		
				
				snedEMAILResult = 0;	
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				AsVO retirevo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.08.31.
				//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.08.31. 
				if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {    								
					String title = "ONTIC LineUs에서 A/S 처리 접수 안내 메일을 보내드립니다."; 
					snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), emailvo.getSender_email(), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
				
					if(snedEMAILResult == 1){  
						//AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");				
						vo.setMemo("AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
						vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
						commonDAO.insert(vo, "asDAO.insertAsInfoHist");
					}	
				}
			}	
						
						
			
			
		}
		
		return returnValue;
	}
	
	@Override
	public int insertAsCnInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		int returnValue = 0;
		int attach_seq = 0;
		int attach_seq2 = 0 ;
		int snedSMSResult = 0;
		int snedEMAILResult = 0;
		
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile_")){
					if(attach_seq == 0) attach_seq = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(attach_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				}else if(temp.getAttach_tag_name().startsWith("upFile_")){
					if(attach_seq2  == 0) attach_seq2 = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
				}
			}
		}
		
		vo.setFile_seq(String.valueOf(attach_seq));
		vo.setAttach_seq2(attach_seq2);
		vo.setCn_as_no(vo.getAs_no());
		vo.setAs_no((String)commonDAO.selectOne(vo, "asDAO.getMaxSubSeq"));
		vo.setSystem_type(vo.getSystem_type().split("@")[0]);
		vo.setAccept_dt(DateTimeUtil.getDate());
		vo.setAccept_time(DateTimeUtil.getTime());

		vo.setGyul_gb1((String)commonDAO.selectOne(vo, "asDAO.getAsGyulGb1Yn"));  //승인대상1(팀장)
		
		if("".equals(SsStringUtil.normalizeNull(vo.getAction_type()))) {
			vo.setGyul_gb2("N");
		}else {
			vo.setAction_type(SsStringUtil.normalizeNull(vo.getAction_type()));  //조치유형					//2023.08.22. 배포승인 조건 변경(문의유형-->조치유형)
			vo.setGyul_gb2((String)commonDAO.selectOne(vo, "asDAO.getAsGyulGb2Yn"));  //승인대상2(배포)
		}
		
		vo.setGyul_emp1((String)commonDAO.selectOne(vo, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)									
		vo.setGyul_emp2((String)commonDAO.selectOne(vo, "asDAO.getAsGyulEmp2"));  //승인자2(배포)

		if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1()))) { //팀장승인여부 
			//팀장승인, 팀장반려 건은 팀장승인여부, 팀장승인자 셋팅안되게
			
		} else { //팀장승인여부 N 이거나 NULL 이면 팀장승인여부, 팀장승인자 지정되도록 셋팅
			if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb1()))) { //승인대상1(팀장) 해당시 
			    vo.setAppr_yn1("N");  //팀장승인여부				>>팀장승인을Y, 팀장승인일자 추가 	
				vo.setAppr_emp1(SsStringUtil.normalizeNull(vo.getGyul_emp1()));	 //팀장승인 승인자 	
				
				//직접 입력건은 신규등록시 (JW그룹 및 문의유형 기준) 해당시 무조건 대기상태로 저장 되도록 2020.09.03. 보완 
				vo.setProc_status("C000");  							
				
			}else {
			    vo.setAppr_yn1("");  //팀장승인여부					
				vo.setAppr_emp1(""); //팀장승인 승인자 				 
			}
		}

		if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2()))) { //배포승인여부 
			//배포승인, 배포반려 건은 배포승인여부, 배포승인자 셋팅안되게
			
		} else { //배포승인여부 N 이거나 NULL 이면 배포승인여부, 배포승인자 지정되도록 셋팅
			if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb2()))) { //승인대상1(배포) 해당시 
			    vo.setAppr_yn2("N");  //배포승인여부					
				vo.setAppr_emp2(SsStringUtil.normalizeNull(vo.getGyul_emp2()));	 //배포승인 승인자 	
				
				//직접 입력건은 신규등록시 (JW그룹 및 문의유형 기준) 해당시 무조건 대기상태로 저장 되도록 2020.09.03. 보완 
				vo.setProc_status("C000");	 						
				
			}else {
			    vo.setAppr_yn2("");  //배포승인여부					
				vo.setAppr_emp2(""); //배포승인 승인자 				
			}
		}
		returnValue = commonDAO.update(vo, "asDAO.insertAsInfo");
		
		if(returnValue > 0) {
			commonDAO.update(vo, "asDAO.updateCnAsState");
			
			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_sms())) ) {
				
				String title = "[LineUs] A/S처리 완료 안내"; 
				String strMsg = vo.getApply_nm()+" 고객님! 중외정보기술입니다.\r\n" + 
						"요청하신 A/S건이 처리완료 되었음을 알려드립니다.\r\n" + 
						"접수번호(A/S번호):" + vo.getAs_no() +"\r\n" + 
						"자세한 서비스는 LineUs상세보기를 이용하여 주시기 바랍니다.\r\n" + 
						"항상 중외정보기술 LineUs를 이용해주셔서 감사합니다.\r\n" + 
						"";
				snedSMSResult = commonSmsService.sendSms("CD06", "C005", "AS",vo.getCust_code(), vo.getApply_sms_tel(), strMsg, title) ;
			}

			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {

				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 A/S 처리 완료 안내 메일을 보내드립니다."; 
				snedEMAILResult = commonSmsService.sendMail("AS","", SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(vo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
				
			}

			
			if(snedSMSResult == 1){
				vo.setMemo("AS처리완료  SMS(메신저)가 " + vo.getApply_sms_tel() + "번호로 발송되었습니다.");
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}

			if(snedEMAILResult == 1){
				vo.setMemo("AS처리완료 EMAIL이 " + vo.getApply_email() + "주소로 발송되었습니다.");
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			if(!"C001".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || !"".equals(SsStringUtil.normalizeNull(vo.getMemo()))|| !SsStringUtil.normalizeNull(vo.getReg_id()).equals(SsStringUtil.normalizeNull(vo.getAssign_id()))) {
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			
			//반려시 요청자에게 반려 안내 이메일발송 2020.10.27. (C009 반려, C011 팀장반려, C005 처리완료) 
			if(("C009".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || 
			    "C011".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {
				
				snedEMAILResult = 0;	
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 (반려) A/S 반려 안내 메일을 보내드립니다.";          
				snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), SsStringUtil.normalizeNull(emailvo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
				
				if(snedEMAILResult == 1){ 
					vo.setMemo("(반려) AS반려 EMAIL이 요청자 메일 " + vo.getApply_email() + "주소로 발송되었습니다.");
					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
					commonDAO.insert(vo, "asDAO.insertAsInfoHist");
				} 				
			}		
			
			
			////접수시 유지보수 담당자에게 이메일발송 (처리상태 C001 접수, C002 담당자배정중(변경), C003 배정완료, C004 처리중)
			if("C001".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ||   
			   "C002".equals(SsStringUtil.normalizeNull(vo.getProc_status()))  ) {		
//			if(!"C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {
				
				snedEMAILResult = 0;	
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				AsVO retirevo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.08.31.
				//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.08.31. 
				if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {    					
					String title = "ONTIC LineUs에서 A/S 처리 접수 안내 메일을 보내드립니다."; 
					snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
					
					if(snedEMAILResult == 1){
						//AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");				
						vo.setMemo("AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
						vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
						commonDAO.insert(vo, "asDAO.insertAsInfoHist");
					}
				}
			}	
					
					
		}
		
		return returnValue;
	}
	
	@Override
	public int updateAsInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		int returnValue = 0;
		int cnERRORValue = 0;
		
		int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0")) ; 
		int attach_seq2 = Integer.parseInt(SsStringUtil.normalize(vo.getAttach_seq2(), "0")) ;
		int snedSMSResult = 0;
		int snedEMAILResult = 0;
		boolean flag_attach_2 = false ; 
		
		String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1()) ; 
		String delAttach2 = SsStringUtil.normalizeNull(vo.getDelAttach2()) ; 
		
		
		if(file_seq > 0) {
			if(!"".equals(delAttach1)) {
				String[] del_attach_seq = delAttach1.split("@") ; 
				
				if(del_attach_seq != null && del_attach_seq.length > 0) {
					for(String temp : del_attach_seq) {
						FileVO fileVO = new FileVO() ; 
						
						fileVO.setAttach_seq(file_seq);
						fileVO.setAttach_ord(Integer.parseInt(temp));
						
						commonFileService.deleteFileInfo(fileVO);
					}
				}
			}
		}
		
		if(attach_seq2 > 0) {
			if(!"".equals(delAttach2)) {
				String[] del_attach_seq = delAttach2.split("@") ; 
				
				if(del_attach_seq != null && del_attach_seq.length > 0) {
					for(String temp : del_attach_seq) {
						FileVO fileVO = new FileVO() ; 
						
						fileVO.setAttach_seq(attach_seq2);
						fileVO.setAttach_ord(Integer.parseInt(temp));
						
						commonFileService.deleteFileInfo(fileVO);
					}
				}
			}
		}
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile_")){
					if(file_seq == 0) file_seq = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(file_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				}else if(temp.getAttach_tag_name().startsWith("upFile_")){
					if(attach_seq2  == 0) attach_seq2 = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
					flag_attach_2 = true ; 
				}
			}
		}
		
		vo.setFile_seq(String.valueOf(file_seq));
		vo.setAttach_seq2(Integer.valueOf(attach_seq2)); 
		vo.setSystem_type(vo.getSystem_type().split("@")[0]);
		
		
		////문의유형 기준으로 AS승인프로세스 추가에 따른 거래처구분, 승인대상1(팀장), 승인대상2(배포), 승인자1(팀장), 승인자2(배포) 2020.08.25. 추가
		//if("C001".equals(SsStringUtil.normalizeNull(vo.getProc_status()))) { //처리상태 접수인 경우에만 팀장승인여부, 팀장승인자, 배포승인여부, 배포승인자 지정되도록 셋팅  		
			AsVO tempasVo1 = new AsVO();     
			tempasVo1.setCust_code(SsStringUtil.normalizeNull(vo.getCust_code()));  //거래처코드			
			vo.setCust_gubun((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsCustGubun")); //거래처구분
			
			tempasVo1.setRequest_type(SsStringUtil.normalizeNull(vo.getRequest_type()));  //문의유형				/C002	
			vo.setGyul_gb1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb1Yn"));  //승인대상1(팀장)
			
			if("".equals(SsStringUtil.normalizeNull(vo.getAction_type()))) {
				vo.setGyul_gb2("N");
			}else {
				tempasVo1.setAction_type(SsStringUtil.normalizeNull(vo.getAction_type()));  //조치유형					//2023.08.22. 배포승인 조건 변경(문의유형-->조치유형)
				vo.setGyul_gb2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb2Yn"));  //승인대상2(배포)
			}							
						
			tempasVo1.setAssign_id(SsStringUtil.normalizeNull(vo.getAssign_id())); //처리담당자
			vo.setGyul_emp1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)									
			vo.setGyul_emp2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp2"));  //승인자2(배포)										
			 
			////거래처구분이 C001 JW그룹 인경우    (JW그룹인 경우, JW그룹이 아닌경우에도 모두 동일하게 AS승인프로세스 2020.09.03.)
			//if ("C001".equals(SsStringUtil.normalizeNull(vo.getCust_gubun()))) {  
				
				String accept_dt = (String)vo.getAccept_dt(); //좌
				String accept_dt_t = "20200901";              //우
				int compareTo = accept_dt.compareTo(accept_dt_t); //문자열의 사전순 값을 비교하여 그에 해당되는 int 값을 리턴한다. 
				
				////접수일자 2020년09월01일이전 데이터 팀장승인여부, 팀장승인자, 배포승인여부, 배포승인자 공란으로셋팅 2020.09.01. 추가 
				if (compareTo < 0) { //좌측 값이 작은 경우 -1 , 좌측 값이 큰 경우 1, 동일한 경우 0    
				    vo.setAppr_yn1("");  //팀장승인여부					
					vo.setAppr_emp1(""); //팀장승인 승인자 			
				    vo.setAppr_yn2("");  //배포승인여부		 			 
					vo.setAppr_emp2(""); //배포승인 승인자 	
					
				} else { //접수일자 2020년09월01일이후 승인 프로세스 						
					if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1()))) { //팀장승인여부 
						//팀장승인, 팀장반려 건은 팀장승인여부, 팀장승인자 셋팅안되게
						
					} else { //팀장승인여부 N 이거나 NULL 이면 팀장승인여부, 팀장승인자 지정되도록 셋팅
						if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb1()))) { //승인대상1(팀장) 해당시 
						    vo.setAppr_yn1("N");  //팀장승인여부					
							vo.setAppr_emp1(SsStringUtil.normalizeNull(vo.getGyul_emp1()));	 //팀장승인 승인자 	
						}else {
						    vo.setAppr_yn1("");  //팀장승인여부					
							vo.setAppr_emp1(""); //팀장승인 승인자 				 
						}
					}
		
					if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2()))) { //배포승인여부 
						//배포승인, 배포반려 건은 배포승인여부, 배포승인자 셋팅안되게
						
					} else { //배포승인여부 N 이거나 NULL 이면 배포승인여부, 배포승인자 지정되도록 셋팅
						if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb2()))) { //승인대상1(배포) 해당시 
						    vo.setAppr_yn2("N");  //배포승인여부					
							vo.setAppr_emp2(SsStringUtil.normalizeNull(vo.getGyul_emp2()));	 //배포승인 승인자 	
						}else {
						    vo.setAppr_yn2("");  //배포승인여부					
							vo.setAppr_emp2(""); //배포승인 승인자 				
						}
					}
				}
				
				// 2023.07.12하위작업 생성 관련 코드 추가 (Main의 처리상태를 "처리완료"로 바꾸기 위한 조건)
				AsVO CnAsR = new AsVO(); 
				CnAsR.setAs_no(SsStringUtil.normalizeNull(vo.getAs_no()));  // 해당 AS번호
				vo.setCn_as_yn((int)commonDAO.selectOne(CnAsR, "asDAO.checkCnAsYn"));  //하위작업 개수 확인(하위작업 존재여부 확인 및 하위작업 개수 파악을 위해 사용) --A
				vo.setCn_as_status((int)commonDAO.selectOne(CnAsR, "asDAO.checkCnAsStatus"));  //하위작업에 처리상태가 대기(C000),처리중(C004),팀장승인(C010)인 개수 확인 --C
				
				// 2023.08.01하위작업에서 배포까지 발생하는 경우 관련 코드 추가
				vo.setCn_as_dep_yn((int)commonDAO.selectOne(CnAsR, "asDAO.checkCnAsDepYn"));  //배포승인이 필요한 하위작업 개수 확인 --B
				vo.setCn_as_dep_status((int)commonDAO.selectOne(CnAsR, "asDAO.checkCnAsDepStatus"));  //배포작업 포함 시 처리가 종료된  건수의 개수 확인 --D
				
				if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status()))) {       //처리상태를 "처리완료"로 저장했을 경우
					
				if("0".equals(SsStringUtil.normalizeNull(vo.getCn_as_yn()))) {             //하위작업 개수가 0개일 경우 처리상태 "처리완료" 가능 (A=0)
					vo.setProc_status(SsStringUtil.normalizeNull(vo.getProc_status()));   
					returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");
				} else {                                                                   // (A>0)
					if("0".equals(SsStringUtil.normalizeNull(vo.getCn_as_dep_yn()))) {     //하위작업들 중 최종 처리상태가 배포승인인 것의 유무 (B=0)
						if("0".equals(SsStringUtil.normalizeNull(vo.getCn_as_status()))) { //하위작업들 중 최종 처리상태가 배포승인인 것이 없고 하위작업들의 처리상태가 대기,처리중,팀장승인인 것이 0개일 경우 "처리완료" 가능 (C=0)
							vo.setProc_status(SsStringUtil.normalizeNull(vo.getProc_status()));   
							returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");
						} else {                                                          //(C>0)
							vo.setProc_status("C004");
							cnERRORValue = 1;
						}
					} else {                                                              // (B>0)
						if(SsStringUtil.normalizeNull(vo.getCn_as_yn()).equals(SsStringUtil.normalizeNull(vo.getCn_as_dep_status()))) { //해당 AS에 대한 하위작업 전체 개수와 해당 AS에 대한 하위작업의 처리상태가 최종인 것들의 개수가 같을 경우(A=D)
							vo.setProc_status(SsStringUtil.normalizeNull(vo.getProc_status()));   
							returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");
						} else {                                                          //(A!=D)
							vo.setProc_status("C004");
							cnERRORValue = 1;
						}
					}
				}
			}else {
				returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");
			}
	
		//returnValue = commonDAO.update(vo, "asDAO.updateAsInfo"); //2023.07.12 하위작업 생성 관련 기존 모든 update 반영 주석처리(하위작업처리상태에 따른 Main처리상태 미변경을 위해 분류화)
		
		if(returnValue > 0) {
			
			//중외그룹 AS건은 SharedService DB update작업이 별도로 필요하다 (C009 반려, C011 팀장반려, C005 처리완료)
			if( !"".equals(SsStringUtil.normalizeNull(vo.getShared_doc_idx()))) {
				if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status()))) {
					//commonMsDAO.update(vo, "asDAO.updateCompleteSsDoc");
				}
				
				if("C009".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || 
				   "C011".equals(SsStringUtil.normalizeNull(vo.getProc_status()))	) {
					//commonMsDAO.update(vo, "asDAO.updateRejectSsDoc");
				}
			
				
			}
			
			if(!SsStringUtil.normalizeNull(vo.getProc_status2()).equals(SsStringUtil.normalizeNull(vo.getProc_status())) || !"".equals(SsStringUtil.normalizeNull(vo.getMemo()))|| !SsStringUtil.normalizeNull(vo.getReg_id()).equals(SsStringUtil.normalizeNull(vo.getAssign_id()))) {
				
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			//commonDAO.update(vo, "asDAO.updateCnAsState");         2023.07.12. 하위작업생성 관련 AS와 CN_AS간의 연동 X
			
			//처리상태가 팀장승인(C010)이고, 유지보수 담당자가 변경되었을 때 1.변경담당자에게 (팀장승인)메일정송 2.CRM_AS_MGT_HIST쌓기 (2022.02.22. 김재용부장님 요청)
			if("C010".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && (SsStringUtil.normalizeNull(vo.getChg_assign_id()) != SsStringUtil.normalizeNull(vo.getAssign_id()))){
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				int snedEMAILResult2 = 0; 
				String title = "ONTIC LineUs에서 (팀장승인완료) A/S 처리 접수 안내 메일을 보내드립니다."; 
				snedEMAILResult2 = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
				
				if(snedEMAILResult2 == 1){	
					vo.setMemo("유지보수 담당자가 변경되었습니다.");
					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
					commonDAO.insert(vo, "asDAO.insertAsInfoHist");
					
					vo.setMemo("(팀장승인완료)AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
					commonDAO.insert(vo, "asDAO.insertAsInfoHist");
				}
			}
			
			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_sms())) ) {
				String title = "[LineUs] A/S처리 완료 안내"; 
				String strMsg = vo.getApply_nm()+" 고객님! 중외정보기술입니다.\r\n" + 
						"요청하신 A/S건이 처리완료 되었음을 알려드립니다.\r\n" + 
						"접수번호(A/S번호):" + vo.getAs_no() +"\r\n" + 
						"자세한 서비스는 LineUs상세보기를 이용하여 주시기 바랍니다.\r\n" + 
						"항상 중외정보기술 LineUs를 이용해주셔서 감사합니다.\r\n" + 
						"";
				snedSMSResult = commonSmsService.sendSms("CD06", "C005", "AS", vo.getCust_code(), vo.getApply_sms_tel(), strMsg , title) ;
			}

			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {

				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 A/S 처리 완료 안내 메일을 보내드립니다."; 
				
				snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(vo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
			}

			
			
			

			if(snedSMSResult == 1){
				vo.setMemo("AS처리완료  SMS(메신저)가 " + vo.getApply_sms_tel() + "번호로 발송되었습니다.");
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}

			if(snedEMAILResult == 1){
				vo.setMemo("AS처리완료 EMAIL이 " + vo.getApply_email() + "주소로 발송되었습니다.");
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			
			//반려시 요청자에게 반려 안내 이메일발송 2020.10.27. (C009 반려, C011 팀장반려, C005 처리완료) 
			if(("C009".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || 
			    "C011".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {
				
				snedEMAILResult = 0;	
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 (반려) A/S 반려 안내 메일을 보내드립니다.";          
				snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), SsStringUtil.normalizeNull(emailvo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
				
				if(snedEMAILResult == 1){ 
					vo.setMemo("(반려) AS반려 EMAIL이 요청자 메일 " + vo.getApply_email() + "주소로 발송되었습니다."); 
					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
					commonDAO.insert(vo, "asDAO.insertAsInfoHist");
				} 				
			}					
			
			
			////접수시 유지보수 담당자에게 이메일발송 (처리상태 C001 접수, C002 담당자배정중(변경), C003 배정완료, C004 처리중)
			if("C001".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ||   
			   "C002".equals(SsStringUtil.normalizeNull(vo.getProc_status()))  ) {
//		    if(!"C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {				
				
				snedEMAILResult = 0;	
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				AsVO retirevo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.08.31.
				//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.08.31. 
				if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {  				
					String title = "ONTIC LineUs에서 유지보수 담당자에게 A/S 처리 접수 안내 메일을 보내드립니다."; 
					snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
					
					if(snedEMAILResult == 1){
						//AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");				
						vo.setMemo("AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
						vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
						commonDAO.insert(vo, "asDAO.insertAsInfoHist");
					} 	
				}
			}		
													
			
		}
		if(cnERRORValue == 0) {      //2023.08.16. 하위작업생성 관련 하위작업들 중 처리가 미완료된 내역들이 존재할 경우 구분
		return returnValue;
		} else {
			returnValue = -999;
			return returnValue;
		}
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<AsVO> getList(AsVO vo, String query) throws Exception {
		return (List<AsVO>) commonDAO.list(vo, query);
	}

	@Override
	public int getTotalCnt(AsVO vo, String query) throws Exception {
		return commonDAO.selectOneInt(vo, query);
	}

	@Override
	public AsVO getAsInfo(AsVO vo) throws Exception {
		return (AsVO)commonDAO.selectOne(vo, "asDAO.getAsInfo");
	}

	@Override
	public AsVO getSelectInfo(AsVO vo, String query) throws Exception {
		return (AsVO) commonDAO.selectOne(vo, query);
	}
	
	////////////////댓글//////////////////////////
	@Override
	public int insertAws(AsVO vo, HttpServletRequest request) throws Exception {
		vo.setSeq(String.valueOf(getAwsMaxSeq()));
		return commonDAO.update(vo, "asDAO.insertAws");
	}
	
	@Override
	public int updateAws(AsVO vo, HttpServletRequest request) throws Exception {
		return commonDAO.update(vo, "asDAO.updateAws");
	}
	
	@Override
	public int deleteAws(AsVO vo, HttpServletRequest request) throws Exception {
		return commonDAO.update(vo, "asDAO.deleteAws");
	}
	
	@Override
	public int getAwsMaxSeq() throws Exception {
		return commonDAO.selectOneInt(null, "asDAO.getAwsMaxSeq");
	}

	
	//////////////// 댓글 끝//////////////////////////////////
	
	
	
	@Override
	public int registChangeStatus(AsVO vo) throws Exception {
		return commonDAO.update(vo, "asDAO.updateStatus");
	}

	@Override
	public int registChangeStar(AsVO vo) throws Exception {
		return commonDAO.update(vo, "asDAO.updateStar");
	}

	@Override
	public int updateAsLayer(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		int returnValue = 0;
		
		int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0")) ; 
		String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1()) ; 
		
		if(file_seq > 0) {
			if(!"".equals(delAttach1)) {
				String[] del_attach_seq = delAttach1.split("@") ; 
				
				if(del_attach_seq != null && del_attach_seq.length > 0) {
					for(String temp : del_attach_seq) {
						FileVO fileVO = new FileVO() ; 
						
						fileVO.setAttach_seq(file_seq);
						fileVO.setAttach_ord(Integer.parseInt(temp));
						
						commonFileService.deleteFileInfo(fileVO);
					}
				}
			}
		}
		
		
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile_")){
					if(file_seq == 0) file_seq = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(file_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				}
			}
		}
		
		vo.setFile_seq(String.valueOf(file_seq));
		
		returnValue = commonDAO.update(vo, "asDAO.updateAsLayer");
		
		return returnValue;
	}

	@Override
	public int updateAsApproval(AsVO vo, HttpServletRequest request)throws Exception{
		vo.setAccept_dt(DateTimeUtil.getDate());
		vo.setAccept_time(DateTimeUtil.getTime());
		
		vo.setProc_status("C001");
		vo.setApproval_dt(DateTimeUtil.getDate()) ;			/**	승인일자*/
		vo.setApproval_time(DateTimeUtil.getTime());			/**	승인시간*/
		vo.setApproval_id(vo.getReg_id());
		return commonDAO.update(vo, "asDAO.updateAsApproval");
	}
	
	@Override
	public int registContents(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		
		int attach_seq = 0 ; 
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("asw_uploadFile_")){
					if(attach_seq  == 0){
						attach_seq = commonFileService.getMaxFileSeq() ;
						temp.setAttach_seq(attach_seq);
					}else{
						temp.setAttach_seq(attach_seq);
					}
					temp.setAttach_ord(commonFileService.getMaxFileOrd(temp));
					commonFileService.insertFile(temp);
				}
			}
			vo.setAttach_seq(attach_seq);
		}
		vo.setW_gubun("U");
		vo.setSeq(String.valueOf(getAwsMaxSeq()));
		return commonDAO.update(vo, "asDAO.insertAwsFront");
	}
	
	@Override
	public int registDelContents(AsVO vo) throws Exception {
		return commonDAO.delete(vo, "asDAO.deleteAwsFront");
	}

	@Override
	public int updateAsCnInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		int returnValue = 0;
		
		int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0")) ; 
		int attach_seq2 = Integer.parseInt(SsStringUtil.normalize(vo.getAttach_seq2(), "0")) ;
		boolean flag_attach_2 = false ; 
		// int snedSMSResult = 0; //2023.11.06. 하위작업생성관련 수정(하위작업에서는 메신저 발송X)
		int snedEMAILResult = 0;
		
		String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1()) ; 
		
		if(file_seq > 0) {
			if(!"".equals(delAttach1)) {
				String[] del_attach_seq = delAttach1.split("@") ; 
				
				if(del_attach_seq != null && del_attach_seq.length > 0) {
					for(String temp : del_attach_seq) {
						FileVO fileVO = new FileVO() ; 
						
						fileVO.setAttach_seq(file_seq);
						fileVO.setAttach_ord(Integer.parseInt(temp));
						
						commonFileService.deleteFileInfo(fileVO);
					}
				}
			}
		}
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile_")){
					if(file_seq == 0) file_seq = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(file_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				}else if(temp.getAttach_tag_name().startsWith("upFile_")){
					if(attach_seq2  == 0) attach_seq2 = commonFileService.getMaxFileSeq() ;
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
					flag_attach_2 = true ; 
				}
			}
		}
		
		vo.setFile_seq(String.valueOf(file_seq));
		vo.setAttach_seq2(Integer.valueOf(attach_seq2));
		vo.setSystem_type(vo.getSystem_type().split("@")[0]);
		
		//2023.07.11  -아래부터 추가 하위작업생성 후 승인 관련 코드
		
	////문의유형 기준으로 AS승인프로세스 추가에 따른 거래처구분, 승인대상1(팀장), 승인대상2(배포), 승인자1(팀장), 승인자2(배포) 2020.08.25. 추가
			//if("C001".equals(SsStringUtil.normalizeNull(vo.getProc_status()))) { //처리상태 접수인 경우에만 팀장승인여부, 팀장승인자, 배포승인여부, 배포승인자 지정되도록 셋팅  		
				AsVO tempasVo1 = new AsVO();     
				tempasVo1.setCust_code(SsStringUtil.normalizeNull(vo.getCust_code()));  //거래처코드			
				vo.setCust_gubun((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsCustGubun")); //거래처구분
				
				tempasVo1.setRequest_type(SsStringUtil.normalizeNull(vo.getRequest_type()));  //문의유형				/C002	
				vo.setGyul_gb1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb1Yn"));  //승인대상1(팀장)															

				if("".equals(SsStringUtil.normalizeNull(vo.getAction_type()))) {
					vo.setGyul_gb2("N");
				}else {
					tempasVo1.setAction_type(SsStringUtil.normalizeNull(vo.getAction_type()));  //조치유형					//2023.08.22. 배포승인 조건 변경(문의유형-->조치유형)
					vo.setGyul_gb2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb2Yn"));  //승인대상2(배포)
				}							
							
				tempasVo1.setAssign_id(SsStringUtil.normalizeNull(vo.getAssign_id())); //처리담당자
				vo.setGyul_emp1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)									
				vo.setGyul_emp2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp2"));  //승인자2(배포)
				
				vo.setAppr_email((String)commonDAO.selectOne(tempasVo1, "asDAO.getApprEmail"));  //2023.08.16 -처리담당자에 대한 승인자2(배포)의 이메일
				 
				////거래처구분이 C001 JW그룹 인경우    (JW그룹인 경우, JW그룹이 아닌경우에도 모두 동일하게 AS승인프로세스 2020.09.03.)
				//if ("C001".equals(SsStringUtil.normalizeNull(vo.getCust_gubun()))) {  
					
					String accept_dt = (String)vo.getAccept_dt(); //좌
					String accept_dt_t = "20200901";              //우
					int compareTo = accept_dt.compareTo(accept_dt_t); //문자열의 사전순 값을 비교하여 그에 해당되는 int 값을 리턴한다. 
					
					////접수일자 2020년09월01일이전 데이터 팀장승인여부, 팀장승인자, 배포승인여부, 배포승인자 공란으로셋팅 2020.09.01. 추가 
					if (compareTo < 0) { //좌측 값이 작은 경우 -1 , 좌측 값이 큰 경우 1, 동일한 경우 0    
					    vo.setAppr_yn1("");  //팀장승인여부					
						vo.setAppr_emp1(""); //팀장승인 승인자 			
					    vo.setAppr_yn2("");  //배포승인여부		 			 
						vo.setAppr_emp2(""); //배포승인 승인자 	
						
					} else { //접수일자 2020년09월01일이후 승인 프로세스 						
						if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn1()))) { //팀장승인여부 
							//팀장승인, 팀장반려 건은 팀장승인여부, 팀장승인자 셋팅안되게
							
						} else { //팀장승인여부 N 이거나 NULL 이면 팀장승인여부, 팀장승인자 지정되도록 셋팅
							if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb1()))) { //승인대상1(팀장) 해당시 
							    vo.setAppr_yn1("N");  //팀장승인여부					
								vo.setAppr_emp1(SsStringUtil.normalizeNull(vo.getGyul_emp1()));	 //팀장승인 승인자 	
							}else {
							    vo.setAppr_yn1("");  //팀장승인여부					
								vo.setAppr_emp1(""); //팀장승인 승인자 				 
							}
						}
			
						if ("Y".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2())) || "R".equals(SsStringUtil.normalizeNull(vo.getAppr_yn2()))) { //배포승인여부 
							//배포승인, 배포반려 건은 배포승인여부, 배포승인자 셋팅안되게
							
						} else { //배포승인여부 N 이거나 NULL 이면 배포승인여부, 배포승인자 지정되도록 셋팅
							if ("Y".equals(SsStringUtil.normalizeNull(vo.getGyul_gb2()))) { //승인대상1(배포) 해당시 
							    vo.setAppr_yn2("N");  //배포승인여부					
								vo.setAppr_emp2(SsStringUtil.normalizeNull(vo.getGyul_emp2()));	 //배포승인 승인자 	
							}else {
							    vo.setAppr_yn2("");  //배포승인여부					
								vo.setAppr_emp2(""); //배포승인 승인자 				
							}
						}
					}
		
					//2023.07.11 위에 코드 모두 pageType : update처럼 진행되기 위해 코드 추가(하위작업생성 후 진행)
					
			//returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");
		
		String cn_as_no = vo.getAs_no() ; 
		String as_no = vo.getCn_as_no() ; 
		
		vo.setCn_as_no(cn_as_no);
		vo.setAs_no(as_no);
		
		
		returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");
		
		if(returnValue > 0) {
			
			commonDAO.update(vo, "asDAO.updateCnAsState");
			// 2023.07.11 아래 코드 pageType : update처럼 진행되도록 수정
			
			
			//처리상태가 팀장승인(C010)이고, 유지보수 담당자가 변경되었을 때 1.변경담당자에게 (팀장승인)메일정송 2.CRM_AS_MGT_HIST쌓기 (2022.02.22. 김재용부장님 요청)
			if("C010".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && (SsStringUtil.normalizeNull(vo.getChg_assign_id()) != SsStringUtil.normalizeNull(vo.getAssign_id()))){
				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				int snedEMAILResult2 = 0;
				String title = "ONTIC LineUs에서 (팀장승인완료) A/S 처리 접수 안내 메일을 보내드립니다."; 
				snedEMAILResult2 = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
				
				if(snedEMAILResult2 == 1){	
					vo.setMemo("유지보수 담당자가 변경되었습니다.");
					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
					commonDAO.insert(vo, "asDAO.insertAsInfoHist");
					
					vo.setMemo("(팀장승인완료)AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
					//commonDAO.insert(vo, "asDAO.insertAsInfoHist");
				}
			}
			
			//2023.08.08 하위작업에 대한 알림은 고객에게 가지 않도록 설정
//			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_sms())) ) {
//				String title = "[LineUs] A/S처리 완료 안내"; 
//				String strMsg = vo.getApply_nm()+" 고객님! 중외정보기술입니다.\r\n" + 
//						"요청하신 A/S건이 처리완료 되었음을 알려드립니다.\r\n" + 
//						"접수번호(A/S번호):" + vo.getAs_no() +"\r\n" + 
//						"자세한 서비스는 LineUs상세보기를 이용하여 주시기 바랍니다.\r\n" + 
//						"항상 중외정보기술 LineUs를 이용해주셔서 감사합니다.\r\n" + 
//						"";
//				snedSMSResult = commonSmsService.sendSms("CD06", "C005", "AS", vo.getCust_code(), vo.getApply_sms_tel(), strMsg , title) ;
//			}
//
			//2023.08.22. 배포승인 조건 변경(문의유형>>조치유형)
			if("C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "C001".equals(SsStringUtil.normalizeNull(vo.getCust_gubun())) && ( "C001".equals(SsStringUtil.normalizeNull(vo.getAction_type())) || "C002".equals(SsStringUtil.normalizeNull(vo.getAction_type())))) {

				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 A/S 처리 완료 안내 메일을 보내드립니다.";
				
				snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(vo.getAppr_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
			}

			
			
			if(!SsStringUtil.normalizeNull(vo.getProc_status2()).equals(SsStringUtil.normalizeNull(vo.getProc_status())) || !"".equals(SsStringUtil.normalizeNull(vo.getMemo()))|| !SsStringUtil.normalizeNull(vo.getReg_id()).equals(SsStringUtil.normalizeNull(vo.getAssign_id()))) {
				
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			//2023.08.08 하위작업에 대한 알림은 고객에게 가지 않도록 설정
//			if(snedSMSResult == 1){
//				vo.setMemo("AS처리완료  SMS(메신저)가 " + vo.getApply_sms_tel() + "번호로 발송되었습니다.");
//				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
//				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
//			}
//
			if(snedEMAILResult == 1){
				vo.setMemo("AS처리완료 EMAIL이 " + vo.getAppr_email() + "주소로 발송되었습니다.");
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
			
			//반려시 요청자에게 반려 안내 이메일발송 2020.10.27. (C009 반려, C011 팀장반려, C005 처리완료)
			//2023.08.08 하위작업에 대한 알림은 고객에게 가지 않도록 설정
//			if(("C009".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || 
//			    "C011".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {
//				
//				snedEMAILResult = 0;	
//				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
//				String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 (반려) A/S 반려 안내 메일을 보내드립니다.";          
//				snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), SsStringUtil.normalizeNull(emailvo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
//				
//				if(snedEMAILResult == 1){ 
//					vo.setMemo("(반려) AS반려 EMAIL이 요청자 메일 " + vo.getApply_email() + "주소로 발송되었습니다."); 
//					vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
//					commonDAO.insert(vo, "asDAO.insertAsInfoHist");
//				} 				
//			}					
			
			
			////접수시 유지보수 담당자에게 이메일발송 (처리상태 C001 접수, C002 담당자배정중(변경), C003 배정완료, C004 처리중)
			//2023.08.08 하위작업에 대한 알림은 고객에게 가지 않도록 설정
//			if("C001".equals(SsStringUtil.normalizeNull(vo.getProc_status())) ||   
//			   "C002".equals(SsStringUtil.normalizeNull(vo.getProc_status()))  ) {
////		    if(!"C005".equals(SsStringUtil.normalizeNull(vo.getProc_status())) && "Y".equals(SsStringUtil.normalizeNull(vo.getSend_email())) ) {				
//				
//				snedEMAILResult = 0;	
//				AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
//				AsVO retirevo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.08.31.
//				//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.08.31. 
//				if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {  				
//					String title = "ONTIC LineUs에서 유지보수 담당자에게 A/S 처리 접수 안내 메일을 보내드립니다."; 
//					snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
//					
//					if(snedEMAILResult == 1){
//						//AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");				
//						vo.setMemo("AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
//						vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
//						commonDAO.insert(vo, "asDAO.insertAsInfoHist");
//					} 	
//				}
//			}
			
			//2023.07.11. 위에 코드 모두 UPDATE에서 가져온 코드(하위작업 모두 pageType : update처럼 진행되도록 수정)
			
			//commonDAO.update(vo, "asDAO.updateCnAsState");  //2023.07.11. 원본에 대해 처리상태 업데이트 하는 코드 주석처리
			
			/*if(!"".equals(SsStringUtil.normalizeNull(vo.getApply_id())) || !"".equals(SsStringUtil.normalizeNull(vo.getApply_tel()))) {
				if (!"".equals(vo.getChg_assign_id())) commonSmsService.sendSms("CD06", "C002", "0", vo.getApply_id() , vo.getApply_tel()) ;   A/S 담당자 배정 완료 
				if (!"".equals(vo.getChg_assign_id()) && !vo.getChg_assign_id().equals(vo.getAssign_id())) commonSmsService.sendSms("CD06", "C003", "0", vo.getApply_id() , vo.getApply_tel()) ;   A/S 담당자 배정 중 (변경) 
				if ("C004".equals(vo.getProc_status())) commonSmsService.sendSms("CD06", "C004", "0", vo.getApply_id() , vo.getApply_tel()) ;   A/S 처리 중  
				if ("C005".equals(vo.getProc_status())) commonSmsService.sendSms("CD06", "C005", "0", vo.getApply_id() , vo.getApply_tel()) ;   A/S 처리 완료 
			}
			*/
			
//			boolean his_flag = false ;
//			
//			if(!his_flag) {
//				AsVO maxHisVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsHistMaxInfo") ; 
//				
//				if(maxHisVO != null) {
//					if(!SsStringUtil.normalizeNull(vo.getProc_status2()).equals(SsStringUtil.normalizeNull(vo.getProc_status())) || !"".equals(SsStringUtil.normalizeNull(vo.getMemo()))|| !SsStringUtil.normalizeNull(vo.getReg_id()).equals(SsStringUtil.normalizeNull(vo.getMemo()))) {
//						his_flag = true; 
//					}
//
//				}
//			}
//			if(his_flag) {
//				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
//				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
//			}
//		}
		
		commonDAO.update(vo, "asDAO.updateMainAsWorkTime"); //2023.11.06. 하위작업관련 생성 (하위작업 작업시간에 따라 메인작업 작업시간 자동 업데이트)
	}
		return returnValue;
	}

	@Override
	public int deleteAsProc(AsVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0;
		if("".equals(SsStringUtil.normalizeNull(vo.getDel_as_no()))) returnValue = -100 ; 
		if(returnValue == 0) {
			String[] delArr = vo.getDel_as_no().split("@");
			for (int i=0; i<delArr.length; i++) {
				vo.setAs_no(delArr[i]);
				returnValue = commonDAO.update(vo, "asDAO.deleteAsProc");	
			}
		}
		return returnValue;
	}
	
	public int selectAsMgtCntByAssignId(String id) throws Exception{
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("id", id);
		return commonDAO.selectOneInt(param, "asDAO.selectAsMgtCntByAssignId");	
	}
	
	
	@Override
	public int approve(AsVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0 ;
		String asNoSave = SsStringUtil.normalizeNull(vo.getAsNoSave()).trim() ; 
		if (!"".equals(asNoSave)) {
			String[] asNoSaveArr = asNoSave.split("@");
			if(asNoSaveArr.length > 0){
				for(int i = 0 ; i < asNoSaveArr.length ; i++){
					AsVO temp = new AsVO();
					String asNo = asNoSaveArr[i] ;
					int asResult = 0 ;
					
					temp.setAs_no(asNo);
					temp.setReg_id(vo.getReg_id());		 
					AsVO asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");	  
					
					if("".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리로직 안타면서 오류메세지도 안뜨도록	returnValue 값셋팅  2020.11.19.			
					//	temp.setAssign_id(temp.getReg_id()); //처리담당자 = 로그인사용자 (임시)    
					//	asinfovo.setAppr_emp1((String)commonDAO.selectOne(temp, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)	
						returnValue += 1;	 					
					} 		  				
					
					if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리안되도록 제외   2020.11.19. 김재용부장님 																						
					
						int checkExistEmp1 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt1") ;
						if(checkExistEmp1 > 0){
							asResult = commonDAO.update(temp, "asDAO.updateAsApprYn1_Y");
							returnValue += asResult;
							//temp.setProc_status("C010"); //C000 대기, C001접수, C010 팀장승인, C011 팀장반려, C005 처리완료, C012 배포승인, C013 배포반려	
							
							//2021.05.18 팀장승인시(처리담당자 배정시) JW그룹 AS건 UPDATE
							if( !"".equals(SsStringUtil.normalizeNull(asinfovo.getShared_doc_idx())) ){
								//int checkWorkerSs = commonMsDAO.selectOneInt(asinfovo,"asDAO.getWorkerSsCnt") ;
								/*if( checkWorkerSs > 0 ){
								//	commonMsDAO.update(asinfovo, "asDAO.updateWorkerSs");
								}*/
							}
						}
						
						int checkExistEmp2 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt2") ;
						if(checkExistEmp2 > 0){
							asResult = commonDAO.update(temp, "asDAO.updateAsApprYn2_Y");
							returnValue += asResult;
							//temp.setProc_status("C012"); //C000 대기, C001접수, C010 팀장승인, C011 팀장반려, C005 처리완료, C012 배포승인, C013 배포반려					
						}						
						
						asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");	  
						 
						if (asResult > 0) { //업데이트 된건만 히스토리내역 및 이메일발송
							if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getProc_dt()))) asinfovo.setProc_dt(asinfovo.getProc_dt().replaceAll("-", "")) ;
							if ("1".equals(asinfovo.getAppr_gb())) { //승인구분 1 접수(팀장), 2 배포   						
								asinfovo.setReg_id(asinfovo.getAppr_emp1()); //AS이력 AS승인 결재 처리자는 로그인사용자 아니고 AS내역 팀장승인자 (대체승인자 X)
							} else {
								asinfovo.setReg_id(asinfovo.getAppr_emp2()); //AS이력 AS승인 결재 처리자는 로그인사용자 아니고 AS내역 배포승인자 (대체승인자 X)
							} 						
							asinfovo.setMemo("A/S승인에서 결재 처리되었습니다.");
							asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
							commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");						
							
							/*유지보수 담당자에게 이메일 발송 (처리상태 C010 팀장승인, C012 배포승인)*/
							if (checkExistEmp1 > 0 && "C010".equals(SsStringUtil.normalizeNull(asinfovo.getProc_status()))){
								
								if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 제외	유지보수 담당자에게 이메일발송 안되도록 (오류남!!)						
								
									int snedEMAILResult = 0;			 									
									AsVO emailvo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
									AsVO retirevo = (AsVO) commonDAO.selectOne(emailvo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.08.31.
									//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.08.31. 
									if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {  				
										String title = "ONTIC LineUs에서 (팀장승인완료) A/S 처리 접수 안내 메일을 보내드립니다."; 
										snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
										
										if(snedEMAILResult == 1){			
											asinfovo.setMemo("(팀장승인완료)AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
											asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
											commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");
										} 	 
									}
								
								}
						   }else if(checkExistEmp2 > 0 && "C012".equals(SsStringUtil.normalizeNull(asinfovo.getProc_status()))){
							   
							   int snedEMAILResult = 0;			 									
								AsVO emailvo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
								AsVO retirevo = (AsVO) commonDAO.selectOne(emailvo, "asDAO.getAsEmpRetireYn");
								
								if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {  				
									String title = "ONTIC LineUs에서 (배포승인완료) A/S 배포승인  안내 메일을 보내드립니다."; 
									snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
									
									if(snedEMAILResult == 1){			
										asinfovo.setMemo("(배포승인완료)AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
										asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
										commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");
									} 	 
								}
							   
						   }
							
						}
					
					}
					
					
				}
			}
		}
		
		return returnValue;
	}
	
	
	@Override
	public int reject(AsVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0 ;
		JSONArray jsonArray = new JSONArray(request.getParameter("DATA_LIST"));		//String을 JSONArray로 변환 (String은 가공이 안되기때문)
																					//jsonArray : [ {"AS_NO":20210928001,"REJECT_DESC":반려사유1} , {"AS_NO":20210927002,"REJECT_DESC":반려사유2}]
		for (int i = 0; i < jsonArray.length(); i++) {
			int asResult = 0 ;
			AsVO temp = new AsVO();
			JSONObject jsonObject = jsonArray.getJSONObject(i);						//JSONObject : {"AS_NO":20210928001,"REJECT_DESC":반려사유1}
			temp.setAs_no(jsonObject.getString("AS_NO"));							//JSON타입은 key값으로 value를 꺼내올수 있으니깐.이게 가공
			temp.setReg_id(vo.getReg_id());
			temp.setAction_content(jsonObject.getString("REJECT_DESC"));
			
			AsVO asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
			temp.setShared_doc_idx(String.valueOf(commonDAO.selectOneInt(temp, "asDAO.getDocIdxInfo")));
			
			if("".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리로직 안타면서 오류메세지도 안뜨도록	returnValue 값셋팅  2020.11.19.			
			//	temp.setAssign_id(temp.getReg_id()); //처리담당자 = 로그인사용자 (임시)    
			//	asinfovo.setAppr_emp1((String)commonDAO.selectOne(temp, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)	
				returnValue += 1;	 					
			} //배정 담당자가 없으면  > 1 						
			
			
			
			//배정담당자 있다는 조건하에.
			if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리안되도록 제외   2020.11.19. 김재용부장님 						
			
				int checkExistEmp1 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt1") ;
				if(checkExistEmp1 > 0){
					asResult = commonDAO.update(temp, "asDAO.updateAsApprYn1_N");	
					returnValue += asResult;		
					
					//2021.09.27 추가 (SharedService 테이블 업데이트)
					if( !"0".equals(SsStringUtil.normalizeNull(temp.getShared_doc_idx()))){
						//commonMsDAO.update(temp, "asDAO.updateRejectSsDoc");
					}
				
				}
				
				int checkExistEmp2 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt2") ;
				if(checkExistEmp2 > 0){
					asResult = commonDAO.update(temp, "asDAO.updateAsApprYn2_N");
					returnValue += asResult;	
					//temp.setProc_status("C013"); //C000 대기, C001접수, C010 팀장승인, C011 팀장반려, C005 처리완료, C012 배포승인, C013 배포반려							
				}				
				
				asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");	  
				
				if (asResult > 0) { //업데이트 된건만 AS히스토리내역 생성
					if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getProc_dt()))) asinfovo.setProc_dt(asinfovo.getProc_dt().replaceAll("-", "")) ;						
					if ("1".equals(asinfovo.getAppr_gb())) { //승인구분 1 접수(팀장), 2 배포 	 									
						asinfovo.setReg_id(asinfovo.getAppr_emp1()); //AS이력 AS승인 부결 처리자는 로그인사용자 아니고 AS내역 팀장승인자 (대체승인자 X)
					} else {
						asinfovo.setReg_id(asinfovo.getAppr_emp2()); //AS이력 AS승인 부결 처리자는 로그인사용자 아니고 AS내역 배포승인자 (대체승인자 X)
					} 
					asinfovo.setMemo("A/S승인에서 부결 처리되었습니다.");
					asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
					commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");	
					
					////팀장반려시 AS요청자(고객)에게 반려 안내 이메일발송 추가 2020.10.27.  
					////(처리상태 C000 대기, C010 팀장승인, c011 팀장반려, C001 접수, C002 담당자배정중(변경), C003 배정완료, C004 처리중, C005 처리완료)
					if (checkExistEmp1 > 0 && "C011".equals(SsStringUtil.normalizeNull(asinfovo.getProc_status()))){
					    if("Y".equals(SsStringUtil.normalizeNull(asinfovo.getSend_email())) ) { //이메일 발송여부(Y/N)  
							
							int snedEMAILResult = 0;			 									
							AsVO emailvo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");									
							String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 (팀장반려) A/S 반려 안내 메일을 보내드립니다."; 
							snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", emailvo.getAttach_seq2()) ;
							
							if(snedEMAILResult == 1){	  			
								asinfovo.setMemo("(팀장반려) AS반려 EMAIL이 요청자 메일 " + emailvo.getApply_email() + "주소로 발송되었습니다.");
								asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
								commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");     
							} 	 
					    }	
				    }							
				}
			}
		}
		
		return returnValue;
	}
	
	
	@Override
	public int cancle(AsVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0 ;
		String asNoSave = SsStringUtil.normalizeNull(vo.getAsNoSave()).trim() ; 
		if (!"".equals(asNoSave)) {
			String[] asNoSaveArr = asNoSave.split("@");
			if(asNoSaveArr.length > 0){
				for(int i = 0 ; i < asNoSaveArr.length ; i++){
					AsVO temp = new AsVO();
					String asNo = asNoSaveArr[i] ; 
					int asResult = 0 ;
					
					temp.setAs_no(asNo);
					temp.setReg_id(vo.getReg_id());		
					AsVO asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
					
					if("".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리로직 안타면서 오류메세지도 안뜨도록	returnValue 값셋팅  2020.11.19.			
					//	temp.setAssign_id(temp.getReg_id()); //처리담당자 = 로그인사용자 (임시)    
					//	asinfovo.setAppr_emp1((String)commonDAO.selectOne(temp, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)	
						returnValue += 1;	  					
					} 						
					
					if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리안되도록 제외   2020.11.19. 김재용부장님 						
					
						int checkExistEmp1 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt1_C") ;
						if(checkExistEmp1 > 0){						
							asResult = commonDAO.update(temp, "asDAO.updateAsApprYn1_C");	
							returnValue += asResult;	
							//temp.setProc_status("C000"); //C000 대기, C001접수, C010 팀장승인, C011 팀장반려, C005 처리완료, C012 배포승인, C013 배포반려							
						}
						
						int checkExistEmp2 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt2_C") ;
						if(checkExistEmp2 > 0){
							asResult = commonDAO.update(temp, "asDAO.updateAsApprYn2_C");
							returnValue += asResult;	
							//temp.setProc_status("C005"); //C000 대기, C001접수, C010 팀장승인, C011 팀장반려, C005 처리완료, C012 배포승인, C013 배포반려							
						}
						
						asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");	  
						
						if (asResult > 0) { //업데이트 된건만 AS히스토리내역 생성
							if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getProc_dt()))) asinfovo.setProc_dt(asinfovo.getProc_dt().replaceAll("-", "")) ;						
							if ("1".equals(asinfovo.getAppr_gb())) { //승인구분 1 접수(팀장), 2 배포 					
								asinfovo.setReg_id(asinfovo.getAppr_emp1()); //AS이력 AS승인 취소 처리자는 로그인사용자 아니고 AS내역 팀장승인자 (대체승인자 X)
							} else {
								asinfovo.setReg_id(asinfovo.getAppr_emp2()); //AS이력 AS승인 취소 처리자는 로그인사용자 아니고 AS내역 배포승인자 (대체승인자 X)
							} 
							asinfovo.setMemo("A/S승인에서 취소 처리되었습니다."); 
							asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
							commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");											
						}				
	
					}
					
				}
			}
		}
		return returnValue;
		
	}
	
	@Override
	public  Map<String , Object> checkTypeQuestion(AsVO vo, HttpServletRequest request) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		AsVO temp = new AsVO();
		temp.setRequest_type(vo.getRequest_type());
		List<String> listGyulGb1 =  (List<String>)commonDAO.list(temp , "asDAO.getAsGyulGb1Yn");
		if(listGyulGb1 != null || listGyulGb1.size() > 0){
			if(listGyulGb1.get(0) != null){
				returnMap.put("GYUL_GB1",listGyulGb1.get(0));
			}
		}
		if("".equals(vo.getAction_type())) {
			
		}else {
			temp.setAction_type(vo.getAction_type());
			List<String> listGyulGb2 =  (List<String>)commonDAO.list(temp , "asDAO.getAsGyulGb2Yn");
			if(listGyulGb2 != null || listGyulGb1.size() > 0){
				if(listGyulGb2.get(0) != null){
					returnMap.put("GYUL_GB2", listGyulGb2.get(0));
				}
			}
		}
		return returnMap;
		
	}
	
	@Override
	public int updateUserTest(AsVO vo, String query) throws Exception {
		
		return commonDAO.update(vo, query);
	}
	
	@Override
	public int checkUserTestYn(AsVO vo, String query) throws Exception {
		
		return commonDAO.selectOneInt(vo, query);
	}

	@Override
	public int reSendEmail(AsVO vo, HttpServletRequest request) throws Exception {
	
		int snedEMAILResult = 0;
		int resultValue = 0;
		
		AsVO emailvo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsEmailInfo");
		String title = "(재발송)중외정보기술에서 제공하는 ONTIC LineUs에서 A/S 처리완료 안내 메일을 보내드립니다."; 
		
		snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(vo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", vo.getAttach_seq2()) ;
		
		if(snedEMAILResult == 1){
			vo.setMemo("(재발송)AS처리완료 EMAIL이 " + vo.getApply_email() + "주소로 발송되었습니다.");
			vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
			resultValue = commonDAO.insert(vo, "asDAO.insertAsInfoHist");
		}
		
		return resultValue;
		
	}

	@Override
	public int goApprove(AsVO vo, HttpServletRequest request) throws Exception {
		
		int returnValue = 0 ;
		int asResult = 0 ;
		
		AsVO temp = new AsVO();
		
		if(vo.getCn_as_no().isEmpty()) {  //2023.07.17. 하위작업생성관련cn_as_no의 유무에 따라 객체 temp의 as_no값에 as_no와 cn_as_no 중 대입할 값 결정(메인AS와 하위작업AS의 구분)
			temp.setAs_no(vo.getAs_no());
		} else {
			temp.setAs_no(vo.getCn_as_no());
		}
		
		//temp.setAs_no(vo.getAs_no());  //2023.07.17. 하위작업생성 관련 주석처리
		
		temp.setReg_id(vo.getReg_id());
		
		
		AsVO asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");	  
		
		if("".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리로직 안타면서 오류메세지도 안뜨도록	returnValue 값셋팅  2020.11.19.			
		//	temp.setAssign_id(temp.getReg_id()); //처리담당자 = 로그인사용자 (임시)    
		//	asinfovo.setAppr_emp1((String)commonDAO.selectOne(temp, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)	
			returnValue += 1;	 					
		} 		  				
		
		if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리안되도록 제외   2020.11.19. 김재용부장님 																						
		
			int checkExistEmp1 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt1") ; // AS승인 팀장승인 결재 및 부결 시 UPDATE 하기전 해당AS번호 중복체크 쿼리(AS번호 존재 체크)
			if(checkExistEmp1 > 0){// AS승인 팀장승인 결재 및 부결 시 UPDATE 하기전 해당AS번호 중복체크 쿼리(AS번호 존재 체크)
				asResult = commonDAO.update(temp, "asDAO.updateAsApprYn1_Y");
				returnValue += asResult;
				//temp.setProc_status("C010"); //C000 대기, C001접수, C010 팀장승인, C011 팀장반려, C005 처리완료, C012 배포승인, C013 배포반려	
				
				//2021.05.18 팀장승인시(처리담당자 배정시) JW그룹 AS건 UPDATE
				if( !"".equals(SsStringUtil.normalizeNull(asinfovo.getShared_doc_idx())) ){
					//int checkWorkerSs = commonMsDAO.selectOneInt(asinfovo,"asDAO.getWorkerSsCnt") ;
					/*if( checkWorkerSs > 0 ){
						//commonMsDAO.update(asinfovo, "asDAO.updateWorkerSs");
					}*/
				}
			}
			
			int checkExistEmp2 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt2") ;
			if(checkExistEmp2 > 0){
				asResult = commonDAO.update(temp, "asDAO.updateAsApprYn2_Y");
				returnValue += asResult;
			}
			
			asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
			
			if (asResult > 0) { //업데이트 된건만 히스토리내역 및 이메일발송
				if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getProc_dt()))) asinfovo.setProc_dt(asinfovo.getProc_dt().replaceAll("-", "")) ;
				if ("1".equals(asinfovo.getAppr_gb())) { //승인구분 1 접수(팀장), 2 배포
					asinfovo.setReg_id(asinfovo.getAppr_emp1()); //AS이력 AS승인 결재 처리자는 로그인사용자 아니고 AS내역 팀장승인자 (대체승인자 X)
				} else {
					asinfovo.setReg_id(asinfovo.getAppr_emp2()); //AS이력 AS승인 결재 처리자는 로그인사용자 아니고 AS내역 배포승인자 (대체승인자 X)
				} 						
				asinfovo.setMemo("A/S승인에서 결재 처리되었습니다.");
				asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");						
				
				/*유지보수 담당자에게 이메일 발송 (처리상태 C010 팀장승인, C012 배포승인)*/
				if (checkExistEmp1 > 0 && "C010".equals(SsStringUtil.normalizeNull(asinfovo.getProc_status()))){
					
					if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 제외	유지보수 담당자에게 이메일발송 안되도록 (오류남!!)						
					
						int snedEMAILResult = 0;
						AsVO emailvo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
						AsVO retirevo = (AsVO) commonDAO.selectOne(emailvo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.08.31.
						//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.08.31. 
						if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {  				
							String title = "ONTIC LineUs에서 (팀장승인완료) A/S 처리 접수 안내 메일을 보내드립니다.";
							snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
							
							if(snedEMAILResult == 1){
								asinfovo.setMemo("(팀장승인완료)AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
								asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
								commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");
							} 	 
						}
					
					}
			   }else if(checkExistEmp2 > 0 && "C012".equals(SsStringUtil.normalizeNull(asinfovo.getProc_status()))){
				   
				   int snedEMAILResult = 0;			 									
					AsVO emailvo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
					AsVO retirevo = (AsVO) commonDAO.selectOne(emailvo, "asDAO.getAsEmpRetireYn");
					
					if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {  				
						String title = "ONTIC LineUs에서 (배포승인완료) A/S 배포승인  안내 메일을 보내드립니다."; 
						snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getSender_email()), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;
						
						if(snedEMAILResult == 1){			
							asinfovo.setMemo("(배포승인완료)AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
							asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
							commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");
						} 	 
					}
				   
			   }
				
			}
		
		}
		 return returnValue;
	}

	@Override
	public int goReject(AsVO vo, HttpServletRequest request) throws Exception {
		
		int returnValue = 0 ;
		int asResult = 0 ;
		
		AsVO temp = new AsVO();
		temp.setAs_no(vo.getAs_no());
		temp.setReg_id(vo.getReg_id());	
		
		AsVO asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");
		temp.setShared_doc_idx(String.valueOf(commonDAO.selectOneInt(temp, "asDAO.getDocIdxInfo")));
		
		if("".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리로직 안타면서 오류메세지도 안뜨도록	returnValue 값셋팅  2020.11.19.			
		//	temp.setAssign_id(temp.getReg_id()); //처리담당자 = 로그인사용자 (임시)    
		//	asinfovo.setAppr_emp1((String)commonDAO.selectOne(temp, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)	
			returnValue += 1;	 					
		} //배정 담당자가 없으면  > 1 						
		
		
		
		//배정담당자 있다는 조건하에.
		if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getAssign_id()))) { //배정담당자 공란 건 처리안되도록 제외   2020.11.19. 김재용부장님 						
		
			int checkExistEmp1 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt1") ;
			if(checkExistEmp1 > 0){
				asResult = commonDAO.update(temp, "asDAO.updateAsApprYn1_N");	
				returnValue += asResult;		
				
				//2021.09.27 추가 (SharedService 테이블 업데이트)
				if( !"0".equals(SsStringUtil.normalizeNull(temp.getShared_doc_idx()))){
					//commonMsDAO.update(temp, "asDAO.updateRejectSsDoc");
				}
			
			}
			
			int checkExistEmp2 = commonDAO.selectOneInt(temp,"asDAO.getAsApprCnt2") ;
			if(checkExistEmp2 > 0){
				asResult = commonDAO.update(temp, "asDAO.updateAsApprYn2_N");
				returnValue += asResult;	
			}				
			
			asinfovo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");	  
			
			if (asResult > 0) { //업데이트 된건만 AS히스토리내역 생성
				if(!"".equals(SsStringUtil.normalizeNull(asinfovo.getProc_dt()))) asinfovo.setProc_dt(asinfovo.getProc_dt().replaceAll("-", "")) ;						
				if ("1".equals(asinfovo.getAppr_gb())) { //승인구분 1 접수(팀장), 2 배포 	 									
					asinfovo.setReg_id(asinfovo.getAppr_emp1()); //AS이력 AS승인 부결 처리자는 로그인사용자 아니고 AS내역 팀장승인자 (대체승인자 X)
				} else {
					asinfovo.setReg_id(asinfovo.getAppr_emp2()); //AS이력 AS승인 부결 처리자는 로그인사용자 아니고 AS내역 배포승인자 (대체승인자 X)
				} 
				asinfovo.setMemo("A/S승인에서 부결 처리되었습니다.");
				asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");	
				
				////팀장반려시 AS요청자(고객)에게 반려 안내 이메일발송 추가 2020.10.27.  
				////(처리상태 C000 대기, C010 팀장승인, c011 팀장반려, C001 접수, C002 담당자배정중(변경), C003 배정완료, C004 처리중, C005 처리완료)
				if (checkExistEmp1 > 0 && "C011".equals(SsStringUtil.normalizeNull(asinfovo.getProc_status()))){
				    if("Y".equals(SsStringUtil.normalizeNull(asinfovo.getSend_email())) ) { //이메일 발송여부(Y/N)  
						
						int snedEMAILResult = 0;			 									
						AsVO emailvo = (AsVO) commonDAO.selectOne(temp, "asDAO.getAsEmailInfo");									
						String title = "중외정보기술에서 제공하는 ONTIC LineUs에서 (팀장반려) A/S 반려 안내 메일을 보내드립니다."; 
						snedEMAILResult = commonSmsService.sendMail("AS","",SsStringUtil.normalizeNull(emailvo.getSender_email()), SsStringUtil.normalizeNull(emailvo.getApply_email()), title, SendMailForm.makeAsMail(emailvo), "", "", emailvo.getAttach_seq2()) ;
						
						if(snedEMAILResult == 1){	  			
							asinfovo.setMemo("(팀장반려) AS반려 EMAIL이 요청자 메일 " + emailvo.getApply_email() + "주소로 발송되었습니다.");
							asinfovo.setSeq(String.valueOf(commonDAO.selectOneInt(asinfovo, "asDAO.getAsHistMaxSeq")));
							commonDAO.insert(asinfovo, "asDAO.insertAsInfoHist");     
						} 	 
				    }	
			    }							
			}
		}
	
	return returnValue;
	
	}

	@Override
	public int schedulerTrigger() throws Exception {
		
		HashMap<String,String> param = new HashMap<String, String>();
		int returnValue = 0; 
		try {
			//SELECT SHARED SERVICE
			List<MssqlVO> resultList = null ;
			MssqlVO dump = new MssqlVO();
			MssqlVO dump2 = new MssqlVO();
			//resultList = (List<MssqlVO>) commonMsDAO.list(dump, "asDAO.getEzSharedServiceSelect");
			
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
					tempVo.setAsis_code1(SsStringUtil.trim(resultVo.getLevel2()));
					tempVo = (InterfaceVO) commonDAO.selectOne(tempVo, "asDAO.selectInterfaceCode");
					if(tempVo == null) {tempVo.setTobe_code1(""); tempVo.setTobe_code2("");} 
					
					//GET SHARED SERVICE & LINEUS CODE MAPPING(REQUEST CODE)
					tempVo1.setCode_gubun("LEVEL3");
					tempVo1.setAsis_code1(SsStringUtil.trim(resultVo.getLevel3()));
					tempVo1 = (InterfaceVO) commonDAO.selectOne(tempVo1, "asDAO.selectInterfaceCode");
					if(tempVo1 == null) {tempVo1.setTobe_code1("");}
					
					
					//GET CUST CODE(EPR CODE)
					tempVo2.setCode_gubun("CUST");
					tempVo2.setAsis_code1(SsStringUtil.trim(resultVo.getRegcomid()));
					tempVo2 = (InterfaceVO) commonDAO.selectOne(tempVo2, "asDAO.selectInterfaceCode");
					if(tempVo2 == null) {tempVo2.setTobe_code1("");} 
					
					//GET OPERATE SEQ
					tempVo3.setErp_code(tempVo2.getTobe_code1()); //cust code
					tempVo3.setSystem_code(tempVo.getTobe_code1()); //system code
					tempVo4.setErp_code(tempVo2.getTobe_code1());
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
					asVo.setCall_content(SsStringUtil.normalizeNull(resultVo.getDocttl()) +"\r" +SsStringUtil.normalizeNull(resultVo.getDoctxt())); //제목+내용
					
					if(  "1".equals(SsStringUtil.normalizeNull(resultVo.getDocattach())) ) {
						
						//int checkDocattach = commonMsDAO.selectOneInt(resultVo, "asDAO.getDocattachCnt");
						
						/*if(checkDocattach == 0){
							//logger.error("getDocattach Fail");
						}else{
							asVo.setShared_attach("Y"); //첨부파일
							//dump2 = (MssqlVO)commonMsDAO.selectOne(resultVo,"asDAO.getDocattach");
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
												
					
					////문의유형 기준으로 AS승인프로세스 추가에 따른 거래처구분, 승인대상1(팀장), 승인자1(팀장) 2020.08.03. 추가
					////조치유형 기준으로 AS승인프로세스 추가에 따른 승인대상2(배포), 승인자2(배포) 2023.08.22. 추가
					if(asVo.getRequest_type() == null) {	    									
						asVo.setGyul_gb1("N");

					}else {
						tempasVo1.setRequest_type(SsStringUtil.normalizeNull(tempVo1.getTobe_code1())); //문의유형					
						asVo.setGyul_gb1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb1Yn"));  //승인대상1(팀장)													
						//asVo.setGyul_gb2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulGb2Yn"));  //승인대상2(배포)	  //2023.08.22. 배포 조건 변경(문의유형 --> 조치유형)에 따른 주석 처리			
					}
					        
						asVo.setGyul_gb2("N");  //2023.08.22. 배포 조건 변경(문의유형 --> 조치유형)에 따른 코드 추가 / 조치유형은 미입력되어있으므로 항상 'N'으로 설정
					
					if(tempVo5 == null) {  //유지보수 담당자정보 없으면 (JW그룹웨어 전산업무의뢰서 거래처 및 시스템유형 오등록건)  2020.08.18. 보완 
						asVo.setCust_gubun("C001");
						asVo.setGyul_emp1("");
						asVo.setGyul_emp2("");	
					}else {		
						tempasVo1.setCust_code(SsStringUtil.normalizeNull(tempVo2.getTobe_code1()));  //거래처코드						
						asVo.setCust_gubun((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsCustGubun"));  //거래처구분	
						
						tempasVo1.setAssign_id(SsStringUtil.normalizeNull(tempVo6.getWk_emp_no())); //처리담당자
						asVo.setGyul_emp1((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp1"));  //승인자1(팀장)										
						asVo.setGyul_emp2((String)commonDAO.selectOne(tempasVo1, "asDAO.getAsGyulEmp2"));  //승인자2(배포)							
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
						
						/*if(returnValue == 1) { 
							commonMsDAO.update(resultVo, "asDAO.updateEzSharedServiceFlag");
						}*/
						
						
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
		
		
		
		
		
		return 0;
	}
	
	
	
}
