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
 * @since 2009. 03.16
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

	@Override
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
						commonSmsService.sendSms("CD05", "C003", "SEQ", tempVO.getSeq(), "") ; /* SMS SEND 회원탈퇴 */
					}
					
					try {
						UserVO mailVO = (UserVO)commonDAO.selectOne(tempVO, "memberDAO.getMemberInfo") ; 
						if(mailVO != null) {
							if(!"".equals(SsStringUtil.normalizeNull(mailVO.getEmail()))) {
								mailVO.setPageType("finish");
								commonSmsService.sendMail("admin@cwit.co.kr", mailVO.getEmail(), "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 탈퇴 완료 안내 메일을 보내드립니다.", SendMailForm.makeMemberMail(mailVO), "", "") ;
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
	public int registMemberPassChange(UserVO vo) throws Exception {
		
		int returnValue = 0 ;
		
		if("".equals(SsStringUtil.normalizeNull(vo.getEmp_id()))) returnValue = -100 ; 
		
		if(returnValue == 0) {
			vo.setPass(SsStringUtil.encryptSHA256(vo.getEmp_id()));
			returnValue = commonDAO.update(vo, "memberDAO.updatePassChange") ; 
		}
		
		return returnValue;
	}

	@Override
	public int registMemberInsert(UserVO vo) throws Exception {
		int returnValue = 0 ;
		String empGrade = SsStringUtil.normalizeNull(vo.getEmp_grade());
		
		/*아이디 중복 체크*/
		int dupcheck = 0;
		dupcheck = commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck2") ;
		
		/*이메일 중복 체크*/
		
		/*대표계정 가입 시도 시, 대표계정이 이미 존재할때*/
		int dupcheck1 = "C001".equals(SsStringUtil.normalizeNull(vo.getEmp_grade())) ? commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck1") : 0 ; 
		
		/*일반계정 가입 시도 시, 대표계정 상태가 정상이 아닐때*/
		int dupcheck3 = "C002".equals(SsStringUtil.normalizeNull(vo.getEmp_grade())) ? commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck5") :0 ;
		
		if(dupcheck  > 0) {returnValue = -400 ;/*동일한 아이디가 중복일 경우*/
		}else if(dupcheck1 > 0) {returnValue = -300 ; /*대표계정이 이미 존재할 경우*/
		}else if(dupcheck3 > 0) {returnValue = -500 ;} /* 대표계정 상태가 정상이 아니면 가입 불가 */ 
		
		if(returnValue == 0) {
			if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
			vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "memberDAO.getMemberMaxSeq")));
			returnValue = commonDAO.update(vo, "memberDAO.insertCustEmp");
			
			if(!"".equals(SsStringUtil.normalizeNull(vo.getEmp_id()))) {
				if ("C001".equals(vo.getUse_type())) commonSmsService.sendSms("CD05", "C001", "0", vo.getEmp_id(), "") ;  /* 회원가입 승인 완료 안내 */
			}
			
			
			try {
				if(!"".equals(SsStringUtil.normalizeNull(vo.getEmail()))) {
					vo.setPageType("join");
					commonSmsService.sendMail("admin@cwit.co.kr", vo.getEmail(), "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 신청 완료 안내 메일을 보내드립니다.", SendMailForm.makeMemberMail(vo), "", "") ;
					
					String title = "" ; 
					
					if ("C001".equals(vo.getUse_type())) { vo.setPageType("confirm"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 승인 완료 안내 메일을 보내드립니다." ;}
					else if ("C003".equals(vo.getUse_type())) { vo.setPageType("finish"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 탈퇴 완료 안내 메일을 보내드립니다.";}
					else if ("C005".equals(vo.getUse_type())) { vo.setPageType("wrong"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 신청에 대한 미승인 완료 안내 메일을 보내드립니다." ;}
					
					if(!"".equals(title)) {
						commonSmsService.sendMail("admin@cwit.co.kr", vo.getEmail(), title, SendMailForm.makeMemberMail(vo), "", "") ;
					}
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		
		vo.setPageType("insert") ; 
		
		return returnValue ; 
	}

	@Override
	public int registMemberUpdate(UserVO vo) throws Exception {
		
		int returnValue = 0 ; 
		int dupcheck = "C001".equals(SsStringUtil.normalizeNull(vo.getEmp_grade())) ? commonDAO.selectOneInt(vo, "memberDAO.getMemberCheck4") : 0 ; 
		
		if(dupcheck > 0) returnValue = -300 ; 
		
		if(returnValue == 0){
			if(!"".equals(SsStringUtil.normalizeNull(vo.getEmp_id()))) {
				if ("C001".equals(vo.getUse_type())) commonSmsService.sendSms("CD05", "C001", "0", vo.getEmp_id(), "") ;  /* 회원가입 승인 완료 안내 */
				if ("C005".equals(vo.getUse_type())) commonSmsService.sendSms("CD05", "C002", "0", vo.getEmp_id(), "") ;  /* 회원가입 승인 불가 안내 */
				if ("C003".equals(vo.getUse_type())) commonSmsService.sendSms("CD05", "C003", "0", vo.getEmp_id(), "") ;  /* 회원탈퇴 완료 안내 */
			}
			
			returnValue = commonDAO.update(vo, "memberDAO.updateCustEmp"); 
			
			try {
				if(!"".equals(SsStringUtil.normalizeNull(vo.getEmail()))) {
					String title = "" ; 
					
					if ("C001".equals(vo.getUse_type())) { vo.setPageType("confirm"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 승인 완료 안내 메일을 보내드립니다." ;}
					else if ("C003".equals(vo.getUse_type())) { vo.setPageType("finish"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 탈퇴 완료 안내 메일을 보내드립니다.";}
					else if ("C005".equals(vo.getUse_type())) { vo.setPageType("wrong"); title = "중외정보기술에서 제공하는 ONTIC LineUs에서 계정 가입 신청에 대한 미승인 완료 안내 메일을 보내드립니다." ;}
					
					if(!"".equals(title)) {
						commonSmsService.sendMail("admin@cwit.co.kr", vo.getEmail(), title, SendMailForm.makeMemberMail(vo), "", "") ;
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
	public int registErpPassChange(UserVO vo) throws Exception {
		int returnValue = 0 ;
		
		if("".equals(SsStringUtil.normalizeNull(vo.getEmp_no()))) returnValue = -100 ; 
		
		if(returnValue == 0) {
			vo.setPass(SsStringUtil.encryptSHA256(vo.getEmp_no()));
			returnValue = commonDAO.update(vo, "memberDAO.updateErpPassChange") ; 
		}
		
		return returnValue;
	}

	@Override
	public int registErpInsert(UserVO vo) throws Exception {
		int dupcheck = commonDAO.selectOneInt(vo, "memberDAO.getErpCheck") ; 
		
		if(dupcheck > 0) return -300 ; 
		
		vo.setPass(SsStringUtil.encryptSHA256(vo.getEmp_no()));
		return commonDAO.update(vo, "memberDAO.registErpInsert") ; 
	}

	@Override
	public int registErpUpdate(UserVO vo) throws Exception {
		return commonDAO.update(vo, "memberDAO.registErpUpdate") ; 
	}
	

	@Override
	public int registErpUpdate2(UserVO vo) throws Exception {
		
		int returnValue = 0 ; 
		vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		int dupcheck = commonDAO.selectOneInt(vo, "memberDAO.getErpCheck3") ;
		
		if(dupcheck == 0) returnValue = -500 ;
		
	
		if(returnValue == 0) {
			if(!"".equals(SsStringUtil.normalizeNull(vo.getChangePass()))) vo.setPass(SsStringUtil.encryptSHA256(vo.getChangePass()));
			returnValue = commonDAO.update(vo, "memberDAO.registErpUpdate") ; 
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
			if(!"".equals(SsStringUtil.normalizeNull(vo.getChangePass()))) vo.setPass(SsStringUtil.encryptSHA256(vo.getChangePass()));
			returnValue = commonDAO.update(vo, "memberDAO.updateCustEmp");
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
