package egovframework.com.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.MainVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
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
	
	/**
	 * 거래처관리 - AS 현황 카운트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsCount.do")
	public void getAsCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		
		returnMap.put("myAsInfo", commonDao.list(vo, "mainDAO.getMyAsInfo")) ;
		returnMap.put("asInfo", commonDao.list(vo, "mainDAO.getAsInfo")) ;
		
		CommonExecute.returnJson(response, returnMap);

	}
	
	/**
	 * 거래처관리 - MyAS 현황 카운트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getMyCount.do")
	public void getMyCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		
		returnMap.put("todayAs", commonDao.selectOne(vo, "mainDAO.getTodayAsCount")) ;
		returnMap.put("todayReply", commonDao.selectOne(vo, "mainDAO.getTodayReplyCount")) ;
		returnMap.put("operchar", commonDao.selectOne(vo, "mainDAO.getOpercharCount")) ;
		returnMap.put("frequenter", commonDao.selectOne(vo, "mainDAO.getFrequenterCount")) ;
		
		CommonExecute.returnJson(response, returnMap);

	}
	
	/**
	 * 나의거래처관리 - 오늘의 AS정보
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTodayAsInfo.do")
	public void getTodayAsInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		returnMap.put("resultList", commonDao.list(vo, "mainDAO.getTodayAsInfo")) ;
		CommonExecute.returnJson(response, returnMap);

	}
	
	/**
	 * 나의거래처관리 - 오늘의 AS답글
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getTodayReplyInfo.do")
	public void getTodayReplyInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		returnMap.put("resultList", commonDao.list(vo, "mainDAO.getTodayReplyInfo")) ;
		CommonExecute.returnJson(response, returnMap);

	}
	
	
	
	/**
	 * 거래처관리 - 나의 단골AS고객 (현월 AS + 전월AS)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getFrequenterInfo.do")
	public void getFrequenterInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		returnMap.put("resultList", commonDao.list(vo, "mainDAO.getFrequenterInfo")) ;
		
		CommonExecute.returnJson(response, returnMap);

	}
	
	
	/**
	 * 거래처관리 - 운영담당자 상세정보
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getOperCharInfo.do")
	public void getOperCharInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		returnMap.put("resultList", commonDao.list(vo, "mainDAO.opercharinfo")) ;
		
		CommonExecute.returnJson(response, returnMap);

	}
	
	
	/**
	 * 거래처관리 - 운영담당자 상세정보(팝업검색용)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getSearchWorkerInfo.do")
	public void getSearchWorkerInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		returnMap.put("resultList", commonDao.list(vo, "mainDAO.opercharinfo")) ;
		CommonExecute.returnJson(response, returnMap);

	}
	
	

	/**
	 * 거래처관리 - 작업시간(추이)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getWorkTimeChart.do")
	public void getWorkTimeChart(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		vo.setStr_dt(vo.getStr_dt().replaceAll("/", ""));
		vo.setEnd_dt(vo.getEnd_dt().replaceAll("/", ""));
		
		returnMap.put("resultList", commonDao.list(vo, "mainDAO.getWorkTimeChart")) ;
		CommonExecute.returnJson(response, returnMap);

	}

	
	/**
	 * 거래처관리 - 전체 A/S 거래처 관리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsStatsInfo.do")
	public void getAsStatsInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		if (!"".equals(SsStringUtil.normalizeNull(vo.getStr_dt()))) {
			vo.setStr_dt(vo.getStr_dt().replaceAll("/", ""));
		}
		returnMap.put("info", commonDao.list(vo, "mainDAO.getAsStatsInfo")) ;
		
		CommonExecute.returnJson(response, returnMap);

	}

	/**
	 * 거래처관리 -  거래처리스트 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getCustList.do")
	public void getCustInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		returnMap.put("info", commonDao.list(vo, "mainDAO.getCustList")) ;
		
		CommonExecute.returnJson(response, returnMap);

	}
	
	/**
	 * 거래처관리 -  as chart
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsStatusChart")
	public void getAsSystemChart(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		if("PROC_STATUS".equals(SsStringUtil.normalizeNull(vo.getFlag1()))) {
			returnMap.put("info", commonDao.list(vo, "mainDAO.getAsStatusChart")) ;
		}else if("SYSTEM_TYPE".equals(SsStringUtil.normalizeNull(vo.getFlag1()))) {
			returnMap.put("info", commonDao.list(vo, "mainDAO.getAsSystemChart")) ;
		}else if("INQUIRY_TYPE".equals(SsStringUtil.normalizeNull(vo.getFlag1()))) {
			returnMap.put("info", commonDao.list(vo, "mainDAO.getAsInquiryChart")) ;
		}else if("ACTION_TYPE".equals(SsStringUtil.normalizeNull(vo.getFlag1()))) {
			returnMap.put("info", commonDao.list(vo, "mainDAO.getAsActionChart")) ;
		}else if("CUST_RANK".equals(SsStringUtil.normalizeNull(vo.getFlag1()))) {
			returnMap.put("info", commonDao.list(vo, "mainDAO.getAsCustRankChart")) ;
		}
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
		
		 System.out.println(asno);
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("asno", asno);
		returnMap.put("resultList", commonDao.list(param, "asDAO.dashboardAsStatus"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 대쉬보드 - 프로젝트카운트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getProjectCount.do")
	public void getProjectCount( @ModelAttribute("vo") MainVO vo,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnMap.put("resultList", commonDao.list(vo,"mainDAO.getProjectCount"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 대쉬보드 - 프로젝트정보
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getProjectInfo.do")
	public void getProjectInfo( @ModelAttribute("vo") MainVO vo,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		if("1".equals(SsStringUtil.normalizeNull(vo.getGubun()))) {
			vo.setGubun("C001");
		}else if("2".equals(SsStringUtil.normalizeNull(vo.getGubun()))) {
			vo.setGubun("C002");
		}else if("3".equals(SsStringUtil.normalizeNull(vo.getGubun()))) {
			vo.setGubun("C003");
		}else if("4".equals(SsStringUtil.normalizeNull(vo.getGubun()))) {
			vo.setGubun("C004");
		}else if("5".equals(SsStringUtil.normalizeNull(vo.getGubun()))) {
			vo.setGubun("C005");
		}else if("6".equals(SsStringUtil.normalizeNull(vo.getGubun()))) {
			vo.setGubun("C006");
		}
		returnMap.put("resultList", commonDao.list(vo,"mainDAO.getProjectInfo"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * 대쉬보드 - 운영계약정보카운팅
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getOpercontractCount.do")
	public void getOpercontractCount( @ModelAttribute("vo") MainVO vo,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		returnMap.put("resultList", commonDao.list(vo,"mainDAO.getOpercontractCount"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 대쉬보드 - 운영계약정보
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getOpercontractInfo.do")
	public void getOperChart( @ModelAttribute("vo") MainVO vo,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		System.out.print(vo.getGubun());
		returnMap.put("resultList", commonDao.list(vo,"mainDAO.getOpercontractInfo"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 대쉬보드 - 나의 A/S 알람
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsAlarm.do")
	public void getAsAlarm( @ModelAttribute("vo") UserVO vo,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setEmp_no(userInfo.getEmp_no());
		returnMap.put("resultList", commonDao.list(vo,"mainDAO.getAsAlarm"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////////
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
