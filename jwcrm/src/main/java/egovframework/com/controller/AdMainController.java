package egovframework.com.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.httpclient.HttpClient;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.common.io.ByteStreams;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.MainVO;
import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.model.RoleVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.LoginService;
import egovframework.com.service.MainService;


/**
 * @Class Name : AdMainController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.09.08	정철구		           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class AdMainController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdMainController.class) ;
	
	@Autowired MainService mainService ; 
	@Autowired CommonDao commonDao;
	
	@RequestMapping(value = "/ad/main/ect.do")
	public String ect(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*CloseableHttpClient client = HttpClients.createDefault();
	    HttpGet request = new HttpGet("https://app.powerbi.com/view?r=eyJrIjoiMGQ0Y2I5MjYtMjk0OC00Nzc2LWJjOTMtYjgwY2IyMTJhMGQ0IiwidCI6IjJlZjAxOTVjLWIyYjgtNDQyMy1hMGM3LTA1ODBjM2IxMTNjYSIsImMiOjEwfQ%3D%3D");
	    HttpResponse response1 = client.execute(request);
	    response.setContentType("text/html");
	    ByteStreams.copy(response1.getEntity().getContent(), response.getOutputStream());*/
		
		
		/*String url = "https://app.powerbi.com/view?r=eyJrIjoiMGQ0Y2I5MjYtMjk0OC00Nzc2LWJjOTMtYjgwY2IyMTJhMGQ0IiwidCI6IjJlZjAxOTVjLWIyYjgtNDQyMy1hMGM3LTA1ODBjM2IxMTNjYSIsImMiOjEwfQ%3D%3D";
		String uri = "://app.powerbi.com/view?r=eyJrIjoiMGQ0Y2I5MjYtMjk0OC00Nzc2LWJjOTMtYjgwY2IyMTJhMGQ0IiwidCI6IjJlZjAxOTVjLWIyYjgtNDQyMy1hMGM3LTA1ODBjM2IxMTNjYSIsImMiOjEwfQ%3D%3D";
		
		HttpServletResponse.setHeader("Location", url);
		httpServletResponse.setStatus(302);
		
		String redirectUrl = request.getScheme() + uri;
		*/
	/*	RequestDispatcher rd = request.getRequestDispatcher("https://app.powerbi.com/view?r=eyJrIjoiMGQ0Y2I5MjYtMjk0OC00Nzc2LWJjOTMtYjgwY2IyMTJhMGQ0IiwidCI6IjJlZjAxOTVjLWIyYjgtNDQyMy1hMGM3LTA1ODBjM2IxMTNjYSIsImMiOjEwfQ%3D%3D");
		rd.forward(request, response);
	*/	
		 return "forward:https://app.powerbi.com/view?r=eyJrIjoiMGQ0Y2I5MjYtMjk0OC00Nzc2LWJjOTMtYjgwY2IyMTJhMGQ0IiwidCI6IjJlZjAxOTVjLWIyYjgtNDQyMy1hMGM3LTA1ODBjM2IxMTNjYSIsImMiOjEwfQ%3D%3D";
	}
	
	
	
	/**
	 * 대쉬 보드 - 거래처 현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/list.do")
	public String form(@ModelAttribute("vo") MainVO vo, HttpServletRequest request) throws Exception {
		return "ad/main/list";
	}
	
	/**
	 * 대쉬 보드 - A/S
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/list1.do")
	public String list1(@ModelAttribute("vo") MainVO vo, HttpServletRequest request) throws Exception {
		return "ad/main/list1";
	}
	
	/**
	 * 대쉬 보드 - 채권관리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/list2.do")
	public String list2(@ModelAttribute("vo") MainVO vo, HttpServletRequest request) throws Exception {
		return "ad/main/list2";
	}
	
	
	
	
	
	/**
	 * 준비중 페이지
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/ready.do")
	public String ready(@ModelAttribute("vo") MainVO vo, HttpServletRequest request) throws Exception {
		return "ad/main/ready";
	}
	
	/**
	 * 거래처관리 - AS 현황 카운트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getMainInfo.do")
	public void getMainInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		vo.setDept_cd(adUserInfo.getDept_cd());
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getStr_dt()))) vo.setStr_dt(vo.getStr_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getEnd_dt()))) vo.setEnd_dt(vo.getEnd_dt().replaceAll("/", "")) ;
		
		
		if("1".equals(SsStringUtil.normalizeNull(vo.getFirstFlag()))) {
			/**	거래처 카운트 */	returnMap.put("top1", mainService.getSelectOne(vo, "mainDAO.getTop1")) ;
		}else if("2".equals(SsStringUtil.normalizeNull(vo.getFirstFlag()))) {
			/**	거래처 카운트 */	returnMap.put("top1", mainService.getSelectOne(vo, "mainDAO.getTop_AS")) ;
			/**	나의a/s현황 */	returnMap.put("top2", commonDao.list(vo, "mainDAO.getTop2")) ;
			/**	팀별a/s현황 */	returnMap.put("top3", commonDao.list(vo, "mainDAO.getTop3")) ;
		}else if("3".equals(SsStringUtil.normalizeNull(vo.getFirstFlag()))) {
			/**	거래처 카운트 */	returnMap.put("top1", mainService.getSelectOne(vo, "mainDAO.getTop1")) ;
		}
		CommonExecute.returnJson(response, returnMap);

	}
	
	/**
	 * 계정관리 - 거래처 계정 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getMainSubInfo.do")
	public void getMainSubInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		vo.setDept_cd(adUserInfo.getDept_cd());

		if("1".equals(SsStringUtil.normalizeNull(vo.getFirstFlag()))) {
			returnMap.put("resultVO", mainService.getList(vo, "mainDAO.getMidInfo" + vo.getThirdFlag())) ;
		}else if("2".equals(SsStringUtil.normalizeNull(vo.getFirstFlag()))) {
			/**	기간별 A/S추이 */	returnMap.put("charList", mainService.getList(vo, "mainDAO.getCharList2")) ;
		}else if("3".equals(SsStringUtil.normalizeNull(vo.getFirstFlag()))) {
			/**	부가솔루션 계약현황 */	returnMap.put("resultVO", mainService.getList(vo, "mainDAO.getMidInfo" + vo.getThirdFlag())) ;
		}
		
		
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 계정관리 - 거래처 계정 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getCustListBySeq.do")
	public void getCustListBySeq(@RequestParam("seqArr") String seqArr, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		logger.debug(seqArr);
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("seqArr", seqArr);
		returnMap.put("resultList", commonDao.list(param, "mainDAO.getCustListBySeqs"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 대쉬보드 - AS 목록 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsListByAsno.do")
	public void getAsListByAsno(@RequestParam("asno") String asno, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		// System.out.println(asno);
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("asno", asno);
		returnMap.put("resultList", commonDao.list(param, "asDAO.selectAsListByAsNo"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * a/s - HIS 버전별 as 분포
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getMainHisChart.do")
	public void getMainHisChart(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		vo.setDept_cd(adUserInfo.getDept_cd());
			
		returnMap.put("charList", mainService.getList(vo, "mainDAO.getCharList2_1")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * a/s - 유형별 차트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getMainAsChart.do")
	public void getMainAsChart(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		vo.setDept_cd(adUserInfo.getDept_cd());
			
		returnMap.put("charList", mainService.getList(vo, "mainDAO.getCharList2_2")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * AS 분석 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsAnalysis.do")
	public void getAsAnalysis(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", commonDao.list(vo, "mainDAO.getAsAnalysisTable")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 거래처 현황 - 유지보수 - 수금현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getFirstTab1LeftList.do")
	public void getFirstTab1LeftList(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getFirstTab1LeftList")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 거래처 현황 - 유지보수 - A/S분석 TOP
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getFirstTab1RightTop.do")
	public void getFirstTab1RightTop(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultData", commonDao.selectOne(vo, "mainDAO.getFirstTab1RightTop")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 거래처 현황 - SMS - 계약현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTab1SmsTop.do")
	public void getTab1SmsTop(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getTab1SmsTop")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 거래처 현황 - SMS - 수금현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTab1SmsLeft.do")
	public void getTab1SmsLeft(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getTab1SmsLeft")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 거래처 현황 - SMS - 기간별계약추이
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTab1SmsRight.do")
	public void getTab1SmsRight(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getTab1SmsRight")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	
	
	//////////////////////////부가솔루션//////////////////////////////////
	
	/**
	 * 거래처 현황 - 부가솔루션 - 매출순위
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTab1SolutionLeft.do")
	public void getTab1SolutionLeft(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getStr_dt())))
			vo.setStr_dt(vo.getStr_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getEnd_dt())))
			vo.setEnd_dt(vo.getEnd_dt().replaceAll("/", ""));
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getTab1SolutionLeft")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 거래처 현황 - 부가솔루션 - 제품,날짜검색
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTab1SolutionRight.do")
	public void getTab1SolutionRight(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		if (!"".equals(SsStringUtil.normalizeNull(vo.getStr_dt())))
			vo.setStr_dt(vo.getStr_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getEnd_dt())))
			vo.setEnd_dt(vo.getEnd_dt().replaceAll("/", ""));
		
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getTab1SolutionRight")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	
	
	
	
	
	/**
	 * 거래처 현황 - 부가솔루션리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTab1SolutionItemList.do")
	public void getTab1SolutionItemList(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getTab1SolutionItemList")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	
	///////////////////////-부가솔루션//////////////////////////////////////
	
	/**
	 * 채권관리 - 고객등급
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getCustGradeCnt.do")
	public void getCustGradeCnt(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getCustGradeCnt")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 채권관리 - 고객등급 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getCustGradeList.do")
	public void getCustGradeList(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getCustGradeList")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 채권관리 - 채권등급
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getBondGradeCnt.do")
	public void getBondGradeCnt(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getBondGradeCnt")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 채권관리 - 채권등급 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getBondGradeList.do")
	public void getBondGradeList(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getBondGradeList")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 채권관리 - 채권등급 리스트 신규
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getCustOverdueList.do")
	public void getCustOverdueList(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getCustOverdueList")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 채권관리 - 채권 최고서 발송
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getBondReminderCnt1.do")
	public void getBondReminderCnt1(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getBondReminderCnt1")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 채권관리 - 채권 최고진행
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getBondReminderCnt2.do")
	public void getBondReminderCnt2(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getBondReminderCnt2")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 채권관리 - 이슈 현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getBondIssueList.do")
	public void getBondIssueList(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
		returnMap.put("resultList", mainService.getList(vo, "mainDAO.getBondIssueList")) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
}
