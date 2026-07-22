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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonCodeService;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.comm.util.StringUtil;
import egovframework.com.model.BoardVO;
import egovframework.com.model.SmsVO;
import egovframework.com.service.SmsService;

/**
 * @Class Name : AdSmsController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ @ 2017.10.16	정연호    최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class AdSmsController {
	@Autowired CommonCodeService commonCodeService ;
	@Autowired CommonFileService commonFileService ; 
	@Autowired SmsService smsService ; 
	
	/**
	 * 발송관리 리스트
	 * @param vo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/sms/list.do")
	public String list(@ModelAttribute("vo") SmsVO vo, ModelMap model, HttpServletRequest request , HttpSession session) throws Exception {
		return "ad/sms/list";
	}
	
	/**
	 * sms 리스트 데이터
	 * @param vo
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/sms/getList.do" , method = RequestMethod.POST)
	public void getNoticeList(@ModelAttribute("vo") SmsVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception{
		
		List<SmsVO> resultList = null ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		String res_data = "" ; 
			
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
					
		resultList = smsService.getList(vo,"smsDAO.getList") ;
		returnMap.put("resultList", resultList) ;

		ObjectMapper om = new ObjectMapper() ; 
		res_data = om.writeValueAsString(returnMap) ;
		response.setContentType("text/html;charset=utf-8");
		PrintWriter pw = response.getWriter() ; 
		pw.print(res_data);
		pw.flush();  
		pw.close();
			
	}
	
	/**
	 * 발송관리 처리
	 * @param vo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/sms/proc.do")
	public void proc(@ModelAttribute("vo") SmsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		String res_data = "" ;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		String returnCode = "" ; 
		
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ; 
		
		try {
			UserVO adUserInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
			
			int returnValue = 0 ;
			
			if (!"C001".equals(adUserInfo.getEmp_grade())){
				returnCode = "gradeNot";
			}else{
				vo.setReg_id(adUserInfo.getReg_id());
				
				if("insert".equals(pageType)){
					returnValue = smsService.insertProc(vo , request) ;
				}else if("update".equals(pageType)){
					returnValue = smsService.updateProc(vo , request) ;
				}
				
				if(returnValue == -100){
					returnCode = "200" ;			/**	변경 항목 없음		*/
				}else if(returnValue == -200){
					returnCode = "400" ; 			/**	parameter 없음		*/
				}else if(returnValue > 0){
					returnCode = "000" ; 			/**	정상 처리		*/
				}else{
					returnCode = "300" ;			/**	처리된 내역 없음	*/
				}
			}
			
			returnMap.put("returnCode", returnCode) ; 
			returnMap.put("returnValue", returnValue) ; 
			
			ObjectMapper om = new ObjectMapper() ; 
			res_data = om.writeValueAsString(returnMap) ; 
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			response.setContentType("text/html;charset=utf-8");
			PrintWriter pw = response.getWriter() ; 
			pw.print(res_data);
			pw.flush();  
			pw.close();
		}
	}
}
