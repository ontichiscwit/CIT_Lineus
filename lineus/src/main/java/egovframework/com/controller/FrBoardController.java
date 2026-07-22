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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
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
	public String noticeForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
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
	public String faqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
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
	public String drugfaqForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		return "fr/drugfaq/form";
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
	public String downForm(@ModelAttribute("vo") BoardVO vo, HttpServletRequest request) throws Exception {
		
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
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		// 20171109 공지사항 권한 체크 적용건
		logger.debug("frUserInfo.getErp_code() : " + frUserInfo.getErp_code());
		vo.setErp_code(frUserInfo.getErp_code());
		
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
		vo.setErp_code(frUserInfo.getErp_code());
		vo.setReadUserId(frUserInfo.getEmp_id());
		vo.setBoard_gbn("0000");
		returnMap.put("resultList", boardService.getList(vo,"noticeDAO.getFrNotReadBoardList")) ;
		
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
		vo.setErp_code(frUserInfo.getErp_code());
		vo.setReadUserId(frUserInfo.getEmp_id());
		vo.setBoard_gbn("0000");
		returnMap.put("resultList", boardService.getList(vo,"noticeDAO.getRecentBoardList")) ;
		
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
		
		logger.debug("frUserInfo.getCust_code() : " + frUserInfo.getCust_code());
		
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
	@RequestMapping(value = "/fr/notice/getBoardInfo.do")
	public void getNoticeInfo(@ModelAttribute("vo") BoardVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;

		vo.setCrmCode(frUserInfo.getCust_code());
		vo.setEmp_id(frUserInfo.getEmp_id());
		logger.debug("frUserInfo.getEmp_id() : " + vo.getReg_id());
		
		returnMap.put("resultVO", boardService.getSelectInfo(vo, "noticeDAO.getBoardInfo")) ;
		returnMap.put("vo",vo);
		
		if (frUserInfo != null){
			boardService.upinNoticeRead(frUserInfo,vo.getSeq());
		}
			
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
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnMap.put("resultVO", boardService.getSelectInfo(vo, "boardDAO.getBoardInfo")) ;
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
	 * 답변 등록 
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
	 * 답변 삭제 
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
	
	
	
	
		
	
	
}
