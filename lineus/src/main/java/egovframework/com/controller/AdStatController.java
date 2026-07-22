package egovframework.com.controller;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
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
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.CustVO;
import egovframework.com.model.Stat2ExlVO;
import egovframework.com.model.Stat2HeaderVO;
import egovframework.com.model.Stat2VO;
import egovframework.com.model.StatVO;
import egovframework.com.model.SystemHistVO;
import egovframework.com.service.LoginService;
import egovframework.com.service.StatService;

/**
 * @Class Name : AdStatController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.10.23	정철구		           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2017. 09.07
 * @version 1.0
 * @see
 *
 *  Copyright (C) by FUNEX All right reserved.
 */

@Controller
public class AdStatController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdStatController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired LoginService loginService ; 
	@Autowired StatService statService ;
	@Autowired CommonDao commonDAO;
	
	/**
	 * 고급검색 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/list.do")
	public String list(@ModelAttribute("vo") StatVO vo, HttpServletRequest request) throws Exception {
		
		return "ad/stat/list";
	}
	
	/**
	 * 고급검색 검색결과 리스트
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/getList01List.do")
	public void getAsList(@ModelAttribute("vo") StatVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<StatVO> resultList = null ;
		String startDt = "";
		String endDt = "";
		
		try{
			
			UserVO adUserInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null ;
			
			if(!"".equals(SsStringUtil.normalizeNull(vo.getOpCnt()))) {
				
				StringBuffer sb = new StringBuffer() ; 
				
				for(int i = 1 ; i <= Integer.parseInt(vo.getOpCnt()) ; i++) {
					
					if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {
						
						//관리정보
						if ("A1".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {

							if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+i)))) {
								
								String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+i));
								
								if ("A1".equals(optionValue)) {
									
									//거래처명
									sb.append("	AND IN_TB.CUST_KOR_NAME LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("cust_nm"+i))+"%'	") ;
									
								} else if ("A2".equals(optionValue)) {
									
									//거래처구분
									sb.append("	AND IN_TB.CUST_GUBUN = '"+SsStringUtil.normalizeNull(request.getParameter("cust_gubun"+i))+"'	") ;
									
								} else if ("A3".equals(optionValue)) {
									
									//병원설립일
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("foundation_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("foundation_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("foundation_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("foundation_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.FOUNDATION_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									
								} else if ("A4".equals(optionValue)) {
									
									//계약일자
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("contract_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("contract_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("contract_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("contract_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.CONTRACT_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									
								} else if ("A5".equals(optionValue)) {
									sb.append("	AND IN_TB.ACTION_RESULT_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("gubun_code"+i))+"' ") ;
								}
							}
						}
						//프로젝트정보
						if ("A2".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {
							
							if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+i)))) {
								
								String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+i));
								
								if ("B1_1".equals(optionValue)) {
									//전산오픈일
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("open_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("open_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("open_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("open_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.OPEN_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									
								} else if ("B1_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.TERM_PERSON_COUNT = '"+SsStringUtil.normalizeNull(request.getParameter("term_person_count"+i))+"' ") ;
									
								} else if ("B1_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.PM = '"+SsStringUtil.normalizeNull(request.getParameter("pm"+i))+"' ") ;
									
								} else if ("B1_4".equals(optionValue)) {
									
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("test_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("test_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("test_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("test_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.TEST_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									
								} else if ("B1_5".equals(optionValue)) {
									
									sb.append("	AND IN_TB.VERSION = '"+SsStringUtil.normalizeNull(request.getParameter("version"+i))+"' ") ;
									
								} else if ("B2_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.FORMATION_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("formation_code"+i))+"' ") ;
									
								} else if ("B2_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OS = '"+SsStringUtil.normalizeNull(request.getParameter("os"+i))+"' ") ;
									
								} else if ("B2_3".equals(optionValue)) {
									
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.MTAC_CONTRACT_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									
								} else if ("B3_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CUST_KOR_NAME LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("cust_kor_name"+i))+"%'	") ;
									
								} else if ("B3_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CUST_GUBUN = '"+SsStringUtil.normalizeNull(request.getParameter("cust_gubun"+i))+"'	") ;
									
								} else if ("B3_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.BASIC_ETC LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("basic_etc"+i))+"%'	") ;
									
								} else if ("B4_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.BED_COUNT = '"+SsStringUtil.normalizeNull(request.getParameter("bed_count"+i))+"'	") ;
									
								} else if ("B4_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.VETERANS_YN = '"+SsStringUtil.normalizeNull(request.getParameter("veterans_yn"+i))+"'	") ;
									
								} else if ("B4_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.MILITARY_YN = '"+SsStringUtil.normalizeNull(request.getParameter("military_yn"+i))+"'	") ;
									
								} else if ("B4_4".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OLD_COMPANY_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("old_company_nm"+i))+"%'	") ;
									
								} else if ("B4_5".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OUTSIDE_CUST_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("outside_cust_code"+i))+"'	") ;
									
								} else if ("B5_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("charge_code"+i))+"'	") ;
									
								} else if ("B5_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("charge_nm"+i))+"%'	") ;
								}
							}
						}
						//운영정보
						if ("A3".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {
							
							if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+i)))) { 
								
								String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+i));
								
								if ("C1_1".equals(optionValue)) {
									sb.append("	AND IN_TB.DEAL_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("deal_code"+i))+"'	") ;
								} else if ("C1_2".equals(optionValue)) {
									
									String his_basic_code = SsStringUtil.normalizeNull(request.getParameter("his_basic_code"+i));
									String his_treat_code = SsStringUtil.normalizeNull(request.getParameter("his_treat_code"+i));
									String his_work_code = SsStringUtil.normalizeNull(request.getParameter("his_work_code"+i));
									String his_claim_code = SsStringUtil.normalizeNull(request.getParameter("his_claim_code"+i));
									
									if (!"".equals(his_basic_code)){
										sb.append("	AND IN_TB.HIS_BASIC_CODE = '"+his_basic_code+"'	") ;
									}
									if (!"".equals(his_treat_code)){
										sb.append("	AND IN_TB.HIS_TREAT_CODE = '"+his_treat_code+"'	") ;
									}
									if (!"".equals(his_work_code)){
										sb.append("	AND IN_TB.HIS_WORK_CODE = '"+his_work_code+"'	") ;
									}
									if (!"".equals(his_claim_code)){
										sb.append("	AND IN_TB.HIS_CLAIM_CODE = '"+his_claim_code+"' 	") ;										
									}
									
								} else if ("C2_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.VETERANS_YN = '"+SsStringUtil.normalizeNull(request.getParameter("veterans_yn"+i))+"'	") ;
									
								} else if ("C2_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.MILITARY_YN = '"+SsStringUtil.normalizeNull(request.getParameter("military_yn"+i))+"'	") ;
									
								} else if ("C2_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHOICE_YN = '"+SsStringUtil.normalizeNull(request.getParameter("choice_yn"+i))+"'	") ;
									
								} else if ("C2_4".equals(optionValue)) {
									
									sb.append("	AND IN_TB.DENTIST_YN = '"+SsStringUtil.normalizeNull(request.getParameter("dentist_yn"+i))+"'	") ;
									
								} else if ("C2_5".equals(optionValue)) {
									
									sb.append("	AND IN_TB.MENTAL_YN = '"+SsStringUtil.normalizeNull(request.getParameter("mental_yn"+i))+"'	") ;
									
								} else if ("C2_6".equals(optionValue)) {
									
									sb.append("	AND IN_TB.ORIENTAL_YN = '"+SsStringUtil.normalizeNull(request.getParameter("oriental_yn"+i))+"'	") ;
									
								} else if ("C2_7".equals(optionValue)) {
									
									sb.append("	AND IN_TB.HEMODIALYSIS_YN = '"+SsStringUtil.normalizeNull(request.getParameter("hemodialysis_yn"+i))+"'	") ;
									
								} else if ("C2_8".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CARE_YN = '"+SsStringUtil.normalizeNull(request.getParameter("care_yn"+i))+"'	") ;
									
								} else if ("C3_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CARE_GRADE = '"+SsStringUtil.normalizeNull(request.getParameter("care_grade"+i))+"'	") ;
									
								} else if ("C3_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OLD_COMPANY_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("old_company_nm"+i))+"%'	") ;
									
								} else if ("C3_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OUTSIDE_CUST_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("outside_cust_code"+i))+"'	") ;
									
								} else if ("C4_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OS = '"+SsStringUtil.normalizeNull(request.getParameter("os"+i))+"'	") ;
									
								} else if ("C5_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("charge_code"+i))+"'	") ;
									
								} else if ("C5_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("charge_nm"+i))+"%'	") ;
									
								} else if ("C6_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.GUBUN = '"+SsStringUtil.normalizeNull(request.getParameter("gubun"+i))+"'	") ;
									
								} else if ("C6_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CONTENTS LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("contents"+i))+"%'	") ;
									
								} else if ("C6_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.ETC LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("n_etc"+i))+"%'	") ;
									
								}
							}
						}						
					}
				}
				vo.setQueryWhere(sb.toString());
			}
			
			resultList = statService.getList(vo,"statDAO.getList01List") ;
			returnMap.put("resultList", resultList) ;
			
			CommonExecute.returnJson(response, returnMap);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * 고급검색 엑셀 다운로드 신규작업
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/exlNew.do")
	public void exlNew(@RequestParam("crmList") String crmList, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("crmList", crmList);
		List<CustVO> resultList = (List<CustVO>) statService.list(param,"statDAO.getNewStatList");
		
		OutputStream fileOut = null;

		String exl_title = "고급검색 리스트";

		UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : null;

		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet(exl_title);

		HSSFRow row = null;
		HSSFCell cell = null;

		String[] title = { "No", "사업자소재지", "거래처명", "CRM코드", "거래처구분",
				"재단구분", "병원설립일", "계약일자", "병상BED", "거래상태", "HIS기초버전",
				"HIS진료버전", "HIS원무버전", "HIS청구버전", "전문병원여부", "병상BED", "운영정보",
				"의사수", "간호사수", "간호등급", "신규/기존", "기존전산업체", "일평균내원자수",
				"평균내원자수", "외부수탁업체", "청구여부", "특이사항", "거래처명", "CRM코드",
				"거래처구분", "신규/기존", "기존전산업체", "전문병원 여부", "PJT OCS/EMR ver",
				"담당PM", "사업장 소재지", "요양기관번호", "사업자번호", "의사수", "병상수",
				"투입기간1", "투입기간2", "전산오픈일", "최종검수일", "구성", "서버 제조사/모델",
				"OS", "서버 RAM", "PC", "오라클버전", "외부수탁업체", "기타설명", "특이사항" };

		String[] refColumn = { "rnum", "cust_address", "cust_kor_name",
				"crm_code", "cust_gubun_nm", "foundation_code_nm",
				"foundation_dt", "contract_dt", "bed_count",

				"deal_code_nm", "his_basic_code_nm", "his_treat_code_nm",
				"his_work_code_nm", "his_claim_code_nm",
				"specially_code_nm", "o_bed_count", "veterans_yn",
				"doctor_count", "nurse_count", "care_grade", "new_code_nm",
				"old_company_nm", "come_count", "average_count",
				"outside_cust_code_nm", "charge_yn", "detail_etc",

				"p_cust_kor_name", "p_crm_code", "p_cust_gubun_nm",
				"p_new_code_nm", "p_old_company_nm", "p_specially_code",
				"version", "pm", "addr", "treat_no", "cust_no",
				"p_doctor_count", "p_bed_count", "term_start_dt",
				"term_end_dt", "open_dt", "test_dt", "formation_code_nm",
				"server_code_nm", "os_nm", "ram_nm", "pc",
				"oracle_version_nm", "p_outside_cust_code_nm",
				"p_basic_etc", "p_detail_etc" };

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
		tStyleM.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE
				.getIndex());
		tStyleM.setFont(boldFont);
		addBoardStyle(tStyleM, true);

		tStyleO.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleO.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleO.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleO.setFillForegroundColor(IndexedColors.LIGHT_YELLOW
				.getIndex());
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
		bStyleM.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE
				.getIndex());
		addBoardStyle(bStyleM, false);

		bStyleO.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		bStyleO.setFillPattern(CellStyle.SOLID_FOREGROUND);
		bStyleO.setFillForegroundColor(IndexedColors.LIGHT_YELLOW
				.getIndex());
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
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 9, 26));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 27, 52));

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
		cell = row.createCell(27);
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
			else if (i < 27)
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
					else if (a < 27)
						cell.setCellStyle(bStyleO);
					else
						cell.setCellStyle(bStyleP);

					if (a == 16) {
						StringBuffer sb = new StringBuffer();
						String chk = BeanUtils.getProperty(temp,
								"veterans_yn");
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
						chk = BeanUtils
								.getProperty(temp, "hemodialysis_yn");
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

					} else if (a == 6 || a == 7 || a == 40 || a == 41
							|| a == 42 || a == 43) {
						cellValue = SsStringUtil.normalizeNull(BeanUtils
								.getProperty(temp, refColumn[a]));

						if (SsStringUtil.isDefined(cellValue)
								&& cellValue.length() == 8) {
							cellValue = cellValue.substring(0, 4) + "-"
									+ cellValue.substring(4, 6) + "-"
									+ cellValue.substring(6);
						}

					} else {
						cellValue = SsStringUtil.normalizeNull(BeanUtils
								.getProperty(temp, refColumn[a]));
					}

					cell.setCellValue(cellValue);
				}
			}

			String usrClient = request.getHeader("User-Agent");

			exl_title = exl_title + ".xls";

			if (usrClient.indexOf("MSIE 5.5") > -1) {
				response.setHeader(
						"Content-Disposition",
						"filename="
								+ new String(exl_title.getBytes("euc-kr"),
										"8859_1") + ";");
			} else {
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
				response.setHeader(
						"Content-Disposition",
						"attachment;filename="
								+ new String(exl_title.getBytes("euc-kr"),
										"8859_1") + ";");
			}

			fileOut = response.getOutputStream();

			workbook.write(fileOut);
		}

		if (fileOut != null) fileOut.close();
	}
	
	/**
	 * 고급검색 엑셀처리
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/exl.do")
	public void exl(@ModelAttribute("vo") StatVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		
		String isTab = SsStringUtil.normalize(vo.getIsTab(), "1").trim() ; 
		
		String exl_title = "고급검색 리스트" ; 
		
		try{
			UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
			vo.setPageType("exl");
			
			String startDt = "";
			String endDt = "";
			
			List<Object> titleArray = new ArrayList<Object>();
			
			if(!"".equals(SsStringUtil.normalizeNull(vo.getOpCnt()))) {
				
				StringBuffer sb = new StringBuffer() ;
				
				titleArray.add("No.");
				titleArray.add("거래처명");
				
				for(int i = 1 ; i <= Integer.parseInt(vo.getOpCnt()) ; i++) {
					
					if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {
						
						//관리정보
						if ("A1".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {

							if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+i)))) {
								
								String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+i));
								
								if ("A1".equals(optionValue)) {
									//거래처명
									sb.append("	AND IN_TB.CUST_KOR_NAME LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("cust_nm"+i))+"%'	") ;
									
								} else if ("A2".equals(optionValue)) {
									
									//거래처구분
									sb.append("	AND IN_TB.CUST_GUBUN = '"+SsStringUtil.normalizeNull(request.getParameter("cust_gubun"+i))+"'	") ;
									titleArray.add("거래처구분");
									
								} else if ("A3".equals(optionValue)) {
									
									//병원설립일
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("foundation_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("foundation_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("foundation_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("foundation_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.FOUNDATION_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									titleArray.add("병원설립일");
									
								} else if ("A4".equals(optionValue)) {
									
									//계약일자
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("contract_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("contract_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("contract_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("contract_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.CONTRACT_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									titleArray.add("계약일자");
									
								} else if ("A5".equals(optionValue)) {
									sb.append("	AND IN_TB.ACTION_RESULT_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("gubun_code"+i))+"' ") ;
									titleArray.add("이슈관리");
								}
							}
						}
						//프로젝트정보
						if ("A2".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {
							
							if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+i)))) {
								
								String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+i));
								
								if ("B1_1".equals(optionValue)) {
									//전산오픈일
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("open_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("open_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("open_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("open_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.OPEN_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									titleArray.add("전산오픈일");
									
								} else if ("B1_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.TERM_PERSON_COUNT = '"+SsStringUtil.normalizeNull(request.getParameter("term_person_count"+i))+"' ") ;
									titleArray.add("투입인원");
									
								} else if ("B1_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.PM = '"+SsStringUtil.normalizeNull(request.getParameter("pm"+i))+"' ") ;
									titleArray.add("담당PM");
									
								} else if ("B1_4".equals(optionValue)) {
									
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("test_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("test_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("test_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("test_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.TEST_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									titleArray.add("최종검수일");
									
								} else if ("B1_5".equals(optionValue)) {
									
									sb.append("	AND IN_TB.VERSION = '"+SsStringUtil.normalizeNull(request.getParameter("version"+i))+"' ") ;
									titleArray.add("OCS/EMRver");
									
								} else if ("B2_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.FORMATION_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("formation_code"+i))+"' ") ;
									titleArray.add("서버구성");
									
								} else if ("B2_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OS = '"+SsStringUtil.normalizeNull(request.getParameter("os"+i))+"' ") ;
									titleArray.add("OS");
									
								} else if ("B2_3".equals(optionValue)) {
									
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt1_"+i)))) startDt = SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt1_"+i).replaceAll("/", ""));
									if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt2_"+i)))) endDt = SsStringUtil.normalizeNull(request.getParameter("mtac_contract_dt2_"+i).replaceAll("/", ""));
									sb.append("	AND IN_TB.MTAC_CONTRACT_DT BETWEEN '"+startDt+"' AND '"+ endDt +"' ") ;
									titleArray.add("유지보수 계약일자");
									
								} else if ("B3_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CUST_KOR_NAME LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("cust_kor_name"+i))+"%'	") ;
									titleArray.add("거래처명");
									
								} else if ("B3_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CUST_GUBUN = '"+SsStringUtil.normalizeNull(request.getParameter("cust_gubun"+i))+"'	") ;
									titleArray.add("거래처구분");
									
								} else if ("B3_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.BASIC_ETC LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("basic_etc"+i))+"%'	") ;
									titleArray.add("기타설명");
									
								} else if ("B4_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.BED_COUNT = '"+SsStringUtil.normalizeNull(request.getParameter("bed_count"+i))+"'	") ;
									titleArray.add("병상수");
									
								} else if ("B4_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.VETERANS_YN = '"+SsStringUtil.normalizeNull(request.getParameter("veterans_yn"+i))+"'	") ;
									titleArray.add("보훈여부");
									
								} else if ("B4_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.MILITARY_YN = '"+SsStringUtil.normalizeNull(request.getParameter("military_yn"+i))+"'	") ;
									titleArray.add("군지역소재");
									
								} else if ("B4_4".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OLD_COMPANY_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("old_company_nm"+i))+"%'	") ;
									titleArray.add("기존전산업체");
									
								} else if ("B4_5".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OUTSIDE_CUST_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("outside_cust_code"+i))+"'	") ;
									titleArray.add("외부수탁업체");
									
								} else if ("B5_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("charge_code"+i))+"'	") ;
									titleArray.add("담당구분");
									
								} else if ("B5_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("charge_nm"+i))+"%'	") ;
									titleArray.add("담당자명");
								}
							}
						}
						//운영정보
						if ("A3".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+i)))) {
							
							if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+i)))) { 
								
								String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+i));
								
								if ("C1_1".equals(optionValue)) {
									sb.append("	AND IN_TB.DEAL_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("deal_code"+i))+"'	") ;
									titleArray.add("거래상태");
									
								} else if ("C1_2".equals(optionValue)) {
									
									String his_basic_code = SsStringUtil.normalizeNull(request.getParameter("his_basic_code"+i));
									String his_treat_code = SsStringUtil.normalizeNull(request.getParameter("his_treat_code"+i));
									String his_work_code = SsStringUtil.normalizeNull(request.getParameter("his_work_code"+i));
									String his_claim_code = SsStringUtil.normalizeNull(request.getParameter("his_claim_code"+i));
									
									if (!"".equals(his_basic_code)){
										sb.append("	AND IN_TB.HIS_BASIC_CODE = '"+his_basic_code+"'	") ;
									}
									if (!"".equals(his_treat_code)){
										sb.append("	AND IN_TB.HIS_TREAT_CODE = '"+his_treat_code+"'	") ;
									}
									if (!"".equals(his_work_code)){
										sb.append("	AND IN_TB.HIS_WORK_CODE = '"+his_work_code+"'	") ;
									}
									if (!"".equals(his_claim_code)){
										sb.append("	AND IN_TB.HIS_CLAIM_CODE = '"+his_claim_code+"' 	") ;										
									}
									
									titleArray.add("HIS(모듈별)");
									
								} else if ("C2_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.VETERANS_YN = '"+SsStringUtil.normalizeNull(request.getParameter("veterans_yn"+i))+"'	") ;
									titleArray.add("HIS(모듈별)");
									
								} else if ("C2_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.MILITARY_YN = '"+SsStringUtil.normalizeNull(request.getParameter("military_yn"+i))+"'	") ;
									titleArray.add("보훈여부");
									
								} else if ("C2_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHOICE_YN = '"+SsStringUtil.normalizeNull(request.getParameter("choice_yn"+i))+"'	") ;
									titleArray.add("군지역소재");
									
								} else if ("C2_4".equals(optionValue)) {
									
									sb.append("	AND IN_TB.DENTIST_YN = '"+SsStringUtil.normalizeNull(request.getParameter("dentist_yn"+i))+"'	") ;
									titleArray.add("선택진료");
									
								} else if ("C2_5".equals(optionValue)) {
									
									sb.append("	AND IN_TB.MENTAL_YN = '"+SsStringUtil.normalizeNull(request.getParameter("mental_yn"+i))+"'	") ;
									titleArray.add("치과유무");
									
								} else if ("C2_6".equals(optionValue)) {
									
									sb.append("	AND IN_TB.ORIENTAL_YN = '"+SsStringUtil.normalizeNull(request.getParameter("oriental_yn"+i))+"'	") ;
									titleArray.add("정신과");
									
								} else if ("C2_7".equals(optionValue)) {
									
									sb.append("	AND IN_TB.HEMODIALYSIS_YN = '"+SsStringUtil.normalizeNull(request.getParameter("hemodialysis_yn"+i))+"'	") ;
									titleArray.add("한방");
									
								} else if ("C2_8".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CARE_YN = '"+SsStringUtil.normalizeNull(request.getParameter("care_yn"+i))+"'	") ;
									titleArray.add("혈액투석");
									
								} else if ("C3_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CARE_GRADE = '"+SsStringUtil.normalizeNull(request.getParameter("care_grade"+i))+"'	") ;
									titleArray.add("포괄간호");
									
								} else if ("C3_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OLD_COMPANY_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("old_company_nm"+i))+"%'	") ;
									titleArray.add("간호등급");
									
								} else if ("C3_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OUTSIDE_CUST_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("outside_cust_code"+i))+"'	") ;
									titleArray.add("기존전산업체");
									
								} else if ("C4_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.OS = '"+SsStringUtil.normalizeNull(request.getParameter("os"+i))+"'	") ;
									titleArray.add("외부수탁업체");
									
								} else if ("C5_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_CODE = '"+SsStringUtil.normalizeNull(request.getParameter("charge_code"+i))+"'	") ;
									titleArray.add("OS");
									
								} else if ("C5_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CHARGE_NM LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("charge_nm"+i))+"%'	") ;
									titleArray.add("담당구분");
									
								} else if ("C6_1".equals(optionValue)) {
									
									sb.append("	AND IN_TB.GUBUN = '"+SsStringUtil.normalizeNull(request.getParameter("gubun"+i))+"'	") ;
									titleArray.add("구분");
									
								} else if ("C6_2".equals(optionValue)) {
									
									sb.append("	AND IN_TB.CONTENTS LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("contents"+i))+"%'	") ;
									titleArray.add("내용");
									
								} else if ("C6_3".equals(optionValue)) {
									
									sb.append("	AND IN_TB.ETC LIKE '%"+SsStringUtil.normalizeNull(request.getParameter("n_etc"+i))+"%'	") ;
									titleArray.add("비고");
									
								}
							}
						}						
					}
				}
				vo.setQueryWhere(sb.toString());
			}
		
			List<StatVO> resultList = statService.getList(vo,"statDAO.getList01List") ;
			
			HSSFWorkbook workbook = new HSSFWorkbook() ; 
			HSSFSheet sheet = workbook.createSheet(exl_title) ;
			
			HSSFRow row = null ; 
			HSSFCell cell = null ; 
			
			//String[] title = { "No" , "접수번호" , "하위작업" , "처리상태" , "접수일" , "거래처명" , "문의서비스" , "중요도" , "원인유형" , "조치유형" , "처리담당자" , "신규답변" , "검수일", "고객평가" } ;
			
			List<Object> dataArray = new ArrayList<Object>();
			
			if(resultList != null && resultList.size() > 0){
				
				for(int i = 0 ; i < resultList.size() ; i++) {
					StatVO temp = resultList.get(i) ; 
					
					String data = "";
					data = SsStringUtil.normalizeNull(temp.getCust_kor_name());
					//dataArray.add(SsStringUtil.normalizeNull(temp.getCust_kor_name()));
					
					for(int j = 1 ; j <= Integer.parseInt(vo.getOpCnt()) ; j++) {
						
						if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+j)))) {
							//관리정보
							if ("A1".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+j)))) {

								if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+j)))) {
									
									String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+j));
									
									if ("A1".equals(optionValue)) {
										//거래처명
										
									} else if ("A2".equals(optionValue)) {
										
										//거래처구분
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCust_gubun_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCust_gubun_nm());
										
									} else if ("A3".equals(optionValue)) {
										
										//병원설립일
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getFoundation_dt());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getFoundation_dt());
										
									} else if ("A4".equals(optionValue)) {
										
										//계약일자
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getContract_dt());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getContract_dt());
										
									} else if ("A5".equals(optionValue)) {
										//이슈관리
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getAction_result_code_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getAction_result_code_nm());
									}
								}
							}
							
							//프로젝트정보
							if ("A2".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+j)))) {
								
								if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+j)))) {
									
									String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+j));
									
									if ("B1_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOpen_dt());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOpen_dt());
										
									} else if ("B1_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getTerm_person_count());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getTerm_person_count());										
										
									} else if ("B1_3".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getPm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getPm());										
										
									} else if ("B1_4".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getTest_dt());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getTest_dt());										
										
									} else if ("B1_5".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getVersion_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getVersion_nm());										
										
									} else if ("B2_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getFormation_code_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getFormation_code_nm());			
										
									} else if ("B2_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOs_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOs_nm());
										
									} else if ("B2_3".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getMtac_contract_dt());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getMtac_contract_dt());
																
									} else if ("B3_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCust_kor_name());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCust_kor_name());
										
									} else if ("B3_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCust_gubun_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCust_gubun_nm());
										
									} else if ("B3_3".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getBasic_etc());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getBasic_etc());
										
									} else if ("B4_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getBed_count());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getBed_count());
									
									} else if ("B4_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getVeterans_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getVeterans_yn());
										
									} else if ("B4_3".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getMilitary_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getMilitary_yn());										
																
									} else if ("B4_4".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOld_company_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOld_company_nm());
										
									} else if ("B4_5".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOutside_cust_code_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOutside_cust_code_nm());										
										
									} else if ("B5_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCharge_code_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCharge_code_nm());										
										
									} else if ("B5_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCharge_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCharge_nm());
										
									}
								}
							}
							//운영정보
							if ("A3".equals(SsStringUtil.normalizeNull(request.getParameter("optionA_"+j)))) {
								
								if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("optionC_"+j)))) { 
									
									String optionValue = SsStringUtil.normalizeNull(request.getParameter("optionC_"+j));
									
									if ("C1_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getDeal_code_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getDeal_code_nm());
										
									} else if ("C1_2".equals(optionValue)) {
										
										String moduleTotal = "";
										
										if (!"".equals(SsStringUtil.normalizeNull(temp.getHis_basic_code_nm()))) {
											if (moduleTotal == "") moduleTotal = SsStringUtil.normalizeNull(temp.getHis_basic_code_nm());
											else moduleTotal = moduleTotal +"@@"+ SsStringUtil.normalizeNull(temp.getHis_basic_code_nm());
										}
										if (!"".equals(SsStringUtil.normalizeNull(temp.getHis_treat_code_nm()))) {
											if (moduleTotal == "") moduleTotal = SsStringUtil.normalizeNull(temp.getHis_treat_code_nm());
											else moduleTotal = moduleTotal +"@@"+ SsStringUtil.normalizeNull(temp.getHis_treat_code_nm());
										}
										if (!"".equals(SsStringUtil.normalizeNull(temp.getHis_work_code_nm()))) {
											if (moduleTotal == "") moduleTotal = SsStringUtil.normalizeNull(temp.getHis_work_code_nm());
											else moduleTotal = moduleTotal +"@@"+ SsStringUtil.normalizeNull(temp.getHis_work_code_nm());
										}
										if (!"".equals(SsStringUtil.normalizeNull(temp.getHis_claim_code_nm()))) {
											if (moduleTotal == "") moduleTotal = SsStringUtil.normalizeNull(temp.getHis_claim_code_nm());
											else moduleTotal = moduleTotal +"@@"+ SsStringUtil.normalizeNull(temp.getHis_claim_code_nm());
										}
										
										if("".equals(data)) {
											data = moduleTotal ;
										} else {
											data = data + "@@" + moduleTotal ;
										} 	
										
									} else if ("C2_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getVeterans_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getVeterans_yn());
										
									} else if ("C2_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getMilitary_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getMilitary_yn());										
																				
									} else if ("C2_3".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getChoice_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getChoice_yn());
										
									} else if ("C2_4".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getDentist_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getDentist_yn());										
										
									} else if ("C2_5".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getMental_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getMental_yn());										
										
									} else if ("C2_6".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOriental_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOriental_yn());
										
									} else if ("C2_7".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getHemodialysis_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getHemodialysis_yn());
										
									} else if ("C2_8".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCare_yn());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCare_yn());
									
									} else if ("C3_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCare_grade());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCare_grade());										
										
									} else if ("C3_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOld_company_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOld_company_nm());										
										
									} else if ("C3_3".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOutside_cust_code_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOutside_cust_code_nm());										
										
									} else if ("C4_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getOs_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getOs_nm());
										
									} else if ("C5_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCharge_code_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCharge_code_nm());
										
									} else if ("C5_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getCharge_nm());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getCharge_nm());
										
									} else if ("C6_1".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getGubun());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getGubun());
										
									} else if ("C6_2".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getContents());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getContents());
										
									} else if ("C6_3".equals(optionValue)) {
										if ("".equals(data)) data = SsStringUtil.normalizeNull(temp.getEtc());
										else data = data + "@@" + SsStringUtil.normalizeNull(temp.getEtc());
										
									}
								}
							}
						}
					}

					//// System.out.println("data : " + data);
					dataArray.add(data);
				}
			}
			
			HashSet dupClear = new HashSet(dataArray);
			ArrayList<String> newArrList = new ArrayList<String>(dupClear);
			Collections.sort(newArrList);
			
			int rowNum = 0 ; 
			row = sheet.createRow(rowNum) ; 
			rowNum++  ;
			
			for(int i = 0 ; i < titleArray.size() ; i++){
				cell = row.createCell(i) ;
				cell.setCellValue(titleArray.get(i).toString());
			}
			
			if(newArrList != null && newArrList.size() > 0){
				
				for(int i = 0 ; i < newArrList.size() ; i++){
					
					//// System.out.println("newArrList.get("+i+"): " + newArrList.get(i));
					
					String[] datas = newArrList.get(i).split("@@");
					row = sheet.createRow(rowNum) ; 
					rowNum++ ;
					
					//// System.out.println("titleArray.size() : " + titleArray.size());
					
					for (int j=0; j < titleArray.size(); j++) {
						String temp = "";
						
						if (j > 0) temp = datas[j-1];
						
						cell = row.createCell(j) ;
						
						String cellValue = "";
						if (j == 0) cellValue = String.valueOf((i+1)); 
						else cellValue = temp;

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
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(fileOut != null) fileOut.close();  
		}
	}
	
	/**
	 * 유지보수 계약현황 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/list2.do")
	public String list2(@ModelAttribute("vo") StatVO vo, HttpServletRequest request) throws Exception {
		return "ad/stat/list2";
	}
	
	/**
	 * 유지보수 계약현황 - 목록 데이터
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/getMtacList.do")
	public void getPayInfo(@ModelAttribute("vo") StatVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		if(!"".equals(SsStringUtil.normalizeNull(vo.getStart_date()))) vo.setStart_date(vo.getStart_date().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getEnd_date()))) vo.setEnd_date(vo.getEnd_date().replaceAll("/", "")) ;
		
		returnMap.put("resultList", statService.getList(vo, "statDAO.getMtacList")) ; 
		
		CommonExecute.returnJson(response, returnMap);
	}	
	
	/**
	 * 엑셀처리
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/exl2.do")
	public void exl2(@ModelAttribute("vo") StatVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
		
		OutputStream fileOut = null ; 
		
		String isTab = SsStringUtil.normalize(vo.getIsTab(), "1").trim() ; 
		
		String exl_title = "유지보수 계약현황" ; 
		
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
	
		if(!"".equals(SsStringUtil.normalizeNull(vo.getStart_date()))) vo.setStart_date(vo.getStart_date().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getEnd_date()))) vo.setEnd_date(vo.getEnd_date().replaceAll("/", "")) ;
		
		List<StatVO> resultList = statService.getList(vo, "statDAO.getMtacList") ; 
		
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		
		HSSFRow row = null ; 
		HSSFCell cell = null ; 
		
		String[] title = { "No" , "거래처명" , "자동갱신 여부" , "계약서번호" , "계약서명" , "계약일시" , "품목" , "유/무상구분" , "유지보수기간" , "계약잔여일" , "월유보금액" , "미수금(전월기준)" , "매입업체명", "매입원가", "서비스주기", "서비스방법" } ;
		
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		rowNum++  ;
		
		for(int i = 0 ; i < title.length ; i++){
			cell = row.createCell(i) ;
			cell.setCellValue(title[i]);
		}
		
		if(resultList != null && resultList.size() > 0){
			for(int i = 0 ; i < resultList.size() ; i++){
				StatVO temp = resultList.get(i) ; 
				row = sheet.createRow(rowNum) ; 
				rowNum++ ;
				
				for(int a = 0 ; a < title.length ; a++){
					cell = row.createCell(a) ;
					String cellValue = "" ; 
					
					if(a == 0) cellValue = String.valueOf((i+1)); 
					else if(a == 1) cellValue = SsStringUtil.normalizeNull(temp.getCust_kor_name()) ;
					else if(a == 2) cellValue = SsStringUtil.normalize(temp.getAuto_renew_yn(), "N") ;
					else if(a == 3) cellValue = SsStringUtil.normalizeNull(temp.getContract_seq()) ;
					else if(a == 4) cellValue = SsStringUtil.normalizeNull(temp.getContract_nm()) ;
					else if(a == 5) cellValue = DateTimeUtil.getDateText(SsStringUtil.normalizeNull(temp.getContract_dt())) ;
					else if(a == 6) cellValue = SsStringUtil.normalizeNull(temp.getBill_code()); 
					else if(a == 7) cellValue = SsStringUtil.normalizeNull(temp.getMtac_code()) ;
					else if(a == 8) cellValue = DateTimeUtil.getDateText(SsStringUtil.normalizeNull(temp.getMtac_start_dt())) + "~" + DateTimeUtil.getDateText(SsStringUtil.normalizeNull(temp.getMtac_end_dt())) ;
					else if(a == 9) cellValue = SsStringUtil.normalizeNull(temp.getMtac_calc()) ;
					else if(a == 10) cellValue = SsStringUtil.normalizeNull(temp.getMon_off_amt()) ;
					else if(a == 11) cellValue = SsStringUtil.normalize(temp.getReceive_amt(), "0") ;
					else if(a == 12) cellValue = SsStringUtil.normalizeNull(temp.getBuy_busi_name()) ;
					else if(a == 13) cellValue = SsStringUtil.normalizeNull(temp.getBuy_cost()) ;
					else if(a == 14) cellValue = SsStringUtil.normalizeNull(temp.getService_period()) ;
					else if(a == 15) cellValue = SsStringUtil.normalizeNull(temp.getService_method()) ;
					
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
	
	
	/**
	 * 담당자별 A/S 현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/list3.do")
	public String list3(@ModelAttribute("vo") Stat2VO vo, HttpServletRequest request) throws Exception {
		return "ad/stat/list3";
	}
	
	@RequestMapping(value = "/ad/stat/getListByAssign.do")
	public void getListByAssign(@ModelAttribute("vo") Stat2VO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		logger.debug(vo.toString());
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 

		String searchType = vo.getSearch_type();
		if (searchType == null) throw new Exception("처리코드 값이 NULL 입니다.");			
		// 각각의 타입별로 쿼리와 헤더정보를 달리 셋팅한다.
		
		if ("proc_status".equals(searchType)){
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.AssignProcStatus");
			
			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "ASSIGN_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			headerList.add(new Stat2HeaderVO("담당자배정중(변경)", "C002","sum",null));
			headerList.add(new Stat2HeaderVO("배정완료", "C003","sum",null));
			headerList.add(new Stat2HeaderVO("처리중", "C004","sum",null));
			headerList.add(new Stat2HeaderVO("처리완료", "C005","sum",null));
			headerList.add(new Stat2HeaderVO("처리율", "AS_RATE","avg","C005"));
			headerList.add(new Stat2HeaderVO("답변수총계", "ANSWER_CNT","sum",null));
			headerList.add(new Stat2HeaderVO("답변율", "ANSWER_RATE","avg","ANSWER_CNT"));
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("accept_route".equals(searchType)){
			
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","ACCEPT_ROUTE");
			paramMap.put("pCode", "CD02");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.AssignAcceptRoute");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "ASSIGN_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}
							
			headerList.add(new Stat2HeaderVO("답변수총계", "ANSWER_CNT","sum",null));
			headerList.add(new Stat2HeaderVO("답변율", "ANSWER_RATE","avg","ANSWER_CNT"));
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("service_cate".equals(searchType)){
			
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","SERVICE_CATE");
			paramMap.put("pCode", "CD03");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.AssignServiceCate");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "ASSIGN_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}

			headerList.add(new Stat2HeaderVO("답변수총계", "ANSWER_CNT","sum",null));
			headerList.add(new Stat2HeaderVO("답변율", "ANSWER_RATE","avg","ANSWER_CNT"));
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("cause_type".equals(searchType)){
			
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","CAUSE_TYPE");
			paramMap.put("pCode", "CD05");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.AssignCauseType");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "ASSIGN_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}

			headerList.add(new Stat2HeaderVO("답변수총계", "ANSWER_CNT","sum",null));
			headerList.add(new Stat2HeaderVO("답변율", "ANSWER_RATE","avg","ANSWER_CNT"));
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
			
		}else if ("action_type".equals(searchType)){
			
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","ACTION_TYPE");
			paramMap.put("pCode", "CD06");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.AssignActionType");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "ASSIGN_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}
			headerList.add(new Stat2HeaderVO("답변수총계", "ANSWER_CNT","sum",null));
			headerList.add(new Stat2HeaderVO("답변율", "ANSWER_RATE","avg","ANSWER_CNT"));
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else{
			throw new Exception("정의되지 않은 처리코드 입니다.\r\n["+searchType+"]");
		}
		
		returnMap.put("resultCode", "000");
		CommonExecute.returnJson(response, returnMap);

	}
	
	/**
	 * 고객사별 A/S 현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/list4.do")
	public String list4(@ModelAttribute("vo") StatVO vo, HttpServletRequest request) throws Exception {
		return "ad/stat/list4";
	}
	
	@RequestMapping(value = "/ad/stat/getListByCust.do")
	public void getListByCust(@ModelAttribute("vo") Stat2VO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		logger.debug(vo.toString());
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 

		String searchType = vo.getSearch_type();
		if (searchType == null) throw new Exception("처리코드 값이 NULL 입니다.");			
		// 각각의 타입별로 쿼리와 헤더정보를 달리 셋팅한다.
		
		if ("proc_status".equals(searchType)){
			
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","PROC_STATUS");
			paramMap.put("pCode", "CD01");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.CustProcStatus");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "CUST_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("accept_route".equals(searchType)){
			
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","ACCEPT_ROUTE");
			paramMap.put("pCode", "CD02");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.CustAcceptRoute");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "CUST_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("service_cate".equals(searchType)){
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","SERVICE_CATE");
			paramMap.put("pCode", "CD03");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.CustServiceCate");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "CUST_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("cause_type".equals(searchType)){
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","CAUSE_TYPE");
			paramMap.put("pCode", "CD05");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.CustCauseType");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "CUST_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
			
		}else if ("action_type".equals(searchType)){
			
			// 컬럼 리스트 데이터를 가져온다.
			HashMap<String,String> paramMap = new HashMap<String, String>();
			paramMap.put("type","ACTION_TYPE");
			paramMap.put("pCode", "CD06");
			
			List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(paramMap, "statDAO.getColByType");
			StringBuffer sb = new StringBuffer();
			
			for (Map<String, String> map : colInfoList){
				sb.append(',').append(map.get("COLS"));
			}
			
			vo.setCol_str(sb.toString());
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.CustActionType");

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "CUST_NM","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> colMap : colInfoList){
				headerList.add(new Stat2HeaderVO(colMap.get("LABEL"), colMap.get("FIELDNAME"),"sum",null));
			}
			
			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else{
			throw new Exception("정의되지 않은 처리코드 입니다.\r\n["+searchType+"]");
		}
		
		returnMap.put("resultCode", "000");
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 유형별 A/S 현황
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/stat/list5.do")
	public String list5(@ModelAttribute("vo") StatVO vo, HttpServletRequest request) throws Exception {
		return "ad/stat/list5";
	}
	
	@RequestMapping(value = "/ad/stat/getListByRange.do")
	public void getListByRange(@ModelAttribute("vo") Stat2VO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		logger.debug(vo.toString());
		
		Map<String , Object> returnMap = new HashMap<String , Object>();
		
		String searchType = vo.getSearch_type();
		if (searchType == null) throw new Exception("처리코드 값이 NULL 입니다.");			
		// 각각의 타입별로 쿼리와 헤더정보를 달리 셋팅한다.
		
		// 월별조회 인가?
		boolean isMonths = vo.getSearch_start().length() == 6 && vo.getSearch_start().length() == 6 ? true : false;
		
		// 컬럼 리스트 데이터를 가져온다.
		List<Map<String, String>> colInfoList = (List<Map<String, String>>) commonDAO.list(vo, "statDAO.getRangeCol" + (isMonths ? "Months" : "Days"));
		
		StringBuffer sb = new StringBuffer();
		
		for (Map<String, String> map : colInfoList){
			logger.debug(map.get("COLS"));
			sb.append(',').append(map.get("COLS"));
		}
		
		vo.setCol_str(sb.toString());
		
		if ("accept_route".equals(searchType)){
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.RangAcceptRoute" + (isMonths ? "Months" : "Days"));

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "NAME","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> map : colInfoList){
				headerList.add(new Stat2HeaderVO(map.get("LABEL"), map.get("FIELDNAME"),"sum",null));
			}

			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("service_cate".equals(searchType)){
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.RangServiceCate" + (isMonths ? "Months" : "Days"));

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "NAME","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> map : colInfoList){
				headerList.add(new Stat2HeaderVO(map.get("LABEL"), map.get("FIELDNAME"),"sum",null));
			}

			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("cause_type".equals(searchType)){
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.RangCauseType" + (isMonths ? "Months" : "Days"));

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "NAME","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> map : colInfoList){
				headerList.add(new Stat2HeaderVO(map.get("LABEL"), map.get("FIELDNAME"),"sum",null));
			}

			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else if ("action_type".equals(searchType)){
			
			// 쿼리로 통계 데이터를 가져오다.
			List<Map> mapList = (List<Map>) commonDAO.list(vo, "statDAO.RangActionType" + (isMonths ? "Months" : "Days"));
			

			// 헤더 정보를 만든다.
			ArrayList<Stat2HeaderVO> headerList = new ArrayList<Stat2HeaderVO>();
			headerList.add(new Stat2HeaderVO("대상구분", "NAME","label","합산 누계"));
			headerList.add(new Stat2HeaderVO("총합계", "TOT","sum",null));
			
			for (Map<String, String> map : colInfoList){
				headerList.add(new Stat2HeaderVO(map.get("LABEL"), map.get("FIELDNAME"),"sum",null));
			}

			returnMap.put("resultHeader", headerList);
			returnMap.put("resultList", mapList);
			
		}else{
			throw new Exception("정의되지 않은 처리코드 입니다.\r\n["+searchType+"]");
		}
		
		returnMap.put("resultCode", "000");
		CommonExecute.returnJson(response, returnMap);
	}
	
	@RequestMapping(value = "/ad/stat/stat2Exl.do")
	public void stat2Exl(@RequestParam("data") String data, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		ObjectMapper om = new ObjectMapper() ;
		Stat2ExlVO vo = om.readValue(data, Stat2ExlVO.class);
		
		List<Map<String,String>> headerList = vo.getHeaderList();
		List<Map<String,String>> dataList = vo.getDataList();
		
		logger.debug("headerList size : " + headerList.size());
		logger.debug("dataList size : " + dataList.size());
		
		OutputStream fileOut = null;

		String exl_title = "통계분석";

		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet(exl_title);
		HSSFRow row = null;
		HSSFCell cell = null;
		
		int rowNum = 0;
		// 첫째 행 셋팅
		row = sheet.createRow(rowNum);
		rowNum++;
		
		for (int i=0; i < headerList.size(); i++){
			cell = row.createCell(i);
			cell.setCellValue(headerList.get(i).get("label"));
		}
		
		// 실 데이터 셋팅
		for (int i=0; i < dataList.size();i++){
			row = sheet.createRow(rowNum);
			rowNum++;
			for (int j=0; j < headerList.size(); j++){
				cell = row.createCell(j);
				cell.setCellValue(dataList.get(i).get(headerList.get(j).get("fieldName")));
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
		
		if (fileOut != null) fileOut.close();

	}
}
