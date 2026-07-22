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
import egovframework.com.model.ServerVO;
import egovframework.com.model.DbVO;
import egovframework.com.model.NetworkVO;
import egovframework.com.model.OperateVO;
import egovframework.com.model.AppVO;
import egovframework.com.model.ServiceVO;
import egovframework.com.model.ProjectVO;
import egovframework.com.model.RetireVO;
import egovframework.com.model.OperateVO;

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
	public int getServerListCnt(ServerVO vo,String queryName) throws Exception;
	public int getNetworkListCnt(NetworkVO vo,String queryName) throws Exception;
	public int getDbListCnt(DbVO vo,String queryName) throws Exception;
	public int getAppListCnt(AppVO vo,String queryName) throws Exception;
	public int getServiceListCnt(ServiceVO vo,String queryName) throws Exception;
	public int getProjectCnt(ProjectVO vo,String queryName) throws Exception;
	public int getOperateCnt(OperateVO vo,String queryName) throws Exception;
	public int getRetireListCnt(RetireVO vo,String queryName) throws Exception;		//2021.05.27
	public int getRetireInitCnt(RetireVO vo,String queryName) throws Exception;		//2021.05.31
	public int getRetireCheckCnt(RetireVO vo,String queryName) throws Exception;	//2021.05.31
	
	
	public int crmCodeChk(CustVO vo) throws Exception;
	public int getListCnt(CustVO vo,String queryName) throws Exception;
	public int getSelectNetworkInt(CustVO vo, String queryName) throws Exception;
	public int getSelectInt(CustVO vo, String queryName) throws Exception;
	
	
	public Map<String , Object> getCustInfo(CustVO vo) throws Exception;
	public Map<String , Object> getServerInfo(ServerVO vo) throws Exception;
	public Map<String , Object> getServerInfo2(ServerVO vo) throws Exception;
	
	public Map<String , Object> getNetworkInfo(NetworkVO vo) throws Exception;
	public Map<String , Object> getDbInfo(DbVO vo) throws Exception;
	public Map<String , Object> getAppInfo(AppVO vo) throws Exception;
	public Map<String , Object> getProjectInfo(ProjectVO vo) throws Exception;
	public Map<String , Object> getOperateInfo(OperateVO vo) throws Exception;
	public Map<String , Object> getMtacHistInfo(CustVO vo) throws Exception;
	public Map<String , Object> getDocInfo(CustVO vo , String queryName) throws Exception ;
	public Map<String , Object> getServiceInfo(ServiceVO vo ) throws Exception ;
	
	
	public int updateInfo(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateMtac(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateInstall(CustVO vo , HttpServletRequest request) throws Exception;
	public int updateDoc(CustVO vo , HttpServletRequest request,  List<FileVO> fileList) throws Exception;
	public int updateServer(ServerVO vo, HttpServletRequest request) throws Exception;
	public int updateDb(DbVO vo , HttpServletRequest request) throws Exception;
	public int updateApp(AppVO vo , HttpServletRequest request) throws Exception;
	public int updateService(ServiceVO vo , HttpServletRequest request) throws Exception;
	public int updateNetwork(NetworkVO vo, HttpServletRequest request) throws Exception;
	public int updateProject(ProjectVO vo, HttpServletRequest request) throws Exception;
	public int updateOperate(OperateVO vo, HttpServletRequest request) throws Exception;
	public int updateRetire(RetireVO vo, HttpServletRequest request) throws Exception;
	
	public List<CustVO> getLinkCustInfo(CustVO vo) throws Exception;
	public List<CustVO> getErpList(CustVO vo) throws Exception;
	public List<CustVO> getGroupCodeList(CustVO vo) throws Exception;
	public List<CustVO> getForm4List(CustVO vo) throws Exception;
	public List<CustVO> getPayInfo(CustVO vo) throws Exception;
	public List<CustVO> getList(CustVO vo , String queryName) throws Exception ; 
	public List<ServerVO> getServerList(ServerVO vo , String queryName) throws Exception ; 
	public List<DbVO> getDbList(DbVO vo , String queryName) throws Exception ; 
	public List<AppVO> getAppList(AppVO vo , String queryName) throws Exception ; 
	public List<NetworkVO> getNetworkList(NetworkVO vo , String queryName) throws Exception ; 
	public List<ServiceVO> getServiceList(ServiceVO vo , String queryName) throws Exception ;
	public List<ProjectVO> getProjectList(ProjectVO vo , String queryName) throws Exception ;
	public List<OperateVO> getOperateList(OperateVO vo , String queryName) throws Exception ;
	public List<RetireVO> getRetireList(RetireVO vo , String queryName) throws Exception ;			//2021.05.27
	public List<RetireVO> getRetireInit(RetireVO vo , String queryName) throws Exception ;			//2021.05.31
	public List<RetireVO> getRetireCheck(RetireVO vo , String queryName) throws Exception ;			//2021.05.31
	public List<RetireVO> getRetireExl(RetireVO vo , String queryName) throws Exception ;			//2021.06.04
	
	public CustVO getSelectOne(CustVO vo , String queryName) throws Exception ; 
	public RetireVO getSelectOne(RetireVO vo , String queryName) throws Exception ; 				//2021.05.28
	public int deleteDoc(CustVO vo, HttpServletRequest request) throws Exception ;
	public int delOperateProc(OperateVO vo) throws Exception;
	public OperateVO getOperatInfoOne(OperateVO vo)throws Exception;




	

	
	
	
		
}
