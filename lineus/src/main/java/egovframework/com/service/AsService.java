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
import egovframework.com.model.AsVO;
import egovframework.com.model.CustVO;

/**
 * @Class Name : AsService.java
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
public interface AsService {
	
	public Map<String , Object> getAsCustInfo(AsVO vo) throws Exception;
	public int insertAsInfo(AsVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int insertAsCnInfo(AsVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int updateAsCnInfo(AsVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int insertAws(AsVO vo , HttpServletRequest request) throws Exception;
	public int updateAws(AsVO vo , HttpServletRequest request) throws Exception;
	public int deleteAws(AsVO vo , HttpServletRequest request) throws Exception;
	public int updateAsInfo(AsVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int deleteAsProc(AsVO vo , HttpServletRequest request) throws Exception;
	public List<AsVO> getList(AsVO vo, String query) throws Exception;
	public AsVO getAsInfo(AsVO vo) throws Exception;
	public int getTotalCnt(AsVO vo, String query) throws Exception;
	public int getMaxSeq() throws Exception;
	public int getAwsMaxSeq() throws Exception;
	public AsVO getSelectInfo(AsVO vo, String query) throws Exception;
	public int registChangeStatus(AsVO vo) throws Exception;
	public int registChangeStar(AsVO vo) throws Exception;
	public int updateAsLayer(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int registContents(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int registDelContents(AsVO vo) throws Exception;
	public int updateAsApproval(AsVO vo,  HttpServletRequest request) throws Exception;
	public int selectAsMgtCntByAssignId(String id) throws Exception;
	
	public int approve(AsVO vo , HttpServletRequest request) throws Exception;
	public int reject(AsVO vo , HttpServletRequest request) throws Exception;
	public int goApprove(AsVO vo , HttpServletRequest request) throws Exception;
	public int goReject(AsVO vo , HttpServletRequest request) throws Exception;
	public int cancle(AsVO vo , HttpServletRequest request) throws Exception;
	public  Map<String , Object> checkTypeQuestion(AsVO vo,  HttpServletRequest request) throws Exception;
	public int updateUserTest(AsVO vo, String query) throws Exception;
	public int reSendEmail(AsVO vo, HttpServletRequest request) throws Exception;
	public int schedulerTrigger() throws Exception;
	public int checkUserTestYn(AsVO vo, String query) throws Exception;
}
