package egovframework.com.comm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.comm.TreeCode;
import egovframework.com.comm.TreeCodeManager;
import egovframework.com.comm.model.Code2VO;
import egovframework.com.comm.model.CommonCodeVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonCodeService;
import egovframework.com.comm.util.CommonExecute;

@Controller
public class CommonCodeController {
	
	@Autowired TreeCodeManager treeCodeManager;
	
	@Autowired CommonCodeService commonCodeService ; 
	
	@RequestMapping(value = "/comm/getCode.do" , method = RequestMethod.POST)
	public void changeLocale(@ModelAttribute("vo") CommonCodeVO vo,HttpServletRequest request, HttpServletResponse response) throws Exception{
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		commonCodeService.getCodeList(vo) ;
		returnMap.put("resultList", vo.getOUTCURSOR()) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/comm/getCodeNm.do" , method = RequestMethod.POST)
	public void getCodeNm(@ModelAttribute("vo") CommonCodeVO vo,HttpServletRequest request, HttpServletResponse response) throws Exception{
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		returnMap.put("resultStr", commonCodeService.getCodeNm(vo)) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	@RequestMapping(value = "/comm/getPcode.do" , method = RequestMethod.POST)
	public void getPcode(@ModelAttribute("vo") CommonCodeVO vo,HttpServletRequest request, HttpServletResponse response) throws Exception{
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		returnMap.put("resultList", commonCodeService.getList(vo,"commmonDAO.getPcodeList")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 신규 코드 조회
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/comm/getCode2.do" , method = RequestMethod.POST)
	public void getCode2List(@ModelAttribute("vo") Code2VO vo,HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		List<TreeCode> list = treeCodeManager.getChildCodeList(vo.getP_code());
		
		ArrayList<Code2VO> reValue = new ArrayList<Code2VO>();
		
		for (TreeCode tCode : list){
			Code2VO code2Vo = new Code2VO();
			BeanUtils.copyProperties(code2Vo, tCode);
			reValue.add(code2Vo);
		}

		returnMap.put("resultList", reValue) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 신규코드 등록
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/comm/regCode2.do" , method = RequestMethod.POST)
	public void regCode2(@ModelAttribute("vo") Code2VO vo,HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception{
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		String returnCode = "400";
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		
		
		if(userInfo != null && userInfo.getEmp_no() != null){
			vo.setReg_id(userInfo.getEmp_no());
			int returnValue = treeCodeManager.insertCode(vo); 
			if(returnValue > 0) returnCode = "000" ; 
		}
		 
		returnMap.put("returnCode", returnCode) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 신규코드 수정
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/comm/modCode2.do" , method = RequestMethod.POST)
	public void modCode2(@ModelAttribute("vo") Code2VO vo,HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception{
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		String returnCode = "400";
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
			
		if(userInfo != null && userInfo.getEmp_no() != null){
				
			vo.setUp_id(userInfo.getEmp_no());
			int returnValue = treeCodeManager.updateCode(vo); 
			if(returnValue > 0) returnCode = "000" ; 
		}

		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 신규코드 삭제
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/comm/delCode2.do" , method = RequestMethod.POST)
	public void delCode2(@ModelAttribute("vo") Code2VO vo,HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception{
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		String returnCode = "400";
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		
		if(userInfo != null && userInfo.getEmp_no() != null){
			vo.setUp_id(userInfo.getEmp_no());
			int returnValue = treeCodeManager.deleteCode(vo); 
			if(returnValue > 0) returnCode = "000" ; 
		}

		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/comm/reOrderCode2.do" , method = RequestMethod.POST)
	public void  jsonArrayTest(@RequestBody List<Code2VO> voList, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception{

		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		String returnCode = "400";
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;

		if(userInfo != null && userInfo.getEmp_no() != null){

			if (treeCodeManager.orderUpdate(voList, userInfo.getEmp_no())){
				returnCode = "000";
			}
		}

		returnMap.put("returnCode", returnCode) ; 
		CommonExecute.returnJson(response, returnMap);
	}
}
