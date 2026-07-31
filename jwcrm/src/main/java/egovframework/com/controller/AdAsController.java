package egovframework.com.controller;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.OperateVO;
import egovframework.com.service.AsService;
import egovframework.com.service.LoginService;
import egovframework.com.comm.dao.CommonDao;
/**
 * @Class Name : AdAsController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.05.25	정철구		           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2017. 09.07
 * @version 1.0
 * @see
 *
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class AdAsController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdAsController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired LoginService loginService ; 
	@Autowired AsService asService ; 
	@Autowired CommonDao commonDAO ;
	
	// [AX Lab] 수정 시작 (2026-07-29 AX Lab): AS 목록 헤더클릭 정렬(오름/내림) 지원.
	/**
	 * 정렬 화이트리스트. key = 화면(list.jsp thead 의 data-sort)이 보내는 키, value = 실제 SQL 컬럼명.
	 *
	 * 이 값은 egov-as-query.xml 의 getAsList 에서 ${sort_expr} 로 "문자열 치환"되어 SQL 에 직접 박힌다.
	 * 바인딩(#{})이 아니므로 이 화이트리스트가 SQL Injection 방어의 전부다. 절대 화면 값을 그대로 쓰지 말 것.
	 *
	 * [주의 1] 정렬은 ROW_NUMBER() 시점(=in_tb)에 걸리므로 in_tb 에 실재하는 컬럼만 넣을 수 있다.
	 *          proc_status_nm 같은 _nm 컬럼은 최외곽 스칼라 서브쿼리라 이 시점에 존재하지 않는다.
	 *          → 원본 코드 컬럼(PROC_STATUS 등)으로 매핑한다. 즉 명칭 가나다순이 아니라 코드순으로 정렬된다.
	 *          반대로 EMP_NM / DEPT_NM / PART_TYPE 은 in_tb 안에서 이미 계산되므로 실제 이름순으로 정렬된다.
	 * [주의 2] 요청내용(CALL_CONTENT)/조치내용(ACTION_CONTENT)/최신댓글(W_CONTENT)은 장문 컬럼이라
	 *          정렬 의미가 없고 CLOB 인 경우 ORDER BY 자체가 불가(ORA-00932)하므로 의도적으로 제외한다.
	 * [주의 3] 연결AS개수/답변수/첨부여부는 최외곽에서 계산되는 파생값이라 정렬 대상이 아니다.
	 */
	private static final Map<String, String> AS_SORT_COLS = new HashMap<String, String>() ;
	static {
		AS_SORT_COLS.put("as_no"             , "AS_NO") ;
		AS_SORT_COLS.put("cn_as_no"          , "CN_AS_NO") ;
		AS_SORT_COLS.put("accept_dt"         , "ACCEPT_DT") ;
		AS_SORT_COLS.put("as_accept_dt"      , "ACCEPT_DT") ;
		AS_SORT_COLS.put("cust_code"         , "CUST_CODE") ;
		AS_SORT_COLS.put("cust_kor_name"     , "CUST_KOR_NAME") ;
		AS_SORT_COLS.put("erp_code"          , "ERP_CODE") ;
		AS_SORT_COLS.put("priority"          , "PRIORITY") ;
		AS_SORT_COLS.put("deal_code_nm"      , "DEAL_CODE") ;
		AS_SORT_COLS.put("apply_nm"          , "APPLY_NM") ;
		AS_SORT_COLS.put("rl_apply_nm"       , "RL_APPLY_NM") ;
		AS_SORT_COLS.put("chatbot_id"        , "CHATBOT_ID") ;
		AS_SORT_COLS.put("proc_status_nm"    , "PROC_STATUS") ;
		AS_SORT_COLS.put("accept_route_nm"   , "ACCEPT_ROUTE") ;
		AS_SORT_COLS.put("request_type_nm"   , "REQUEST_TYPE") ;
		AS_SORT_COLS.put("service_cate_nm"   , "SERVICE_CATE") ;
		AS_SORT_COLS.put("inquiry_type_nm"   , "INQUIRY_TYPE") ;
		AS_SORT_COLS.put("inportance_nm"     , "INPORTANCE") ;
		AS_SORT_COLS.put("cause_type_nm"     , "CAUSE_TYPE") ;
		AS_SORT_COLS.put("action_type_nm"    , "ACTION_TYPE") ;
		AS_SORT_COLS.put("tel_confirm"       , "TEL_CONFIRM") ;
		AS_SORT_COLS.put("tel_absence"       , "TEL_ABSENCE") ;
		AS_SORT_COLS.put("tel_absence_cnt"   , "TEL_ABSENCE_CNT") ;
		AS_SORT_COLS.put("emp_nm"            , "EMP_NM") ;
		AS_SORT_COLS.put("dept_nm"           , "DEPT_NM") ;
		AS_SORT_COLS.put("part_type"         , "PART_TYPE") ;
		AS_SORT_COLS.put("as_proc_dt"        , "PROC_DT") ;
		AS_SORT_COLS.put("as_complete_dt"    , "COMPLETE_DT") ;
		AS_SORT_COLS.put("work_time"         , "WORK_TIME") ;
		AS_SORT_COLS.put("proc_gubun_nm"     , "PROC_GUBUN") ;
		AS_SORT_COLS.put("proc_build_info"   , "PROC_BUILD_INFO") ;
		AS_SORT_COLS.put("proc_test_info"    , "PROC_TEST_INFO") ;
		AS_SORT_COLS.put("proc_process_sp"   , "PROC_PROCESS_SP") ;
		AS_SORT_COLS.put("proc_screen_sp"    , "PROC_SCREEN_SP") ;
		AS_SORT_COLS.put("proc_table_sp"     , "PROC_TABLE_SP") ;
		AS_SORT_COLS.put("proc_function_sp"  , "PROC_FUNCTION_SP") ;
		AS_SORT_COLS.put("proc_interface_sp" , "PROC_INTERFACE_SP") ;
		AS_SORT_COLS.put("star_state_date"   , "STAR_STATE_DATE") ;
		AS_SORT_COLS.put("star_state"        , "STAR_STATE") ;
	}

	/**
	 * 화면이 보낸 정렬조건(sort_col/sort_dir)을 검증해 쿼리용 값(sort_expr/sort_dir_sql/sort_dir_inv)으로 확정한다.
	 *
	 * sort_dir_inv 가 sort_dir_sql 의 반대인 이유: PagingVO.setPaging() 이
	 * startRow = rowCnt - page*pageSize + 1 로 "뒤에서부터" 페이지 창을 잡기 때문에 1페이지가 RNUM 최대 구간이다.
	 * 따라서 ROW_NUMBER 채번은 최종 출력순서의 역방향이어야 1페이지에 원하는 행이 나온다.
	 * (자세한 내용은 egov-as-query.xml getAsList 의 ROW_NUMBER 주석 참고)
	 *
	 * 화이트리스트에 없는 키가 오면 정렬 미지정으로 간주해 AS_NO DESC 기본값으로 되돌린다(=개편 전과 동일한 동작).
	 */
	private void applyAsSort(AsVO vo) {
		String sortKey = SsStringUtil.normalizeNull(vo.getSort_col()) ;
		String sortCol = AS_SORT_COLS.get(sortKey) ;

		if (sortCol == null) {
			// 화면 표시용 값도 함께 비워 헤더에 엉뚱한 정렬표시가 남지 않게 한다.
			vo.setSort_col("") ;
			vo.setSort_dir("") ;
			vo.setSort_expr("AS_NO") ;
			vo.setSort_dir_sql("DESC") ;
			vo.setSort_dir_inv("ASC") ;
			return ;
		}

		boolean asc = "ASC".equalsIgnoreCase(SsStringUtil.normalizeNull(vo.getSort_dir())) ;

		vo.setSort_dir(asc ? "ASC" : "DESC") ;	// 화면 복원용(정규화)
		vo.setSort_expr(sortCol) ;
		vo.setSort_dir_sql(asc ? "ASC" : "DESC") ;
		vo.setSort_dir_inv(asc ? "DESC" : "ASC") ;
	}
	// [AX Lab] 수정 끝
	
	
	/**
	 * A/S 목록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/list.do")
	public String list(@ModelAttribute("vo") AsVO vo, HttpServletRequest request, HttpSession session) throws Exception {
		
//		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
//		// 본인의 아이디가 crm_as_mgt.assign_id 에 포함되어 있으면 본인의 이름을 vo.emp_nm에 셋팅해준다.
//		if ("".equals(vo.getEmp_nm()) && adUserInfo != null){
//			logger.debug(adUserInfo.getEmp_id());
//			logger.debug(adUserInfo.getEmp_no());
//			if (asService.selectAsMgtCntByAssignId(adUserInfo.getEmp_no()) > 0){
//				vo.setEmp_nm(adUserInfo.getEmp_nm());
//			}
//		}
		
		// [AX Lab] 수정 시작 (2026-07-24 AX Lab): 검색 후 리로드 시 고급 동적필터를 화면에서 복원할 수 있도록 JSON 으로 내려준다.
		vo.setAdvFiltersJson(buildAdvFiltersJson(vo.getAdv_field(), vo.getAdv_value(), vo.getAdv_value2()));
		// [AX Lab] 수정 끝
		
		// [AX Lab] 수정 시작 (2026-07-29 AX Lab): 정렬조건 정규화.
		// 화면(list.jsp)이 ${vo.sort_col} / ${vo.sort_dir} 로 헤더의 정렬표시를 복원하므로, 화이트리스트에 없는
		// 값이 그대로 내려가 "정렬된 것처럼" 보이는 일이 없도록 여기서도 검증을 거친다.
		applyAsSort(vo);
		// [AX Lab] 수정 끝
		
		return "ad/as/list";
	}
	
	// [AX Lab] 수정 시작 (2026-07-24 AX Lab): AS 통합검색 고급 동적필터 공통 유틸
	/**
	 * 고급 동적필터의 병렬 배열(adv_field/adv_value/adv_value2)을 쿼리용 조건 목록으로 조립한다.
	 * - 값이 없는(빈) 행은 제외한다.
	 * - 날짜형(PROC_DT/COMPLETE_DT)은 시작/종료 둘 다 비어있으면 제외하고, '/' 는 제거하여 YYYYMMDD 로 맞춘다.
	 */
	private List<Map<String, String>> buildAdvFilterList(String[] fields, String[] values, String[] values2) {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		if (fields == null) return list;
		for (int i = 0; i < fields.length; i++) {
			String f = SsStringUtil.normalizeNull(fields[i]);
			String v  = (values  != null && i < values.length)  ? SsStringUtil.normalizeNull(values[i])  : "";
			String v2 = (values2 != null && i < values2.length) ? SsStringUtil.normalizeNull(values2[i]) : "";
			if ("".equals(f)) continue;
			boolean isDate = "PROC_DT".equals(f) || "COMPLETE_DT".equals(f);
			if (isDate) {
				if ("".equals(v) && "".equals(v2)) continue;
				v  = v.replaceAll("/", "");
				v2 = v2.replaceAll("/", "");
			} else {
				if ("".equals(v)) continue;
			}
			Map<String, String> m = new HashMap<String, String>();
			m.put("field", f);
			m.put("value", v);
			m.put("value2", v2);
			list.add(m);
		}
		return list;
	}

	/** 고급 동적필터 배열을 화면 복원용 JSON 문자열로 변환한다. (실패 시 빈 배열) */
	private String buildAdvFiltersJson(String[] fields, String[] values, String[] values2) {
		try {
			return new ObjectMapper().writeValueAsString(buildAdvFilterList(fields, values, values2));
		} catch (Exception e) {
			return "[]";
		}
	}
	// [AX Lab] 수정 끝
	
	/**
	 * 처리담당자 관리 목록
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
	 * A/S 등록 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/form.do")
	public String form(@ModelAttribute("vo") AsVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/as/form";
	}
	
	/**
	 * 처라담당자 관리 상세 - 처리담당자 관리 
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
	 * AS 리스트 데이터 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsList.do")
	public void getAsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start3()))) vo.setSearch_start3(vo.getSearch_start3().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end3()))) vo.setSearch_end3(vo.getSearch_end3().replaceAll("/", "")) ;
		
		String[] procSelectArray =  vo.getProcSelect().split(",");
		vo.setProcSelectArray(procSelectArray);
		
		// [AX Lab] 수정 시작 (2026-07-24 AX Lab): 처리구분(나의 A/S) + 고급 동적필터(AND 중복) 조건 조립
		// 나의 A/S(asGubunFlag="2")이면 로그인 사용자 사번을 담당자(ASSIGN_ID) 필터로 사용
		if ("2".equals(SsStringUtil.normalizeNull(vo.getAsGubunFlag())) && adUserInfo != null) {
			vo.setUser_id(SsStringUtil.normalizeNull(adUserInfo.getEmp_no()));
		} else {
			vo.setUser_id("");
		}
		// 고급 동적 검색조건(검색구분 select/keyword/date)을 쿼리용 목록으로 변환
		vo.setAdvFilterList(buildAdvFilterList(vo.getAdv_field(), vo.getAdv_value(), vo.getAdv_value2()));
		// [AX Lab] 수정 끝
		
		// [AX Lab] 수정 시작 (2026-07-29 AX Lab): 목록 헤더클릭 정렬조건 확정 (화이트리스트 검증 필수)
		applyAsSort(vo);
		// [AX Lab] 수정 끝
		
		int totalCount = asService.getTotalCnt(vo,"asDAO.getAsListCnt") ;
		
		if(totalCount > 0){
			logger.debug("pageSize : " + vo.getPageSize());
			logger.debug("startRow : " + vo.getStartRow());
			logger.debug("endRow : " + vo.getEndRow());
			vo.setPaging(totalCount);
			logger.debug("startRow : " + vo.getStartRow());
			logger.debug("endRow : " + vo.getEndRow());
			
			resultList = asService.getList(vo,"asDAO.getAsList") ;
			
			vo.setJson_paging(vo.getJsonPaging("getAsList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		// [AX Lab] 수정 시작 (2026-07-28 AX Lab): 상단 KPI 6종을 목록 응답에 동봉.
		// (신규 전용 URL은 MenuAuthFilter 권한목록 미등록으로 403 차단되므로, 권한 있는 getAsList.do 응답에 태운다)
		// KPI는 항상 "나에게 배정된 건" 기준이므로 목록 검색필터와 무관하게 reg_id(=로그인 사번)를 세팅 후 조회.
		if (adUserInfo != null) {
			vo.setReg_id(SsStringUtil.normalizeNull(adUserInfo.getEmp_no())) ;
		}
		returnMap.put("kpi", commonDAO.selectOne(vo, "asDAO.getAswsKpi")) ;
		// [AX Lab] 수정 끝
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	// [AX Lab] 삭제 (2026-07-28 AX Lab): 전용 엔드포인트 /ad/as/getAswsKpi.do 는 MenuAuthFilter 권한목록(CRM_ROLE_PROG)
	//           미등록으로 항상 403 차단됨. KPI는 권한 있는 getAsList.do 응답에 동봉하는 방식으로 대체하여 이 메서드는 제거함.
	//           (KPI 집계 쿼리 asDAO.getAswsKpi 는 getAsList 에서 재사용하므로 유지)
	
	/**
	 * 고객사 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsCustMaster.do")
	public void getCustMaster(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		asService.getAsCustInfo(vo) ; 
		returnMap.put("resultList", vo.getOUTCURSOR()) ; 
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * AS 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/proc.do")
	public String proc(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ; 
		String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim() ; 
		List<FileVO> fileList = null ;
		List<AsVO> resultList = null ;
		int returnValue = 0 ;
		String script = "" ;
		String a = "" ;
		
		if("C011".equals(SsStringUtil.normalizeNull(vo.getRequest_type()))) {
			vo.setService_cate("P010") ;
		}

		if("insertcopy".equals(pageType)) {pageType = "insert";  vo.setPageType("insert");};
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))) vo.setProc_dt(vo.getProc_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getComplete_dt()))) vo.setComplete_dt(vo.getComplete_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAccept_dt()))) vo.setAccept_dt(vo.getAccept_dt().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getAccept_time()))) vo.setAccept_time(vo.getAccept_time().replaceAll(":", "")) ;
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		if(!"delete".equals(pageType)) {
			fileList = commonFileService.uploadFormFile(multiRequest, "as") ;
		}
		
		/* 상태값 변경 로직 */
		
		/* 하위작업 등록을 할때 */
		if (pageType.startsWith("sub")) {
			
			AsVO tempVO = new AsVO();
			
			if("subUpdate".equals(pageType)) {
				tempVO.setAs_no(vo.getAs_no());				/**	cn_as_no	*/
				tempVO.setCn_as_no(vo.getCn_as_no());	/**	as_no		*/
				tempVO.setSearch_type1("selfExcept");
			}else {
				tempVO.setAs_no(vo.getAs_no());			/**	cn_as_no	*/
			}
			
			resultList = asService.getList(tempVO, "asDAO.getCnAsList") ;
			
			String statusArray[] = new String[resultList.size()+1];
			statusArray[0] = vo.getProc_status();
			
			if (resultList != null && resultList.size()>0) {
				for (int i=0; i<resultList.size(); i++) {
					AsVO temp = resultList.get(i) ; 
					statusArray[i+1]  = temp.getProc_status();
				}
			}
			
			if(Arrays.asList(statusArray).contains("C002")){ 
				if(Arrays.asList(statusArray).contains("C004")) tempVO.setProc_status("C004");
				else tempVO.setProc_status("C002");
			}else if(Arrays.asList(statusArray).contains("C003")){
				if(Arrays.asList(statusArray).contains("C004")) tempVO.setProc_status("C004");
				else tempVO.setProc_status("C003");
			}else if(Arrays.asList(statusArray).contains("C004")){
				tempVO.setProc_status("C004");
			}else if(Arrays.asList(statusArray).contains("C005")){
				tempVO.setProc_status("C005");
			} else {
				tempVO.setProc_status(vo.getProc_status());
			}
			
			/* 원건 상태값 업데이트 (1건이라도 있을때) */
			vo.setProc_status2(tempVO.getProc_status());
			vo.setAs_no2(vo.getAs_no());
			
		}
		
		if("insert".equals(pageType)) {
			vo.setAs_no((String)commonDAO.selectOne(vo, "asDAO.getMaxSeq"));
		}
		if("subInsert".equals(pageType)) {
			vo.setCn_as_no(vo.getAs_no());
			vo.setAs_no((String)commonDAO.selectOne(vo, "asDAO.getMaxSubSeq"));
		}
		
		
		
		if ("insert".equals(pageType)) returnValue = asService.insertAsInfo(vo, request, fileList) ;	
		else if ("update".equals(pageType)) returnValue = asService.updateAsInfo(vo, request, fileList, adUserInfo) ;
		else if ("subInsert".equals(pageType)) returnValue = asService.insertAsCnInfo(vo, request, fileList) ;
		else if ("subUpdate".equals(pageType)) returnValue = asService.updateAsCnInfo(vo, request, fileList, adUserInfo) ;
		
		String param_as_no = SsStringUtil.normalizeNull(vo.getAs_no());  
		String param_cn_as_no = SsStringUtil.normalizeNull(vo.getCn_as_no());
		String save_gubun = SsStringUtil.normalizeNull(vo.getSave_gubun());
		if(returnValue > 0) script = "parent.procReturn('success','"+ param_as_no +"','" +pageType+"','"+param_cn_as_no +"','" +save_gubun+"');" ;
		else script = "parent.procReturn('fail');" ;
		
		return CommonExecute.execute(model, script);
	}
	
	
	
	@RequestMapping(value = "/ad/as/updateProcDetailByChecked.do")
	public String updateProcDetailByChecked(
	        @ModelAttribute("vo") AsVO vo,
	        ModelMap model,
	        HttpServletRequest request,
	        HttpServletResponse response,
	        HttpSession session) throws Exception {

	    UserVO adUserInfo = (UserVO) session.getAttribute("adUserInfo");

	    if (adUserInfo == null) {
	        return CommonExecute.execute(model, "parent.procReturn('session');");
	    }

	    String pageType = SsStringUtil.normalizeNull(vo.getPageType()).trim();
	    String script = "";

	    List<String> successList = new ArrayList<>();
	    List<String> failList = new ArrayList<>();

	    // 날짜 정리
	    if (!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))) {
	        vo.setProc_dt(vo.getProc_dt().replaceAll("/", ""));
	    }
	    if (!"".equals(SsStringUtil.normalizeNull(vo.getComplete_dt()))) {
	        vo.setComplete_dt(vo.getComplete_dt().replaceAll("/", ""));
	    }

	    // 공통 세팅
	    vo.setUpd_id(adUserInfo.getEmp_no());
	    vo.setReg_id(adUserInfo.getEmp_no());
	    vo.setW_id(adUserInfo.getEmp_no());
	    vo.setAssign_id(adUserInfo.getEmp_no());
	    vo.setW_content(vo.getW_content_pop());
	    vo.setW_gubun("A");

	    // 체크된 AS 목록
	    String asNoLink = SsStringUtil.normalizeNull(vo.getAs_no_link()).trim();

	    List<String> asNoList = Arrays.stream(asNoLink.split(","))
	            .map(String::trim)
	            .filter(s -> !s.isEmpty())
	            .collect(Collectors.toList());

	    int returnValue = 0;
	    boolean isFirst = true;
	    

	    for (String asNo : asNoList) {
	        try {
	            vo.setAs_no(asNo);
	            
	            commonDAO.update(vo, "asDAO.updateAsNoLinkToBlankByAsNo");
	            
	            String curProcStatus = SsStringUtil.normalizeNull((String) commonDAO.selectOne(vo, "asDAO.selectProcStatusByAsNo"));
	            
	            //조치이력추가 : 연결된 접수번호
	            vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	            vo.setProc_status("C005");
        	    vo.setAction_content2(vo.getAs_no_link());
        	    commonDAO.insert(vo, "asDAO.insertAsInfoHist2");
	            
	            if ("C005".equals(curProcStatus)) {
	                continue;
	            }
	            
	            returnValue += asService.updateAsInfoAll(vo, request, null, adUserInfo);
	            
	            // ✅ 첫 건 처리 끝난 뒤부터는 work_time을 0으로 고정
	            if (isFirst) {
	                isFirst = false;
	                vo.setWork_time("0");
	            }
	            

	            // 답변 처리도 Service에서 하게 만들거나
	            // 여기서 유지하고 싶으면 유지
	            asService.insertAws(vo, request);

	            successList.add(asNo);

	        } catch (Exception e) {
	            failList.add(asNo);
	            continue;
	        }
	    }

	    script =
	        "parent.procReturn('batch'," +
	        "'" + String.join(",", successList) + "'," +
	        "'" + String.join(",", failList) + "','" +
	        pageType + "');";

	    return CommonExecute.execute(model, script);
	}
	
	
	
	/**
	 * AS 관리 - 조치이력 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsHistList.do")
	public void getAsHistList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		AsVO resultVO = asService.getSelectInfo(vo, "asDAO.getAsInfo") ;
		
		returnMap.put("resultVO", resultVO) ;
		
		if(resultVO != null) {
			returnMap.put("asHistList", asService.getList(vo, "asDAO.getAsHistList")) ; 
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * AS 관리 -  조치이력 수정
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/histProc.do")
	public void histProc(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		String returnCode = "" ; 
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		int returnValue = 0;
		if("updateHistActionContent".equals(vo.getPageType())) {
			returnValue = asService.updateAsHistAction(vo) ;
		} else if("deleteFileSeqHist".equals(vo.getPageType())) {
			returnValue = asService.updateAsHistFileSeq(vo) ;
			FileVO fileVO = new FileVO();
			if(!"0".equals(SsStringUtil.normalize(vo.getFile_seq(), "0"))) {
				fileVO.setAttach_seq(Integer.parseInt(vo.getFile_seq()));
				returnValue += commonFileService.deleteFileByAttachSeq(fileVO) ;
			}
	// [AX Lab] 수정 시작 (2026-07-30 AX Lab): AS 통합화면 인라인 처리(조치내용 작성 / 처리상태 변경 / 담당자 이관).
	//   ★ 신규 URL 을 만들지 않고 기존 histProc.do 에 pageType 을 추가하는 이유는
	//     MenuAuthFilter 가 acceptUrlList 와 완전일치 비교만 해서 신규 /ad/as/*.do 가 403 이 되기 때문이다.
	//     (awsProc.do 의 insert/update/delete, histProc.do 의 updateHistActionContent 와 같은 기존 관례)
	} else if("insertAction".equals(vo.getPageType())
			|| "changeStatus".equals(vo.getPageType())
			|| "transferAssign".equals(vo.getPageType())) {
		returnValue = procAswsInline(vo, userInfo) ;
	} else if("saveAction".equals(vo.getPageType())) {
		// [AX Lab] 수정 시작 (2026-07-31 AX Lab): 처리 탭 통합 저장 (처리상태 + 담당자 + 조치메모 한 번에).
		//   기존 changeStatus/transferAssign 를 각각 모달로 처리하던 것을
		//   처리 탭 단일 폼으로 통합하면서 추가한 pageType.
		returnValue = procAswsSaveAction(vo, userInfo) ;
		// [AX Lab] 수정 끝
	// [AX Lab] 수정 끝
	// [AX Lab] 수정 시작 (2026-07-31 AX Lab): AS 통합화면 아코디언 그룹별 인라인 편집(접수정보/고객사정보/
	//   문의유형정보/처리완료사항/처리완료 상세사항). 기존 updateAsInfoAll 은 건드리지 않고
	//   egov-combine-as-thread-query.xml 의 새 쿼리(그룹별 부분 UPDATE)만 사용한다.
	} else if("saveAccept".equals(vo.getPageType())) {
		returnValue = procAswsSaveAccept(vo, userInfo) ;
	} else if("saveCust".equals(vo.getPageType())) {
		returnValue = procAswsSaveCust(vo, userInfo) ;
	} else if("saveInquiry".equals(vo.getPageType())) {
		returnValue = procAswsSaveInquiry(vo, userInfo) ;
	} else if("saveDone".equals(vo.getPageType())) {
		returnValue = procAswsSaveDone(vo, userInfo) ;
	} else if("saveDoneDt".equals(vo.getPageType())) {
		returnValue = procAswsSaveDoneDt(vo, userInfo) ;
	} else if("saveProcExtra".equals(vo.getPageType())) {
		/* 중요도/전화확인/전화부재중 즉시 저장 (필드 클릭 즉시 수정 UX).
		   처리상태·담당자와 달리 조치메모 없이 저장하며 이력도 남기지 않는다
		   (원본 화면(form.jsp)도 이 필드들은 이력 없이 마스터만 갱신). */
		returnValue = procAswsSaveProcExtra(vo, userInfo) ;
	// [AX Lab] 수정 끝
	}

		if(returnValue > 0) returnCode = "000" ;

		returnMap.put("returnCode", returnCode) ;
		CommonExecute.returnJson(response, returnMap);
	}


	// [AX Lab] 수정 시작 (2026-07-30 AX Lab): AS 통합화면 인라인 처리 공통 로직.
	/**
	 * 이관 코멘트 식별 접두어.
	 *
	 * CRM_AS_MGT_HIST 에는 "이 행이 이관인지"를 구분하는 컬럼도, 이관 코멘트 전용 컬럼도 없다.
	 * (컬럼: SEQ / AS_NO / PROC_DT / ACCEPTOR / PROC_STATUS / ACTION_CONTENT / FILE_SEQ /
	 *        REG_DATE / REG_ID / INPORTANCE / REQUEST_TYPE / SERVICE_CATE / INQUIRY_TYPE)
	 * 그래서 DDL 없이 ACTION_CONTENT 앞에 이 접두어를 붙여 저장하고, 화면(combine-as-thread.js)에서
	 * 접두어를 떼어 이관 코멘트로 표시한다. "이관 전 담당자"는 직전 이력행의 ACCEPTOR 로 유추한다.
	 * 추후 HIST_TYPE / FROM_ASSIGN_ID / TRANSFER_COMMENT 컬럼이 생기면 이 상수와
	 * procAswsInline() 의 transferAssign 분기, JS 의 어댑터만 교체하면 된다.
	 */
	private static final String ASWS_TRANSFER_PREFIX = "[이관] " ;

	/**
	 * AS 통합화면(list.jsp) 의 인라인 처리.
	 *
	 * pageType
	 *  - insertAction   : 조치내용만 단독 추가. CRM_AS_MGT 는 건드리지 않고 이력만 남긴다.
	 *  - changeStatus   : 처리상태 / 처리예정일 변경 + 이력.
	 *  - transferAssign : 배정담당자 변경(이관) + 이관 코멘트 이력.
	 *
	 * ★ changeStatus 가 현재 행을 먼저 읽어서 통째로 다시 넣는 이유:
	 *   updateAsInfoAll 은 부분 UPDATE 가 아니라 20여 개 컬럼을 무조건 덮어쓴다.
	 *   화면이 보낸 3~4개 값만 담아 호출하면 원인유형/조치유형/작업시간/처리완료 상세 등이
	 *   전부 NULL 로 지워진다. 그래서 getAsInfo 로 현재 값을 읽어 복사한 뒤 바뀐 값만 덮어쓴다.
	 *   (신규 쿼리를 만들지 않고 egov-as-query.xml 을 무수정으로 두기 위한 선택이다)
	 *
	 * @return 처리 건수 (0 이면 실패)
	 */
	private int procAswsInline(AsVO vo, UserVO userInfo) throws Exception {

		String pageType = SsStringUtil.normalizeNull(vo.getPageType()) ;
		String asNo     = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		String comment  = SsStringUtil.normalizeNull(vo.getAction_content()).trim() ;

		if("".equals(asNo) || "".equals(comment) || userInfo == null) return 0 ;

		AsVO curKey = new AsVO() ;
		curKey.setAs_no(asNo) ;
		AsVO cur = asService.getSelectInfo(curKey, "asDAO.getAsInfo") ;
		if(cur == null) return 0 ;

		String empNo = SsStringUtil.normalizeNull(userInfo.getEmp_no()) ;

		/** 이력에 남길 값. 기본값은 "현재 상태 그대로" 이고 각 분기에서 바뀐 값만 덮어쓴다. */
		AsVO hist = new AsVO() ;
		hist.setAs_no(asNo) ;
		hist.setProc_dt(SsStringUtil.normalizeNull(cur.getProc_dt())) ;
		hist.setProc_status(SsStringUtil.normalizeNull(cur.getProc_status())) ;
		hist.setInportance(SsStringUtil.normalizeNull(cur.getInportance())) ;
		hist.setRequest_type(SsStringUtil.normalizeNull(cur.getRequest_type())) ;
		hist.setService_cate(SsStringUtil.normalizeNull(cur.getService_cate())) ;
		hist.setInquiry_type(SsStringUtil.normalizeNull(cur.getInquiry_type())) ;
		hist.setAssign_id(SsStringUtil.normalizeNull(cur.getAssign_id())) ;	/* ACCEPTOR = 인수자 */
		hist.setAttach_seq2(0) ;											/* FILE_SEQ  = 첨부 없음 */
		hist.setReg_id(empNo) ;
		hist.setAction_content(comment) ;

		int returnValue = 0 ;

		if("changeStatus".equals(pageType)) {

			/* ※ 중요도(INPORTANCE)는 updateAsInfoAll 의 SET 절에 없어서 이 경로로는 바꿀 수 없다.
			      그래서 상태변경 모달은 처리상태 / 처리예정일 / 조치의견만 다루고,
			      중요도 변경은 기존 상세페이지(form.do)에 그대로 위임한다. */
			String newStatus = SsStringUtil.normalizeNull(vo.getProc_status()).trim() ;
			String newProcDt = SsStringUtil.normalizeNull(vo.getProc_dt()).replaceAll("/", "").trim() ;

			if("".equals(newStatus)) return 0 ;

			/* updateAsInfoAll 이 덮어쓰는 모든 컬럼을 현재 값으로 채운다.
			   ※ BeanUtils.copyProperties 를 쓰지 않는 이유: PagingVO 에 getPaging():String 과
			      setPaging(int) 가 공존해서 String→int 변환 예외가 발생한다. */
			AsVO upd = new AsVO() ;
			upd.setAs_no(asNo) ;
			upd.setPageType("") ;					/* updateAsInfoAll 의 subUpdate 분기(CN_AS_NO 조건) 회피 */
			upd.setReg_id(empNo) ;					/* UPT_ID */
			upd.setTel_confirm(SsStringUtil.normalizeNull(cur.getTel_confirm())) ;
			upd.setProc_dt(SsStringUtil.normalizeNull(cur.getProc_dt())) ;
			upd.setProc_time(SsStringUtil.normalizeNull(cur.getProc_time())) ;
			upd.setCause_type(SsStringUtil.normalizeNull(cur.getCause_type())) ;
			upd.setAction_type(SsStringUtil.normalizeNull(cur.getAction_type())) ;
			upd.setAssign_id(SsStringUtil.normalizeNull(cur.getAssign_id())) ;
			upd.setAttach_seq2(cur.getAttach_seq2()) ;
			upd.setWork_time(SsStringUtil.normalizeNull(cur.getWork_time())) ;
			upd.setComplete_dt(SsStringUtil.normalizeNull(cur.getComplete_dt())) ;
			upd.setProc_gubun(SsStringUtil.normalizeNull(cur.getProc_gubun())) ;
			upd.setProc_build_info(SsStringUtil.normalizeNull(cur.getProc_build_info())) ;
			upd.setProc_test_info(SsStringUtil.normalizeNull(cur.getProc_test_info())) ;
			upd.setProc_process_sp(SsStringUtil.normalizeNull(cur.getProc_process_sp())) ;
			upd.setProc_screen_sp(SsStringUtil.normalizeNull(cur.getProc_screen_sp())) ;
			upd.setProc_table_sp(SsStringUtil.normalizeNull(cur.getProc_table_sp())) ;
			upd.setProc_function_sp(SsStringUtil.normalizeNull(cur.getProc_function_sp())) ;
			upd.setProc_interface_sp(SsStringUtil.normalizeNull(cur.getProc_interface_sp())) ;
			upd.setProc_status(newStatus) ;
			upd.setAction_content(comment) ;
			if(!"".equals(newProcDt)) upd.setProc_dt(newProcDt) ;

			returnValue = commonDAO.update(upd, "asDAO.updateAsInfoAll") ;

			if(returnValue > 0) {
				hist.setProc_status(newStatus) ;
				if(!"".equals(newProcDt)) hist.setProc_dt(newProcDt) ;
			}

		} else if("transferAssign".equals(pageType)) {

			String newAssignId = SsStringUtil.normalizeNull(vo.getAssign_id()).trim() ;

			if("".equals(newAssignId)) return 0 ;
			if(newAssignId.equals(SsStringUtil.normalizeNull(cur.getAssign_id()).trim())) return 0 ;

			AsVO assignVO = new AsVO() ;
			assignVO.setAs_no(asNo) ;
			assignVO.setAssign_id(newAssignId) ;

			returnValue = commonDAO.update(assignVO, "asDAO.updateAssignIdSingle") ;

			if(returnValue > 0) {
				/* 이관은 담당자만 바꾼다. 처리상태까지 같이 바꾸면 이력행의 PROC_STATUS 와
				   마스터의 PROC_STATUS 가 어긋나므로 상태 변경은 별도 동작으로 분리한다. */
				hist.setAssign_id(newAssignId) ;								/* ACCEPTOR = 인수자 */
				hist.setAction_content(ASWS_TRANSFER_PREFIX + comment) ;
			}

		} else {
			/* insertAction : 이력만 추가한다. 마스터(CRM_AS_MGT)는 건드리지 않는다. */
			returnValue = 1 ;
		}

		if(returnValue > 0) {
			hist.setSeq(String.valueOf(commonDAO.selectOneInt(hist, "asDAO.getAsHistMaxSeq"))) ;
			commonDAO.insert(hist, "asDAO.insertAsInfoHist") ;
		}

		return returnValue ;
	}
	// [AX Lab] 수정 끝


	// [AX Lab] 수정 시작 (2026-07-31 AX Lab): 처리 탭 통합 저장 로직.
	/**
	 * AS 통합화면 처리 탭 — 처리상태 · 담당자 · 조치메모를 한 번에 저장한다.
	 *
	 * 기존에는 '처리상태 변경' 과 '담당자 이관' 이 각각 별도 모달(changeStatus / transferAssign)이었다.
	 * 통합 처리 탭으로 합치면서 아래 규칙으로 동작한다.
	 *
	 * ① 처리상태 또는 담당자가 변경된 경우:
	 *    updateAsInfoAll 로 마스터 1회 업데이트 (read-modify-write 패턴은 changeStatus 분기와 동일).
	 *    updateAsInfoAll 이 PROC_STATUS 와 ASSIGN_ID 를 모두 덮어쓰므로 두 번 호출할 필요 없다.
	 * ② 아무것도 바뀌지 않은 "메모만" 케이스: 마스터는 건드리지 않고 이력만 추가한다.
	 * ③ 담당자가 바뀌면 이력 ACTION_CONTENT 에 ASWS_TRANSFER_PREFIX 를 붙여 이관 이벤트로 식별한다.
	 *    (JS 의 CAWS_TR_PREFIX 상수와 반드시 같아야 한다)
	 *
	 * @return 처리 건수 (0 이면 실패)
	 */
	private int procAswsSaveAction(AsVO vo, UserVO userInfo) throws Exception {

		String asNo    = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		String comment = SsStringUtil.normalizeNull(vo.getAction_content()).trim() ;

		if("".equals(asNo) || "".equals(comment) || userInfo == null) return 0 ;

		AsVO curKey = new AsVO() ;
		curKey.setAs_no(asNo) ;
		AsVO cur = asService.getSelectInfo(curKey, "asDAO.getAsInfo") ;
		if(cur == null) return 0 ;

		String empNo     = SsStringUtil.normalizeNull(userInfo.getEmp_no()) ;
		String newStatus = SsStringUtil.normalizeNull(vo.getProc_status()).trim() ;
		String newProcDt = SsStringUtil.normalizeNull(vo.getProc_dt()).replaceAll("/", "").trim() ;
		String newAssign = SsStringUtil.normalizeNull(vo.getAssign_id()).trim() ;

		String curStatus = SsStringUtil.normalizeNull(cur.getProc_status()).trim() ;
		String curAssign = SsStringUtil.normalizeNull(cur.getAssign_id()).trim() ;

		boolean statusChanged = !"".equals(newStatus) && !newStatus.equals(curStatus) ;
		boolean assignChanged = !"".equals(newAssign) && !newAssign.equals(curAssign) ;

		// [AX Lab] 수정 시작 (2026-07-31 AX Lab): 처리상태사항 편집폼에 중요도/전화확인/전화부재중 추가.
		//   updateAsInfoAll 의 SET 절에는 이 3개 컬럼이 없어 위 read-modify-write 로는 반영이 안 되므로,
		//   egov-combine-as-thread-query.xml 의 updateAsProcExtra(부분 UPDATE) 로 별도 처리한다.
		String newGrade = SsStringUtil.normalizeNull(vo.getInportance()).trim() ;
		String curGrade = SsStringUtil.normalizeNull(cur.getInportance()).trim() ;
		boolean gradeChanged = !"".equals(newGrade) && !newGrade.equals(curGrade) ;
		// [AX Lab] 수정 끝

		/* 이력 기본값 — 변경된 값은 아래에서 덮어쓴다 */
		AsVO hist = new AsVO() ;
		hist.setAs_no(asNo) ;
		hist.setProc_dt(SsStringUtil.normalizeNull(cur.getProc_dt())) ;
		hist.setProc_status(curStatus) ;
		hist.setInportance(SsStringUtil.normalizeNull(cur.getInportance())) ;
		hist.setRequest_type(SsStringUtil.normalizeNull(cur.getRequest_type())) ;
		hist.setService_cate(SsStringUtil.normalizeNull(cur.getService_cate())) ;
		hist.setInquiry_type(SsStringUtil.normalizeNull(cur.getInquiry_type())) ;
		hist.setAssign_id(curAssign) ;
		hist.setAttach_seq2(0) ;
		hist.setReg_id(empNo) ;
		hist.setAction_content(comment) ;

		int returnValue = 1 ;		/* 메모만 남기는 케이스(상태/담당자 모두 그대로)도 이력 추가는 성공 */

		if(statusChanged || assignChanged) {

			/* read-modify-write : updateAsInfoAll 이 20여 개 컬럼을 무조건 덮어쓰므로
			   현재 값을 먼저 복사한 뒤 바뀐 값만 교체한다. (changeStatus 분기와 동일한 패턴) */
			AsVO upd = new AsVO() ;
			upd.setAs_no(asNo) ;
			upd.setPageType("") ;					/* subUpdate 분기(CN_AS_NO 조건) 회피 */
			upd.setReg_id(empNo) ;
			upd.setTel_confirm(SsStringUtil.normalizeNull(cur.getTel_confirm())) ;
			upd.setProc_dt(SsStringUtil.normalizeNull(cur.getProc_dt())) ;
			upd.setProc_time(SsStringUtil.normalizeNull(cur.getProc_time())) ;
			upd.setCause_type(SsStringUtil.normalizeNull(cur.getCause_type())) ;
			upd.setAction_type(SsStringUtil.normalizeNull(cur.getAction_type())) ;
			upd.setAssign_id(curAssign) ;
			upd.setAttach_seq2(cur.getAttach_seq2()) ;
			upd.setWork_time(SsStringUtil.normalizeNull(cur.getWork_time())) ;
			upd.setComplete_dt(SsStringUtil.normalizeNull(cur.getComplete_dt())) ;
			upd.setProc_gubun(SsStringUtil.normalizeNull(cur.getProc_gubun())) ;
			upd.setProc_build_info(SsStringUtil.normalizeNull(cur.getProc_build_info())) ;
			upd.setProc_test_info(SsStringUtil.normalizeNull(cur.getProc_test_info())) ;
			upd.setProc_process_sp(SsStringUtil.normalizeNull(cur.getProc_process_sp())) ;
			upd.setProc_screen_sp(SsStringUtil.normalizeNull(cur.getProc_screen_sp())) ;
			upd.setProc_table_sp(SsStringUtil.normalizeNull(cur.getProc_table_sp())) ;
			upd.setProc_function_sp(SsStringUtil.normalizeNull(cur.getProc_function_sp())) ;
			upd.setProc_interface_sp(SsStringUtil.normalizeNull(cur.getProc_interface_sp())) ;
			upd.setProc_status(statusChanged ? newStatus : curStatus) ;
			upd.setAction_content(comment) ;
			if(statusChanged && !"".equals(newProcDt)) upd.setProc_dt(newProcDt) ;
			if(assignChanged) upd.setAssign_id(newAssign) ;

			returnValue = commonDAO.update(upd, "asDAO.updateAsInfoAll") ;

			if(returnValue > 0) {
				if(statusChanged) {
					hist.setProc_status(newStatus) ;
					if(!"".equals(newProcDt)) hist.setProc_dt(newProcDt) ;
				}
				if(assignChanged) {
					hist.setAssign_id(newAssign) ;
					hist.setAction_content(ASWS_TRANSFER_PREFIX + comment) ;
				}
			}
		}

		// [AX Lab] 수정 시작 (2026-07-31 AX Lab): 중요도/전화확인/전화부재중 저장.
		//   updateAsInfoAll 과 별도 쿼리라 실패해도 위에서 이미 커밋된 상태변경까지 되돌리지는 않는다
		//   (커밋 단위는 함수 전체 트랜잭션이므로 return 0 이면 전체 롤백된다. 정상 케이스만 고려).
		if(returnValue > 0) {
			AsVO extra = new AsVO() ;
			extra.setAs_no(asNo) ;
			extra.setReg_id(empNo) ;
			extra.setInportance(gradeChanged ? newGrade : curGrade) ;
			extra.setTel_confirm(SsStringUtil.normalize(vo.getTel_confirm(), SsStringUtil.normalizeNull(cur.getTel_confirm()))) ;
			extra.setTel_absence(SsStringUtil.normalize(vo.getTel_absence(), SsStringUtil.normalizeNull(cur.getTel_absence()))) ;
			extra.setTel_absence_cnt(SsStringUtil.normalize(vo.getTel_absence_cnt(), SsStringUtil.normalizeNull(cur.getTel_absence_cnt()))) ;
			commonDAO.update(extra, "asDAO.updateAsProcExtra") ;
			if(gradeChanged) hist.setInportance(newGrade) ;
		}
		// [AX Lab] 수정 끝

		if(returnValue > 0) {
			hist.setSeq(String.valueOf(commonDAO.selectOneInt(hist, "asDAO.getAsHistMaxSeq"))) ;
			commonDAO.insert(hist, "asDAO.insertAsInfoHist") ;
		}

		return returnValue ;
	}
	// [AX Lab] 수정 끝


	// [AX Lab] 수정 시작 (2026-07-31 AX Lab): AS 통합화면 아코디언 그룹별 인라인 편집 저장.
	//   접수정보/고객사정보/문의유형정보/처리완료사항/처리완료 상세사항 — 5개 그룹.
	//   각 그룹은 egov-combine-as-thread-query.xml 의 "그 그룹 컬럼만 SET 하는" 좁은 쿼리를 쓴다.
	//   (updateAsInfoAll 처럼 전체 덮어쓰기가 아니므로 read-modify-write 가 필요 없다)
	//   ★ 원본 화면(form.jsp)도 이 필드들을 저장할 때 CRM_AS_MGT_HIST 에 이력을 남기지 않으므로,
	//     여기서도 동일하게 이력 없이 마스터만 갱신한다(처리상태사항 편집만 이력을 남기는 기존 규칙 유지).

	/** 접수정보 — 접수경로 */
	private int procAswsSaveAccept(AsVO vo, UserVO userInfo) throws Exception {
		String asNo = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		if("".equals(asNo) || userInfo == null) return 0 ;

		AsVO upd = new AsVO() ;
		upd.setAs_no(asNo) ;
		upd.setReg_id(userInfo.getEmp_no()) ;
		upd.setAccept_route(SsStringUtil.normalizeNull(vo.getAccept_route()).trim()) ;

		return commonDAO.update(upd, "asDAO.updateAsAccept") ;
	}

	/** 고객사정보 — 실신청자명 / 연락처 / SMS수신동의 */
	private int procAswsSaveCust(AsVO vo, UserVO userInfo) throws Exception {
		String asNo = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		if("".equals(asNo) || userInfo == null) return 0 ;

		AsVO upd = new AsVO() ;
		upd.setAs_no(asNo) ;
		upd.setReg_id(userInfo.getEmp_no()) ;
		upd.setRl_apply_nm(SsStringUtil.normalizeNull(vo.getRl_apply_nm()).trim()) ;
		upd.setApply_tel(SsStringUtil.normalizeNull(vo.getApply_tel()).trim()) ;
		upd.setSend_sms(SsStringUtil.normalizeNull(vo.getSend_sms()).trim()) ;

		return commonDAO.update(upd, "asDAO.updateAsCust") ;
	}

	/** 문의유형정보 — 문의유형 / 시스템(대) / 시스템(소) / 요청내용
	 *  ★ 일반 담당자(as_admin != 'Y')는 원본 화면(form.jsp)과 동일하게 문의유형/시스템유형을 바꿀 수 없다.
	 *    화면에서도 select 를 비활성화하지만, 우회 호출을 막기 위해 서버에서도 한 번 더 확인한다. */
	private int procAswsSaveInquiry(AsVO vo, UserVO userInfo) throws Exception {
		String asNo = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		if("".equals(asNo) || userInfo == null) return 0 ;

		AsVO curKey = new AsVO() ;
		curKey.setAs_no(asNo) ;
		curKey.setReg_id(userInfo.getEmp_no()) ;
		AsVO cur = asService.getSelectInfo(curKey, "asDAO.getAsInfo") ;
		if(cur == null) return 0 ;

		boolean isAdmin = "Y".equals(SsStringUtil.normalizeNull(cur.getAs_admin())) ;

		AsVO upd = new AsVO() ;
		upd.setAs_no(asNo) ;
		upd.setReg_id(userInfo.getEmp_no()) ;
		if(isAdmin) {
			upd.setRequest_type(SsStringUtil.normalizeNull(vo.getRequest_type()).trim()) ;
			upd.setService_cate(SsStringUtil.normalizeNull(vo.getService_cate()).trim()) ;
			upd.setInquiry_type(SsStringUtil.normalizeNull(vo.getInquiry_type()).trim()) ;
		} else {
			/* 권한이 없으면 3개 필드는 현재 값을 그대로 유지하고, 요청내용만 반영한다 */
			upd.setRequest_type(SsStringUtil.normalizeNull(cur.getRequest_type())) ;
			upd.setService_cate(SsStringUtil.normalizeNull(cur.getService_cate())) ;
			upd.setInquiry_type(SsStringUtil.normalizeNull(cur.getInquiry_type())) ;
		}
		upd.setCall_content(SsStringUtil.normalizeNull(vo.getCall_content()).trim()) ;

		return commonDAO.update(upd, "asDAO.updateAsInquiry") ;
	}

	/** 처리완료사항 — 처리예정일자/시각 / 원인유형 / 조치유형 / 작업시간 / 처리완료일자 */
	private int procAswsSaveDone(AsVO vo, UserVO userInfo) throws Exception {
		String asNo = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		if("".equals(asNo) || userInfo == null) return 0 ;

		AsVO upd = new AsVO() ;
		upd.setAs_no(asNo) ;
		upd.setReg_id(userInfo.getEmp_no()) ;
		upd.setProc_dt(SsStringUtil.normalizeNull(vo.getProc_dt()).replaceAll("/", "").trim()) ;
		upd.setProc_time(SsStringUtil.normalizeNull(vo.getProc_time()).trim()) ;
		upd.setCause_type(SsStringUtil.normalizeNull(vo.getCause_type()).trim()) ;
		upd.setAction_type(SsStringUtil.normalizeNull(vo.getAction_type()).trim()) ;
		upd.setWork_time(SsStringUtil.normalizeNull(vo.getWork_time()).trim()) ;
		upd.setComplete_dt(SsStringUtil.normalizeNull(vo.getComplete_dt()).replaceAll("/", "").trim()) ;

		return commonDAO.update(upd, "asDAO.updateAsDone") ;
	}

	/** 처리완료 상세사항 — 처리구분 / 빌드순번 / 각종 정의서 (개발팀 참고용) */
	private int procAswsSaveDoneDt(AsVO vo, UserVO userInfo) throws Exception {
		String asNo = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		if("".equals(asNo) || userInfo == null) return 0 ;

		AsVO upd = new AsVO() ;
		upd.setAs_no(asNo) ;
		upd.setReg_id(userInfo.getEmp_no()) ;
		upd.setProc_gubun(SsStringUtil.normalizeNull(vo.getProc_gubun()).trim()) ;
		upd.setProc_build_info(SsStringUtil.normalizeNull(vo.getProc_build_info()).trim()) ;
		upd.setProc_test_info(SsStringUtil.normalizeNull(vo.getProc_test_info()).trim()) ;
		upd.setProc_process_sp(SsStringUtil.normalizeNull(vo.getProc_process_sp()).trim()) ;
		upd.setProc_screen_sp(SsStringUtil.normalizeNull(vo.getProc_screen_sp()).trim()) ;
		upd.setProc_table_sp(SsStringUtil.normalizeNull(vo.getProc_table_sp()).trim()) ;
		upd.setProc_function_sp(SsStringUtil.normalizeNull(vo.getProc_function_sp()).trim()) ;
		upd.setProc_interface_sp(SsStringUtil.normalizeNull(vo.getProc_interface_sp()).trim()) ;

		return commonDAO.update(upd, "asDAO.updateAsDoneDt") ;
	}

	/** 처리상태사항 부가필드 — 중요도 / 전화확인 / 전화부재중 (조치메모 불필요, 이력 미기록)
	 *  화면에서 빈 값으로 온 필드는 현재 값을 유지한다(체크박스·select 하나만 바꿔도 안전). */
	private int procAswsSaveProcExtra(AsVO vo, UserVO userInfo) throws Exception {
		String asNo = SsStringUtil.normalizeNull(vo.getAs_no()).trim() ;
		if("".equals(asNo) || userInfo == null) return 0 ;

		AsVO curKey = new AsVO() ;
		curKey.setAs_no(asNo) ;
		AsVO cur = asService.getSelectInfo(curKey, "asDAO.getAsInfo") ;
		if(cur == null) return 0 ;

		AsVO upd = new AsVO() ;
		upd.setAs_no(asNo) ;
		upd.setReg_id(userInfo.getEmp_no()) ;
		upd.setInportance(SsStringUtil.normalize(vo.getInportance(), SsStringUtil.normalizeNull(cur.getInportance()))) ;
		upd.setTel_confirm(SsStringUtil.normalize(vo.getTel_confirm(), SsStringUtil.normalizeNull(cur.getTel_confirm()))) ;
		upd.setTel_absence(SsStringUtil.normalize(vo.getTel_absence(), SsStringUtil.normalizeNull(cur.getTel_absence()))) ;
		upd.setTel_absence_cnt(SsStringUtil.normalize(vo.getTel_absence_cnt(), SsStringUtil.normalizeNull(cur.getTel_absence_cnt()))) ;

		return commonDAO.update(upd, "asDAO.updateAsProcExtra") ;
	}
	// [AX Lab] 수정 끝


	/**
	 * 엑셀처리
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/exl.do")
	public void exl(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		
		String isTab = SsStringUtil.normalize(vo.getIsTab(), "1").trim() ; 
		
		String exl_title = "AS 관리" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setPageType("exl");
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start()))) vo.setSearch_start(vo.getSearch_start().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end()))) vo.setSearch_end(vo.getSearch_end().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_text()))) vo.setSearch_text_arr(vo.getSearch_text().split(" "));
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_start2()))) vo.setSearch_start2(vo.getSearch_start2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_end2()))) vo.setSearch_end2(vo.getSearch_end2().replaceAll("/", "")) ;
		
		String[] procSelectArray =  vo.getProcSelect().split(",");
		vo.setProcSelectArray(procSelectArray);
	
		// [AX Lab] 수정 시작 (2026-07-24 AX Lab): 엑셀도 목록과 동일하게 처리구분(나의 A/S)+고급 동적필터 적용
		if ("2".equals(SsStringUtil.normalizeNull(vo.getAsGubunFlag())) && userInfo != null) {
			vo.setUser_id(SsStringUtil.normalizeNull(userInfo.getEmp_no()));
		} else {
			vo.setUser_id("");
		}
		vo.setAdvFilterList(buildAdvFilterList(vo.getAdv_field(), vo.getAdv_value(), vo.getAdv_value2()));
		// [AX Lab] 수정 끝
	
		// [AX Lab] 수정 시작 (2026-07-29 AX Lab): 화면에서 정렬한 순서 그대로 엑셀이 나오도록 동일한 정렬조건을 적용.
		// 정렬 미지정 시 AS_NO DESC 로 확정되므로 기존 다운로드 결과와 완전히 동일하다.
		applyAsSort(vo);
		// [AX Lab] 수정 끝
	
		List<AsVO> resultList = asService.getList(vo, "asDAO.getAsList");
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		HSSFRow row = null ; 
		HSSFCell cell = null ; 
		
		String[] title = { "No" 
				, "접수번호" 
				, "하위작업" 
				, "처리상태" 
				, "접수일" 
				, "CRM코드"
				, "거래처명"
				, "A/S신청자 이름"
				, "접수경로"
				, "챗봇ID"
				, "문의유형"
				, "시스템(대)"
				, "시스템(소)" 
				, "중요도" 
				, "전화확인 완료"
				, "전화 부재중"
				, "전화 부재중 횟수"
				, "원인유형" 
				, "조치유형" 
				, "부서명"
				, "처리담당자"
				, "처리완료예정일"
				, "처리완료일"
				, "작업시간"
				, "처리구분"
				, "빌드순번"
				, "개발처리서(테스트케이스)"
				, "프로세스정의서"
				, "화면정의서"
				, "테이블정의서"
				, "기능분해도"
				, "인터페이스정의서"
				, "검수일"
				, "고객평가"
				, "요청내용"
				, "조치 및 처리 의견(내부직원만 확인가능)"
				, "내부직원 최신댓글내용"
				
				};
		String[] refColumn = { "rnum" 
				, "as_no" 
				, "cn_as_no" 
				, "proc_status_nm" 
				, "as_accept_dt" 
				, "cust_code"
				, "cust_kor_name"
				, "rl_apply_nm"
				, "accept_route_nm"
				, "chatbot_id"
				, "request_type_nm"
				, "service_cate_nm"
				, "inquiry_type_nm" 
				, "inportance_nm" 
				, "tel_confirm" 
				, "tel_absence" 
				, "tel_absence_cnt" 
				, "cause_type_nm" 
				, "action_type_nm" 
				, "dept_nm"
				, "emp_nm"
				, "as_proc_dt"
				, "as_complete_dt"
				, "work_time"
				, "proc_gubun_nm"
				, "proc_build_info"
				, "proc_test_info"
				, "proc_process_sp"
				, "proc_screen_sp"
				, "proc_table_sp"
				, "proc_function_sp"
				, "proc_interface_sp"
				, "star_state_date"
				, "star_state"
				, "call_content"
				, "action_content"
				, "w_content"
				
				};
		
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		rowNum++  ;
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
		}
		
		if(resultList != null && resultList.size() > 0){
			for(int i = 0 ; i < resultList.size() ; i++){
				AsVO temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				// 접수번호 및 하위 작업에 대한 데이터 보정
				String asNo = temp.getAs_no();
				String cnAsNo = temp.getCn_as_no();
				
				if (SsStringUtil.isDefined(cnAsNo)){
					temp.setAs_no(cnAsNo);
					temp.setCn_as_no(asNo);
				}
				
				for(int a = 0 ; a < title.length ; a++){

					cell = row.createCell(a) ;
					String cellValue = "" ; 

					cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
//						
//						if(a == 0) cellValue = SsStringUtil.normalizeNull(temp.getRnum()) ; 
//						else if(a == 1) cellValue = SsStringUtil.normalizeNull(temp.getAs_no()) ;
//						else if(a == 2) cellValue = SsStringUtil.normalizeNull(temp.getCn_as_no()) ;
//						else if(a == 3) cellValue = SsStringUtil.normalizeNull(temp.getProc_status_nm()) ;
//						else if(a == 4) cellValue = SsStringUtil.normalizeNull(temp.getAccept_dt()) ;
//						else if(a == 5) cellValue = SsStringUtil.normalizeNull(temp.getCust_kor_name()) ;
//						else if(a == 6) cellValue = SsStringUtil.normalizeNull(temp.getService_cate_nm() + "/" + temp.getInquiry_type_nm()); //문의서비스
//						else if(a == 7) cellValue = SsStringUtil.normalizeNull(temp.getInportance_nm()) ;
//						else if(a == 8) cellValue = SsStringUtil.normalizeNull(temp.getCause_type_nm()) ;
//						else if(a == 9) cellValue = SsStringUtil.normalizeNull(temp.getAction_type_nm()) ;
//						else if(a == 10) cellValue = SsStringUtil.normalizeNull(temp.getEmp_nm()) ;
//						else if(a == 11) cellValue = SsStringUtil.normalizeNull(temp.getAws_cnt()) ;
//						else if(a == 12) cellValue = SsStringUtil.normalizeNull(temp.getStar_state_date()) ; //검수일 데이터 확인
//						else if(a == 13) cellValue = SsStringUtil.normalizeNull(temp.getStar_state()) ; //고객평가 데이터 확인
					
					cell.setCellValue(cellValue);
				}
			}
			
			String usrClient = request.getHeader("User-Agent") ; 
			
			exl_title = exl_title + ".xls" ; 
			
			if(usrClient.indexOf("MSIE 5.5") > -1){
				response.setHeader("Content-Disposition", "filename="+ new String(exl_title.getBytes("euc-kr"), "8859_1") + ";");
			}else{
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader("Content-Disposition", "attachment;filename=" + new String(exl_title.getBytes("euc-kr"), "8859_1")+";");
			}
			
			fileOut = response.getOutputStream() ; 
			
			workbook.write(fileOut);
		}
		
		if(fileOut != null) fileOut.close();  
	}
	
	/**
	 * AS 상세 답변내역 리스트 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAwsList.do")
	public void getAwsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		int totalCount = asService.getTotalCnt(vo, "asDAO.getAwsListCnt") ;
		
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = asService.getList(vo, "asDAO.getAwsList");
			vo.setJson_paging(vo.getJsonPaging("getAwsList"));
			
			
			for(int i =0 ; i < totalCount ; i++) {
				if(resultList != null) {
					resultList.get(i).setW_content( resultList.get(i).getW_content().replace("\r\n", "<br>" ));	/*2021.07.18 이설아*/
					
					Map<String , Object> returnMap1 = new HashMap<String , Object>() ;
					FileVO fileVO = new FileVO() ; 
					if(!"0".equals(SsStringUtil.normalize(resultList.get(i).getAttach_seq(), "0"))) {
						fileVO.setAttach_seq(resultList.get(i).getAttach_seq());
						returnMap1.put("attachList", commonFileService.getFileList(fileVO)) ; 
						resultList.get(i).setAmap(returnMap1);
					}
				}
			}
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo", vo) ;
		}
		CommonExecute.returnJson(response, returnMap);
		
		
	}	
	
	/**
	 * AS 리스트 신규답변 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/awsProc.do")
	public String awsProc(@ModelAttribute("vo") AsVO vo, ModelMap model, MultipartHttpServletRequest multiRequest, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

	    List<FileVO> fileList = null;
	    int attach_seq = 0;

	    UserVO adUserInfo = session.getAttribute("adUserInfo") != null
	            ? (UserVO) session.getAttribute("adUserInfo")
	            : null;

	    int returnValue = 0;
	    String resultCode = "";

	    // delete 가 아니면 파일 업로드
	    if (!"delete".equals(vo.getPageType())) {
	        fileList = commonFileService.uploadFormFile(multiRequest, "as_answer");
	    }

	    // 업로드된 파일 처리
	    if (fileList != null && fileList.size() > 0) {
	        for (FileVO temp : fileList) {
	            if (temp.getAttach_tag_name().startsWith("uploadFile")) {

	                if (attach_seq == 0) {
	                    attach_seq = commonFileService.getMaxFileSeq();
	                    temp.setAttach_seq(attach_seq);
	                } else {
	                    temp.setAttach_seq(attach_seq);
	                }

	                temp.setAttach_ord(commonFileService.getMaxFileOrd(temp));
	                commonFileService.insertFile(temp);
	            }
	        }

	        vo.setAttach_seq(attach_seq);
	    }

	    vo.setReg_id(adUserInfo.getEmp_no());
	    vo.setW_gubun("A");

	    // 우선 현재 as_no 에 대해 기존 로직 수행
	    if ("insert".equals(vo.getPageType())) {
	        returnValue = asService.insertAws(vo, request);
	    } else if ("update".equals(vo.getPageType())) {
	        returnValue = asService.updateAws(vo, request);
	    } else if ("delete".equals(vo.getPageType())) {
	        returnValue = asService.deleteAws(vo, request);
	    }

	    // 1건이라도 성공하면 성공 코드
	    if (returnValue > 0) {
	        resultCode = "000";
	    } else {
	        resultCode = "001";
	    }

	    // ===============================
	    // as_no_link 에 있는 접수건에도 답변 복사 (답변 작성 시에만)
	    // ===============================
	    if ("insert".equals(vo.getPageType()) && returnValue > 0) {

	        String currentAsNo = vo.getAs_no() != null ? vo.getAs_no().trim() : "";
	        String linkStr = vo.getAs_no_link() != null ? vo.getAs_no_link().trim() : "";

	        if (!"".equals(linkStr)) {
	            String[] linkArr = linkStr.split(",");

	            for (String linkNoRaw : linkArr) {
	                if (linkNoRaw == null) continue;

	                String linkNo = linkNoRaw.trim();
	                if ("".equals(linkNo)) continue;

	                // 내 접수번호는 이미 insert 했으니 제외
	                if (linkNo.equals(currentAsNo)) continue;

	                AsVO linkVo = new AsVO();

	                // 복사할 값들 세팅
	                linkVo.setAs_no(linkNo);                     // 대상 접수번호
	                linkVo.setW_content(vo.getW_content());      // 동일한 답변 내용
	                linkVo.setW_gubun("A");
	                linkVo.setReg_id(vo.getReg_id());
	                linkVo.setAttach_seq(vo.getAttach_seq());    // 위에서 생성한 첨부파일 SEQ 공유
	                linkVo.setPageType("insert");

	                try {
	                    asService.insertAws(linkVo, request);
	                } catch (Exception e) {
	                    // 연관 건 중 일부 실패해도 로그인 화면이 터지지 않게 로그만 남김
	                    // 필요하면 logger 사용
	                    e.printStackTrace();
	                }
	            }
	        }
	    }

	    return CommonExecute.execute(model, "parent.awsProcReturn('" + resultCode + "');");
	}
	
	/**
	 * AS 리스트 삭제 처리
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/delProc.do")
	public void delProc(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ; 
		
		vo.setReg_id(adUserInfo.getEmp_no());
		
		int result;
	    if ("ALL_LINKED".equals(vo.getDel_type())) {
	        result = asService.deleteAsProcAllLinked(vo, request);
	    } else {
	        result = asService.deleteAsProc(vo, request);
	    }

	    returnMap.put("resultCode", result > 0 ? "000" : "001");
	    CommonExecute.returnJson(response, returnMap);
		
	}
	
	/**
	
	/**
	 * AS 직원목록 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsEmpList.do")
	public void getAsEmpList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		
		returnMap.put("resultList", asService.getList(vo, "asDAO.getAsEmpList")) ;
		CommonExecute.returnJson(response, returnMap);
	}	
	
	/**
	 * AS 직원목록 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsEmpList2.do")
	public void getAsEmpList2(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		
		returnMap.put("resultList", asService.getList(vo, "asDAO.getAsEmpList2")) ;
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	@RequestMapping(value = "/ad/as/getUnprocessedAsList.do")
	public void getUnprocessedAsListAdmin(
	        @RequestParam("asGubunFlag") String asGubunFlag,
	        @RequestParam("as_str_dt") String asStrDt,
	        @RequestParam("as_end_dt") String asEndDt,
	        @RequestParam("search_text") String search_text,
	        HttpServletResponse response,
	        HttpSession session) throws Exception {

	    Map<String, Object> returnMap = new HashMap<>();
	    HashMap<String, String> param = new HashMap<>();

	    String userId = "";
	    if ("2".equals(asGubunFlag)) { // 나의AS 일 때만 사용
	        UserVO adUserInfo = (UserVO) session.getAttribute("adUserInfo");
	        if (adUserInfo != null) {
	            userId = adUserInfo.getEmp_no();
	        }
	    }

	    param.put("as_str_dt", asStrDt.replaceAll("/", ""));
	    param.put("as_end_dt", asEndDt.replaceAll("/", ""));
	    param.put("asGubunFlag", asGubunFlag);
	    param.put("user_id", userId);
	    param.put("search_text", search_text);

	    @SuppressWarnings("unchecked")
	    List<AsVO> list = (List<AsVO>) commonDAO.list(param, "asDAO.getUnprocessedAsListAdmin");
	    returnMap.put("resultList", list);

	    CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/as/getprocessedAsList.do")
	public void getprocessedAsListAdmin(
	        @RequestParam("as_str_dt") String asStrDt,
	        @RequestParam("as_end_dt") String asEndDt,
	        @RequestParam("search_text") String search_text,
	        HttpServletResponse response,
	        HttpSession session) throws Exception {

	    Map<String, Object> returnMap = new HashMap<>();
	    HashMap<String, String> param = new HashMap<>();
	    
	    String userId = "";
	    UserVO adUserInfo = (UserVO) session.getAttribute("adUserInfo");
	    if (adUserInfo != null) {
	        userId = adUserInfo.getEmp_no();
	    }
	    
	    param.put("as_str_dt", asStrDt.replaceAll("/", ""));
	    param.put("as_end_dt", asEndDt.replaceAll("/", ""));
	    param.put("user_id", userId);
	    param.put("search_text", search_text);

	    @SuppressWarnings("unchecked")
	    List<AsVO> list = (List<AsVO>) commonDAO.list(param, "asDAO.getprocessedAsListAdmin");
	    returnMap.put("resultList", list);

	    CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * AS 상세 정보 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsInfo.do")
	public void getAsInfo(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		vo.setReg_id(userInfo.getEmp_no());
		
		AsVO resultVO = asService.getSelectInfo(vo, "asDAO.getAsInfo") ;
		
		returnMap.put("resultVO", resultVO) ;
		
		if(resultVO != null) {
			FileVO fileVO = new FileVO() ; 
			if(!"0".equals(SsStringUtil.normalize(resultVO.getFile_seq(), "0"))) {
				fileVO.setAttach_seq(Integer.parseInt(resultVO.getFile_seq()));
				returnMap.put("attachList", commonFileService.getFileList(fileVO)) ; 
			}
			
			if(!"0".equals(SsStringUtil.normalize(resultVO.getAttach_seq2(), "0"))) {
				fileVO.setAttach_seq(resultVO.getAttach_seq2());
				returnMap.put("attachList2", commonFileService.getFileList(fileVO)) ;
			}

			// [AX Lab] 수정 시작 (2026-07-30 AX Lab): AS 통합화면 - 문의/답변/조치/이관을 한 줄기 타임라인으로
			//   그리기 위해 답변목록과 각 조치이력의 첨부목록을 이 응답에 함께 실어 보낸다.
			//   ★ 신규 URL 을 만들지 않는 이유: MenuAuthFilter.isAccept() 가 세션 acceptUrlList 와
			//     "완전일치" 비교만 하므로 DB 메뉴권한에 없는 신규 /ad/as/*.do 는 무조건 403 이 된다.
			//     (과거 getAswsKpi.do 가 이 이유로 제거되고 getAsList.do 응답에 합쳐졌다)
			//     그래서 여기서도 기존 엔드포인트의 응답만 확장한다. 기존 호출자(form.jsp 등)는
			//     추가된 키를 참조하지 않으므로 영향이 없다.
			List<AsVO> awsList = asService.getList(vo, "asDAO.getAwsList") ;
			if(awsList != null && awsList.size() > 0) {
				for(AsVO awsVO : awsList) {
					if(awsVO.getAttach_seq() > 0) {
						FileVO awsFileVO = new FileVO() ;
						awsFileVO.setAttach_seq(awsVO.getAttach_seq()) ;
						Map<String , Object> awsMap = new HashMap<String , Object>() ;
						awsMap.put("attachList", commonFileService.getFileList(awsFileVO)) ;
						awsVO.setAmap(awsMap) ;
					}
				}
			}
			returnMap.put("awsList", awsList) ;

			List<AsVO> asHistList = asService.getList(vo, "asDAO.getAsHistList") ;
			if(asHistList != null && asHistList.size() > 0) {
				for(AsVO histVO : asHistList) {
					int histFileSeq = SsStringUtil.parseInt(SsStringUtil.normalizeNull(histVO.getFile_seq()), 0) ;
					if(histFileSeq > 0) {
						FileVO histFileVO = new FileVO() ;
						histFileVO.setAttach_seq(histFileSeq) ;
						Map<String , Object> histMap = new HashMap<String , Object>() ;
						histMap.put("attachList", commonFileService.getFileList(histFileVO)) ;
						histVO.setAmap(histMap) ;
					}
				}
			}
			returnMap.put("asHistList", asHistList) ;
			// [AX Lab] 수정 끝
		}

		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * AS 상세 하위작업번호 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getCnAsList.do")
	public void getCnAsList(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<AsVO> resultList = null ;
		
		
		UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
		int totalCount = asService.getTotalCnt(vo, "asDAO.getCnAsCnt") ;
		
		if(totalCount > 0){
			resultList = asService.getList(vo, "asDAO.getCnAsList") ;
			returnMap.put("resultList", resultList) ;
		}
		CommonExecute.returnJson(response, returnMap);
	}		
	
	
	/**
	 * AS 상세 조치이력 - 파일 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getAsHistFileInfo.do")
	public void getAsHistFileInfo(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		FileVO fileVO = new FileVO() ; 
		if(!"0".equals(SsStringUtil.normalize(vo.getAttach_seq2(), "0"))) {
			fileVO.setAttach_seq(vo.getAttach_seq2());
			returnMap.put("attach2FileList", commonFileService.getFileList(fileVO)) ; 
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 배정구분 및 2차분류구분 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getTaskType.do")
	public void getTaskType(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		AsVO resultList = null ;
		
		resultList = asService.getOneList(vo,"asDAO.getTaskType") ;
		
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo",vo);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 배정담당자(처리담당자) 데이터 조회
	 * @param seq
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/as/getWorker.do")
	public void getWorker(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		AsVO resultList = null ;
		
		resultList = asService.getOneList(vo,"asDAO.getWorker") ;
		
		returnMap.put("resultList", resultList) ;
		returnMap.put("vo",vo);
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 처리담당자 관리 목록 데이터
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
		
		int totalCount = asService.getOperateCnt(vo,"asDAO.getOperateCnt") ;
		if(totalCount > 0){
			vo.setPaging(totalCount);
			resultList = asService.getOperateList(vo,"asDAO.getOperateList") ;
			vo.setJson_paging(vo.getJsonPaging("getOperateList"));
			returnMap.put("resultList", resultList) ;
			returnMap.put("vo",vo);
		}
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	
	/**
	 * 처리담당자 관리 - 처리담당자정보 상세 데이터
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
		returnMap = asService.getOperateInfo(vo);
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
		
		if("C011".equals(SsStringUtil.normalizeNull(vo.getRequest_type()))) {
			vo.setService_cate("P010") ;
		}
		
		vo.setReg_id(adUserInfo.getEmp_no());
		returnValue = asService.updateOperate(vo,request) ;	
		
		if (returnValue > 0) {
			returnMap.put("returnCode", "000");
		}else if(returnValue == -3) {
			returnMap.put("returnCode", "003");
		}else if(returnValue == -99) {
			returnMap.put("returnCode", "099");
		}

		CommonExecute.returnJson(response, returnMap);
	}
}

















