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
		session.invalidate();  
		
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
		
		UserVO tempvo1 = new UserVO();     
		tempvo1.setEmp_id(SsStringUtil.normalizeNull(vo.getEmp_id()));   	
		
		UserVO userInfo = loginService.selectFrUserInfo(vo) ;				
		int checkCnt1 = 0 ;
		int checkCnt2 = 0 ; 			
		int returnFlag = 0 ;	
		
		//비밀번호체계 정규식 체크로직 validationPass  
		//if시작 3 		
		if(SsStringUtil.validationPass(vo.getPass()) == false ) {  //비밀번호체계 정규식 아닌경우 (false)  		   	
		//if(SsStringUtil.validationPass(vo.getPass()) == false && !vo.getEmp_id().equals(vo.getPass()) ) {  //아이디와 동일패스워드 로그인 가능 (아이디와 동일패스워드 금지)   		

			vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
			
			checkCnt1 = commonDao.selectOneInt(vo,"memberDAO.getPassPolicy1Cnt") ; //아이디 존재유무 체크
			checkCnt2 = commonDao.selectOneInt(vo,"memberDAO.getPassPolicy2Cnt") ; //아이디/비번 체크 				
			
			if(checkCnt1 > 0 && checkCnt2 > 0){ //비밀번호맞으나 비밀번호 체계가 아님  
				returnMap.put("returnFlag" , "600") ;  /**	비밀번호 체계 : 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 변경해주세요.	*/
				returnFlag = 0 ;
			} else if(checkCnt1 > 0 && checkCnt2 == 0){ //비밀번호틀림   
				returnMap.put("returnFlag" , "650") ;  /**	비밀번호를 확인해 주세요. 비밀번호 체계 : 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 변경해주세요.	*/			
				returnFlag = 0 ;					
				commonDao.update(vo, "memberDAO.updatePassLoginfCnt"); //비밀번호 오류횟수 저장
				// 
				tempvo1 = (UserVO)commonDao.selectOne(vo, "memberDAO.getPassPolicy_LoginfCnt");
				vo.setLogin_f_cnt(tempvo1.getLogin_f_cnt());   
				returnMap.put("login_f_cnt" , vo.getLogin_f_cnt()) ; 
				//				
			} else {			 	
				returnMap.put("returnFlag" , "001") ;  /**	아이디를 확인해 주세요.	*/ 
				returnFlag = 0 ;						
			}												
			
		} else {  //비밀번호체계 정규식 맞는경우 (true)   		  
			
			vo.setPass(SsStringUtil.encryptSHA256(vo.getPass()));
			
			checkCnt1 = commonDao.selectOneInt(vo,"memberDAO.getPassPolicy1Cnt") ; //아이디 존재유무 체크
			checkCnt2 = commonDao.selectOneInt(vo,"memberDAO.getPassPolicy2Cnt") ; //아이디/비번 체크 						
			
			if(checkCnt1 > 0 && checkCnt2 > 0){ //정상처리 
				returnMap.put("returnFlag" , "000");   /**	정상 처리	*/
				returnFlag = 1 ;
			} else if(checkCnt1 > 0 && checkCnt2 == 0){ //비밀번호틀림   
				returnMap.put("returnFlag" , "700") ;  /**	비밀번호를 확인해 주세요.	*/			
				returnFlag = 0 ;	
				commonDao.update(vo, "memberDAO.updatePassLoginfCnt"); //비밀번호 오류횟수 저장 
				// 
				tempvo1 = (UserVO)commonDao.selectOne(vo, "memberDAO.getPassPolicy_LoginfCnt");
				vo.setLogin_f_cnt(tempvo1.getLogin_f_cnt());   
				returnMap.put("login_f_cnt" , vo.getLogin_f_cnt()) ;  
				//	
			} else {			 	
				returnMap.put("returnFlag" , "001") ;  /**	아이디를 확인해 주세요.	*/ 
				returnFlag = 0 ;													
			}						
		}
		//if끝 3			
			
		if(checkCnt1 > 0){   				
			//고객사 비밀번호 정책 로그인LOCK여부(Y)인경우 로그인제한 체크  (lock해제(N)시 로그인가능) 
			tempvo1 = (UserVO)commonDao.selectOne(vo, "memberDAO.getPassPolicy_LockYn");
			vo.setLock_yn(tempvo1.getLock_yn());   
			if ("Y".equals(SsStringUtil.normalizeNull(vo.getLock_yn()))) {
				returnMap.put("returnFlag" , "740") ;  /**	로그인LOCK여부(Y)인경우 로그인제한		*/
				returnFlag = 0 ;	
			}  							
			//고객사 비밀번호 정책 (C001 정책일수) 초과(Y) 체크
			tempvo1 = (UserVO)commonDao.selectOne(vo, "memberDAO.getPassPolicy1");
			vo.setPass_policy1(tempvo1.getPass_policy1()); 
			vo.setPolicy1_val(tempvo1.getPolicy1_val()); 
			if ("Y".equals(SsStringUtil.normalizeNull(vo.getPass_policy1()))) {
				returnMap.put("policy1_val" , vo.getPolicy1_val()) ; 
				returnMap.put("returnFlag" , "710") ;  /**	비밀번호 정책일수 초과 	*/	
				returnFlag = 0 ;								
			}  				
			//고객사 비밀번호 정책 (C002 오류횟수제한) 로그인시 비밀번호 오류횟수제한(Y) 체크
			tempvo1 = (UserVO)commonDao.selectOne(vo, "memberDAO.getPassPolicy2");
			vo.setPass_policy2(tempvo1.getPass_policy2()); 
			vo.setPolicy2_val(tempvo1.getPolicy2_val()); 
			returnMap.put("policy2_val" , vo.getPolicy2_val()) ; 
			if ("Y".equals(SsStringUtil.normalizeNull(vo.getPass_policy2()))) {
				returnMap.put("returnFlag" , "720") ;  /**	비밀번호 오류횟수제한 		*/	
				returnFlag = 0 ;								
			}  				
			//고객사 비밀번호 정책 (C003 동일비번체크제한) 동일 비밀번호 체크제한(Y) 체크
			int checkCnt3 = commonDao.selectOneInt(vo, "memberDAO.getPassPolicy3Cnt"); 
			if (checkCnt3 > 0){
				tempvo1 = (UserVO)commonDao.selectOne(vo, "memberDAO.getPassPolicy3");
				vo.setPass_policy3(tempvo1.getPass_policy3()); 
				vo.setPolicy3_val(tempvo1.getPolicy3_val()); 
				if ("Y".equals(SsStringUtil.normalizeNull(vo.getPass_policy3()))) {
					returnMap.put("policy3_val" , vo.getPolicy3_val()) ; 
					returnMap.put("returnFlag" , "730") ;  /**	동일 비밀번호 체크제한 	*/	 
					returnFlag = 0 ;									
				}  				
			} 				
		}				
		
		//if시작 4
		if(checkCnt1 > 0 && checkCnt2 > 0){ //아이디와 비번이 일치하는 경우 (정상처리 이거나 비밀번호체계가 아니거나)  		
		
			if(userInfo != null){
				
				// 사용자의 crm_code를 이용하여 해당 병원의 운영상태코드가 C003,C004,C005에 해당하는지 확인한다.
				if (!userInfo.getPass().equals(vo.getPass())){
					/**	패스워드 틀림	*/
					returnMap.put("returnFlag" , "003") ;
				} else if (loginService.checkOPDealCode(userInfo.getErp_code())){
					/**	해당병원 사용가능 상태가 아님	*/
					returnMap.put("returnFlag" , "007");
				} else if("C001".equals(SsStringUtil.normalizeNull(userInfo.getUse_type())) ){
					/**	정상 처리	*/
					if(checkCnt1 > 0 && checkCnt2 > 0 && returnFlag == 1){ //정상처리   						
						HttpSession session = request.getSession() ; 
						session.setAttribute("frUserInfo", userInfo);
						returnMap.put("returnFlag" , "000") ;
						vo.setWeight("U");
						//commonDao.insert(vo, "loginDAO.insertComeUser");
						commonDao.update(vo, "memberDAO.updatePassLoginfCnt_Reset"); //로그인 성공시 비밀번호 오류횟수 초기화	 2020.09.22. 추가  	
					}					
				} else if("C006".equals(SsStringUtil.normalizeNull(userInfo.getUse_type())) ) {
					/**	약관미동의	*/
					HttpSession session = request.getSession() ; 
					session.setAttribute("tempUserInfo", userInfo);
					returnMap.put("returnFlag" , "006") ;
					commonDao.update(vo, "memberDAO.updatePassLoginfCnt_Reset"); //로그인 성공시 비밀번호 오류횟수 초기화	 2020.09.22. 추가  	
					
				}else if("C004".equals(SsStringUtil.normalizeNull(userInfo.getUse_type())) ) {
					/**	승인대기**/
					returnMap.put("returnFlag" , "004");
					 
				}else {
					/**	사용할수 없는 아이디 입니다.	*/
					returnMap.put("returnFlag" , "002") ;
				}				
			//}else{
			//	returnMap.put("returnFlag" , "001") ; 				/**	아이디 혹은 비밀번호를 확인해 주세요.	*/  
			}
			
		}
		//if끝 4
		
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
			
			if(returnValue == -600) {
				returnMap.put("returnFlag" , "600") ; 		/**	비밀번호 체계 : 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요.	*/ 					
			}else if(returnValue > 0){
				returnMap.put("returnFlag" , "success") ;		/**	정상 처리	*/
			}else{
				returnMap.put("returnFlag" , "fail") ; 		/**	일치 하는 정보가 없습니다.	*/  
			}
		}
		
		returnMap.put("pageType", vo.getPageType()) ;
		CommonExecute.returnJson(response, returnMap);
			
	}
}
