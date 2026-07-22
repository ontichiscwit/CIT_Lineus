package egovframework.com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.BoardAswVO;
import egovframework.com.model.BoardVO;
import egovframework.com.service.BoardService;
import egovframework.com.service.LoginService;

/**
 * @Class Name : BoardController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.10.10	정연호		           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2017. 09.07
 * @version 1.0
 * @see
 *
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class BoardController {
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired LoginService loginService ; 
	@Autowired BoardService boardService ; 
	
	/**
	 * 공지사항 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/notice/list.do")
	public String noticeList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))){
			// 조회시작 일자 가 없을 경우
			String currentDateStr = DateTimeUtil.getDate();
			vo.setSearch_start(DateTimeUtil.addMonths(currentDateStr, -3, "yyyyMMdd"));
		}
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))){
			// 조회시작 일자 가 없을 경우
			vo.setSearch_end(DateTimeUtil.getDate());
		}
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
		return "ad/notice/list";
	}
	
	/**
	 * 공지사항 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/notice/form.do")
	public String noticeForm(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		
		return "ad/notice/form";
	}
	
	/**
	 * 패치노트 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/patch/list.do")
	public String patchList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		
		return "ad/patch/list";
	}
	
	/**
	 * 패치노트 등록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/patch/form.do")
	public String patchForm(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		
		return "ad/patch/form";
	}

	/**
	 * faq 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/faq/list.do")
	public String faqList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/faq/list";
	}
	
	/**
	 * faq 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/faq/form.do")
	public String faqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/faq/form";
	}
	
	
	
	/**
	 *	다운로드관리 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/down/list.do")
	public String downList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/down/list";
	}
	
	/**
	 * 다운로드관리 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/down/form.do")
	public String downForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/down/form";
	}
	
	/**
	 *	사내 다운로드관리 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cdown/list.do")
	public String cdownList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/cdown/list";
	}
	
	/**
	 * 사내 다운로드관리 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cdown/form.do")
	public String cdownForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		return "ad/cdown/form";
	}
	
	/**
	 * 공지사항 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/notice/getBoardList.do")
	public void getNoticeList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		logger.debug("adUserInfo.getCust_code() : " + adUserInfo.getCust_code());
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))){
			// 조회시작 일자 가 없을 경우
			String currentDateStr = DateTimeUtil.getDate();
			vo.setSearch_start(DateTimeUtil.addMonths(currentDateStr, -3, "yyyyMMdd"));
		}
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))){
			// 조회시작 일자 가 없을 경우
			vo.setSearch_end(DateTimeUtil.getDate());
		}
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		int totalCount = boardService.getTotalCnt(vo,"noticeDAO.getBoardListCnt") ;
		
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = boardService.getList(vo,"noticeDAO.getBoardList") ;
			
			vo.setJson_paging(vo.getJsonPaging("getBoardList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 게시판  리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/getBoardList.do")
	public void getBoardList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		int totalCount = boardService.getTotalCnt(vo,"boardDAO.getBoardListCnt") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = boardService.getList(vo,"boardDAO.getBoardList") ;
			
			vo.setJson_paging(vo.getJsonPaging("getBoardList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 공지사항 상세 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/notice/getBoardInfo.do")
	public void getNoticeInfo(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnMap.put("resultVO", boardService.getNoticeSelectInfo(vo, "noticeDAO.getBoardInfo")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 공지사항에서 고객정보 검색 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/notice/custSearch.do")
	public void noticeCustSearch(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnMap.put("custSearchVO", boardService.getNoticeSearch(vo)) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 게시판 상세 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/getBoardInfo.do")
	public void getBoardInfo(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnMap.put("resultVO", boardService.getSelectInfo(vo, "boardDAO.getBoardInfo")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 공지사항 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/notice/proc.do")
	public String noticeProc(@ModelAttribute("vo") BoardVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ; 
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ; 
		List<FileVO> fileList = null ;
		List<BoardVO> resultList = null ;
		int returnValue = 0 ;
		String script = "" ;
		
			
		vo.setReg_id(adUserInfo.getEmp_no());
		
		if(!"delete".equals(pageType)) {
			fileList = commonFileService.uploadFormFile(multiRequest, "board") ;
		}
		
		if ("insert".equals(pageType)) returnValue = boardService.insertNotice(vo, request, fileList) ;	
		else if("copy".equals(pageType))returnValue = boardService.insertNotice(vo, request, fileList) ;
		else if ("update".equals(pageType)) returnValue = boardService.updateNotice(vo, request, fileList) ;
		else if ("delete".equals(pageType)) returnValue = boardService.deleteNotice(vo) ;
		
		if(returnValue > 0) script = "parent.procReturn('success', '정상적으로 처리 되었습니다.');" ;
		else script = "parent.procReturn('fail', '비정상적으로 처리 되었습니다.');" ;
			 
		return CommonExecute.execute(model, script);
	}
	
	/**
	 * 게시판 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/proc.do")
	public String boardProc(@ModelAttribute("vo") BoardVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ; 
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ; 
		List<FileVO> fileList = null ;
		List<BoardVO> resultList = null ;
		int returnValue = 0 ;
		String script = "" ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		if(!"delete".equals(pageType)) {
			fileList = commonFileService.uploadFormFile(multiRequest, "board") ;
		}
		
		if ("insert".equals(pageType)) returnValue = boardService.insertBoard(vo, request, fileList) ;	
		else if ("update".equals(pageType)) returnValue = boardService.updateBoard(vo, request, fileList) ;
		else if ("delete".equals(pageType)) returnValue = boardService.deleteBoard(vo) ;
		
		if(returnValue > 0) script = "parent.procReturn('success', '정상적으로 처리 되었습니다.');" ;
		else script = "parent.procReturn('fail', '비정상적으로 처리 되었습니다.');" ;
			 
		return CommonExecute.execute(model, script);
	}
	
	
	
	/**
	 * 공지사항 상세 답변내역 리스트 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/getAwsList.do")
	public void getAwsList(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardAswVO> resultList = null ;
		
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		int totalCount = boardService.getTotalAswCnt(vo, "noticeDAO.getAwsListCnt") ;
		vo.setPaging(totalCount);
		
		resultList = boardService.getNoticeAswList(vo ,"noticeDAO.listAsw" ) ;
		vo.setJson_paging(vo.getJsonPaging("getListAsw"));
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo", vo) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 답변 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/awsform.do")
	public void awsForm(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String returnCode = "" ; 
		int returnValue = 0;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		vo.setW_id(adUserInfo.getEmp_no());
		vo.setW_gubun("A");
		
	    returnValue = boardService.insertAsw(vo);
		
	    if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
	    
	    returnMap.put("returnCode", returnCode) ; 
	    CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 답변 삭제 
	 * @param vo
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/awsDel.do")
	public void awsDel(@ModelAttribute("vo") BoardAswVO vo,  ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		String returnCode = "" ; 
		int returnValue = 0;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnValue = boardService.deleteAsw(vo);
		if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
	    
	    returnMap.put("returnCode", returnCode) ; 
	    CommonExecute.returnJson(response, returnMap);
		
	}
	
	
	
	
}
