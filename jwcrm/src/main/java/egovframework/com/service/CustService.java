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
package egovframework.com.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.model.CustVO;

/**
 * @Class Name : CustService.java
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
public interface CustService {
	
	public List<CustVO> getCustList(CustVO vo) throws Exception;
	public int getCustListCnt(CustVO vo) throws Exception;
	public int crmCodeChk(CustVO vo) throws Exception;
	public int getProjectCnt(CustVO vo) throws Exception;
	public List<CustVO> getLinkCustInfo(CustVO vo) throws Exception;
	public Map<String , Object> getCustInfo(CustVO vo) throws Exception;
	public Map<String , Object> getProjectInfo(CustVO vo) throws Exception;
	public Map<String , Object> getOperateInfo(CustVO vo) throws Exception;
	public Map<String , Object> getMtacHistInfo(CustVO vo) throws Exception;
	public int updateInfo(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateProject(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateOperate(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateMtac(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateInstall(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateDoc(CustVO vo , HttpServletRequest request,  List<FileVO> fileList) throws Exception;
	public List<CustVO> getErpList(CustVO vo) throws Exception;
	public List<CustVO> getGroupCodeList(CustVO vo) throws Exception;
	public List<CustVO> getForm4List(CustVO vo) throws Exception;
	public List<CustVO> getPayInfo(CustVO vo) throws Exception;
	public int updateOperateState(CustVO vo) throws Exception;
	public int getSelectInt(CustVO vo, String queryName) throws Exception;
	public List<CustVO> getList(CustVO vo , String queryName) throws Exception ; 
	public CustVO getSelectOne(CustVO vo , String queryName) throws Exception ; 
	public Map<String , Object> getDocInfo(CustVO vo , String queryName) throws Exception ;
	public int deleteDoc(CustVO vo, HttpServletRequest request) throws Exception ;
	
		
}
