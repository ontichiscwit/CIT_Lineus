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

import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.service.LoginService;
import egovframework.com.service.MemberService;
import egovframework.com.comm.dao.CommonDao;

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
public class FrLoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(FrLoginController.class) ;
	
	@Autowired CommonDao commonDao;
	@Autowired LoginService loginService ; 
	/**
	 * 로그인 화면 호출 - O
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/login/form.do")
	public String form(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession() ; 
		/*session.invalidate();  */
		
		return "fr/login/form";
	}
	
	/**
	 * 로그아웃 처리 - O
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/login/out.do")
	public void removeOut(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession() ; 
		session.invalidate();  
		
		response.sendRedirect("/fr/login/form.do");
	}
	
	
	/**
	 * SSO 자동 로그인 - 테스트용 (emp_id만으로 바로 로그인)
	 * ⚠️⚠️ 테스트 전용! 운영 반영 시 SSO_TEST_MODE = false 로 끄거나
	 *       sig/만료 검증 버전으로 교체할 것!
	 */
	@RequestMapping(value = "/fr/sso/login.do")
	public void ssoLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		logger.warn("★★★ SSO 진입함! emp_id=" + request.getParameter("emp_id"));

	    // ★ 테스트 입구 스위치 - 운영 시 false로 바꾸면 막힘
	    boolean SSO_TEST_MODE = true;

	    if (!SSO_TEST_MODE) {
	        response.sendRedirect("/fr/login/form.do");
	        return;
	    }

	    String empId = request.getParameter("emp_id");

	    // ── 사용자 조회 (emp_id로 바로) ──
	    UserVO vo = new UserVO();
	    vo.setEmp_id(empId);
	    UserVO userInfo = loginService.selectFrUserInfo(vo);

	    // ── 기존 로그인 검증들 (살려두는 게 안전) ──
	    if (userInfo == null) {
	        logger.warn("SSO: 존재하지 않는 계정 " + empId);
	        response.sendRedirect("/fr/login/form.do");
	        return;
	    }
	    if (loginService.checkOPDealCode(userInfo.getCust_code())) {
	        response.sendRedirect("/fr/login/form.do");   // 폐업/해지/중지 병원
	        return;
	    }
	    if (!"C001".equals(SsStringUtil.normalizeNull(userInfo.getUse_type()))) {
	        response.sendRedirect("/fr/login/form.do");   // 정상 사용자 아님
	        return;
	    }

	    // ── 세션 생성 (★ 기존 FrLoginController와 완전히 동일) ──
	    HttpSession session = request.getSession();
	    session.setAttribute("frUserInfo", userInfo);

	    // (선택) 접속 로그
	    vo.setWeight("U");
	    commonDao.insert(vo, "loginDAO.insertComeUser");

	    // ── A/S 폼으로 이동 ──
	    response.sendRedirect("/fr/as/form.do");
	}

	
	/**
	 * 사용자 로그인 처리 - O
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/login/proc.do")
	public void proc(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		logger.debug(vo.getPass());
		UserVO userInfo = loginService.selectFrUserInfo(vo) ;
		logger.debug(vo.getPass());
		vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
		logger.debug(vo.getPass());
		if(userInfo != null){
			
			// 사용자의 crm_code를 이용하여 해당 병원의 운영상태코드가 C003,C004,C005에 해당하는지 확인한다.
			if (!userInfo.getPass().equals(vo.getPass())){
				/**	패스워드 틀림	*/
				returnMap.put("returnFlag" , "003") ;
			} else if (loginService.checkOPDealCode(userInfo.getCust_code())){
				/**	해당병원 사용가능 상태가 아님	*/	//2022.10.19 수정)거래상태가 중지일 경우 로그인이 가능하도록 조건에서 제외
				returnMap.put("returnFlag" , "007");
			} else if("C001".equals(SsStringUtil.normalizeNull(userInfo.getUse_type())) ){
				/**	정상 처리	*/
				HttpSession session = request.getSession() ; 
				session.setAttribute("frUserInfo", userInfo);
				returnMap.put("returnFlag" , "000") ;
				vo.setWeight("U");
				commonDao.insert(vo, "loginDAO.insertComeUser");
				
			} else if("C006".equals(SsStringUtil.normalizeNull(userInfo.getUse_type())) ) {
				/**	약관미동의	*/
				HttpSession session = request.getSession() ; 
				session.setAttribute("tempUserInfo", userInfo);
				returnMap.put("returnFlag" , "006") ;
			}else if("C004".equals(SsStringUtil.normalizeNull(userInfo.getUse_type())) ) {
				/**	승인대기**/
				returnMap.put("returnFlag" , "004");
			}else {
				/**	사용할수 없는 아이디 입니다.	*/
				returnMap.put("returnFlag" , "002") ;
			}
			
		}else{
			returnMap.put("returnFlag" , "001") ; 				/**	아이디 혹은 비밀번호를 확인해 주세요.	*/  
		}
		
		System.out.print(response);
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * 아이디 / 비번 찾기 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/login/find.do")
	public String find(@ModelAttribute("vo") UserVO vo, HttpServletRequest request) throws Exception {
		return "fr/login/find";
	}
	
	/**
	 * 아이디 / 비번 찾기
	 * @param vo
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fr/login/registFind.do")
	public void regist(@ModelAttribute("vo") UserVO vo, HttpServletRequest request , HttpServletResponse response) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		String queryName = "" ; 
		
		if("findId".equals(SsStringUtil.normalizeNull(vo.getPageType()))) queryName = "loginDAO.getFindId" ;
		else if("findPw".equals(SsStringUtil.normalizeNull(vo.getPageType()))) queryName = "loginDAO.getFindPw" ;
		
		if(!"changePw".equals(SsStringUtil.normalizeNull(vo.getPageType()))) {
			UserVO userInfo = loginService.findUserInfo(vo , queryName) ;
			returnMap.put("userInfo", userInfo) ; 
		}else {
			int returnValue = loginService.registMemberPassChange(vo) ;
			String returnFlag = "" ; 
			if(returnValue > 0) returnFlag = "success" ;
			else returnFlag = "fail" ;
			returnMap.put("returnFlag", returnFlag) ;
		}
		
		returnMap.put("pageType", vo.getPageType()) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
}
