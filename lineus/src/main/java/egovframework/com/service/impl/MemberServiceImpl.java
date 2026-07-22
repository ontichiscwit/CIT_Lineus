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

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.util.SendMailForm;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.MemberService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : MemberServiceImpl.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16registMemberInsert
 * 
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Service("memberService")	
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService {

	@Autowired CommonDao commonDAO ;
	@Autowired CommonSmsService commonSmsService ;

	@Override
	public int getSelectInt(UserVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, queryName);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<UserVO> getList(UserVO vo, String queryName) throws Exception {
		return (List<UserVO>) commonDAO.list(vo, queryName);
	}

	@Override /*send Email, send Mms*/
	public int registMemberChange(UserVO vo) throws Exception {
		int returnValue = 0 ; 
		String seq_arr = SsStringUtil.normalizeNull(vo.getSeq_arr()) ; 
		
		if(!"".equals(seq_arr)) {
			String[] seq = seq_arr.split("@") ; 
			
			if(seq != null && seq.length > 0) {
				for(String temp : seq) {
					UserVO tempVO = new UserVO() ; 
					
					tempVO.setSeq(temp);
					returnValue += commonDAO.update(tempVO, "memberDAO.updateChange") ;
					
					if(!"".equals(SsStringUtil.normalizeNull(tempVO.getSeq()))) {
						commonSmsService.sendSms("CD05", "C003", "MEMBER", tempVO.getCust_code(), "","","") ; /* SMS SEND 회원탈퇴 */
					}
					
					try {
						UserVO mailVO = (UserVO)commonDAO.selectOne(tempVO, "memberDAO.getMemberInfo") ; 
						if(mailVO != null) {
							if(!"".equals(SsStringUtil.normalizeNull(mailVO.getEmail()))) {
								mailVO.setPageType("finish");
								commonSmsService.sendMail("MEMBER",vo.getCust_code(),"", mailVO.getEmail(), "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 탈퇴 완료 안내 메일을 보내드립니다.", SendMailForm.makeMemberMail(mailVO), "", "", 0) ;
							}
						}
					}catch(Exception e) {
						e.printStackTrace();
					}
				}
			}else returnValue = -200 ; 
			
		}else returnValue = -100 ; 
		
		return returnValue;
	}

	@Override
	public int registMemberPassChange(UserVO vo) throws Exception { //거래처 고객 비밀번호 초기화 
		
		int returnValue = 0 ;
		
		if("".equals(SsStringUtil.normalizeNull(vo.getEmp_id()))) returnValue = -100 ; 
		
		if(returnValue == 0) { 
			//vo.setPass(SsStringUtil.encryptSHA256(vo.getEmp_id())); //아이디와 동일패스워드 금지
			vo.setPass(SsStringUtil.encryptSHA256("*Abc1234"));       //초기비번 *Abc1234 설정   			
			returnValue = commonDAO.update(vo, "memberDAO.updatePassChange") ; 
		}
		
		return returnValue;
	}

	@Override/*send Email, send Mms*/
	public int registMemberInsert(UserVO vo) throws Exception {
		int returnValue = 0 ; 
		int dupcheck = "C001".equals(SsStringUtil.normalizeNull(vo.getEmp_grade())) ? commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck1") : 0 ; 	//회원 등급 COO1:고객사 대표, C002:고객사 개인
		int dupcheck2 = commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck2") ; 
		
		if(dupcheck > 0) returnValue = -300 ; 						//고객사 대표 계정 존재
		if(returnValue == 0 && dupcheck2 > 0) returnValue = -400 ; 	//중복된 아이디 존재
		
		if(returnValue == 0) {    
				if(SsStringUtil.validationPass(vo.getPass()) == false) returnValue = -600 ;		
		}			
		
		if(returnValue == 0) {
			if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
			returnValue = commonDAO.update(vo, "memberDAO.insertCustEmp");
						
			if(returnValue > 0) { 
				if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) {
					commonDAO.insert(vo, "memberDAO.insertPassHist");    	
				}
			}					
			
			/*가입상태-정상 sms 전송 서비스*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getEmp_id()))) {
				if ("C001".equals(vo.getUse_type()) &&  !vo.getUse_type2().equals(vo.getUse_type()) ) commonSmsService.sendSms("CD05", "C001", "MEMBER", vo.getCust_code(),vo.getTel_no(),"","") ;  /* 회원가입 승인 완료 안내 */
				if ("C004".equals(vo.getUse_type())) commonSmsService.sendSms("CD05", "C004", "MEMBER", vo.getCust_code(),vo.getTel_no(),"","") ;  /* 회원가입 승인 완료 안내 */
				
			}
			
			
			
			/*가입상태-정상 이메일 전송 서비스*/
			try {
				if(!"".equals(SsStringUtil.normalizeNull(vo.getEmail()))) {
					vo.setPageType("join");
					commonSmsService.sendMail("MEMBER" ,vo.getCust_code(),"", vo.getEmail(), "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 신청 완료 안내 메일을 보내드립니다.", SendMailForm.makeMemberMail(vo), "", "", 0) ;
					
					String title = "" ; 
					if ("C001".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) { vo.setPageType("confirm"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 승인 완료 안내 메일을 보내드립니다." ;}
					else if ("C003".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) { vo.setPageType("finish"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 탈퇴 완료 안내 메일을 보내드립니다.";}
					else if ("C005".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) { vo.setPageType("wrong"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 신청에 대한 미승인 완료 안내 메일을 보내드립니다." ;}
					
					if(!"".equals(title)) {
						commonSmsService.sendMail("MEMBER", vo.getCust_code(),"", vo.getEmail(), title, SendMailForm.makeMemberMail(vo), "", "", 0) ;
					}
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		
		vo.setPageType("insert") ; 
		
		return returnValue ; 
	}

	@Override/*send Email, send Mms*/
	public int registMemberUpdate(UserVO vo) throws Exception {
		
		int returnValue = 0 ; 
		int dupcheck = "C001".equals(SsStringUtil.normalizeNull(vo.getEmp_grade())) ? commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck4") : 0 ; 	//회원 계정유형 COO1:마스터계정, C002:일반계정
		
		if(dupcheck > 0) returnValue = -300 ; 
		
		if(returnValue == 0){		//해당 거래처의 마스터 계정이 없음
			if(!"".equals(SsStringUtil.normalizeNull(vo.getEmp_id()))) {	//USE_TYPE:회원 계정상태 C001:정상, C005:승인거절, C003:탈퇴
				if ("C001".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type()) ) commonSmsService.sendSms("CD05", "C001", "MEMBER", vo.getCust_code(), "","","") ;  /* 회원가입 승인 완료 안내 */
				if ("C005".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) commonSmsService.sendSms("CD05", "C005", "MEMBER", vo.getCust_code(), "","","") ;  /* 회원가입 승인 불가 안내 */
				if ("C003".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) commonSmsService.sendSms("CD05", "C003", "MEMBER", vo.getCust_code(), "","","") ;  /* 회원탈퇴 완료 안내 */
			}
			
			returnValue = commonDAO.update(vo, "memberDAO.updateCustEmp"); 
			
			try {
				if(!"".equals(SsStringUtil.normalizeNull(vo.getEmail()))) {
					String title = "" ; 
					
					if ("C001".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) { vo.setPageType("confirm"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 승인 완료 안내 메일을 보내드립니다." ;}
					else if ("C003".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) { vo.setPageType("finish"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 탈퇴 완료 안내 메일을 보내드립니다.";}
					else if ("C005".equals(vo.getUse_type()) && !vo.getUse_type2().equals(vo.getUse_type())) { vo.setPageType("wrong"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 신청에 대한 미승인 완료 안내 메일을 보내드립니다." ;}
					
					if(!"".equals(title)) {
						commonSmsService.sendMail("MEMBER",vo.getCust_code() ,"", vo.getEmail(), title, SendMailForm.makeMemberMail(vo), "", "", 0) ;
					}
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		
		return returnValue ; 
	}

	@Override
	public UserVO getSelectOne(UserVO vo, String queryName) throws Exception {
		return (UserVO) commonDAO.selectOne(vo, queryName);
	}

	@Override
	public int registErpChange(UserVO vo) throws Exception {
		int returnValue = 0 ; 
		String seq_arr = SsStringUtil.normalizeNull(vo.getSeq_arr()) ; 
		
		if(!"".equals(seq_arr)) {
			String[] seq = seq_arr.split("@") ; 
			
			if(seq != null && seq.length > 0) {
				for(String temp : seq) {
					UserVO tempVO = new UserVO() ; 
					
					tempVO.setEmp_no(temp);
					returnValue += commonDAO.update(tempVO, "memberDAO.updateEmpChange") ; 		
				}
			}else returnValue = -200 ; 
			
		}else returnValue = -100 ; 
		
		return returnValue;
	}

	@Override
	public int registErpPassChange(UserVO vo) throws Exception { //직원 비밀번호 초기화
		int returnValue = 0 ;
		
		if("".equals(SsStringUtil.normalizeNull(vo.getEmp_no()))) returnValue = -100 ; 
		
		if(returnValue == 0) {    
			//vo.setPass(SsStringUtil.encryptSHA256(vo.getEmp_no())); //아이디와 동일패스워드 금지
			vo.setPass(SsStringUtil.encryptSHA256("*Abc1234"));       //초기비번 *Abc1234 설정    
			returnValue = commonDAO.update(vo, "memberDAO.updateErpPassChange") ; 
		}
		
		return returnValue;
	}

	@Override
	public int registErpInsert(UserVO vo) throws Exception {
		
		int returnValue = 0 ; 	
		
		int dupcheck = commonDAO.selectOneInt(vo, "memberDAO.getErpCheck") ; 				
		if(dupcheck > 0) return -300 ; 		
		
		if(returnValue == 0) {   
			if(SsStringUtil.validationPass(vo.getPass()) == false) returnValue = -600 ;		
		}			
		
		//vo.setPass(SsStringUtil.encryptSHA256(vo.getEmp_no()));  
		
		if(returnValue == 0) { 
			if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
			returnValue = commonDAO.update(vo, "memberDAO.registErpInsert") ; 
		}
		
		if(returnValue > 0) { 
			if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) {
				commonDAO.insert(vo, "memberDAO.insertErpPassHist");  	
			}
		}		
		
		return returnValue ; 		
	}

	@Override
	public int registErpUpdate(UserVO vo) throws Exception {
		return commonDAO.update(vo, "memberDAO.registErpUpdate") ; 
	}
	

	@Override
	public int registErpUpdate2(UserVO vo) throws Exception {
		
		int returnValue = 0 ;
		
		if(SsStringUtil.validationPass(vo.getChangePass()) == false) returnValue = -600 ; //2024.03.26 (동일비번체크제한 관련 위치 변경)
		
		vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		int dupcheck = commonDAO.selectOneInt(vo, "memberDAO.getErpCheck3") ;	
		
		if(dupcheck == 0) returnValue = -500 ;	//현재 사용중인 비밀번호를 잘못 입력한 경우
		
		
		
		vo.setChangePass(SsStringUtil.encryptSHA256(vo.getChangePass()));    //2024.03.26 (동일비번체크제한 관련 코드 추가 / 기존에는 암호화 없이 코드를 실행하여서 항상 참이 되는 SQL문이 실행되었음)
		int dupcheck2 = commonDAO.selectOneInt(vo, "memberDAO.getErpPassPolicy4Cnt") ;	
		
		if(dupcheck2 > 0) returnValue = -700 ;	//변경할 비밀번호가 최근 사용했던 비밀번호와 동일한 경우
		
		/*if(returnValue == 0) {  
			if(SsStringUtil.validationPass(vo.getChangePass()) == false) returnValue = -600 ;		
		}	*/
		
		if(returnValue == 0) { 
			if(!"".equals(SsStringUtil.normalizeNull(vo.getChangePass()))) vo.setPass(vo.getChangePass()); //vo.setPass(SsStringUtil.encryptSHA256(vo.getChangePass()));
			returnValue = commonDAO.update(vo, "memberDAO.registErpUpdate") ; 
		}

		if(returnValue > 0) {  
			if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) {
				commonDAO.insert(vo, "memberDAO.insertErpPassHist");  	
			}
		}		
		
		return returnValue ; 
	}	

	@Override
	public int registMemberPUpdate(UserVO vo) throws Exception {
		int returnValue = 0 ; 
		vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		int dupcheck = commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck3") ; 
					
		if(dupcheck == 0) returnValue = -500 ; 
		
		if(returnValue == 0) {  
			if(SsStringUtil.validationPass(vo.getChangePass()) == false) returnValue = -600 ;		
		}    	
		
		if(returnValue == 0) {
			if(!"".equals(SsStringUtil.normalizeNull(vo.getChangePass()))) vo.setPass(SsStringUtil.encryptSHA256(vo.getChangePass()));
			returnValue = commonDAO.update(vo, "memberDAO.updateCustEmp");
		}
		
		if(returnValue > 0) { 
			if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) {
				commonDAO.insert(vo, "memberDAO.insertPassHist");    	
			}
		}		
		
		return returnValue ; 
	}

	@Override
	public int registRatingInfo(UserVO vo) throws Exception {
		
		int returnValue = 0 ;
		
		returnValue = commonDAO.update(vo, "memberDAO.registRatingInfo") ; 
		
		return returnValue;
	}

	@Override
	public int custErpEmpId(UserVO vo) throws Exception {
		return commonDAO.selectOneInt(vo, "memberDAO.custErpEmpId") ;
	}

}
