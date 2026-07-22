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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.LoginService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : LoginServiceImpl.java
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

@Service("loginService")	
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {

	@Autowired CommonDao commonDAO ;

	@Override
	public UserVO selectUserInfo(UserVO vo) throws Exception {
		String pass = vo.getPass();
		if (pass != null) {
		    if (pass.length() != 64) {
		    	vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		    } else {
		        vo.setPass(pass);
		    }
		}
		
		return (UserVO) commonDAO.selectOne(vo, "loginDAO.selectUserInfo");
	}
	
	
	@Override
	public UserVO selectUserInfoById(UserVO vo) throws Exception {
		
		return (UserVO) commonDAO.selectOne(vo, "loginDAO.selectUserInfoById");
	}
	
	
	@Override
	public UserVO selectSearchInfo(UserVO vo) throws Exception {
		return (UserVO) commonDAO.selectOne(vo, "loginDAO.selectSearchInfo");
	}
	
	@Override
	public int updatePass(UserVO vo) throws Exception {
		vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		return commonDAO.update(vo, "loginDAO.updatePass");
	}

	@Override
	public UserVO selectFrUserInfo(UserVO vo) throws Exception {
		return (UserVO) commonDAO.selectOne(vo, "loginDAO.selectFrUserInfo");
	}
	
	@Override
	public int updateAgreement(UserVO vo) throws Exception {
		return commonDAO.update(vo, "loginDAO.updateAgreement");
	}

	@Override
	public UserVO findUserInfo(UserVO vo, String queryName) throws Exception {
		return (UserVO) commonDAO.selectOne(vo, queryName);
	}

	@Override
	public int registMemberPassChange(UserVO vo) throws Exception {
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getPass()))) vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		
		return commonDAO.update(vo, "memberDAO.updatePassChange");
	}

	@Override
	public boolean checkOPDealCode(String crm_code) throws Exception {
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("crm_code", crm_code);
		
		int reValue = commonDAO.selectOneInt(param, "memberDAO.checkOPDealCode");
		if ( reValue == 1) return true;
		return false;
	}

}
