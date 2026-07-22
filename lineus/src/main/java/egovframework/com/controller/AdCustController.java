package egovframework.com.controller;

import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.quartz.JobExecutionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.controller.SimpleQuartzJob;
import egovframework.com.comm.dao.CommonDao;
//import egovframework.com.comm.dao.CommonMsDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.InterfaceVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.service.impl.CommonSmsServiceImpl;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SendMailForm;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.BoardAswVO;
import egovframework.com.model.CustVO;
import egovframework.com.model.MaintenanceAddVO;
import egovframework.com.model.MssqlVO;
import egovframework.com.model.SystemHistVO;
import egovframework.com.model.VirtualContactVO;
import egovframework.com.service.CustService;
import egovframework.com.service.LoginService;
import egovframework.com.service.MemberService;
import egovframework.com.model.ServerVO;
import egovframework.com.model.DbVO;
import egovframework.com.model.NetworkVO;
import egovframework.com.model.AppVO;
import egovframework.com.model.AsStatsVo;
import egovframework.com.model.AsVO;
import egovframework.com.model.ServiceVO;
import egovframework.com.model.ProjectVO;
import egovframework.com.model.RetireVO;
import egovframework.com.model.OperateVO;
import egovframework.com.model.MssqlVO;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 * @Class Name : AdCustController.java @ @ 수정일 수정자 수정내용 @ --------- ---------
 *        ------------------------------- @ 2018.10.19 김민지 최초생성
 *
 * @author 기업운영팀  개발팀
 * @version 1.0
 * @see Copyright (C) by 중외정보기술 All right reserved.
 */

@SuppressWarnings("unused")
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
	
	/*@Autowired
	CommonMsDao commonMsDAO;*/

	@Autowired MemberService memberService ; 	
	
	@Autowired CommonSmsService commonSmsService ; 	
	
	/**
	 * 거래처 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")	 
	@RequestMapping(value = "/ad/cust/list.do")
	public String list(@ModelAttribute("vo") CustVO vo, HttpServletRequest request) throws Exception {		
		
		
/**	거래처관리 클릭시 SimpleQuartzJob.java (JW Shared service) 인터페이스 및 유지보수담당자에게 이메일발송 디버깅 테스트 하기위함! 
		HashMap<String,String> param = new HashMap<String, String>();
		int returnValue = 0; 
		try {
			//SELECT SHARED SERVICE
			List<MssqlVO> resultList = null ;
			MssqlVO dump = new MssqlVO();
			MssqlVO dump2 = new MssqlVO();
			resultList = (List<MssqlVO>) commonMsDAO.list(dump, "asDAO.getEzSharedServiceSelect");
			
			//INSERT INTO CRM_AS_MGT 
			if(resultList != null && resultList.size() > 0){
				for(MssqlVO resultVo : resultList){
					
					InterfaceVO tempVo = new InterfaceVO();
					InterfaceVO tempVo1 = new InterfaceVO();
					InterfaceVO tempVo2 = new InterfaceVO();
					
					OperateVO tempVo3 = new OperateVO();
					OperateVO tempVo3G = new OperateVO();
					
					OperateVO tempVo4 = new OperateVO();
					OperateVO tempVo4G = new OperateVO();
					
					OperateVO tempVo5 = new OperateVO();
					OperateVO tempVo6 = new OperateVO();
					OperateVO tempVo7 = new OperateVO();
					
					
					AsVO asVo = new AsVO();
					
					int returnVal = 0;		
					int snedSMSResult = 0;
					int snedEMAILResult = 0;	
					
					//GET SHARED SERVICE & LINEUS CODE MAPPING(SYSTEM CODE,INQUIRY CODE)
					tempVo.setCode_gubun("LEVEL2");
					tempVo.setAsis_code1(SsStringUtil.trim(resultVo.getLevel2()));
					tempVo = (InterfaceVO) commonDAO.selectOne(tempVo, "asDAO.selectInterfaceCode");
					if(tempVo == null) {tempVo.setTobe_code1(""); tempVo.setTobe_code2("");} 
					
					//GET SHARED SERVICE & LINEUS CODE MAPPING(REQUEST CODE)
					tempVo1.setCode_gubun("LEVEL3");
					tempVo1.setAsis_code1(SsStringUtil.trim(resultVo.getLevel3()));
					tempVo1 = (InterfaceVO) commonDAO.selectOne(tempVo1, "asDAO.selectInterfaceCode");
					if(tempVo1 == null) {tempVo1.setTobe_code1("");}
					
					
					//GET CUST CODE(EPR CODE)
					tempVo2.setCode_gubun("CUST");
					tempVo2.setAsis_code1(SsStringUtil.trim(resultVo.getRegcomid()));
					tempVo2 = (InterfaceVO) commonDAO.selectOne(tempVo2, "asDAO.selectInterfaceCode");
					if(tempVo2 == null) {tempVo2.setTobe_code1("");} 
					
					//GET OPERATE SEQ
					tempVo3.setErp_code(tempVo2.getTobe_code1()); //cust code
					tempVo3.setSystem_code(tempVo.getTobe_code1()); //system code
					tempVo4.setErp_code(tempVo2.getTobe_code1());
					tempVo3 = (OperateVO) commonDAO.selectOne(tempVo3, "asDAO.selectOperateSeq");
					
					if(tempVo3 == null) {tempVo3G.setOper_seq("");
					}else {
						tempVo3G.setOper_seq(tempVo3.getOper_seq());
					} 
					asVo.setOper_seq(tempVo3G.getOper_seq());
					
					
					//GET CUST SEQ
					tempVo4 = (OperateVO) commonDAO.selectOne(tempVo4, "asDAO.selectCustSeq");
					asVo.setCust_seq(tempVo4.getSeq());
					
					
					//INSERT INTO A/S INFO FROM SHARED SERVICE
					//resultVo.getRcvrdate(); //예상완료일시
					//resultVo.getRcvedate(); //접수처리완료일시
					//resultVo.getWorktime(); //소요일
					
					
					//GET WORKER(TASK CHARGER)
					tempVo5.setOper_seq(SsStringUtil.normalizeNull(tempVo3G.getOper_seq()));
					tempVo5.setTask_code(SsStringUtil.normalizeNull(tempVo.getTobe_code2()));
					tempVo5 = (OperateVO)commonDAO.selectOne(tempVo5,"asDAO.getAsAssignMaster");
					if(tempVo5 == null) {tempVo6.setWk_emp_no("");
					}else {
						tempVo6.setWk_emp_no(tempVo5.getWk_emp_no());
					} 
					
					
					asVo.setShared_doc_idx(SsStringUtil.normalizeNull(resultVo.getIdx())); //순번
					asVo.setShared_doc_id(SsStringUtil.normalizeNull(resultVo.getDocid())); //문서 ID
					asVo.setCall_content(SsStringUtil.normalizeNull(resultVo.getDocttl()) +"\r" +SsStringUtil.normalizeNull(resultVo.getDoctxt())); //제목+내용
					
					
					if(  "1".equals(SsStringUtil.normalizeNull(resultVo.getDocattach())) ) {
						asVo.setShared_attach("Y"); //첨부파일
						dump2 = (MssqlVO)commonMsDAO.selectOne(resultVo,"asDAO.getDocattach");
						asVo.setShared_filenm(dump2.getFilenm2()); //첨부파일 이름.
						asVo.setShared_filepath(dump2.getFilepath()); //첨부파일 경로.
					}
					
					String mDate = SsStringUtil.normalizeNull(resultVo.getDocdate());
					mDate = mDate.substring(0,10);
					mDate = mDate.replaceAll("-", "");
					asVo.setAccept_dt(SsStringUtil.normalizeNull(mDate)); //의뢰일시
					
					String mTime = SsStringUtil.normalizeNull(resultVo.getDocdate());
					mTime = mTime.trim();
					mTime = mTime.substring(11, 19);
					mTime = mTime.replaceAll(":", "");
					asVo.setAccept_time(SsStringUtil.normalizeNull(mTime)); //의뢰시각
					
					
					String iqDt = SsStringUtil.normalizeNull(resultVo.getDocrdate());
					iqDt = iqDt.substring(0,10);
					iqDt = iqDt.replaceAll("-", "");
					
					asVo.setInquiry_dt(SsStringUtil.normalizeNull(iqDt)); //처리요청일
					
					asVo.setApply_id(SsStringUtil.normalizeNull(resultVo.getRegid()));//의뢰자ID
					asVo.setApply_nm(SsStringUtil.normalizeNull(resultVo.getRegnm()));//의뢰자이름
					asVo.setCust_code(SsStringUtil.normalizeNull(tempVo2.getTobe_code1()));//거래처코드
					
					asVo.setApproval_id(SsStringUtil.normalizeNull(resultVo.getRcvid())); //최종결재자 ID(접수자)
					asVo.setApproval_nm(SsStringUtil.normalizeNull(resultVo.getRcvnm())); //최종결재자 ID(접수자)
					
					String mDate1 = SsStringUtil.normalizeNull(resultVo.getRcvsdate());
					mDate1 = mDate1.substring(0,10);
					mDate1 = mDate1.replaceAll("-", "");
					asVo.setApproval_dt(SsStringUtil.normalizeNull(mDate1)); //최종결재날짜(접수일자)
					
					
					String mTime1 = SsStringUtil.normalizeNull(resultVo.getRcvsdate());
					mTime1 = mTime1.trim();
					mTime1 = mTime1.substring(11, 19);
					mTime1 = mTime1.replaceAll(":", "");
					asVo.setApproval_time(SsStringUtil.normalizeNull(mTime1)); //최종결재시각
					
					asVo.setApply_email(resultVo.getMail()); //의뢰자 이메일
					asVo.setSend_email("Y"); //의뢰자 이메일
					asVo.setSystem_type(SsStringUtil.normalizeNull(tempVo.getTobe_code1()));
					asVo.setInquiry_type(SsStringUtil.normalizeNull(tempVo.getTobe_code2()));
					asVo.setRequest_type(SsStringUtil.normalizeNull(tempVo1.getTobe_code1()));
					asVo.setAssign_id(SsStringUtil.normalizeNull(tempVo6.getWk_emp_no()));
					
					asVo.setAccept_route("C001");
					asVo.setProc_status("C001");
					
					asVo.setAs_no((String)commonDAO.selectOne(asVo, "asDAO.getMaxSeq"));
					returnValue = commonDAO.insert(asVo, "asDAO.insertAsInfo");
					
					if(returnValue == 1) { 
						commonMsDAO.update(resultVo, "asDAO.updateEzSharedServiceFlag");
					}
					
					
					////(JW Shared service) AS접수시 유지보수 담당자에게 이메일발송 (처리상태 C001 접수) 2020.07.08. 추가     						  					
					AsVO emailvo = (AsVO) commonDAO.selectOne(asVo, "asDAO.getAsEmailInfo");  
					AsVO retirevo = (AsVO) commonDAO.selectOne(asVo, "asDAO.getAsEmpRetireYn"); //유지보수담당자 퇴사자여부(Y) 2020.07.08.
					//유지보수담당자 퇴사자여부(Y) 이메일발송 안되도록 2020.07.08. 
					if ("N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {    
						String title = "(JW Shared service)ONTIC LineUs에서 A/S 처리 접수 안내 메일을 보내드립니다.";  
						snedEMAILResult = commonSmsService.sendMail("AS","",emailvo.getSender_email(), emailvo.getSender_email(), title, SendMailForm.makeAsEmpMail(emailvo), "", "", 0) ;					
						
						if(snedEMAILResult == 1){  			
							asVo.setMemo("(JW Shared service)AS접수 EMAIL이 유지보수 담당자에게 " + emailvo.getSender_email() + "주소로 발송되었습니다.");
							asVo.setSeq(String.valueOf(commonDAO.selectOneInt(asVo, "asDAO.getAsHistMaxSeq")));
							commonDAO.insert(asVo, "asDAO.insertAsInfoHist");
						}	
					}			
										
				}
			}//for문
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
*/		
		
		return "ad/cust/list";
	}
	
	
	
	/**
	 * 서버 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/list.do")
	public String server(@ModelAttribute("vo") CustVO vo, HttpServletRequest request) throws Exception {

		return "ad/server/list";
	}

	
	/**
	 * 네트워크 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/network/list.do")
	public String network(@ModelAttribute("vo") CustVO vo, HttpServletRequest request) throws Exception {

		return "ad/network/list";
	}
	
	/**
	 * 프로젝트 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/project/list.do")
	public String project(@ModelAttribute("vo") ProjectVO vo, HttpServletRequest request) throws Exception {

		return "ad/project/list";
	}

	/**
	 * 운영정보 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/list.do")
	public String operate(@ModelAttribute("vo") OperateVO vo, HttpServletRequest request) throws Exception {

		return "ad/operate/list";
	}
	
	/**
	 * 퇴사자 관리 목록
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/list.do")
	public String retire(@ModelAttribute("vo") RetireVO vo, HttpServletRequest request) throws Exception {

		return "ad/retire/list";
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
		List<CustVO> resultList = null ;
		
		int totalCount = custService.getCustListCnt(vo) ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getList(vo,"custDAO.getCustList") ;
			vo.setJson_paging(vo.getJsonPaging("custList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 프로젝트 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/project/getProjectList.do")
	public void getProjectList(@ModelAttribute("vo") ProjectVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<ProjectVO> resultList = null ;
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start1())))
			vo.setSearch_start1(vo.getSearch_start1().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end1())))
			vo.setSearch_end1(vo.getSearch_end1().replaceAll("/", ""));


		if (!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2())))
			vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2())))
			vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", ""));

		
		int totalCount = custService.getProjectCnt(vo,"custDAO.getProjectCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getProjectList(vo,"custDAO.getProjectList") ;
			vo.setJson_paging(vo.getJsonPaging("getProjectList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	

	/**
	 * 운영정보 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/getOperateList.do")
	public void getOperateList(@ModelAttribute("vo") OperateVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<OperateVO> resultList = null ;
		
		int totalCount = custService.getOperateCnt(vo,"custDAO.getOperateCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getOperateList(vo,"custDAO.getOperateList") ;
			vo.setJson_paging(vo.getJsonPaging("getOperateList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	
	/**
	 * 서버 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getServerList.do")
	public void getServerList(@ModelAttribute("vo") ServerVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<ServerVO> resultList = null ;
		
		int totalCount = custService.getServerListCnt(vo,"custDAO.getServerListCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getServerList(vo,"custDAO.getServerList") ;
			vo.setJson_paging(vo.getJsonPaging("getServerList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 네트워크 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/network/getNetworkList.do")
	public void getNetworkList(@ModelAttribute("vo") NetworkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<NetworkVO> resultList = null ;
		
		int totalCount = custService.getNetworkListCnt(vo ,"custDAO.getNetworkCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getNetworkList(vo,"custDAO.getNetworkList") ;
			vo.setJson_paging(vo.getJsonPaging("getNetworkList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * DB 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getDbList.do")
	public void getDbList(@ModelAttribute("vo") DbVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<DbVO> resultList = null ;
		
		int totalCount = custService.getDbListCnt(vo,"custDAO.getDbListCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getDbList(vo,"custDAO.getDbList") ;
			vo.setJson_paging(vo.getJsonPaging("getDbList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}

	
	/**
	 * 어플리케이션 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getAppList.do")
	public void getAppList(@ModelAttribute("vo") AppVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<AppVO> resultList = null ;
		
		int totalCount = custService.getAppListCnt(vo,"custDAO.getAppListCnt") ;
		if(totalCount > 0){
			logger.debug("pageSize : " + vo.getPageSize());
			logger.debug("startRow : " + vo.getStartRow());
			logger.debug("endRow : " + vo.getEndRow());
			vo.setPaging(totalCount);
			logger.debug("startRow : " + vo.getStartRow());
			logger.debug("endRow : " + vo.getEndRow());
			resultList = custService.getAppList(vo,"custDAO.getAppList") ;
			vo.setJson_paging(vo.getJsonPaging("getAppList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 서비스 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getServiceList.do")
	public void getServiceList(@ModelAttribute("vo") ServiceVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<ServiceVO> resultList = null ;
		
		int totalCount = custService.getServiceListCnt(vo,"custDAO.getServiceListCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getServiceList(vo,"custDAO.getServiceList") ;
			vo.setJson_paging(vo.getJsonPaging("getServiceList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}

	/**
	 * 퇴사자 관리 목록 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/getRetireList.do")
	public void getRetireList(@ModelAttribute("vo") RetireVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<RetireVO> resultList = null ;
		
		int totalCount = custService.getRetireListCnt(vo,"custDAO.getRetireListCnt") ; 
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = custService.getRetireList(vo,"custDAO.getRetireList") ;
			
			vo.setJson_paging(vo.getJsonPaging("getRetireList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		
		CommonExecute.returnJson(response, returnMap);
		
	
	}
	
	
	/**
	 * 퇴사자 관리 - 퇴사자관리 체크리스트 초기화면
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/getRetireInit.do")
	public void getRetireInit(@ModelAttribute("vo") RetireVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<RetireVO> resultList = null ;
		
		int totalCount = custService.getRetireInitCnt(vo,"custDAO.getRetireInitCnt") ; 
		
		
		if(totalCount > 0){
			
			resultList = custService.getRetireInit(vo,"custDAO.getRetireInit") ;
			
			vo.setJson_paging(vo.getJsonPaging("getRetireInit"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
			
		}
		
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 퇴사자 관리 - 퇴사자관리 체크리스트 조회
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/getRetireCheck.do")
	public void getRetireCheck(@ModelAttribute("vo") RetireVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<RetireVO> resultList = null ;
		
		int totalCount = custService.getRetireCheckCnt(vo,"custDAO.getRetireCheckCnt") ; 
		
		if(totalCount > 0){
			
			resultList = custService.getRetireCheck(vo,"custDAO.getRetireCheck") ;
			
			vo.setJson_paging(vo.getJsonPaging("getRetireCheck"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
			
		}
		
		
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
		returnMap.put("vo", custService.getSelectOne(vo,"custDAO.getLinkCustOne"));
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
	 * 서버관리 관리 - 서버정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getServerInfo.do")
	public void getServerInfo(@ModelAttribute("vo") ServerVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getServerInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 서버관리 관리 - 서버정보 상세 데이터 (프로젝트정보에서 사용)
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getServerInfo2.do")
	public void getServerInfo2(@ModelAttribute("vo") ServerVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getServerInfo2(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * DB 관리 - DB정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getDbInfo.do")
	public void getDbInfo(@ModelAttribute("vo") DbVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getDbInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	

	/**
	 * App 관리 - APP정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getAppInfo.do")
	public void getAppInfo(@ModelAttribute("vo") AppVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getAppInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * 서비스 관리 - 서비스정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/getServiceInfo.do")
	public void getServiceInfo(@ModelAttribute("vo") ServiceVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getServiceInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	

	/**
	 * 네트워크 관리 - 네트워크정보 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/network/getNetworkInfo.do")
	public void getNetworkInfo(@ModelAttribute("vo") NetworkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		vo.setNetwork_seq(vo.getSeq());
		returnMap = custService.getNetworkInfo(vo);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * 서버 관리 - 어플리케이션 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping(value = "/ad/server/getAppInfo.do")
	public void getAppInfo(@ModelAttribute("vo") AppVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getAppInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}*/
	
	
	/**
	 * 서버 관리 - 서버이력 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/Server/getServerHistInfo.do")
	public void getServerHistInfo(@ModelAttribute("vo") ServerVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getServerInfo(vo);
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 거래처 관리 - 네트워크이력 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/network/getNetworkHistInfo.do")
	public void getNetworkHistInfo(@ModelAttribute("vo") NetworkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getNetworkInfo(vo);
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
	@RequestMapping(value = "/ad/project/getProjectInfo.do")
	public void getProjectInfo(@ModelAttribute("vo") ProjectVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap = custService.getProjectInfo(vo);
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
	@RequestMapping(value = "/ad/operate/getOperateInfo.do")
	public void getOperateInfo(@ModelAttribute("vo") OperateVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
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
	 * 퇴사자 관리 - 퇴사자 상세 데이터
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/getRetireInfo.do")
	public void getRetireInfo(@ModelAttribute("vo") RetireVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultVO", custService.getSelectOne(vo , "custDAO.getRetireInfo")) ;  
		CommonExecute.returnJson(response, returnMap);
	}
	

	
	
	/**
	 * 거래처 관리 - 운영정보 정보삭제
	 * 특정 담당자 상세조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/delProc.do")
	public void delOperateProc(@ModelAttribute("vo") OperateVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) 
			throws Exception {
		
		int resultValue = 0; 
		int returnCode = 0;
		String returnText = "";
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		OperateVO operOb = new OperateVO();
		resultValue =  custService.delOperateProc(vo) ;
		
		if( resultValue == 1 ){ returnText = "정상처리 되었습니다."; returnCode = 100; /*삭제 성공*/}
		else{ 
			vo.setOper_seq(Integer.toString(resultValue)); 
			operOb = (OperateVO)custService.getOperatInfoOne(vo); 
			returnText = "삭제 불가합니다.\n 프로젝트명 [" +operOb.getProject_nm() +"]에 대한 A/S가 존재합니다. ";
			returnCode = 200;
		}
	
		returnMap.put("returnText", returnText) ; 
		returnMap.put("returnCode", returnCode) ; 
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
	 * 프로젝트관리 -  
	 * 수주심의코드조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/project/getProjectByPjtCode.do")
	public void getProjectByPjtCode(@ModelAttribute("vo") ProjectVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) 
			throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultVO", commonDAO.selectOne(vo , "custDAO.getProjectByPjtCode")) ;
	
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
	 * 거래처 관리 상세 - 관리정보
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/form.do")
	public String form(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {

		
		if (vo.getErp_code() == null || ("".equals(vo.getErp_code()) && "".equals(vo.getPageType()))){
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
		if (vo.getErp_code() == null || ("".equals(vo.getErp_code()) && "".equals(vo.getPageType()))){
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
		if (vo.getErp_code() == null || ("".equals(vo.getErp_code()) && "".equals(vo.getPageType()))){
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
		if (vo.getErp_code() == null || ("".equals(vo.getErp_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/cust/form7";
	}
	
	
	/**
	 * 서버관리 관리 상세 - 서버관리 
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/form.do")
	public String serverForm(@ModelAttribute("vo") ServerVO vo, Model model, HttpServletRequest request) throws Exception {
		
		return "ad/server/form";
	}
	
	
	
	/**
	 * 서버관리 관리 상세 - DB관리 
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/form2.do")
	public String dbForm(@ModelAttribute("vo") ServerVO vo, Model model, HttpServletRequest request) throws Exception {
		
		if (vo.getSeq() != null ){
				vo.setServer_seq(vo.getSeq());
				model.addAttribute("vo", vo);
		}
		return "ad/server/form2";
	}
	
	
	/**
	 * 서버관리 관리 상세 - 어플리케이션관리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/form3.do")
	public String appForm(@ModelAttribute("vo") ServerVO vo, Model model, HttpServletRequest request) throws Exception {
		
		if (vo.getSeq() != null ){
			vo.setServer_seq(vo.getSeq());
			model.addAttribute("vo", vo);
		}
		return "ad/server/form3";
	}
	
	/**
	 * 서버관리 관리 상세 - 서비스관리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/form4.do")
	public String serviceForm(@ModelAttribute("vo") ServerVO vo, Model model, HttpServletRequest request) throws Exception {
		
		if (vo.getSeq() != null ){
			vo.setServer_seq(vo.getSeq());
			model.addAttribute("vo", vo);
		}
		return "ad/server/form4";
	}
	
	
	
	/**
	 * 네트워크 관리 상세 - 네트워크관리 
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/network/form.do")
	public String networkForm(@ModelAttribute("vo") CustVO vo, Model model, HttpServletRequest request) throws Exception {
		if (vo.getErp_code() == null || ("".equals(vo.getErp_code()) && "".equals(vo.getPageType()))){
			vo = (CustVO) commonDAO.selectOne(vo, "custDAO.getCustMgtByPK");
			model.addAttribute("vo", vo);
		}
		return "ad/network/form";
	}
	
	
	/**
	 * 프로젝트 관리 상세 - 프로젝트관리 
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/project/form.do")
	public String projectForm(@ModelAttribute("vo") ProjectVO vo, Model model, HttpServletRequest request) throws Exception {
		
		return "ad/project/form";
	}
	
	
	/**
	 * 운영정보 관리 상세 - 운영정보관리 
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/form.do")
	public String operateForm(@ModelAttribute("vo") OperateVO vo, Model model, HttpServletRequest request) throws Exception {
		
		return "ad/operate/form";
	}
	
	/**
	 * 퇴사자 관리 상세
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/form.do")
	public String retireForm(@ModelAttribute("vo") RetireVO vo, HttpServletRequest request) throws Exception {

		return "ad/retire/form";
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
	 * 서버 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/proc.do")
	public void serverProc(@ModelAttribute("vo") ServerVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;

		if (!"".equals(SsStringUtil.normalizeNull(vo.getTake_dt())))
			vo.setTake_dt(vo.getTake_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTerm_start_dt())))
			vo.setTerm_start_dt(vo.getTerm_start_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTerm_end_dt())))
			vo.setTerm_end_dt(vo.getTerm_end_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getFree_start_dt())))
			vo.setFree_start_dt(vo.getFree_start_dt().replaceAll("/", ""));
		if (!"".equals(SsStringUtil.normalizeNull(vo.getFree_end_dt())))
			vo.setFree_end_dt(vo.getFree_end_dt().replaceAll("/", ""));
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		returnValue = custService.updateServer(vo,request) ;	
		
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
		
	/**
	 * DB 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/proc2.do")
	public void dbProc(@ModelAttribute("vo") DbVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;

		if (!"".equals(SsStringUtil.normalizeNull(vo.getBackup_dt())))
			vo.setBackup_dt(vo.getBackup_dt().replaceAll("/", ""));
		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = custService.updateDb(vo,request) ;	
		
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * DB 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/proc3.do")
	public void appProc(@ModelAttribute("vo") AppVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;

		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = custService.updateApp(vo,request) ;	
		
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
	

	/**
	 * 서비스 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/server/proc4.do")
	public void serviceProc(@ModelAttribute("vo") ServiceVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;

		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = custService.updateService(vo,request) ;	
		
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 네트워크 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/network/proc.do")
	public void networkProc(@ModelAttribute("vo") NetworkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = custService.updateNetwork(vo,request) ;	
		
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 프로젝트 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/project/proc.do")
	public void projectProc(@ModelAttribute("vo") ProjectVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = custService.updateProject(vo,request) ;	
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}
	
	

	/**
	 * 운영정보 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/proc.do")
	public void operateProc(@ModelAttribute("vo") OperateVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		int returnValue = 0 ;
		String script = "" ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = custService.updateOperate(vo,request) ;	
		if (returnValue > 0)
			returnMap.put("returnCode", "000");
		else
			returnMap.put("returnCode", "001");

		CommonExecute.returnJson(response, returnMap);
	}


	

	/**
	 * 퇴사자 관리 - 처리
	 * 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/proc.do")
	public String retireProc(@ModelAttribute("vo") RetireVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		int returnValue = 0 ;
		String script = "" ;
		
		String[] check_cd = request.getParameterValues("check_cd");	//체크리스트 항목코드
		String[] check_yn = request.getParameterValues("hidden_check_yn");	//체크유무
		String[] note = request.getParameterValues("note");			//비고
		String[] reg_id = request.getParameterValues("reg_id");		//확인자 사번
		String[] reg_date = request.getParameterValues("reg_date");	//확인일자
		String retireId = request.getParameter("retireId");			//퇴사자 사번
		String retireDate = request.getParameter("retireDate");		//퇴사일자
		
		for(int i=0; i<check_cd.length; i++){
			
			RetireVO retireVO = new RetireVO();
			retireVO.setEmp_no(retireId);						//퇴사자 사번
			retireVO.setRetire_date(retireDate);				//퇴사일자
			retireVO.setCheck_cd(check_cd[i]);					//체크리스트 항목코드
			retireVO.setCheck_yn(check_yn[i]);					//체크유무
			retireVO.setNote(note[i]);							//비고
			retireVO.setReg_id(reg_id[i]);						//확인자 사번
			retireVO.setReg_date(reg_date[i]);					//확인일자
			
			returnValue += commonDAO.update(retireVO, "custDAO.mergeRetire");
		}
		
		if(returnValue > 0) script = "parent.procReturn('success');" ;
		else script = "parent.procReturn('fail');" ;
		
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

		String[] title = { "No", "사업자소재지", "거래처명", "CRM코드", "거래처구분", "재단구분", "병원설립일", "계약일자", "병상BED", "거래상태", "HIS기초버전", "HIS진료버전", "HIS원무버전", "HIS청구버전",
				"전문병원여부", "병상BED", "운영정보", "의사수", "간호사수", "간호등급", "신규/기존", "기존전산업체", "일평균내원자수", "평균내원자수", "외부수탁업체", "청구여부", "특이사항",
				"응급의료기관종류", "의약품정보업체", "카드밴사업체", "검진연동업체", "팍스연동업체",
				"거래처명", "CRM코드",
				"거래처구분", "신규/기존", "기존전산업체", "전문병원 여부", "PJT OCS/EMR ver", "담당PM", "사업장 소재지", "요양기관번호", "사업자번호", "의사수", "병상수", "투입기간1", "투입기간2", "전산오픈일",
				"최종검수일", "구성", "서버 제조사/모델", "OS", "서버 RAM", "PC", "오라클버전", "외부수탁업체", "기타설명", "특이사항" };

		String[] refColumn = { "rnum", "cust_address", "cust_kor_name", "crm_code", "cust_gubun_nm", "foundation_code_nm", "foundation_dt", "contract_dt",
				"bed_count",

				"deal_code_nm", "his_basic_code_nm", "his_treat_code_nm", "his_work_code_nm", "his_claim_code_nm", "specially_code_nm", "o_bed_count",
				"veterans_yn", "doctor_count", "nurse_count", "care_grade", "new_code_nm", "old_company_nm", "come_count", "average_count",
				"outside_cust_code_nm", "charge_yn", "detail_etc", "emergency_type_code_nm", "medicine_info_cust_code_nm", "card_van_cust_code_nm",
				"examination_cust_code_nm", "pasc_cust_code_nm", 

				"p_cust_kor_name", "p_crm_code", "p_cust_gubun_nm", "p_new_code_nm", "p_old_company_nm", "p_specially_code", "version", "pm", "addr",
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
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 9, 31));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 32, 57));

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
		cell = row.createCell(32);
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
			else if (i < 32)
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
					else if (a < 32)
						cell.setCellStyle(bStyleO);
					else
						cell.setCellStyle(bStyleP);

					if (a == 16) {
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

						String chkString = sb.toString();

						if (SsStringUtil.isDefined(chkString)) {
							cellValue = chkString.substring(1);
						} else {
							cellValue = "";
						}

					} else if (a == 6 || a == 7 || a == 40 || a == 46 || a == 47 || a == 48) {
						cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));

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
	 * 퇴사자관리 -엑셀처리
	 * 
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/retire/exl.do")
	public void exl2(@ModelAttribute("vo") RetireVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		OutputStream fileOut = null;

		String isTab = SsStringUtil.normalize(vo.getIsTab(), "1").trim();

		String exl_title = "퇴사자관리";

		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;
		vo.setPageType("exl");
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;

		
		List<RetireVO> resultList  = custService.getRetireExl(vo, "custDAO.getRetireExl"); 
		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet(exl_title);
		HSSFRow row = null;
		HSSFCell cell = null;
		HSSFPalette palette = workbook.getCustomPalette();
		
		String[] title = { 
				
				 "사번"
				, "이름"
				, "퇴사일"
				, "기업명"
				, "팀명"
				, "퇴사유형"
				
				, "확인항목"
				, "확인여부"
				, "확인자"
				, "확인일자"
				, "비고"
				, "확인완료"
				
				};
		String[] refColumn = { 
			      "userid" 
				, "usernm" 
				, "retire_date" 
				, "company_nm"
				, "deptnm"
				, "retire_flag_nm"
				
				, "check_nm"
				, "check_yn"
				, "reg_nm"
				, "reg_date"
				, "note"
				, "conf"
				
				};
		
		
		//셀스타일
		CellStyle tStyleOne = workbook.createCellStyle();
		CellStyle tStyleTwo = workbook.createCellStyle();
		CellStyle tStyleThree = workbook.createCellStyle();
		CellStyle tStyleFour = workbook.createCellStyle();
		CellStyle tStyleFive = workbook.createCellStyle();
		CellStyle tStyleSix = workbook.createCellStyle();
		CellStyle tStyleSeven = workbook.createCellStyle();
		CellStyle tStyleEigth = workbook.createCellStyle();
		CellStyle tStyleNine = workbook.createCellStyle();
		CellStyle tStyleTen = workbook.createCellStyle();
		CellStyle titleStyle = workbook.createCellStyle();
		
		tStyleOne.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleOne.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleOne.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleOne.setFillForegroundColor(IndexedColors.LIME.getIndex());
		//addBoardStyle(tStyleOne, true);
		
		tStyleTwo.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTwo.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleTwo.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTwo.setFillForegroundColor(IndexedColors.TAN.getIndex());
		//addBoardStyle(tStyleTwo, true);
		
		tStyleThree.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleThree.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleThree.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleThree.setFillForegroundColor(IndexedColors.GREEN.getIndex());
		//addBoardStyle(tStyleThree, true);
		
		tStyleFour.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFour.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleFour.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFour.setFillForegroundColor(IndexedColors.GOLD.getIndex());
		addBoardStyle(tStyleFour, true);
		
		tStyleFive.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleFive.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleFive.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleFive.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		addBoardStyle(tStyleFive, true);
		
		tStyleSix.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSix.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleSix.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSix.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());
		addBoardStyle(tStyleSix, true);
		
		tStyleSeven.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleSeven.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleSeven.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleSeven.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
		addBoardStyle(tStyleSeven, true);
		
		
		tStyleEigth.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleEigth.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleEigth.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleEigth.setFillForegroundColor(palette.findSimilarColor(248, 203, 173).getIndex());
//		tStyleEigth.setFillForegroundColor(IndexedColors.CORAL.getIndex());
		addBoardStyle(tStyleEigth, true);
		
		tStyleNine.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleNine.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleNine.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleNine.setFillForegroundColor(palette.findSimilarColor(255, 230, 153).getIndex());
//		tStyleNine.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
		addBoardStyle(tStyleNine, true);
		
		tStyleTen.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleTen.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		tStyleTen.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleTen.setFillForegroundColor(IndexedColors.PLUM.getIndex());
		addBoardStyle(tStyleTen, true);
		
		titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
		titleStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		titleStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		titleStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
		addBoardStyle(titleStyle, true);
		
		
		//첫번째행
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 6, 11));
		
		//헤더생성
		cell = row.createCell(0);
		cell.setCellValue("퇴사자 상세정보");
		cell.setCellStyle(tStyleOne);
		
		cell = row.createCell(6);
		cell.setCellValue("퇴사자 체크리스트 정보");
		cell.setCellStyle(tStyleTwo);
		
		//두번째 행 셋팅
		rowNum++  ;
		row = sheet.createRow(rowNum) ; 
		
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
			
			cell.setCellStyle(titleStyle);
			addBoardStyle(titleStyle, true);
			
		}
		
		rowNum++  ;
		
		if(resultList != null && resultList.size() > 0){
			for(int i = resultList.size() -1 ; i >= 0 ; i--){
				RetireVO temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				//셀 너비 자동 조정
				sheet.autoSizeColumn(i);
				sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+512);
				
				for(int a = 0 ; a < title.length ; a++){

					cell = row.createCell(a) ;
					String cellValue = "" ; 

					cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
					cell.setCellValue(cellValue);
				}
			}
			
			String usrClient = request.getHeader("User-Agent") ; 
			
			exl_title = exl_title + ".xls" ; 
			
			if(usrClient.indexOf("MSIE 5.5") > -1){
				response.setHeader("Content-Disposition", "filename="+ new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			}else{
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(exl_title, "UTF-8") + ";");
			}
			
			fileOut = response.getOutputStream() ; 
			
			workbook.write(fileOut);
		}
		
		if(fileOut != null) fileOut.close();  
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
	 * 시스템 유형 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getSystemInfo.do")
	public void getSystemInfo(@ModelAttribute("vo") OperateVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		logger.debug("getSystemInfo페이지타입" + vo.getPageType());
		
		returnMap.put("resultList", commonDAO.list(vo, "custDAO.selectSystemInfoBySeq"));
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 운영 유형 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/operate/getOperTask.do")
	public void getOperTask(@ModelAttribute("vo") OperateVO vo, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultList", commonDAO.list(vo, "custDAO.getOperTask"));
		
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
	@RequestMapping(value = "/ad/cust/getCustInfoBySeq.do")
	public void getCustInfoBySeq(@ModelAttribute("vo") CustVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("resultVO", commonDAO.selectOne(vo, "custDAO.getCustInfoBySeq"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 계정관리 - 사원 계정 목록
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/cust/getEmpList.do")
	public void getEmpList(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		int totalCount = memberService.getSelectInt(vo , "memberDAO.getEmpListCnt") ;
		vo.setPaging(totalCount);
		if(totalCount>  0) {
			vo.setJson_paging(vo.getJsonPaging("charList"));
			returnMap.put("resultList", memberService.getList(vo , "memberDAO.getEmpList")) ;
			returnMap.put("vo", vo) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
			
	}

	
}
