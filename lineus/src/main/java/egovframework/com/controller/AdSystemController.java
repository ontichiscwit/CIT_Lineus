package egovframework.com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.model.ProgVO;
import egovframework.com.comm.model.RoleMenuVO;
import egovframework.com.comm.model.RoleProgVO;
import egovframework.com.comm.model.RoleVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.comm.model.CommonCodeVO;
import egovframework.com.model.AsVO;
import egovframework.com.model.StatVO;
import egovframework.com.comm.model.PartsVO;

/**
 * @Class Name : AdSystemController.java
 *
 * @author 박승모
 * @since 2018-02-13
 * @version 1.0
 * @see
 */

@Controller
public class AdSystemController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdSystemController.class) ;
	
	@Autowired CommonDao commonDAO;
	
	/**
	 * AS승인 관리 - 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/approvalMgt.do")
	public String approvalMgt(HttpServletRequest request) throws Exception {
		return "ad/system/approvalMgt";
	}
	
	
	/**
	 * 프로그램 관리 - 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/progMgt.do")
	public String progMgt(HttpServletRequest request) throws Exception {
		return "ad/system/progMgt";
	}
	
	/**
	 * 프로그램 관리 - 등록된 리스트 보여주기
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/getProgList.do")
	public void getProgList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(null, "systemDAO.getProgListAll"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 프로그램 관리 - 내용 수정/삭제/생성
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/ad/system/progProc.do")
	public void progModify(@ModelAttribute("progVo") ProgVO progVo, @RequestParam("type") String type, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null  ? (UserVO) session.getAttribute("adUserInfo") : null ;
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		
		if ("update".equals(type)){
			
			progVo.setUpd_id(adUserInfo.getEmp_no());
			int cnt = commonDAO.update(progVo, "systemDAO.updateProgMgtByPk");
			
			if (cnt > 0){
				returnMap.put("resultCode", "000");
				returnMap.put("resultMsg", cnt + "건 수정되었습니다.");
			}else{
				returnMap.put("resultCode", "999");
				returnMap.put("resultMsg", "수정에 실패했습니다.");
			}
		}else if ("insert".equals(type)){
			
			progVo.setReg_id(adUserInfo.getEmp_no());
			int cnt = commonDAO.insert(progVo, "systemDAO.insertProgMgt");
			
			if (cnt > 0){
				returnMap.put("resultCode", "000");
				returnMap.put("resultMsg", "등록 되었습니다.");
			}else{
				returnMap.put("resultCode", "999");
				returnMap.put("resultMsg", "등록에 실패했습니다.");
			}
		}else if ("delete".equals(type)){
			int cnt = commonDAO.insert(progVo, "systemDAO.deleteProgMgtByPk");
			
			if (cnt > 0){
				returnMap.put("resultCode", "000");
				returnMap.put("resultMsg", "삭제 되었습니다.");
			}else{
				returnMap.put("resultCode", "999");
				returnMap.put("resultMsg", "삭제에 실패했습니다.");
			}
		}else{
			returnMap.put("resultCode", "999");
			returnMap.put("resultMsg", "type 지정이 안되어 처리할 수 없습니다.");
		}
		
		returnMap.put("vo", progVo);
		returnMap.put("resultType", type);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 메뉴 관리 - 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/menuMgt.do")
	public String menuMgt(HttpServletRequest request) throws Exception {
		return "ad/system/menuMgt";
	}
	
	/**
	 * 메뉴 관리 - 등록된 리스트 보여주기
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/getMenuList.do")
	public void getMenuList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(null, "systemDAO.getMenuListAll"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 권한 관리 - 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/roleMgt.do")
	public String roleMgt(HttpServletRequest request) throws Exception {
		return "ad/system/roleMgt";
	}
	
	/**
	 * 권한 관리 - 등록된 리스트 보여주기
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/getRoleList.do")
	public void getRoleList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(null, "systemDAO.getRoleListAll"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 권한 관리 - 내용 수정/삭제/생성
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/ad/system/roleProc.do")
	public void roleModify(@ModelAttribute("roleVo") RoleVO roleVo, @RequestParam("type") String type, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null  ? (UserVO) session.getAttribute("adUserInfo") : null ;
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		
		if ("update".equals(type)){
			
			int cnt = commonDAO.update(roleVo, "systemDAO.updateRoleMgtByPk");
			
			if (cnt > 0){
				returnMap.put("resultCode", "000");
				returnMap.put("resultMsg", cnt + "건 수정되었습니다.");
			}else{
				returnMap.put("resultCode", "999");
				returnMap.put("resultMsg", "수정에 실패했습니다.");
			}
		}else if ("insert".equals(type)){
			
			int cnt = commonDAO.insert(roleVo, "systemDAO.insertRoleMgt");
			
			if (cnt > 0){
				returnMap.put("resultCode", "000");
				returnMap.put("resultMsg", "등록 되었습니다.");
			}else{
				returnMap.put("resultCode", "999");
				returnMap.put("resultMsg", "등록에 실패했습니다.");
			}
		}else if ("delete".equals(type)){
			int cnt = commonDAO.insert(roleVo, "systemDAO.deleteRoleMgtByPk");
			
			commonDAO.delete(null, "systemDAO.deleteRoleMenuByNONRole");
			commonDAO.delete(null, "systemDAO.deleteRoleProgByNONRole");
			commonDAO.delete(null, "systemDAO.deleteRoleUserByNONRole");
			
			if (cnt > 0){
				returnMap.put("resultCode", "000");
				returnMap.put("resultMsg", "삭제 되었습니다.");
			}else{
				returnMap.put("resultCode", "999");
				returnMap.put("resultMsg", "삭제에 실패했습니다.");
			}
		}else{
			returnMap.put("resultCode", "999");
			returnMap.put("resultMsg", "type 지정이 안되어 처리할 수 없습니다.");
		}
		
		returnMap.put("vo", roleVo);
		returnMap.put("resultType", type);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 권한 관리 - 맵핑된 메뉴 리스트 및 등록 가능 메뉴리스트 조회
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ad/system/getManageRoleList.do")
	public void getManageRoleList(@ModelAttribute("roleVo") RoleVO roleVo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		
		// 등록된 메뉴
		List<MenuVO> registeredMenuList = (List<MenuVO>) commonDAO.list(roleVo, "systemDAO.getMenuListByRoleCode");
		
		// 전체 메뉴
		List<MenuVO> allMenuList = (List<MenuVO>) commonDAO.list(roleVo, "systemDAO.getMenuListAll2");
		
		// 등록가능 메뉴 
		List<MenuVO> registrableMenuList = new ArrayList<MenuVO>();
		for (MenuVO vo : allMenuList){
			if (hasMenu(registeredMenuList,vo.getMenu_code())) continue;
			
			registrableMenuList.add(vo);
		}
		
		// 등록된 프로그램
		List<ProgVO> registeredProgList= (List<ProgVO>) commonDAO.list(roleVo, "systemDAO.getProgListByRoleCode");
		// 등록가능 프로그램
		List<ProgVO> registrableProgList= (List<ProgVO>) commonDAO.list(roleVo, "systemDAO.getProgListByNotInRoleCode");
		
		// 등록된 사용자
		List<UserVO> registeredUserList= (List<UserVO>) commonDAO.list(roleVo, "systemDAO.getUserListByRoleCode");
		// 등록가능 사용자
		List<UserVO> registrableUserList= (List<UserVO>) commonDAO.list(roleVo, "systemDAO.getUserListByNotInRoleCode");
		
		
		returnMap.put("registeredMenuList", registeredMenuList);
		returnMap.put("registrableMenuList", registrableMenuList);
		returnMap.put("registeredProgList", registeredProgList);
		returnMap.put("registrableProgList", registrableProgList);
		returnMap.put("registeredUserList", registeredUserList);
		returnMap.put("registrableUserList", registrableUserList);
		returnMap.put("vo", roleVo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	private boolean hasMenu(List<MenuVO> list, String menuCode){
		
		boolean reValue = false;
		
		if (menuCode == null) return reValue;
		
		for(MenuVO vo : list){
			if (menuCode.equals(vo.getMenu_code())) return true;
		}
		
		return reValue;
		
	}
	
	/**
	 * 권한 관리 - 특정권한에 메뉴 멥핑 시키기
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ad/system/setManageRoleList.do")
	public void setManageRoleList(@RequestParam("roleCode") String roleCode, @RequestParam("menuCodeList") String menuCodeStr, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null  ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		
		System.out.println(roleCode);
		System.out.println(menuCodeStr);
		
		String[] menuCodeArr = menuCodeStr.split(",");
		String inQueryStr = "'" + StringUtils.join(menuCodeArr, "','") + "'";
		if (menuCodeStr == null || "".equals(menuCodeStr.trim())) inQueryStr = "'0000'"; 
		System.out.println(inQueryStr);
		HashMap<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("roleCode", roleCode);
		paramMap.put("inQueryStr", inQueryStr);
		paramMap.put("regId", adUserInfo.getEmp_no());
		
		List<MenuVO> delMenuList = null;
		// 삭제 대상 메뉴 코드를 구한다.
		delMenuList = (List<MenuVO>) commonDAO.list(paramMap, "systemDAO.getDeleteMenuList");
		
		System.out.println(delMenuList.size());
		
		// 메뉴에서 빼면서 롤 프로그램 맵핑에도 있으면 같이 뺀다.
		RoleProgVO param = new RoleProgVO();
		param.setRole_code(roleCode);
		
		RoleMenuVO param2 = new RoleMenuVO();
		param2.setRole_code(roleCode);

		for (MenuVO delVo : delMenuList){
			param.setProg_code(delVo.getMenu_url());
			commonDAO.delete(param, "systemDAO.deleteRoleProgByPk");
			
			param2.setMenu_code(delVo.getMenu_code());
			commonDAO.delete(param2, "systemDAO.deleteRoleMenuByPk");
		}
		
		// 롤 메뉴 맵핑에 추가
		int resultCnt = commonDAO.insert(paramMap, "systemDAO.insertRoleMenuBySelect");
		
		returnMap.put("resultCode", "000");
		returnMap.put("resultMsg", resultCnt + "건이 정상 처리 되었습니다.");
		returnMap.put("roleCode", roleCode);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 권한 관리 - 특정권한에 프로그램 멥핑 시키기
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ad/system/setManageRoleProgList.do")
	public void setManageRoleProgList(@RequestParam("roleCode") String roleCode, @RequestParam("progCodeList") String progCodeStr, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null  ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		
		System.out.println("roleCode : " + roleCode);
		System.out.println("progCodeStr : " + progCodeStr);
		
		String[] progCodeArr = progCodeStr.split(",");
		String inQueryStr = "'" + StringUtils.join(progCodeArr, "','") + "'";

		System.out.println(inQueryStr);
		
		HashMap<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("roleCode", roleCode);
		paramMap.put("inQueryStr", inQueryStr);
		paramMap.put("regId", adUserInfo.getEmp_no());
		
		// 기존 삭제
		commonDAO.delete(paramMap, "systemDAO.deleteRoleProgByRoleCode");
		// 신규 등록
		commonDAO.insert(paramMap, "systemDAO.insertRoleProgBySelect");
		
		returnMap.put("resultCode", "000");
		returnMap.put("resultMsg", "정상 처리 되었습니다.");
		returnMap.put("roleCode", roleCode);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 권한 관리 - 특정권한에 사용자 멥핑 시키기
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ad/system/setManageRoleUserList.do")
	public void setManageRoleUserList(@RequestParam("roleCode") String roleCode, @RequestParam("userCodeList") String userCodeStr, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null  ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		HashMap<String,Object> returnMap = new HashMap<String, Object>();
		
		System.out.println("roleCode : " + roleCode);
		System.out.println("userCodeStr : " + userCodeStr);
		
		String[] userCodeArr = userCodeStr.split(",");
		String inQueryStr = "'" + StringUtils.join(userCodeArr, "','") + "'";
		
		if (userCodeStr == null || "".equals(userCodeStr.trim())) inQueryStr = "'isnotid'";
		System.out.println(inQueryStr);
		
		HashMap<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("roleCode", roleCode);
		paramMap.put("inQueryStr", inQueryStr);
		paramMap.put("regId", adUserInfo.getEmp_no());
		
		// 기존 삭제
		commonDAO.delete(paramMap, "systemDAO.deleteRoleUserByRoleCode");
		// 신규 등록
		commonDAO.insert(paramMap, "systemDAO.insertRoleUserBySelect");
		
		returnMap.put("resultCode", "000");
		returnMap.put("resultMsg", "정상 처리 되었습니다.");
		returnMap.put("roleCode", roleCode);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 사용자 권한 맵핑 - 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/roleUserMgt.do")
	public String roleUserMgt(HttpServletRequest request) throws Exception {
		return "ad/system/roleUserMgt";
	}
	
	
	
	/**
	 * 거래처조회 - A/S승인 프로세스(YES)
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/approval/getCustList.do")
	public void getCustList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		
		/**	parameter 설정	*/
		int totalCount = commonDAO.selectOneInt(vo , "systemDAO.getCustListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("custList"));
			returnMap.put("resultList", commonDAO.list(vo , "systemDAO.getCustList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * A/S 승인 권한등록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/approval/proApproval.do")
	public void proApproval(@ModelAttribute("vo") CommonCodeVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getGroup_addCnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getGroup_addCnt()) ; i++) {
				CommonCodeVO tempVO = new CommonCodeVO() ;
				
				tempVO.setCust_code(vo.getCust_code());	
				tempVO.setGubun("AS");
				tempVO.setP_code(SsStringUtil.normalizeNull(request.getParameter("as_type" + (i+1))));
				tempVO.setCode(SsStringUtil.normalizeNull(request.getParameter("code_type" + (i+1))));
				tempVO.setReg_id(adUserInfo.getEmp_no());
				
				int vali = 0;
				vali = commonDAO.selectOneInt(tempVO, "systemDAO.valiApproval");
				if(vali == 0) {
					returnValue = commonDAO.update(tempVO, "systemDAO.proApproval");
				}
			}
		}
		
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * A/S 승인 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/approval/getApprovalList.do")
	public void getApprovalList(@ModelAttribute("vo") CommonCodeVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		/**	parameter 설정	*/
		int totalCount = commonDAO.selectOneInt(vo , "systemDAO.getApprovalListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("getApprovalList"));
			returnMap.put("resultList", commonDAO.list(vo , "systemDAO.getApprovalList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	/**
	 * A/S 승인 정보 삭제
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/approval/delApproval.do")
	public void delApproval(@ModelAttribute("vo") CommonCodeVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int returnValue = 0;
		returnValue = commonDAO.delete(vo , "systemDAO.delApproval") ;
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");
		
		CommonExecute.returnJson(response, returnMap);
			
	}
	
	
	/**
	 * 통계분석관리 - 화면
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/stateMgt.do")
	public String stateMgt(HttpServletRequest request) throws Exception {
		return "ad/system/stateMgt";
	}
	
	
	
	/**
	 * 통계분석 관리 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/getStateCrList.do")
	public void getStateList(@ModelAttribute("vo") PartsVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int totalCount = commonDAO.selectOneInt(vo , "systemDAO.getStateCrListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("getApprovalList"));
			returnMap.put("resultList", commonDAO.list(vo , "systemDAO.getStateCrList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/ad/system/updateStateCr.do")
	public void updateStateCr(@ModelAttribute("vo") PartsVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		
		int returnValue = 0;
		returnValue = commonDAO.update(vo , "systemDAO.updateStateCr") ;
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/ad/system/getBiUrl.do")
	public void getBiUrl(@ModelAttribute("vo") PartsVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		returnMap.put("returnVo", commonDAO.selectOne(vo , "systemDAO.getBIUrl"));
		
		CommonExecute.returnJson(response, returnMap);
	}
		
	/**
	 * 시스템세팅-프로그램관리 - UI
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/programMng.do")
	public String programMng(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		return "ad/system/listProgramMng";
	}
	
	
	/**
	 * 프로그램관리(유지보수) - 검색
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/getProgramList.do")
	public void getAsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		int totalCount = commonDAO.selectOneInt(vo , "systemDAO.getProgramListCnt") ;
		vo.setPaging(totalCount);
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("getProgramListPanging"));
			returnMap.put("resultList", commonDAO.list(vo , "systemDAO.getProgramList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 프로그램관리(유지보수) - 등록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/system/saveProgramMng.do")
	public void saveProgramMng(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ; 

		int returnValue = 0;
		if ("insert".equals(pageType)){
			int checkExist = commonDAO.selectOneInt(vo , "systemDAO.checkExistProgramMng");
			if(checkExist > 0){
				returnMap.put("returnCode", "003");
			}else {
				returnValue = commonDAO.insert(vo, "systemDAO.insertProgramMng");
				if (returnValue > 0){
					returnMap.put("returnCode", "000");
				}else{
					returnMap.put("returnCode", "001");
					
				}
			}
		} else {
			returnValue = commonDAO.update(vo, "systemDAO.updateProgramMng");
			if (returnValue > 0){
				returnMap.put("returnCode", "000");
			}else{
				returnMap.put("returnCode", "001");
				
			}
		}
		CommonExecute.returnJson(response, returnMap);
	}
}
