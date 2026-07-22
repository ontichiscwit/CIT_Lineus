package egovframework.com.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.BoardAswVO;
import egovframework.com.model.CustVO;
import egovframework.com.model.MaintenanceAddVO;
import egovframework.com.model.SystemHistVO;
import egovframework.com.model.VirtualContactVO;
import egovframework.com.service.CustService;
import egovframework.com.service.LoginService;

/**
 * @Class Name : AdCustController.java @ @ 수정일 수정자 수정내용 @ --------- ---------
 *        ------------------------------- @ 2017.05.25 정철구 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2017. 09.07
 * @version 1.0
 * @see Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class AdCustController {

	private static final Logger logger = LoggerFactory.getLogger(AdCustController.class);

	@Autowired
	LoginService loginService;
	@Autowired
	CustService custService;
	@Autowired
	CommonFileService commonFileService ;

	@Autowired
	CommonDao commonDAO;

	/**
	 * 거래처 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/list.do")
	public String list(@ModelAttribute("vo") CustVO vo, HttpServletRequest request) throws Exception {

		return "ad/cust/list";
	}

	/**
	 * 거래처 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getCustList.do")
	public void getCustList(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();


		vo.setPageType("1");
		custService.getCustList(vo);
		int totalCnt = 0;

		if (vo.getOUTCURSOR() != null && vo.getOUTCURSOR().size() > 0) {
			totalCnt = Integer.parseInt(SsStringUtil.normalize(vo.getOUTCURSOR().get(0).getCnt(), "0"));
		}

		vo.setPaging(totalCnt);
		if (totalCnt > 0) {
			vo.setPageType("2");
			custService.getCustList(vo);
			vo.setJson_paging(vo.getJsonPaging("custList"));
			returnMap.put("resultList", vo.getOUTCURSOR());
			returnMap.put("vo", vo);
		}

		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * 거래처 관리 - ERP 코드 조회
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getCustMaster.do")
	public void getCustMaster(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		int totalCount = custService.getSelectInt(vo,"custDAO.getLinkCustInfoCnt" );
		vo.setPaging(totalCount);
		
		if(totalCount > 0 ) {
			vo.setJson_paging(vo.getJsonPaging("custList"));
			returnMap.put("resultList", custService.getLinkCustInfo(vo));
			returnMap.put("vo", vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 거래처 관리 - ERP 코드 조회(selectOne)
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getCustMasterOne.do")
	public void getCustMasterOne(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("vo", custService.getSelectOne(vo,"custDAO.getLinkCustInfo_one"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	

	/**
	 * 거래처 관리 CRM코드 중복체크
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/crmCodeChk.do")
	public void crmCodeChk(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		int chkCnt = custService.crmCodeChk(vo);
		returnMap.put("chkCnt", chkCnt);
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - ERP 코드 조회
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getCustMaster_old.do")
	public void getCustMaster_old(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		custService.getLinkCustInfo(vo);
		returnMap.put("resultList", vo.getOUTCURSOR());
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 관리정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getCustInfo.do")
	public void getCustInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getCustInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 프로젝트 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getProjectInfo.do")
	public void getProjectInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getProjectInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 프로젝트 등록 유무
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getProjectCnt.do")
	public void getProjectCnt(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		int cnt = custService.getProjectCnt(vo);
		returnMap.put("cnt", cnt);
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 운영정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getOperateInfo.do")
	public void getOperateInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getOperateInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	

	
	/**
	 * 거래처 관리 - 운영정보 상세 데이터 - 담당자 조회
	 * 담당자 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getOperateChargeInfo.do")
	public void getOperateChargeInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		int totalCount = custService.getSelectInt(vo , "custDAO.getChargeEmpCnt") ;
		vo.setPaging(totalCount);
		
		
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("chargeEmpList"));
			returnMap.put("resultList", custService.getList(vo , "custDAO.getChargeEmpList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
		
	}
	

	
	/**
	 * 거래처 관리 - 운영정보 상세 데이터 - 특정 담당자 상세조회
	 * 특정 담당자 상세조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getSelectOneChargeEmpInfo.do")
	public void getSelectOneChargeEmpInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) 
			throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultVO", custService.getSelectOne(vo , "custDAO.getSelectOneChargeInfo")) ;
	
		CommonExecute.returnJson(response, returnMap);
	}

	

	/**
	 * 거래처 관리 - 유지보수이력 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getMtacHistInfo.do")
	public void getMtacHistInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getMtacHistInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	

	/**
	 * 거래처 관리 - 관리문서 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getDocInfo.do")
	public void getDocInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		returnMap.put("resultVO",custService.getDocInfo(vo,"custDAO.getDocInfo") );
		CommonExecute.returnJson(response, returnMap);
		
	}
	
	
	/**
	 * 문서(파일) 삭제 
	 * @param vo
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/docDel.do")
	public void docDel(@ModelAttribute("vo") CustVO vo,  ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		String returnCode = "" ; 
		int returnValue = 0;
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		returnValue = custService.deleteDoc(vo,request);
		if(returnValue == -100) returnCode = "100" ;				/**	선택된 회원정보가 없습니다.		*/ 
		else if(returnValue == -200) returnCode = "200" ;		/**	데이터를 확인해 주세요.			*/ 
		else if(returnValue == -300) returnCode = "300" ;		/**	대표계정이 이미 있습니다.		*/ 
		else if(returnValue == -400) returnCode = "400" ;		/**	중복된 아이디가 존재합니다.		*/ 
		else if(returnValue > 0) returnCode = "000" ;				/**	정상처리 되었습니다.				*/ 
	    
	    returnMap.put("returnCode", returnCode) ; 
	    CommonExecute.returnJson(response, returnMap);
		
	}
	
	
	

	/**
	 * 거래처 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/proc.do")
	public void proc(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();

		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;

		if (!"".equals(SsStringUtil.normalizeNull(vo.getFoundation_dt())))
			vo.setFoundation_dt(vo.getFoundation_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getContract_dt())))
			vo.setContract_dt(vo.getContract_dt().replaceAll("/", ""));
		/*20180223 추가*/
		if (!"".equals(SsStringUtil.normalizeNull(vo.getMaintenance_raise_dt())))
			vo.setMaintenance_raise_dt(vo.getMaintenance_raise_dt().replaceAll("/", ""));
		
		vo.setReg_id(adUserInfo.getEmp_no());

		custService.updateInfo(vo, request);

		if (!"-1".equals(SsStringUtil.normalize(vo.getV_return_seq(), "-1")))
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		returnMap.put("seq", SsStringUtil.normalize(vo.getV_return_seq(), "-1"));
		returnMap.put("message", SsStringUtil.normalizeNull(vo.getV_message()));

		CommonExecute.returnJson(response, returnMap);
		
	}

	/**
	 * 거래처 관리 상세 - 관리정보
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form.do")
	public String form(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {

		
		if (vo.getCrm_code() == null || ("".equals(vo.getCrm_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		
		return "ad/cust/form";
	}

	/**
	 * 거래처 관리 상세 - 프로젝트 정보
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form2.do")
	public String form2(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {
		if (vo.getCrm_code() == null || ("".equals(vo.getCrm_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/cust/form2";
	}

	/**
	 * 거래처 관리 상세 - 운영정보
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form3.do")
	public String form3(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {
		if (vo.getCrm_code() == null || ("".equals(vo.getCrm_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/cust/form3";
	}

	/**
	 * 거래처 관리 상세 - 설치이력
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form4.do")
	public String form4(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {
		if (vo.getCrm_code() == null || ("".equals(vo.getCrm_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/cust/form4";
	}

	/**
	 * 거래처 관리 상세 - 유지보수이력
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form5.do")
	public String form5(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {
		if (vo.getCrm_code() == null || ("".equals(vo.getCrm_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/cust/form5_new";
	}
	
	/**
	 * 거래처 관리 상세 - 관리문서
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form6.do")
	public String form6(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {
		if (vo.getCrm_code() == null || ("".equals(vo.getCrm_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/cust/form6";
	}
	
	
	
	/**
	 * 거래처 관리 상세 - 관리문서
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form7.do")
	public String form7(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {
		if (vo.getCrm_code() == null || ("".equals(vo.getCrm_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/cust/form7";
	}
	
	
	
	/**
	 * 거래처 관리 - 프로젝트 정보 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/proc2.do")
	public void proc2(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();

		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;

		if (!"".equals(SsStringUtil.normalizeNull(vo.getOpen_dt())))
			vo.setOpen_dt(vo.getOpen_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTerm_start_dt())))
			vo.setTerm_start_dt(vo.getTerm_start_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTerm_end_dt())))
			vo.setTerm_end_dt(vo.getTerm_end_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTest_dt())))
			vo.setTest_dt(vo.getTest_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getMtac_contract_dt())))
			vo.setMtac_contract_dt(vo.getMtac_contract_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getBuss_open_dt())))
			vo.setBuss_open_dt(vo.getBuss_open_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getApproval_dt())))
			vo.setApproval_dt(vo.getApproval_dt().replaceAll("/", ""));

		
		
		vo.setReg_id(adUserInfo.getEmp_no());

		custService.updateProject(vo, request);

		if (!"-1".equals(SsStringUtil.normalize(vo.getV_return_seq(), "-1")))
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");


		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 운영정보 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/proc3.do")
	public void proc3(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();

		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;

		if (!"".equals(SsStringUtil.normalizeNull(vo.getMtac_contract_dt())))
			vo.setMtac_contract_dt(vo.getMtac_contract_dt().replaceAll("/", ""));
		                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		if (!"".equals(SsStringUtil.normalizeNull(vo.getCancel_dt())))
			vo.setCancel_dt(vo.getCancel_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getCh_cancel_dt())))
			vo.setCh_cancel_dt(vo.getCh_cancel_dt().replaceAll("/", ""));
		

		vo.setReg_id(adUserInfo.getEmp_no());

		custService.updateOperate(vo, request);

		if (!"-1".equals(SsStringUtil.normalize(vo.getV_return_seq(), "-1")))
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * 거래처 관리 - 문서관리 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/proc6.do")
	public String proc6(@ModelAttribute("vo") CustVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
        UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		
        List<FileVO> fileList = null ;
		vo.setReg_id(adUserInfo.getEmp_no());
		fileList = commonFileService.uploadFormFile(multiRequest, "doc") ;
		
		
		int returnValue = custService.updateDoc(vo, request, fileList);
		//String returnCode="";
		 String script = "";
		 
		 /*//System.out.print(model);
		 //return CommonExecute.execute(model, script);
		 	if(returnValue == -100) returnCode = "100" ;				*//**	선택된 회원정보가 없습니다.		*//* 
			else if(returnValue == -200) returnCode = "200" ;		*//**	데이터를 확인해 주세요.			*//* 
			else if(returnValue == -300) returnCode = "300" ;		*//**	대표계정이 이미 있습니다.		*//* 
			else if(returnValue == -400) returnCode = "400" ;		*//**	중복된 아이디가 존재합니다.		*//* 
			else if(returnValue > 0) returnCode = "000" ;				*//**	정상처리 되었습니다.				*//* 
		*/    
		 	if(returnValue > 0) script = "parent.procReturn('success');" ;
			else script = "parent.procReturn('fail');" ;
			
			System.out.print(model);
			
			
			return CommonExecute.execute(model, script);
	}
	
	
	
		
	

	/**
	 * 거래처 관리 - 설치이력 거래처 목록 가져오기
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getErpList.do")
	public void getErpList(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		custService.getErpList(vo);
		returnMap.put("resultList", vo.getOUTCURSOR());

		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	

	
	/**
	 * 거래처 관리 - 설치이력 거래처 목록 가져오기
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getSolutionHist.do")
	public void getSolutionHist(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList",custService.getList(vo ,"getSolutionHist"));

		CommonExecute.returnJson(response, returnMap);
	}

	
	/**
	 * 거래처 관리 - 설치 이력 대분류 가져오기
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getGroupCode.do")
	public void getGroupCode(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		custService.getGroupCodeList(vo);
		returnMap.put("resultList", vo.getOUTCURSOR());

		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 설치 이력 목록 가져오기
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getForm4List.do")
	public void getForm4List(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<CustVO> list = custService.getForm4List(vo);
		returnMap.put("resultList", list);

		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 실치이력 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/proc4.do")
	public void proc4(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();

		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		vo.setReg_id(adUserInfo.getEmp_no());

		int returnValue = custService.updateInstall(vo, request);

		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 거래처 관리 - 유지보수 이력
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/proc5.do")
	public void proc5(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();

		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		vo.setReg_id(adUserInfo.getEmp_no());

		int returnValue = custService.updateMtac(vo, request);

		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 거래처 관리 - 유지보수 이력
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/chkTreatNo.do")
	public void chkTreatNo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		int returnValue = commonDAO.selectOneInt(vo, "custDAO.chkTreatNo");

		if (returnValue > 0)
			returnMap.put("returnCode", "001");
		else
			returnMap.put("returnCode", "000");

		CommonExecute.returnJson(response, returnMap);
	}

	
	
	/**
	 * 거래처 관리 - 유지보수 이력 > 수금정보 DB Link
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getPayInfo.do")
	public void getPayInfo(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		if (!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start())))
			vo.setSearch_start(vo.getSearch_start().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end())))
			vo.setSearch_end(vo.getSearch_end().replaceAll("/", ""));
		returnMap.put("resultList", custService.getPayInfo(vo));
		
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 엑셀처리
	 * 
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/exl.do")
	public void exl(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		OutputStream fileOut = null;

		String isTab = SsStringUtil.normalize(vo.getIsTab(), "1").trim();

		String exl_title = "거래처 관리";

		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		vo.setPageType("exl");

		custService.getCustList(vo);
		List<CustVO> resultList = vo.getOUTCURSOR();

		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet(exl_title);

		HSSFRow row = null;
		HSSFCell cell = null;

		String[] title = { "No", "사업자소재지", "거래처명", "CRM코드", "거래처구분", "재단구분", "병원설립일", "계약일자", "병상BED", "거래상태", "해지일", "HIS기초버전", "HIS진료버전", "HIS원무버전", "HIS청구버전",
				"전문병원여부", "병상BED", "운영정보", "의사수", "간호사수", "간호등급", "신규/기존", "기존전산업체", "일평균내원자수", "평균내원자수", "외부수탁업체", "청구여부", "특이사항",
				"응급의료기관종류", "의약품정보업체", "카드밴사업체", "검진연동업체", "팍스연동업체",
				
				"서버구성", "서버제조사", "모델" ,"OS" ,"서버RAM","서비스네임","오라클버전","서버IP","서버아이디","서버비밀번호","DUR브로커IP","유지보수계약일자","PC","백신","서버유지보수업체",
				
				
				"거래처명", "CRM코드",
				"거래처구분", "신규/기존", "기존전산업체", "전문병원 여부", "PJT OCS/EMR ver", "담당PM", "사업장 소재지", "요양기관번호", "사업자번호", "의사수", "병상수", "투입기간1", "투입기간2", "전산오픈일",
				"최종검수일", "구성", "서버 제조사/모델", "OS", "서버 RAM", "PC", "오라클버전", "외부수탁업체", "기타설명", "특이사항" };

		String[] refColumn = { "rnum", "cust_address", "cust_kor_name", "crm_code", "cust_gubun_nm", "foundation_code_nm", "foundation_dt", "contract_dt",
				"bed_count",
				"deal_code_nm", "cancel_dt", "his_basic_code_nm", "his_treat_code_nm", "his_work_code_nm", "his_claim_code_nm", "specially_code_nm", "o_bed_count",
				"veterans_yn", "doctor_count", "nurse_count", "care_grade", "new_code_nm", "old_company_nm", "come_count", "average_count",
				"outside_cust_code_nm", "charge_yn", "detail_etc", "emergency_type_code_nm", "medicine_info_cust_code_nm", "card_van_cust_code_nm",
				"examination_cust_code_nm", "pasc_cust_code_nm", 
				"o_formation_code_nm"
				, "o_server_code_nm"
				,"o_model_code_nm"
				, "o_os_nm"
				,"o_ram_nm"
				,"o_sid_nm"
				,"o_oracle_version_nm"
				,"o_server_ip"
				,"o_server_id"
				,"o_server_pw",
				"o_dur_ip"
				,"o_mtac_contract_dt"
				,"o_pc"
				,"o_vc_nm"
				,"o_mtac_nm"
				,"p_cust_kor_name", "p_crm_code", "p_cust_gubun_nm", "p_new_code_nm", "p_old_company_nm", "p_specially_code", "version", "pm", "addr",
				"treat_no", "cust_no", "p_doctor_count", "p_bed_count", "term_start_dt", "term_end_dt", "open_dt", "test_dt", "formation_code_nm",
				"server_code_nm", "os_nm", "ram_nm", "pc", "oracle_version_nm", "p_outside_cust_code_nm", "p_basic_etc", "p_detail_etc" };

		// 셀 스타일 정의
		Font boldFont = workbook.createFont();
		boldFont.setBoldweight(Font.BOLDWEIGHT_BOLD);

		Font noFontH = workbook.createFont();
		noFontH.setColor(IndexedColors.RED.getIndex());
		noFontH.setBoldweight(Font.BOLDWEIGHT_BOLD);

		Font noFontB = workbook.createFont();
		noFontB.setColor(IndexedColors.RED.getIndex());

		CellStyle tStyleNo = workbook.createCellStyle();
		CellStyle bStyleNo = workbook.createCellStyle();

		CellStyle tStyleM = workbook.createCellStyle();
		CellStyle tStyleO = workbook.createCellStyle();
		CellStyle tStyleP = workbook.createCellStyle();

		CellStyle bStyleM = workbook.createCellStyle();
		CellStyle bStyleO = workbook.createCellStyle();
		CellStyle bStyleP = workbook.createCellStyle();

		tStyleM.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleM.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleM.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleM.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		tStyleM.setFont(boldFont);
		addBoardStyle(tStyleM, true);

		tStyleO.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleO.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleO.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleO.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
		tStyleO.setFont(boldFont);
		addBoardStyle(tStyleO, true);

		tStyleP.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleP.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleP.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleP.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
		tStyleP.setFont(boldFont);
		addBoardStyle(tStyleP, true);

		bStyleM.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		bStyleM.setFillPattern(CellStyle.SOLID_FOREGROUND);
		bStyleM.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		addBoardStyle(bStyleM, false);

		bStyleO.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		bStyleO.setFillPattern(CellStyle.SOLID_FOREGROUND);
		bStyleO.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
		addBoardStyle(bStyleO, false);

		bStyleP.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		bStyleP.setFillPattern(CellStyle.SOLID_FOREGROUND);
		bStyleP.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
		addBoardStyle(bStyleP, false);

		tStyleNo.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleNo.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleNo.setFont(noFontH);
		addBoardStyle(tStyleNo, true);

		bStyleNo.setAlignment(CellStyle.ALIGN_CENTER);
		bStyleNo.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		bStyleNo.setFont(noFontB);
		addBoardStyle(bStyleNo, false);

		int rowNum = 0;
		// 첫째 행 셋팅
		row = sheet.createRow(rowNum);
		rowNum++;

		sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 1, 8));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 9, 47));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 48, 73));

		// for(int i = 0 ; i < title.length ; i++){
		// cell = row.createCell(i);
		// addBoardStyle(cell.getCellStyle(),true);
		// }

		cell = row.createCell(0);
		cell.setCellValue("NO");
		cell.setCellStyle(tStyleNo);
		cell = row.createCell(1);
		cell.setCellValue("관리정보");
		cell.setCellStyle(tStyleM);
		cell = row.createCell(9);
		cell.setCellValue("운영정보");
		cell.setCellStyle(tStyleO);
		cell = row.createCell(48);
		cell.setCellValue("프로젝트정보");
		cell.setCellStyle(tStyleP);

		// 두째 행 셋팅
		row = sheet.createRow(rowNum);
		rowNum++;

		for (int i = 1; i < title.length; i++) {
			cell = row.createCell(i);
			cell.setCellValue(title[i]);

			if (i < 9)
				cell.setCellStyle(tStyleM);
			else if (i < 48)
				cell.setCellStyle(tStyleO);
			else
				cell.setCellStyle(tStyleP);
		}

		if (resultList != null && resultList.size() > 0) {
			for (int i = 0; i < resultList.size(); i++) {
				CustVO temp = resultList.get(i);
				row = sheet.createRow(rowNum);
				rowNum++;

				for (int a = 0; a < title.length; a++) {
					cell = row.createCell(a);
					String cellValue = "";

					if (a < 1)
						cell.setCellStyle(bStyleNo);
					else if (a < 9)
						cell.setCellStyle(bStyleM);
					else if (a < 48)
						cell.setCellStyle(bStyleO);
					else
						cell.setCellStyle(bStyleP);

					if (a == 17) {
						StringBuffer sb = new StringBuffer();
						String chk = BeanUtils.getProperty(temp, "veterans_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/보훈");
						chk = BeanUtils.getProperty(temp, "military_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/군지역소재");
						chk = BeanUtils.getProperty(temp, "choice_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/선택진료");
						chk = BeanUtils.getProperty(temp, "dentist_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/치과");
						chk = BeanUtils.getProperty(temp, "mental_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/정신과");
						chk = BeanUtils.getProperty(temp, "oriental_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/한방");
						chk = BeanUtils.getProperty(temp, "hemodialysis_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/혈액투석");
						chk = BeanUtils.getProperty(temp, "care_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/포괄간호");
						chk = BeanUtils.getProperty(temp, "emergencyop_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/응급실운영");
						chk = BeanUtils.getProperty(temp, "nedis_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/NEDIS사용");
						chk = BeanUtils.getProperty(temp, "narcotics_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/마약류연계");
						chk = BeanUtils.getProperty(temp, "onticsense_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/Ontic Sense");
						chk = BeanUtils.getProperty(temp, "van_yn");
						if (chk != null && "Y".equals(chk.toUpperCase()))
							sb.append("/VAN 인터페이스");

						String chkString = sb.toString();

						if (SsStringUtil.isDefined(chkString)) {
							cellValue = chkString.substring(1);
						} else {
							cellValue = "";
						}

					} else if (a == 6 || a == 7 || a == 10 || a == 44|| a == 61 || a == 62 || a == 63 || a == 64 ) {
						cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
						
						/*날짜형식*/
						if (SsStringUtil.isDefined(cellValue) && cellValue.length() == 8) {
							cellValue = cellValue.substring(0, 4) + "-" + cellValue.substring(4, 6) + "-" + cellValue.substring(6);
						}

					} else {
						cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
					}

					// if(a == 0) cellValue =
					// SsStringUtil.normalizeNull(temp.getRnum()) ;
					// else if(a == 1) cellValue =
					// SsStringUtil.normalizeNull(temp.getCust_gubun_nm()) ;
					// else if(a == 2) cellValue =
					// SsStringUtil.normalizeNull(temp.getFoundation_code_nm())
					// ;
					// else if(a == 3) cellValue =
					// SsStringUtil.normalizeNull(temp.getSpecially_code())
					// ;
					// else if(a == 4) cellValue =
					// SsStringUtil.normalizeNull(temp.getCust_kor_name()) ;
					// else if(a == 5) cellValue =
					// SsStringUtil.normalizeNull(temp.getDeal_code()) ;
					// else if(a == 6) cellValue =
					// SsStringUtil.normalizeNull(temp.getHis_basic_code());
					// else if(a == 7) cellValue =
					// SsStringUtil.normalizeNull(temp.getHis_treat_code())
					// ;
					// else if(a == 8) cellValue =
					// SsStringUtil.normalizeNull(temp.getHis_work_code()) ;
					// else if(a == 9) cellValue =
					// SsStringUtil.normalizeNull(temp.getHis_claim_code())
					// ;
					// else if(a == 10) cellValue =
					// SsStringUtil.normalizeNull(temp.getFormation_code())
					// ;
					// else if(a == 11) cellValue =
					// SsStringUtil.normalizeNull(temp.getVc_nm()) ;
					// else if(a == 12) cellValue =
					// SsStringUtil.normalizeNull(temp.getMtac_nm().replaceAll("@",
					// ",")) ;
					// else if(a == 13) cellValue =
					// SsStringUtil.normalizeNull(temp.getReg_date().replaceAll("@",
					// ",")) ;

					cell.setCellValue(cellValue);
				}
			}

			String usrClient = request.getHeader("User-Agent");

			exl_title = exl_title + ".xls";

			if (usrClient.indexOf("MSIE 5.5") > -1) {
				response.setHeader("Content-Disposition", "filename=" + new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			} else {
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader("Content-Disposition", "attachment;filename=" + new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			}

			fileOut = response.getOutputStream();

			workbook.write(fileOut);
		}
		
		if (fileOut != null) fileOut.close();
	}


	/**
	 * 목록 - 거래중지
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/regist.do")
	public void regist(@ModelAttribute("vo") CustVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		int returnValue = 0;
		String returnCode = "";

		String pageType = SsStringUtil.normalizeNull(vo.getPageType());

		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		vo.setReg_id(adUserInfo.getEmp_no());

		returnValue = custService.updateOperateState(vo);

		if (returnValue == -100)
			returnCode = "100";
		/** 삭제할 정보가 없습니다. */
		else if (returnValue > 0)
			returnCode = "000";
		/** 정상처리 되었습니다. */
		else if (returnValue == 0)
			returnCode = "200";
		/** 운영정보가 존재하지 않습니다. */

		returnMap.put("returnCode", returnCode);
		returnMap.put("pageType", pageType);
		CommonExecute.returnJson(response, returnMap);
	}

	private void addBoardStyle(CellStyle style, boolean isBold) {

		short border;

		if (isBold) {
			border = CellStyle.BORDER_MEDIUM;
		} else {
			border = CellStyle.BORDER_THIN;
		}

		style.setBorderBottom(border);
		style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderTop(border);
		style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderRight(border);
		style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderLeft(border);
		style.setLeftBorderColor(IndexedColors.BLACK.getIndex());

	}

	@RequestMapping(value = "/ad/cust/getErpMtHist.do")
	public void getErpMtList(@ModelAttribute("vo") CustVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(vo, "custDAO.getErpMtList"));
		CommonExecute.returnJson(response, returnMap);
	}

	@RequestMapping(value = "/ad/cust/histMultiSave.do")
	public void histMultiSave(@RequestBody SystemHistVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();

		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;

		List<SystemHistVO> list = vo.getList();

		if (!list.isEmpty()) {

			try {
				// 각 열을 읽어서 DB CRUD 작업을 수행한다.

				// 1. 공용데이터 찾기
				// 1-1 seq를 이용해 고객사 crm_code와 erp 코드를 구한다.
				SystemHistVO firstData = list.get(0);
				CustVO custVO = (CustVO) commonDAO.selectOne(firstData.getSeq(), "custDAO.selectCustMgtByPk");
				String erpCode = custVO.getErp_code();
				String regId = adUserInfo.getEmp_no();

				// 2 공용 임시 데이터에 기초값을 셋팅한다.
				SystemHistVO param = new SystemHistVO();
				param.setSeq(custVO.getSeq());
				param.setErp_code(erpCode);
				param.setReg_id(regId);

				for (SystemHistVO obj : list) {
					param.setDtl_seq(obj.getDtl_seq());
					param.setGroup_code1(obj.getGroup_code1());
					param.setGroup_code2(obj.getGroup_code2());
					param.setGroup_code3(obj.getGroup_code3());
					param.setItem_nm(obj.getItem_nm());
					param.setEtc(obj.getEtc());
					param.setSerial_no(obj.getSerial_no());

					if ("I".equals(obj.getAction_type())) { // 생성
						commonDAO.update(param, "custDAO.systemHistUpdateInsert");
					} else if ("U".equals(obj.getAction_type())) { // 수정
						commonDAO.update(param, "custDAO.systemHistUpdateInsert");
					} else if ("D".equals(obj.getAction_type())) { // 삭제
						commonDAO.update(param, "custDAO.systemHistDelete");
					}
				}

				returnMap.put("resultCode", "000"); // 성공
				CommonExecute.returnJson(response, returnMap);
			} catch (Exception e) {
				returnMap.put("resultCode", "999"); // 실패
				returnMap.put("errorMsg", "정보 저장에 실패하였습니다.\r\n오류내용 : " + e.getMessage());
				CommonExecute.returnJson(response, returnMap);
			}
		} else {
			try {
				returnMap.put("resultCode", "001"); // 수정할 데이터 없음
				CommonExecute.returnJson(response, returnMap);
			} catch (Exception e) {
				logger.debug("histMultiSave error !!", e);
			}
		}
	}

	@RequestMapping(value = "/ad/cust/getInstallHist.do")
	public void getInstallHist(@ModelAttribute SystemHistVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();

		try {
			returnMap.put("resultList", commonDAO.list(vo, "custDAO.systemHistList")); // 수정할
																						// 데이터
																						// 없음
			CommonExecute.returnJson(response, returnMap);
		} catch (Exception e) {
			logger.debug("getInstallHist error !!", e);
		}
	}
	
	@RequestMapping(value = "/ad/cust/getVirtualContractInfo.do")
	public void getVirtualContractInfo(@ModelAttribute VirtualContactVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();

		try {
			returnMap.put("resultObj", commonDAO.selectOne(vo, "custDAO.getVirtualContractInfo"));
			CommonExecute.returnJson(response, returnMap);
		} catch (Exception e) {
			logger.debug("getVirtualContractInfo error !!", e);
		}
	}
	
	@RequestMapping(value = "/ad/cust/regVirtualContract.do")
	public void regVirtualContract(@ModelAttribute("vo") VirtualContactVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		try {
			
			vo.setReg_id(adUserInfo.getEmp_no());
			commonDAO.update(vo, "custDAO.inupVirtualContract");
			
			returnMap.put("resultCode", "000"); // 등록 성공
			
		} catch (Exception e) {
			logger.debug("regVirtualContract error !!", e);
			returnMap.put("resultCode", "999"); // 등록 성공
			returnMap.put("errorMsg", e.getMessage());
		}finally{
			CommonExecute.returnJson(response, returnMap);
		}
	}
	
	@RequestMapping(value = "/ad/cust/delVirtualContract.do")
	public void delVirtualContract(@RequestParam("pkArr") String pkArrStr, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		
		// System.out.println(pkArrStr);
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		try {
			
			// CRM_CUST_MAINTENANCE_ADD 테이블 내용 삭제
			String[] pkArr = pkArrStr.split(",");
			MaintenanceAddVO param = new MaintenanceAddVO();
			for (String vw_pk : pkArr){
				param.setVw_pk(vw_pk);
				commonDAO.delete(param, "custDAO.delMaintenanceAdd");
			}
			
			// CRM_VIRTUAL_CONTRACT 테이블 내용 삭제
			VirtualContactVO param2 = new VirtualContactVO();
			for (String seq : pkArr){
				seq = seq.substring(1,seq.length()-1);
				param2.setSeq(seq);
				commonDAO.delete(param2, "custDAO.delVirtualContract");
			}
			
			returnMap.put("resultCode", "000"); // 삭제 성공
		} catch (Exception e) {
			logger.debug("regVirtualContract error !!", e);
			returnMap.put("resultCode", "999"); // 삭제 성공
			returnMap.put("errorMsg", e.getMessage());
		}finally{
			CommonExecute.returnJson(response, returnMap);
		}
	}
	
	@RequestMapping(value = "/ad/cust/getMaintenanceAddInfo.do")
	public void getMaintenanceAddInfo(@ModelAttribute MaintenanceAddVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();

		try {
			returnMap.put("resultObj", commonDAO.selectOne(vo, "custDAO.getMaintenanceAddInfo"));
			CommonExecute.returnJson(response, returnMap);
		} catch (Exception e) {
			logger.debug("getMaintenanceAddInfo error !!", e);
		}
	}
	
	@RequestMapping(value = "/ad/cust/regMaintenance.do")
	public void regMaintenance(@ModelAttribute("vo") MaintenanceAddVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		try {
			vo.setReg_id(adUserInfo.getEmp_no());
			commonDAO.update(vo, "custDAO.inupMaintenanceAdd");
			returnMap.put("resultCode", "000"); // 등록 성공
		} catch (Exception e) {
			logger.debug("regMaintenance error !!", e);
			returnMap.put("resultCode", "999"); // 등록 실패
			returnMap.put("errorMsg", e.getMessage());
		} finally{
			CommonExecute.returnJson(response, returnMap);
		}
		
	}
	
	/**
	 * ERP 이력 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getErpHistData.do")
	public void getErpHistData(@RequestParam("seq") String seq, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("seq", seq);
		
		returnMap.put("resultList", commonDAO.list(param, "custDAO.selectErpHistBySeq"));
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * ERP 이력 데이터 삭제
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/deleteErpHistData.do")
	public void deleteErpHistData(@RequestParam("seq") String seq, @RequestParam("dtlSeq") String dtlSeq, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		
		if (seq == null || dtlSeq == null || "".equals(seq.trim()) || "".equals(dtlSeq.trim())){
			returnMap.put("resultMsg","삭제 대상 레코드의 키값이 없습니다." );
			CommonExecute.returnJson(response, returnMap);
			return;
		}
		
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("seq", seq);
		param.put("dtlSeq", dtlSeq);
		
		int cnt = commonDAO.delete(param, "custDAO.deleteErpHistByPk");
		
		if (cnt == 1){
			returnMap.put("resultMsg","정상 처리 되었습니다." );
		}else if (cnt == 0){
			returnMap.put("resultMsg","처리된 건수가 없습니다." );
		}else{
			returnMap.put("resultMsg","오류가 발생하였습니다." );
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * ERP 무상 계약 이력 조회
	 * @param erp_code
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getErpFreeContract.do")
	public void getErpFreeContract(@ModelAttribute("vo") CustVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(vo, "custDAO.getErpFreeContract"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * ERP 유상 계약 -최신계약 이력 조회
	 * @param erp_code
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getErpBill.do")
	public void getErpBill(@ModelAttribute("vo") CustVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(vo, "custDAO.getErpBill"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * ERP 유상 계약 -이전계약 이력 조회
	 * @param erp_code
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getErpBillHsty.do")
	public void getErpBillHsty(@ModelAttribute("vo") CustVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(vo, "custDAO.getErpBillHsty"));
		CommonExecute.returnJson(response, returnMap);
	}
	
}
