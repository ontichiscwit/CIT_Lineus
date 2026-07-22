package egovframework.com.controller;

import java.util.Arrays;
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
import egovframework.com.model.AsVO;
import egovframework.com.model.BoardVO;
import egovframework.com.model.CommonVO;
import egovframework.com.service.BoardService;
import egovframework.com.service.LoginService;
import egovframework.com.model.BoardAswVO;


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
public class FrBoardController {
	
	private static final Logger logger = LoggerFactory.getLogger(FrBoardController.class) ;
	
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
	@RequestMapping(value = "/fr/notice/list.do")
	public String noticeList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		vo.setPageSize(30);
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("weight",  "NL");
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/notice/list";
	}
	
	/**
	 * 공지사항 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/notice/form.do")
	public String noticeForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("seq", vo.getSeq());
		paramMap.put("board_gbn", vo.getBoard_gbn());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("search_text", vo.getSearch_text());
		
		if("9999".equals(SsStringUtil.normalizeNull(vo.getBoard_gbn()))) {
			commonDao.insert(paramMap, "boardDAO.insertBoardSearchView");
			paramMap.put("board_gbn", "0000");
		}
		
		return "fr/notice/form";
	}
	
	/**
	 * faq 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/faq/list.do")
	public String faqList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		vo.setPageSize(30);
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("weight",  "FAQ");
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/faq/list";
	}
	
	
	
	/**
	 * faq 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/faq/form.do")
	public String faqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("seq", vo.getSeq());
		paramMap.put("board_gbn", vo.getBoard_gbn());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("search_text", vo.getSearch_text());
		
		if("9999".equals(SsStringUtil.normalizeNull(vo.getBoard_gbn()))) {
			commonDao.insert(paramMap, "boardDAO.insertBoardSearchView");
			paramMap.put("board_gbn", "0001");
		}else {
			if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) {
				paramMap.put("board_gbn", "0001");
				commonDao.insert(paramMap, "boardDAO.insertBoardSearchView");
			}
		}
		
		commonDao.insert(paramMap, "boardDAO.insertBoardView");
		
		return "fr/faq/form";
	}
	
	
	/**
	 * drugfaq 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/drugfaq/list.do")
	public String drugfaqList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		vo.setPageSize(30);
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("weight",  "DRUG");
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/drugfaq/list";
	}
	
	
	
	
	/**
	 * drugfaq 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/drugfaq/form.do")
	public String drugfaqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("seq", vo.getSeq());
		paramMap.put("board_gbn", vo.getBoard_gbn());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("search_text", vo.getSearch_text());
		
		if("9999".equals(SsStringUtil.normalizeNull(vo.getBoard_gbn()))) {
			commonDao.insert(paramMap, "boardDAO.insertBoardSearchView");
			paramMap.put("board_gbn", "0005");
		}
		
		return "fr/drugfaq/form";
	}
	
	/**
	 * videofaq 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/videofaq/list.do")
	public String videofaqList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		vo.setPageSize(30);
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("weight",  "VIDEO");
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/videofaq/list";
	}
	
	/**
	 * search 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/main/search.do")
	public String searchList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("search_text", vo.getSearch_text());
		paramMap.put("weight",  "SEARCH");
		
//		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) {
//			commonDao.insert(vo, "boardDAO.insertBoardSearch");
//		}
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/main/search";
	}
	
	
	
	
	/**
	 * videofaq 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/videofaq/form.do")
	public String videofaqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("seq", vo.getSeq());
		paramMap.put("board_gbn", vo.getBoard_gbn());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("search_text", vo.getSearch_text());
		
		if("9999".equals(SsStringUtil.normalizeNull(vo.getBoard_gbn()))) {
			commonDao.insert(paramMap, "boardDAO.insertBoardSearchView");
			paramMap.put("board_gbn", "0006");
		}
		
		return "fr/videofaq/form";
	}
	
	
	/**
	 *	다운로드관리 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/down/list.do")
	public String downList(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		vo.setPageSize(30);
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("weight",  "DOWN");
		
		commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/down/list";
	}
	
	/**
	 * 다운로드관리 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/down/form.do")
	public String downForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
		UserVO userInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		paramMap.put("seq", vo.getSeq());
		paramMap.put("board_gbn", vo.getBoard_gbn());
		paramMap.put("cust_code", userInfo.getCust_code());
		paramMap.put("emp_id", userInfo.getEmp_id());
		paramMap.put("search_text", vo.getSearch_text());
		
		if("9999".equals(SsStringUtil.normalizeNull(vo.getBoard_gbn()))) {
			commonDao.insert(paramMap, "boardDAO.insertBoardSearchView");
			paramMap.put("board_gbn", "0002");
		}
		
		return "fr/down/form";
	}
	
	/**
	 * 공지사항 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/notice/getBoardList.do")
	public void getNoticeList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardVO> resultList = null ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
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
		
		// 20171109 공지사항 권한 체크 적용건
		logger.debug("frUserInfo.getCust_code() : " + frUserInfo.getCust_code());
		vo.setCrmCode(frUserInfo.getCust_code());
		
		int totalCount = boardService.getTotalCnt(vo,"noticeDAO.getFrBoardListCnt") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = boardService.getList(vo,"noticeDAO.getFrBoardList") ;
			
			vo.setJson_paging(vo.getJsonPaging("getBoardList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 특정사용자의 읽지않은 공지사항 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/notice/getNotReadList.do")
	public void getNotReadNoticeList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		vo.setCrmCode(frUserInfo.getCust_code());
		vo.setReadUserId(frUserInfo.getEmp_id());
		vo.setBoard_gbn("0000");
		returnMap.put("resultList", boardService.getList(vo,"noticeDAO.getFrNotReadBoardList")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 조회수가 많은 상담사례 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/faq/getManyReadList.do")
	public void getManyReadFaqList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		vo.setReg_id(frUserInfo.getEmp_id());
		/*vo.setCrmCode(frUserInfo.getCust_code());
		vo.setReadUserId(frUserInfo.getEmp_id());*/
		vo.setBoard_gbn("0001");
		returnMap.put("resultList", boardService.getList(vo,"noticeDAO.getFrManyReadFaqList")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 최근 공지사항 리스트 데이터 조회(한달)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/notice/getRecentList.do")
	public void getRecentNoticeList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		vo.setCrmCode(frUserInfo.getCust_code());
		vo.setReadUserId(frUserInfo.getEmp_id());
		vo.setBoard_gbn("0000");
		returnMap.put("resultList", boardService.getList(vo,"noticeDAO.getRecentBoardList")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 최근 상담사례 리스트 데이터 조회(한달)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/faq/getRecentList.do")
	public void getRecentFaqList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		vo.setReg_id(frUserInfo.getEmp_id());
//		vo.setCrmCode(frUserInfo.getCust_code());
//		vo.setReadUserId(frUserInfo.getEmp_id());
		vo.setBoard_gbn("0001");
		returnMap.put("resultList", boardService.getList(vo,"noticeDAO.getRecentFaqList")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 최근 상담사례 리스트 데이터 조회(한달)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/main/getBestFaqList.do")
	public void getBestFaqList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		vo.setReg_id(frUserInfo.getEmp_id());
//		vo.setCrmCode(frUserInfo.getCust_code());
//		vo.setReadUserId(frUserInfo.getEmp_id());
		vo.setBoard_gbn("0001");
		returnMap.put("resultList", boardService.getList(vo,"boardDAO.getBestFaqList")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 공지사항 외 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/board/getBoardList.do")
	public void getBoardList(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardVO> resultList = null ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		vo.setReg_id(frUserInfo.getEmp_id());
		vo.setEmp_id(frUserInfo.getEmp_id());
		vo.setCust_code(frUserInfo.getCust_code());
		
		logger.debug("frUserInfo.getCust_code() : " + frUserInfo.getCust_code());
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) {
			vo.setSearch_text_arr(vo.getSearch_text().split(" "));
			commonDao.insert(vo, "boardDAO.insertBoardSearch");
		}
		
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
	@RequestMapping(value = "/fr/notice/getBoardInfo.do")
	public void getNoticeInfo(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		vo.setCrmCode(frUserInfo.getCust_code());
		vo.setEmp_id(frUserInfo.getEmp_id());
		vo.setSeq(vo.getSeq());
		logger.debug("frUserInfo.getEmp_id() : " + vo.getReg_id());
		
		returnMap.put("resultVO", boardService.getSelectInfo(vo, "noticeDAO.getFrBoardInfo")) ;
		returnMap.put("vo",vo);
		
		if (frUserInfo != null){
			boardService.upinNoticeRead(frUserInfo,vo.getSeq());
		}
			
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 상담사례 상세 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/board/getFaqBoardInfo.do")
	public void getFaqBoardInfo(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		vo.setCrmCode(frUserInfo.getCust_code());
		vo.setCrm_code(frUserInfo.getCust_code());
		vo.setEmp_id(frUserInfo.getEmp_id());
		vo.setW_id(frUserInfo.getEmp_id());
		vo.setSeq(vo.getSeq());
		logger.debug("frUserInfo.getEmp_id() : " + vo.getReg_id());
		
		int likeStatusCnt = boardService.getTotalCnt(vo, "boardDAO.getFaqLikeStatusCnt") ;

		if(likeStatusCnt == 0){
			vo.setLike_yn("N");
			commonDao.insert(vo, "boardDAO.insertFaqLike");
		}

		
		
		returnMap.put("resultVO", boardService.getSelectInfo(vo, "boardDAO.getFaqBoardInfo")) ;
		returnMap.put("vo",vo);
		
//		if (frUserInfo != null){ //(2024.05.23 김규민) 상담사례 관련 수정 대기(방문 기록)
//			boardService.upinNoticeRead(frUserInfo,vo.getSeq());
//		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 공지사항 외 상세 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/board/getBoardInfo.do")
	public void getBoardInfo(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		vo.setCrmCode(frUserInfo.getCust_code());
		vo.setEmp_id(frUserInfo.getEmp_id());
		logger.debug("frUserInfo.getEmp_id() : " + vo.getReg_id());
		
		returnMap.put("resultVO", boardService.getSelectInfo(vo, "boardDAO.getBoardInfo")) ;
		returnMap.put("vo",vo);
		
//		if (frUserInfo != null){ //(2024.05.23 김규민) 상담사례 관련 수정 대기(방문 기록)
//			boardService.upinNoticeRead(frUserInfo,vo.getSeq());
//		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 공지사항 상세 답변내역 리스트 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/board/getAwsList.do")
	public void getAwsList(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardAswVO> resultList = null ;
		
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
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
	@RequestMapping(value = "/fr/board/getFaqAwsList.do")
	public void getFaqAwsList(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardAswVO> resultList = null ;
		
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
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
	@RequestMapping(value = "/fr/board/getFaqLikeList.do")
	public void getFaqLikeList(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardAswVO> resultList = null ;
		
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		int totalCount = boardService.getTotalAswCnt(vo, "boardDAO.getFaqLikeListCnt") ;
		vo.setPaging(totalCount);
		
		resultList = boardService.getNoticeAswList(vo ,"boardDAO.listLike" ) ;
		vo.setJson_paging(vo.getJsonPaging("getListAsw"));
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo", vo) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 상담사례 좋아요 등록,변경 및 개수 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/board/getLikeByRecent.do")
	public void getLikeByRecent(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<BoardAswVO> resultList = null ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		vo.setCrm_code(frUserInfo.getCust_code());
		vo.setW_id(frUserInfo.getEmp_id());
		vo.setBoard_gbn("0001");
		vo.setFaq_seq(vo.getSeq());
		vo.setSeq(vo.getSeq());
		
		int likeStatusCnt = boardService.getTotalAswCnt(vo, "boardDAO.getFaqLikeStatusCnt") ;
		
		int likeCnt = boardService.getTotalLikeCnt(vo, "boardDAO.getFaqEmpLikeCnt") ;
		
		if(likeStatusCnt > 0){
			if(likeCnt > 0) {
				vo.setLike_yn("N");
			}else {
				vo.setLike_yn("Y");
			}
			commonDao.update(vo, "boardDAO.updateFaqLike");
		}else {
			vo.setLike_yn("Y");
			commonDao.insert(vo, "boardDAO.insertFaqLike");
		}
		
		int totalCount = boardService.getTotalAswCnt(vo, "boardDAO.getFaqLikeListCnt") ;
		vo.setPaging(totalCount);
		
		resultList = boardService.getNoticeAswList(vo ,"boardDAO.getFaqLikeList" ) ;
		
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo",vo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 공지사항 답변 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/board/awsform.do")
	public void awsForm(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String returnCode = "" ; 
		int returnValue = 0;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		vo.setCrm_code(frUserInfo.getCust_code());
		vo.setW_id(frUserInfo.getEmp_id());
	    vo.setW_gubun("U");
		
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
	@RequestMapping(value = "/fr/board/awsDel.do")
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
	@RequestMapping(value = "/fr/board/faqawsform.do")
	public void faqawsform(@ModelAttribute("vo") BoardAswVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		String returnCode = "" ; 
		int returnValue = 0;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		vo.setCrm_code(frUserInfo.getCust_code());
		vo.setW_id(frUserInfo.getEmp_id());
	    vo.setW_gubun("U");
		
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
	 * 상담사례 답변 삭제 
	 * @param vo
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/board/faqawsDel.do")
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
	
	@RequestMapping(value = "/fr/board/getNoticenum.do")
	public void getNoticenum(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seq", seq);
		
		returnMap.put("resultList", commonDao.list(param, "boardDAO.getNoticenum"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
		
	
	
}
