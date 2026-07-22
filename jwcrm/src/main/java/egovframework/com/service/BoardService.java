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
import egovframework.com.model.AsVO;
import egovframework.com.model.BoardVO;
import egovframework.com.model.CustVO;
import egovframework.com.model.DownHistVO;
import egovframework.com.model.NoticeCustSearchVO;
import egovframework.com.model.BoardAswVO;
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
public interface BoardService {
	
	public List<BoardVO> getList(BoardVO vo, String query) throws Exception;
	public int getTotalCnt(BoardVO vo, String query) throws Exception;
	public Map<String , Object> getSelectInfo(BoardVO vo, String query) throws Exception;
	public int insertBoard(BoardVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int updateBoard(BoardVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int deleteBoard(BoardVO vo) throws Exception;
	
	public int insertNotice(BoardVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int updateNotice(BoardVO vo , HttpServletRequest request, List<FileVO> fileList) throws Exception;
	public int deleteNotice(BoardVO vo) throws Exception;
	public Map<String , Object> getNoticeSelectInfo(BoardVO vo, String query) throws Exception;
	
	public int insertDownHist(DownHistVO vo) throws Exception;
	public List<DownHistVO> getDownHistList(DownHistVO vo) throws Exception;
	public List<NoticeCustSearchVO> getNoticeSearch(BoardVO vo) throws Exception;
	public List<BoardVO> getHisNoticeList(BoardVO boardVO) throws Exception;
	public int upinNoticeRead(UserVO frUserInfo, String seq) throws Exception;
	
	public List<BoardAswVO> getNoticeAswList(BoardAswVO vo , String query) throws Exception;
	public int insertAsw(BoardAswVO vo) throws Exception;
	public int deleteAsw(BoardAswVO vo) throws Exception;
	public int insertFaqAsw(BoardAswVO vo) throws Exception;
	public int deleteFaqAsw(BoardAswVO vo) throws Exception;
	public int insertFaqLike(BoardAswVO vo) throws Exception;
	public int updateFaqLike(BoardAswVO vo) throws Exception;
	public int getTotalAswCnt(BoardAswVO vo, String query) throws Exception;
	public int getTotalLikeCnt(BoardAswVO vo, String query) throws Exception;
	

}
