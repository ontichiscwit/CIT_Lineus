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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.dao.CommonDao;
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
	@Autowired CommonDao commonDao;
	
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
	 * faq 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/faq/list.do")
	public String faqList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))){
			// 조회시작 일자 가 없을 경우
			//String currentDateStr = DateTimeUtil.getDate();
			vo.setSearch_start("20170101");
		}
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))){
			// 조회시작 일자 가 없을 경우
			vo.setSearch_end(DateTimeUtil.getDate());
		}
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
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
	 * drugfaq 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/drugfaq/list.do")
	public String drugfaqList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {

		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))){
			// 조회시작 일자 가 없을 경우
			//String currentDateStr = DateTimeUtil.getDate();
			vo.setSearch_start("20180101");
		}
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))){
			// 조회시작 일자 가 없을 경우
			vo.setSearch_end(DateTimeUtil.getDate());
		}
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
		return "ad/drugfaq/list";
	}
	
	/**
	 * drugfaq 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/drugfaq/form.do")
	public String drugfaqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/drugfaq/form";
	}
	
	/**
	 * FAQ(동영상) 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/videofaq/list.do")
	public String videofaqList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))){
			// 조회시작 일자 가 없을 경우
			//String currentDateStr = DateTimeUtil.getDate();
			vo.setSearch_start("20210101");
		}
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))){
			// 조회시작 일자 가 없을 경우
			vo.setSearch_end(DateTimeUtil.getDate());
		}
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
		return "ad/videofaq/list";
	}
	
	/**
	 * FAQ(동영상) 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/videofaq/form.do")
	public String videofaqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/videofaq/form";
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
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))){
			// 조회시작 일자 가 없을 경우
			//String currentDateStr = DateTimeUtil.getDate();
			vo.setSearch_start("20170101");
		}
		
		if ("".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))){
			// 조회시작 일자 가 없을 경우
			vo.setSearch_end(DateTimeUtil.getDate());
		}
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		
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
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
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
		returnMap.put("resultVO", boardService.getNoticeSelectInfo(vo, "boardDAO.getBoardInfo")) ;
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
		
		if(!"C002".equals(SsStringUtil.normalizeNull(vo.getImp_type()))) {
		if(!"".equals(SsStringUtil.normalizeNull(vo.getDeadline()))) vo.setDeadline(vo.getDeadline().replaceAll("/", "")) ;
		}else {
			vo.setDeadline("");
		}
		
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
		int totalCount = 0 ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		/*2021.03.19 이설아 -FAQ(동영상) 영상 첨부파일 경로 수정*/
		if(vo.getBoard_gbn().equals("0006")){			//0006: FAQ(동영상)
			
			if(!"delete".equals(pageType)) {
				fileList = commonFileService.uploadFormFile(multiRequest, "board(video)") ;
			}
			
		}else{
			
			if(!"delete".equals(pageType)) {
				fileList = commonFileService.uploadFormFile(multiRequest, "board") ;
			}
		}
		
		/*2024.09.24 김규민 - Best 상담사례 개수 확인
		if(vo.getBoard_gbn().equals("0001") && vo.getBest_type().equals("Y") && "C001".equals(vo.getOpen_type())){
		totalCount = boardService.getTotalCnt(vo,"boardDAO.getBestFaqBoardListCnt") ;
		}*/
		/*2024.09.24 김규민 - Best 상담사례는 최대 5개까지로 제한
		if(totalCount >= 5) {
			script = "parent.procReturn('fail', 'BEST 상담사례의 제한개수를 초과하였습니다. 다른 BEST 상담사례 변경이 필요합니다.');" ;
		}
		*/
		
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
	 * 상담사례 상세 답변내역 리스트 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/getFaqAwsList.do")
	public void getFaqAwsList(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardAswVO> resultList = null ;
		
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		int totalCount = boardService.getTotalAswCnt(vo, "boardDAO.getFaqAwsListCnt") ;
		vo.setPaging(totalCount);
		
		resultList = boardService.getNoticeAswList(vo ,"boardDAO.listAsw" ) ;
		vo.setJson_paging(vo.getJsonPaging("getListAsw"));
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo", vo) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 상담사례 좋아요 내역 리스트 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/getFaqLikeList.do")
	public void getFaqLikeList(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardAswVO> resultList = null ;
		
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		int totalCount = boardService.getTotalAswCnt(vo, "boardDAO.getFaqLikeListCnt") ;
		vo.setPaging(totalCount);
		
		resultList = boardService.getNoticeAswList(vo ,"boardDAO.listLike" ) ;
		vo.setJson_paging(vo.getJsonPaging("getListAsw"));
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo", vo) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 공지사항 답변 등록 
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
	 * 공지사항 답변 삭제 
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
	
	/**
	 * 상담사례 답변 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/faqawsform.do")
	public void faqawsform(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String returnCode = "" ; 
		int returnValue = 0;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		vo.setW_id(adUserInfo.getEmp_no());
		vo.setW_gubun("A");
		
	    returnValue = boardService.insertFaqAsw(vo);
		
	    if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
	    
	    returnMap.put("returnCode", returnCode) ; 
	    CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 공지사항 답변 삭제 
	 * @param vo
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/board/faqawsDel.do")
	public void faqawsDel(@ModelAttribute("vo") BoardAswVO vo,  ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		String returnCode = "" ; 
		int returnValue = 0;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnValue = boardService.deleteFaqAsw(vo);
		if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
	    
	    returnMap.put("returnCode", returnCode) ; 
	    CommonExecute.returnJson(response, returnMap);
		
	}
	
	@RequestMapping(value = "/ad/board/getNoticenum.do")
	public void getNoticenum(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getNoticenum"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getNoticeexist.do")
	public void getNoticeexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("board_gbn", "0000");
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getNoticeexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getNoticeallexist.do")
	public void getNoticeallexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getNoticeallexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getNoticecustexist.do")
	public void getNoticecustexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getNoticecustexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getFaqexist.do")
	public void getFaqexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("board_gbn", "0001");
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getFaqexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getFaqallexist.do")
	public void getFaqallexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("board_gbn", "0001");
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getFaqallexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getFaqonlymeexist.do")
	public void getFaqonlymeexist(@RequestParam("seq") String seq, @RequestParam("emp_no") String emp_no, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("emp_no", emp_no);
		param.put("board_gbn", "0001");
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getFaqonlymeexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getDownexist.do")
	public void getDownexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("board_gbn", "0002");
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getDownexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getDrugfaqexist.do")
	public void getDrugfaqexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("board_gbn", "0005");
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getDrugfaqexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/board/getVideofaqexist.do")
	public void getVideofaqexist(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("board_gbn", "0006");
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getVideofaqexist"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	
}
