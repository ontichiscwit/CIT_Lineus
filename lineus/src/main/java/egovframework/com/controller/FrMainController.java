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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.model.MainVO;
import egovframework.com.model.CustVO;
import egovframework.com.model.OperateVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.LoginService;
import egovframework.com.service.MemberService;
import egovframework.com.comm.util.DateTimeUtil;

/**
 * @Class Name : FrLoginController.java
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
public class FrMainController {
	
	@Autowired
	CommonDao commonDao;
	
	private static final Logger logger = LoggerFactory.getLogger(FrMainController.class) ;
	
	/**
	 * 로그인 화면 호출 - O
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/main/list.do")
	public String list(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		
		String currentDateStr =  DateTimeUtil.getDate();
		String agoDate = DateTimeUtil.getAddDay(currentDateStr, -7);
		vo.setStr_dt(DateTimeUtil.getDateFormatText(agoDate, "/"));
		vo.getStr_dt();
		frUserInfo.getCust_code();
		frUserInfo.getEmp_id();
		
		System.out.println(frUserInfo.getEmp_id());
		
		
		Map<String , String> paramMap = new HashMap<String , String>() ;
		
		CustVO temp1 = new CustVO();
		UserVO temp2 = new UserVO();
		
		temp1 = (CustVO) commonDao.selectOne(frUserInfo.getCust_code(),"custDAO.selectIsAsApproval1");
		temp2 = (UserVO) commonDao.selectOne(frUserInfo.getEmp_id(),"custDAO.selectIsAsApproval3");
		 
		// A/S 승인 프로세스 확인 	
		if(	"C001".equals(SsStringUtil.normalizeNull(temp1.getAs_approval_yn())) &&  "C001".equals(SsStringUtil.normalizeNull(temp2.getApproval_auth()))) {
			vo.setApproval("use");
		}else {
			vo.setApproval("un_use");
		}
			
		paramMap.put("emp_id", frUserInfo.getEmp_id());
		paramMap.put("cust_code", frUserInfo.getCust_code());
		paramMap.put("weight",  "M");
		
		//commonDao.insert(paramMap, "loginDAO.insertComeUser");
		
		return "fr/main/list";
	}
	
	@RequestMapping(value = "/fr/main/getMyAsStatus.do")
	public void getMyAsStatus(@RequestParam("str_dt") String str_dt, @RequestParam("end_dt") String end_dt, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String , String> paramMap = new HashMap<String , String>() ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		paramMap.put("str_dt", str_dt.replaceAll("/", ""));
		paramMap.put("end_dt", end_dt.replaceAll("/", ""));
		paramMap.put("userId", frUserInfo.getEmp_id());
		
		returnMap.put("result", commonDao.list(paramMap,"mainDAO.getMyAsStatus")) ;
		
		CommonExecute.returnJson(response, returnMap);
		
	}
	
	@RequestMapping(value = "/fr/main/getCrmAsStatus.do")
	public void getCrmAsStatus(@RequestParam("str_dt") String str_dt, @RequestParam("end_dt") String end_dt, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String , String> paramMap = new HashMap<String , String>() ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		paramMap.put("str_dt", str_dt.replaceAll("/", ""));
		paramMap.put("end_dt", end_dt.replaceAll("/", ""));
		paramMap.put("erpCode", frUserInfo.getErp_code());
		
		returnMap.put("result", commonDao.list(paramMap,"mainDAO.getCrmAsStatus")) ;
		
		CommonExecute.returnJson(response, returnMap);
		
	}
	
	@RequestMapping(value = "/fr/main/getAsGraph.do")
	public void getAsGraph(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String , String> paramMap = new HashMap<String , String>() ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		paramMap.put("erp_code", frUserInfo.getErp_code());
		returnMap.put("result", commonDao.list(paramMap,"mainDAO.getAsGraph")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/fr/main/dashboardAsStatus.do")
	public void getAsListByAsno(@RequestParam("asno") String asno, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		// System.out.println(asno);
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("asno", asno);
		returnMap.put("resultList", commonDao.list(param, "asDAO.dashboardAsStatus"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/// AS댓글 ///
	@RequestMapping(value = "/fr/main/getAnswerListbyRecent.do")
	public void getAnswerListbyRecent(@RequestParam("user_id") String user_id, @RequestParam("answerGubunFlag") String answerGubunFlag,@RequestParam("cust_code") String cust_code,@RequestParam("asw_str_dt") String asw_str_dt,@RequestParam("asw_end_dt") String asw_end_dt, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("cust_code", cust_code);
		param.put("asw_str_dt", asw_str_dt.replaceAll("/", ""));
		param.put("asw_end_dt", asw_end_dt.replaceAll("/", ""));
		param.put("answerGubunFlag", answerGubunFlag);
		param.put("user_id", user_id);
		
		
		returnMap.put("resultList", commonDao.list(param, "mainDAO.getAnswerListbyRecent"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/fr/main/getTodayAnswerCnt.do")
	public void getTodayAnswerCnt(@RequestParam("cust_code") String cust_code, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("cust_code", cust_code);
		
		returnMap.put("resultList", commonDao.list(param, "mainDAO.getTodayAnswerCnt"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/fr/main/getTodayAnswer.do")
	public void getTodayAnswer(@RequestParam("cust_code") String cust_code, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		param.put("cust_code", cust_code);
		
		returnMap.put("resultList", commonDao.list(param, "mainDAO.getTodayAnswer"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/fr/main/getMybadgeCount.do")
	public void getMybadgeCount(HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		param.put("cust_code", frUserInfo.getErp_code());
		param.put("reg_id", frUserInfo.getEmp_id());
		
		
		returnMap.put("todayMyAS", commonDao.selectOne(param, "mainDAO.getTodayMyASCount"));
		returnMap.put("todayMyReply", commonDao.selectOne(param, "mainDAO.getTodayMyRelyCount"));
		returnMap.put("approvalAs", commonDao.selectOne(param, "mainDAO.getApprovalAsCount"));
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/fr/main/dashboardAddressInfo.do")
	public void dashboardAddressInfo(@ModelAttribute("vo") OperateVO vo,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		param.put("cust_code", frUserInfo.getErp_code());
		
		int totalCount = commonDao.selectOneInt(param , "mainDAO.getAddressCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("getAddressInfo"));
			returnMap.put("resultList", commonDao.list(param, "mainDAO.getAddressInfo"));
			returnMap.put("vo", vo) ; 
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	@RequestMapping(value = "/fr/main/getTodayMyAs.do")
	public void getTodayMyAs(@RequestParam("str_dt") String str_dt,@RequestParam("end_dt") String end_dt,HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		param.put("cust_code", frUserInfo.getErp_code());
		param.put("reg_id", frUserInfo.getEmp_id());
		
		param.put("str_dt",str_dt.replaceAll("/", ""));
		param.put("end_dt",end_dt.replaceAll("/", "") );
		
		returnMap.put("list", commonDao.list(param, "mainDAO.getTodayMyAs"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	@RequestMapping(value = "/fr/main/dashboardApprovalAsInfo.do")
	public void getApprovalAs(HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		HashMap<String,String> param = new HashMap<String, String>();
		UserVO frUserInfo = session.getAttribute("frUserInfo") != null ? (UserVO) session.getAttribute("frUserInfo") : null ;
		
		param.put("cust_code", frUserInfo.getErp_code());
		param.put("reg_id", frUserInfo.getEmp_id());
		
		returnMap.put("list", commonDao.list(param, "mainDAO.getApprovalAs"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	
}
