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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.dao.CommonMsDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.controller.AdAsController;
import egovframework.com.model.AsVO;
import egovframework.com.model.BoardAswVO;
import egovframework.com.model.BoardVO;
import egovframework.com.model.CustVO;
import egovframework.com.model.DownHistVO;
import egovframework.com.model.NoticeAuthVO;
import egovframework.com.model.NoticeCustSearchVO;
import egovframework.com.model.NoticeReadVO;
import egovframework.com.service.BoardService;
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

@Service("boardService")	
public class BoardServiceImpl extends EgovAbstractServiceImpl implements BoardService {
	
	private static final Logger logger = LoggerFactory.getLogger(BoardServiceImpl.class) ;

	@Autowired CommonDao commonDAO ;
	@Autowired CommonMsDao commonMsDAO ;
	@Autowired CommonFileService commonFileService ;
	
	
	@Override
	@SuppressWarnings("unchecked")
	public List<BoardVO> getList(BoardVO vo, String query) throws Exception {
		return (List<BoardVO>)commonDAO.list(vo, query);
	}
	
	@Override
	public int getTotalCnt(BoardVO vo, String query) throws Exception {
		return commonDAO.selectOneInt(vo, query);
	}
	
	@Override
	public Map<String , Object> getSelectInfo(BoardVO vo, String query) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		/**	기본정보		*/BoardVO info = (BoardVO)commonDAO.selectOne(vo, query);
		if(info != null){
			//파일,다운로드 이력
			FileVO fileVO = new FileVO() ; 
			if(info.getAttach_seq() != 0){
				fileVO.setAttach_seq(info.getAttach_seq());
				returnMap.put("attachList", commonFileService.getFileList(fileVO)) ;
				
				// 첨부파일 다운로드 이력 데이터 찾기

				// System.out.println("첨부파일 다운로드 이력 데이터 찾기 222222");
				DownHistVO downHistVO = new DownHistVO();
				downHistVO.setAttach_seq(info.getAttach_seq());
				downHistVO.setCrm_code(vo.getCrmCode());
				List<DownHistVO> downHistList = (List<DownHistVO>) commonDAO.list(downHistVO, "noticeDAO.listDownHistByCrmCode");
				
				returnMap.put("attachHistList", downHistList);
			}
			//댓글이력데이터 찾기
			
		}
		commonDAO.update(vo, "boardDAO.setUpCount");
		returnMap.put("info", info) ; 
		return returnMap ; 
	}
	
	@Override
	public Map<String , Object> getNoticeSelectInfo(BoardVO vo, String query) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		/**	기본정보		*/BoardVO info = (BoardVO)commonDAO.selectOne(vo, query);
		
		if(info != null){
			FileVO fileVO = new FileVO() ;

			if(info.getAttach_seq() != 0){
				fileVO.setAttach_seq(info.getAttach_seq());
				returnMap.put("attachList", commonFileService.getFileList(fileVO)) ;
				
				// 첨부파일 다운로드 이력 데이터 찾기

				// System.out.println("첨부파일 다운로드 이력 데이터 찾기");
				DownHistVO downHistVO = new DownHistVO();
				downHistVO.setAttach_seq(info.getAttach_seq());
				List<DownHistVO> downHistList = (List<DownHistVO>) commonDAO.list(downHistVO, "noticeDAO.listDownHist");
				
				for (DownHistVO histVo : downHistList){
					// System.out.println(histVo);
				}
				
				returnMap.put("attachHistList", downHistList);
				
			}
			
			// 20171116 수신 거래처 목록을 찾아서 셋팅한다.
			if ("C003".equals(info.getOpen_type())){
				returnMap.put("custSelectList", commonDAO.list(vo, "noticeDAO.listCustCrm"));
			}
			
		}
		commonDAO.update(vo, "boardDAO.setUpCount");
		returnMap.put("info", info) ; 
		return returnMap ; 
	}
	
	@Override
	public int insertBoard(BoardVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		
		int returnValue = 0 ; 
		int attach_seq = 0 ; 
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile")){
					
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
		}
		
		vo.setBest_faq("N");
		//2024.09.24 상담사례 관리 내 BEST 상담사례 구분 추가
		if ("Y".equals(vo.getBest_type())){
			// BEST 상담사례
			vo.setBest_faq("Y");
		}
		
		vo.setOnlyme_open_yn("N");
		//2024.05.03 상담사례 관리 내 나만보기 기능 추가
		if ("C002".equals(vo.getOpen_type())){
			// 나만보기
			vo.setOnlyme_open_yn("Y");
			vo.setBest_faq("N");
		}
		
		vo.setAttach_seq(attach_seq);
		vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "boardDAO.getMaxSeq")));
		returnValue = commonDAO.update(vo, "boardDAO.insertBoard");  
		return returnValue;		
	}
	
	@Override
	public int updateBoard(BoardVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		int returnValue = 0 ; 
		
		int attach_seq = vo.getAttach_seq() ; 
		
		/**	파일 삭제 처리	*/
		String del_attach_seq = SsStringUtil.normalizeNull(vo.getDel_attach_seq()) ; 
		String del_attach_ord = SsStringUtil.normalizeNull(vo.getDel_attach_ord()) ; 
		
		if(!"".equals(del_attach_seq)){
			String[] del_seq = del_attach_seq.split("@") ; 
			String[] del_ord = del_attach_ord.split("@") ;
			
			if(del_seq != null && del_seq.length > 0){
				for(int i = 0 ; i < del_seq.length ; i++){
					FileVO temp = new FileVO() ; 
					
					temp.setAttach_seq(Integer.parseInt(del_seq[i]));
					temp.setAttach_ord(Integer.parseInt(del_ord[i]));
					
					commonFileService.deleteFileInfo(temp) ; 
				}
			}
			
		}
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile")){
					
					String attach_ord = SsStringUtil.normalizeNull(temp.getAttach_tag_name()).replace("uploadFile", "") ; 
					
					if(attach_seq  == 0){
						attach_seq = commonFileService.getMaxFileSeq() ;
						temp.setAttach_seq(attach_seq);
					}else{
						temp.setAttach_seq(attach_seq);
					}
					
					temp.setAttach_ord(Integer.parseInt(attach_ord));
					
					commonFileService.insertFile(temp);
				}
			}
		}
		
		/*첨부파일insert*/
		vo.setAttach_seq(attach_seq);
		
		vo.setBest_faq("N");
		//2024.09.24 상담사례 관리 내 BEST 상담사례 구분 추가
		if ("Y".equals(vo.getBest_type())){
			// BEST 상담사례
			vo.setBest_faq("Y");
		}
		
		vo.setOnlyme_open_yn("N");
		//2024.05.03 상담사례 관리 내 나만보기 기능 추가
		if ("C002".equals(vo.getOpen_type())){
			// 나만보기
			vo.setOnlyme_open_yn("Y");
			vo.setBest_faq("N");
		}
		
		returnValue = commonDAO.update(vo, "boardDAO.updateBoard");
		
		return returnValue;
	}
	
	@Override
	public int deleteBoard(BoardVO vo) throws Exception {
		/* 파일 삭제 처리(?) */
		String del_seq = SsStringUtil.normalizeNull(vo.getDel_seq());
		int returnValue = 0;
		if (!"".equals(del_seq)) {
			String[] seq = del_seq.split("@");
			for (int i = 0; i < seq.length; i++) {
				vo.setSeq(seq[i]);
				returnValue = commonDAO.delete(vo, "boardDAO.deleteBoard");		
			}
		}
		return returnValue;
	}

	@Override
	public int insertNotice(BoardVO vo, HttpServletRequest request,
			List<FileVO> fileList) throws Exception {
		int returnValue = 0 ; 
		int attach_seq = 0 ; 
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile")){
					
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
		}
		
		vo.setAttach_seq(attach_seq);
		
		vo.setImp_yn("N");
		//2024.05.07 공지사항 관리 내 중요공지 옵션 추가
		if ("C001".equals(vo.getImp_type())){
			// 나만보기
			vo.setImp_yn("Y");
		}
		
		int newSeq = commonDAO.selectOneInt(vo, "boardDAO.getMaxSeq");
		vo.setSeq(String.valueOf(newSeq));
		
		// 공지사항용 번호 구하기
		int noticeNum = commonMsDAO.selectOneInt(vo, "noticeDAO.getCiCrmNoticeNextNum");
		vo.setNotice_num(String.valueOf(noticeNum));
		returnValue = commonDAO.update(vo, "noticeDAO.insertBoard");
		
		// 권한 테이블에 데이터를 넣는다.
		NoticeAuthVO authVo = new NoticeAuthVO();
		authVo.setNotice_seq(newSeq);
		String crmCodeArrStr = vo.getCrmCodeArr();
		
		if ("C001".equals(vo.getOpen_type())){
			// 전체공지
			authVo.setAll_open_yn("Y");
			commonDAO.insert(authVo, "noticeDAO.insertAccess");
			
		}else if ("C002".equals(vo.getOpen_type())){
			// 직원공지
			authVo.setAll_open_yn("N");
			authVo.setCrm_code("HOS00");
			commonDAO.insert(authVo, "noticeDAO.insertAccess");
		}else if ("C003".equals(vo.getOpen_type())){
			// 거래처 공지
			String[] crmCodeArr =  crmCodeArrStr.split(",");
			authVo.setAll_open_yn("N");
			
			// 특정병원 대상
			for (String crmCode : crmCodeArr){
				authVo.setCrm_code(crmCode);
				commonDAO.insert(authVo, "noticeDAO.insertAccess");
			}
		}
		
		// 구시스템에 데이터 넣기
		
		// 1. 구 시스템 notice_info 정보 넣기
		commonMsDAO.insert(vo, "noticeDAO.insertCiCrmNoticeInfo");
				
		// 2. 권한 테이블에 데이터 넣기
		NoticeAuthVO noticeAccess = new NoticeAuthVO();
		noticeAccess.setNotice_seq(noticeNum);
		noticeAccess.setCit_emp_yn("N");
		
		if ("C001".equals(vo.getOpen_type())){
			// 전체공지
			noticeAccess.setAll_open_yn("Y");
			
			//TODO 아래 코드를 막는다.(무조건 중외정보 공지)
//			noticeAccess.setAll_open_yn("N");
//			noticeAccess.setCrm_code("HOS00");

			commonMsDAO.insert(noticeAccess, "noticeDAO.insertCiCrmNoticeAccess");
			
		}else if ("C002".equals(vo.getOpen_type())){
			// 직원공지
			noticeAccess.setAll_open_yn("N");
			noticeAccess.setCrm_code("HOS00");
			noticeAccess.setCit_emp_yn("Y");
			commonMsDAO.insert(noticeAccess, "noticeDAO.insertCiCrmNoticeAccess");
		}else if ("C003".equals(vo.getOpen_type())){
			// 거래처 공지
			String[] crmCodeArr =  crmCodeArrStr.split(",");
			noticeAccess.setAll_open_yn("N");
			
			// 특정병원 대상
			for (String crmCode : crmCodeArr){

				noticeAccess.setCrm_code(crmCode);
				
				//TODO 아래 코드를 막는다.(무조건 중외정보 공지 -> 장유부성병원)
//				noticeAccess.setCrm_code("HOS139");
				
				
				commonMsDAO.insert(noticeAccess, "noticeDAO.insertCiCrmNoticeAccess");
			}
		}

		return returnValue;		
	}

	@Override
	public int updateNotice(BoardVO vo, HttpServletRequest request,
			List<FileVO> fileList) throws Exception {
		int returnValue = 0 ; 
		
		int attach_seq = vo.getAttach_seq() ; 
		
		/**	파일 삭제 처리	*/
		String del_attach_seq = SsStringUtil.normalizeNull(vo.getDel_attach_seq()) ; 
		String del_attach_ord = SsStringUtil.normalizeNull(vo.getDel_attach_ord()) ; 
		
		if(!"".equals(del_attach_seq)){
			String[] del_seq = del_attach_seq.split("@") ; 
			String[] del_ord = del_attach_ord.split("@") ;
			
			if(del_seq != null && del_seq.length > 0){
				for(int i = 0 ; i < del_seq.length ; i++){
					FileVO temp = new FileVO() ; 
					
					temp.setAttach_seq(Integer.parseInt(del_seq[i]));
					temp.setAttach_ord(Integer.parseInt(del_ord[i]));
					
					commonFileService.deleteFileInfo(temp) ; 
				}
			}
			
		}
		
		if(fileList != null && fileList.size() > 0){
			for(FileVO temp : fileList){
				if(temp.getAttach_tag_name().startsWith("uploadFile")){
					
					String attach_ord = SsStringUtil.normalizeNull(temp.getAttach_tag_name()).replace("uploadFile", "") ; 
					
					if(attach_seq  == 0){
						attach_seq = commonFileService.getMaxFileSeq() ;
						temp.setAttach_seq(attach_seq);
					}else{
						temp.setAttach_seq(attach_seq);
					}
					
					temp.setAttach_ord(Integer.parseInt(attach_ord));
					
					commonFileService.insertFile(temp);
				}
			}
		}
		
		vo.setImp_yn("N");
		//2024.05.07 공지사항 관리 내 중요공지 옵션 추가
		if ("C001".equals(vo.getImp_type())){
			// 나만보기
			vo.setImp_yn("Y");
		}
		
		// 공지사항 정보 수정
		vo.setAttach_seq(attach_seq);
		returnValue = commonDAO.update(vo, "noticeDAO.updateBoard");
		
		// 기존 접근테이블 삭제
		// 연관 권한 테이블 정보 삭제
		NoticeAuthVO authVo = new NoticeAuthVO();
		authVo.setNotice_seq(Integer.parseInt(vo.getSeq()));
		commonDAO.delete(authVo, "noticeDAO.deleteAccess");
		
		// 권한 테이블에 데이터를 넣는다.
		String crmCodeArrStr = vo.getCrmCodeArr();
		if ("C001".equals(vo.getOpen_type())){
			// 전체공지
			authVo.setAll_open_yn("Y");
			commonDAO.insert(authVo, "noticeDAO.insertAccess");
			
		}else if ("C002".equals(vo.getOpen_type())){
			// 직원공지
			authVo.setAll_open_yn("N");
			authVo.setCrm_code("HOS00");
			commonDAO.insert(authVo, "noticeDAO.insertAccess");
		}else if ("C003".equals(vo.getOpen_type())){
			// 거래처 공지
			String[] crmCodeArr =  crmCodeArrStr.split(",");
			authVo.setAll_open_yn("N");
			
			// 특정병원 대상
			for (String crmCode : crmCodeArr){
				authVo.setCrm_code(crmCode);
				commonDAO.insert(authVo, "noticeDAO.insertAccess");
			}
		}
		
		updateASIS(vo);
		
		return returnValue;
	}

	/**
	 * AS-IS CRM 데이터 업데이트
	 * @param vo
	 * @param authVo
	 * @throws Exception 
	 */
	private void updateASIS(BoardVO vo ) throws Exception {
		// 1. notice_num 값을 알아낸다.
		BoardVO newVo = (BoardVO) commonDAO.selectOne(vo, "noticeDAO.getNoticeNum");
		
		// 2. TOBE의 모든 접근 가능한 crm 코드를 가져온다.
		List<NoticeAuthVO> authList = (List<NoticeAuthVO>) commonDAO.list(newVo, "noticeDAO.getCrmCodeListBy");
		
		// 3. 기존 접근권한 테이블의 값을 삭제한다.
		commonMsDAO.delete(newVo, "noticeDAO.deleteCiCrmNoticeAccess");
		
		// 4. 접근권한 테이블의 데이터를 다시 넣는다.
		NoticeAuthVO noticeAccess = new NoticeAuthVO();
		noticeAccess.setNotice_seq(Integer.parseInt(newVo.getNotice_num()));
		noticeAccess.setCit_emp_yn("N");
		
		if ("C001".equals(vo.getOpen_type())){
			// 전체공지
			noticeAccess.setAll_open_yn("Y");
			
			//TODO 아래 코드를 막는다.(무조건 중외정보 공지)
//			noticeAccess.setAll_open_yn("N");
//			noticeAccess.setCrm_code("HOS00");

			commonMsDAO.insert(noticeAccess, "noticeDAO.insertCiCrmNoticeAccess");
			
		}else if ("C002".equals(vo.getOpen_type())){
			// 직원공지
			noticeAccess.setAll_open_yn("N");
			noticeAccess.setCrm_code("HOS00");
			noticeAccess.setCit_emp_yn("Y");
			commonMsDAO.insert(noticeAccess, "noticeDAO.insertCiCrmNoticeAccess");
		}else if ("C003".equals(vo.getOpen_type())){
			// 거래처 공지

			noticeAccess.setAll_open_yn("N");

			// 특정병원 대상
			for (NoticeAuthVO auth : authList){

				noticeAccess.setCrm_code(auth.getCrm_code());
				
				//TODO 아래 코드를 막는다.(무조건 중외정보 공지 -> 장유부성병원)
//				noticeAccess.setCrm_code("HOS139");
				
				commonMsDAO.insert(noticeAccess, "noticeDAO.insertCiCrmNoticeAccess");
			}
		}
		
		// 3. 원 테이블의 정보를 업데이트 한다.
		commonMsDAO.update(newVo, "noticeDAO.updateCiCrmNoticeInfo");
	}

	@Override
	public int deleteNotice(BoardVO vo) throws Exception {
		/* 파일 삭제 처리(?) */
		String del_seq = SsStringUtil.normalizeNull(vo.getDel_seq());
		int returnValue = 0;
		if (!"".equals(del_seq)) {
			String[] seq = del_seq.split("@");
			for (int i = 0; i < seq.length; i++) {
				vo.setSeq(seq[i]);
				
				// AS 시스템 데이터 삭제처리
				deleteASIS(seq[i]);
				
				returnValue = commonDAO.delete(vo, "boardDAO.deleteBoard");
				
				// 연관 권한 테이블 정보 삭제
				NoticeAuthVO authVo = new NoticeAuthVO();
				authVo.setNotice_seq(Integer.parseInt(vo.getSeq()));
				commonDAO.delete(authVo, "noticeDAO.deleteAccess");
			}
		}
		return returnValue;
	}

	/**
	 * AS-IS CRM 데이터 삭제처리
	 * @param string TOBE seq
	 * @throws Exception 
	 */
	private void deleteASIS(String seq) throws Exception {
		
		BoardVO param = new BoardVO();
		param.setSeq(seq);
		// 1. notice_num 값을 알아낸다.
		BoardVO qValue = (BoardVO) commonDAO.selectOne(param, "noticeDAO.getNoticeNum");
		String noticeNum = qValue.getNotice_num();
		
		// 2. 접근권한 테이블의 데이터를 지운다.
		param.setNotice_num(noticeNum);
		commonMsDAO.delete(param, "noticeDAO.deleteCiCrmNoticeAccess");
		// 3. 원 테이블의 정보를 지운다.
		commonMsDAO.delete(param, "noticeDAO.deleteCiCrmNotice");
	}

	@Override
	public int insertDownHist(DownHistVO vo) throws Exception {
		return commonDAO.insert(vo, "noticeDAO.insertDwnHist");
	}

	@Override
	public List<DownHistVO> getDownHistList(DownHistVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<NoticeCustSearchVO> getNoticeSearch(BoardVO vo) throws Exception {
		return (List<NoticeCustSearchVO>) commonDAO.list(vo, "noticeDAO.custSearch");
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<BoardVO> getHisNoticeList(BoardVO vo) throws Exception {
		return (List<BoardVO>) commonDAO.list(vo, "noticeDAO.hisNoticeList");
	}

	@Override
	public int upinNoticeRead(UserVO frUserInfo, String seq) {
		// 20171129 게시물 읽은 사용자정보를 저장한다.
		NoticeReadVO nrVO = new NoticeReadVO();
		nrVO.setNotice_seq(seq);
		nrVO.setUser_id(frUserInfo.getEmp_id());
		
		int reValue = 0;
		try {
			reValue = commonDAO.update(nrVO, "noticeDAO.upinNoticeRead");
		} catch (Exception e) {
			logger.error("게시물 읽은 user_id 저장 실패", e);
		}
		return reValue;
	}
	
	
	@Override
	public int insertAsw(BoardAswVO vo) throws Exception {
		return commonDAO.insert(vo, "noticeDAO.insertAsw");
	}
	
	
	@Override
	public int deleteAsw(BoardAswVO vo) throws Exception {
		return commonDAO.delete(vo, "noticeDAO.deleteAsw");
	}
	
	@Override
	public int insertFaqAsw(BoardAswVO vo) throws Exception {
		return commonDAO.insert(vo, "boardDAO.insertFaqAsw");
	}
	
	
	@Override
	public int deleteFaqAsw(BoardAswVO vo) throws Exception {
		return commonDAO.delete(vo, "boardDAO.deleteFaqAsw");
	}
	
	@Override
	public int insertFaqLike(BoardAswVO vo) throws Exception {
		return commonDAO.insert(vo, "boardDAO.insertFaqLike");
	}
	
	@Override
	public int updateFaqLike(BoardAswVO vo) throws Exception {
		return commonDAO.update(vo, "boardDAO.updateFaqLike");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BoardAswVO> getNoticeAswList(BoardAswVO vo , String query ) throws Exception {
		return (List<BoardAswVO >)commonDAO.list(vo, query);
	}

	@Override
	public int getTotalAswCnt(BoardAswVO vo, String query) throws Exception {
		return commonDAO.selectOneInt(vo, query);
		
	}
	@Override
	public int getTotalLikeCnt(BoardAswVO vo, String query) throws Exception {
		return commonDAO.selectOneInt(vo, query);
		
	}
	
	
}
