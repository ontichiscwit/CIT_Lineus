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
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.SmsVO;
import egovframework.com.service.SmsService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : SmsService.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.10.16	정연호    최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2016. 06.20
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Service("smsService")	
public class SmsServiceImpl extends EgovAbstractServiceImpl implements SmsService {

	@Autowired CommonDao commonDAO ; 
	@Autowired CommonFileService commonFileService ;
	
	/**
	 * 발송관리 목록을 조회한다.
	 * @param SmsVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<SmsVO> getList(SmsVO vo, String k) throws Exception {
		return (List<SmsVO>)commonDAO.list(vo, k);
	}

	/**
	 * 발송관리 등록
	 * @param SmsVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	@Override
	@Transactional
	public int insertProc(SmsVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0 ; 
		
		String CD05_cnt = SsStringUtil.normalizeNull(request.getParameter("CD05_cnt"));
		String CD06_cnt = SsStringUtil.normalizeNull(request.getParameter("CD06_cnt"));
		int cnt1 = 0;
		if (!"".equals(CD05_cnt)) {
			cnt1 = Integer.parseInt(CD05_cnt);
			for (int i = 1; i <= cnt1; i++) {
				String sms_code_grp = "CD05";
				String sms_code  = "C00"+i;
				String use_yn = SsStringUtil.normalizeNull(request.getParameter("CD05_C00" + i)) ;
				
				vo.setSms_code_grp(sms_code_grp);
				vo.setSms_code(sms_code);
				vo.setUse_yn(use_yn);
				
				returnValue = commonDAO.update(vo, "smsDAO.smsInsertProc");  
			}		
		}
		
		if (!"".equals(CD06_cnt)) {
			int cnt2 = Integer.parseInt(CD06_cnt);
			for (int i = 1; i <= cnt2; i++) {
				String sms_code_grp = "CD06";
				String sms_code  = "C00"+i;
				String use_yn = SsStringUtil.normalizeNull(request.getParameter("CD06_C00" + i)) ;
				
				vo.setSms_code_grp(sms_code_grp);
				vo.setSms_code(sms_code);
				vo.setUse_yn(use_yn);
				
				returnValue = commonDAO.update(vo, "smsDAO.smsInsertProc");  
			}		
		}
		return returnValue;
	}

	/**
	 * 발송관리 수정
	 * @param SmsVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	@Override
	@Transactional
	public int updateProc(SmsVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0 ; 
		
		returnValue = commonDAO.update(vo, "smsDAO.smsUpdateProc");  
		return returnValue;
	}

	@Override
	public SmsVO getDetail(SmsVO vo) throws Exception {
		return (SmsVO) commonDAO.selectOne(vo, "smsDAO.getDetail");
	}
	
	
	@Override
	public SmsVO getSenderTel(SmsVO vo) throws Exception {
		return (SmsVO) commonDAO.selectOne(vo, "smsDAO.getSenderTel");
	}
	
	
	@Override
	public SmsVO getSenderEmail(SmsVO vo) throws Exception {
		return (SmsVO) commonDAO.selectOne(vo, "smsDAO.getSenderEmail");
	}
}










