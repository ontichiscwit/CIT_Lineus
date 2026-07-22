package egovframework.com.controller;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.com.comm.model.CommonCodeVO;
import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonCodeService;
import egovframework.com.comm.service.CommonMenuService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.service.MemberService;

/**
 * @Class Name : AdManageController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.10.20	정연호		           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 */

@Controller
public class AdManageController {
	
	@Autowired CommonCodeService commonCodeService ;
	@Autowired CommonMenuService commonMenuService ; 
	@Autowired MemberService memberService ;
	
	/**
	 * 코드 관리
	 * @param vo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/code/list.do")
	public String list2(@ModelAttribute("vo") MenuVO vo, ModelMap model, HttpServletRequest request , HttpSession session) throws Exception {
		return "ad/code/list";
	}
	
	/**
	 * 코드그룹 정렬
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/code/getCodeGroupSort.do")
	public void getCodeGroupSort(@ModelAttribute("vo") CommonCodeVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<CommonCodeVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		resultList = commonCodeService.getList(vo,"commmonDAO.getCodeGroupSort") ;
		returnMap.put("resultList", resultList) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 코드 그룹 리스트 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/code/getCodeGroupList.do")
	public void getCodeGroupList(@ModelAttribute("vo") CommonCodeVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<CommonCodeVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		resultList = commonCodeService.getList(vo,"commmonDAO.getCodeGroupList") ;
		returnMap.put("resultList", resultList) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 코드 상세 리스트 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/code/getCodeDetailList.do")
	public void getCodeDetailList(@ModelAttribute("vo") CommonCodeVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<CommonCodeVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		resultList = commonCodeService.getList(vo,"commmonDAO.getCodeDetailList") ;
		returnMap.put("resultList", resultList) ;
		CommonExecute.returnJson(response, returnMap);
	}	
	
	@RequestMapping(value = "/ad/code/proc.do", method=RequestMethod.POST)
	public void regist(@ModelAttribute("vo") CommonCodeVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ;
		String returnCode = "400" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		
		//if (!"C001".equals(userInfo.getEmp_grade())){ 
		if (!"admin".equals(userInfo.getEmp_no())){	 		
			returnCode = "gradeNot";
		}else{
			vo.setReg_id(userInfo.getEmp_no());
			returnValue = commonCodeService.registCodeInfo(vo , request) ; 
			if(returnValue > 0) returnCode = "000" ; 
		}
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/code/del.do", method=RequestMethod.POST)
	public void deleteCodeInfo(@ModelAttribute("vo") CommonCodeVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0 ;
		String returnCode = "400" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		
		if (!"C001".equals(userInfo.getEmp_grade())){
			returnCode = "gradeNot";
		}else{
			vo.setReg_id(userInfo.getEmp_no());
			returnValue = commonCodeService.deleteCodeInfo(vo , request) ; 
			if(returnValue > 0) returnCode = "000" ; 
		}
		
		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}

}
