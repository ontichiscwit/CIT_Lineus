package egovframework.com.controller;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.httpclient.HttpClient;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.common.io.ByteStreams;
import com.sun.mail.iap.ProtocolException;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.MainVO;
import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.model.RoleVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.CommonExecute;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.CustVO;
import egovframework.com.service.LoginService;
import egovframework.com.service.MainCustService;


/**
 * @Class Name : AdMainCustController.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.09.19	김민지		           최초생성
 *
 * @author ITO 사업부 Biz 컨설팅팀 
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by  All right reserved.
 */

@Controller
public class AdMainCustController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdMainCustController.class) ;
	
	@Autowired MainCustService mainCustService ; 
	@Autowired CommonDao commonDao;
	
	/**
	 * 대시보드 - 병원 종류별 거래처 수
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getCustGubunCount.do")
	public void getCustGubunCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		returnMap.put("resultInfo", commonDao.list(vo, "mainCustDAO.getCustGubunCount")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 대시보드 - 유지보수 계약종류별 거래처 수
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getPayInfoCount.do")
	public void getPayInfoCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		returnMap.put("resultInfo", commonDao.list(vo, "mainCustDAO.getPayInfoCount")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 대시보드 - 유지보수 계약 지연 거래처 수
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getDelPayInfoCount.do")
	public void getDelPayInfoCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ; 
		returnMap.put("resultInfo", commonDao.list(vo, "mainCustDAO.getDelPayInfoCount")) ;
		
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 대시보드 - 계약 상세 정보 리스트 
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getPayInfoList.do")
	public void getPayInfoList(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
			
		if("C001".equals(SsStringUtil.normalizeNull(vo.getSearch_type2()))){
			//거래상태 : 무상
			returnMap.put("resultList", commonDao.list(vo, "mainCustDAO.getPayInfoListFree")) ;
		}else{
			//거래상태 : 유상, 중지, 폐업, 해지
			returnMap.put("resultList", commonDao.list(vo, "mainCustDAO.getPayInfoListNotFree")) ;
		}
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	
	/**
	 * 대쉬보드 - A/S현황  AS접수건수
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsInfoCount.do")
	public void getAsInfoCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_type2()))) vo.setSearch_type2(vo.getSearch_type2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_type3()))) vo.setSearch_type3(vo.getSearch_type3().replaceAll("/", "")) ;
		
		returnMap.put("resultInfo", commonDao.list(vo, "mainCustDAO.getAsInfoCount"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	
	/**
	 * 대쉬보드 - A/S현황  AS문의유형
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsServiceCateInfoCount.do")
	public void getAsServiceCateInfoCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_type2()))) vo.setSearch_type2(vo.getSearch_type2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_type3()))) vo.setSearch_type3(vo.getSearch_type3().replaceAll("/", "")) ;
		
		returnMap.put("resultInfo", commonDao.list(vo, "mainCustDAO.getAsServiceCateInfoCount"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	

	/**
	 * 대쉬보드 - A/S현황  A/진행상태
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getAsStatusInfoCount.do")
	public void getAsStatusInfoCount(@ModelAttribute("vo") MainVO vo, HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_type2()))) vo.setSearch_type2(vo.getSearch_type2().replaceAll("/", "")) ;
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_type3()))) vo.setSearch_type3(vo.getSearch_type3().replaceAll("/", "")) ;
		returnMap.put("resultInfo", commonDao.list(vo, "mainCustDAO.getAsStatusInfoCount"));
		CommonExecute.returnJson(response, returnMap);
	}
	
	/**
	 * 대쉬보드 - 프로젝트현황 조회
	 * @param vo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ad/main/getProjectInfo.do")
	public void getProjectInfo(@ModelAttribute("vo") MainVO vo, HttpServletRequest request ,HttpServletResponse response, HttpSession session) throws Exception {
		
		HttpURLConnection connection = null;
		InputStream is = null;
		
		if (connection != null) connection.disconnect();
		//URL url = new URL("http://dev.cwit.co.kr/wavsLog/selectPrjMst");
		URL url = new URL("http://services.cwit.co.kr/wavsLog/selectPrjMst");
		
		BufferedReader br = null;
        int statusCode;
        	
		connection = (HttpURLConnection)url.openConnection();
		
		JSONObject jsonObject = new JSONObject();
        
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSearch_type1()))) vo.setSearch_type1(vo.getSearch_type1().replaceAll("/", "")) ;
		jsonObject.put("reviewDate", vo.getSearch_type1());
        
        String json = "";
        json = jsonObject.toString();
        
        connection.setRequestProperty("Accept", "application/json");
        connection.setRequestProperty("Content-Type", "application/json");
		connection.setRequestMethod("POST");
		connection.setDoOutput(true);
		connection.setDoInput(true);
        
		OutputStreamWriter os = new OutputStreamWriter(connection.getOutputStream(),"UTF-8");
        os.write(json);
        os.flush();
        os.close();
		
		statusCode = connection.getResponseCode();
        
        try {
        	if (statusCode >= 200 && statusCode < 400) {
     		    
        		is = connection.getInputStream();
     		    ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
				
     		    byte[] byteBuffer = new byte[1024];
			    byte[] byteData = null;
			    int nLength = 0;
			    
			    while((nLength = is.read(byteBuffer, 0, byteBuffer.length)) != -1) {
			    	byteArray.write(byteBuffer, 0, nLength);
			    }
			    byteData = byteArray.toByteArray();
			    
			    String responseRaw = new String(byteData,"UTF-8");
			    JSONObject responseJSON = new JSONObject(responseRaw);
			    
			    Map<String , Object> returnMap = new HashMap<String , Object>() ;
				
			    //responseJSON.getJSONObject("myArrayList");
				/*JSONArray array = responseJSON.getJSONArray("result");
			    List list = new ArrayList<>();
				for (int i = 0; i < array.length(); i++) {
			        System.out.println(array.getJSONObject(i));
			        list.add(array.getJSONObject(i));
			    }*/
			    
			    String arrayString = responseJSON.getString("result");
			    
			    //returnMap.put("result", arrayString);
			    //CommonExecute.returnJson(response, returnMap);
				
			    CommonExecute.returnJsonString(response, arrayString);
			    
			   // String jsonResult = (String)responseJSON.get("result"); 
			    //System.out.println(jsonResult);     		
			 }
     		else {
     		   connection.getErrorStream();
     		  
     		}

		} catch (Exception e) {
			
		} finally {
			connection.disconnect();
			 os.close();
		}
        
		
	
	}
	
	/**
	 * 메인 대시보드 - 엑셀 다운로드
	 * @param vo
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ad/main/goExcel.do")
	public void goExcel(@ModelAttribute("vo") AsVO vo, ModelMap model, HttpServletRequest request , HttpServletResponse response , HttpSession session) throws Exception {
	
		OutputStream fileOut = null ; 
		
		String exl_title = "ONTIC HIS 사용 거래처 리스트" ;
		
		List<CustVO> resultList = (List<CustVO>) commonDao.list(vo, "mainCustDAO.getHisCustList");

		// 워크북 생성
		HSSFWorkbook workbook = new HSSFWorkbook() ; 
		
		// 시트 생성
		HSSFSheet sheet = workbook.createSheet(exl_title) ;
		
		HSSFRow row = null ; 
		HSSFCell cell = null ; 
		
		String[] title = { "No", "거래처명", "CRM코드", "거래상태", "HIS ver",  "사업장 소재지"};
		String[] refColumn = {"rnum", "cust_kor_name", "crm_code", "deal_code_nm", "his_treat_code_nm", "cust_address" };
		
		// 시트 셀 너비 강제 세팅
		// sheet.setColumnWidth(Column Index, 글자수*256 );
		sheet.setColumnWidth(0, 5*256 );	//No
		sheet.setColumnWidth(1, 40*256 );	//거래처명
		sheet.setColumnWidth(2, 12*256 );	//CRM코드
		sheet.setColumnWidth(3, 9*256 );	//거래상태
		sheet.setColumnWidth(4, 20*256 );	//HIS ver
		sheet.setColumnWidth(5, 20*256 );	//사업장 소재지
		
		// 셀 스타일 및 폰트 설정
		Font boldFont = workbook.createFont();
		boldFont.setBoldweight(Font.BOLDWEIGHT_BOLD);

		CellStyle tStyleM = workbook.createCellStyle();
		CellStyle bStyleM = workbook.createCellStyle();

		tStyleM.setAlignment(CellStyle.ALIGN_CENTER);
		tStyleM.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		tStyleM.setFillPattern(CellStyle.SOLID_FOREGROUND);
		tStyleM.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		tStyleM.setFont(boldFont);
		addBoardStyle(tStyleM, true);
		
		bStyleM.setVerticalAlignment(CellStyle.ALIGN_CENTER);
		bStyleM.setFillPattern(CellStyle.SOLID_FOREGROUND);
		bStyleM.setFillForegroundColor(IndexedColors.WHITE.getIndex());
		addBoardStyle(bStyleM, false);

		//첫 번째 행 세팅
		int rowNum = 0 ; 
		row = sheet.createRow(rowNum) ; 
		
		cell = row.createCell(0);
		cell.setCellValue("No");
		cell.setCellStyle(tStyleM);
		
		cell = row.createCell(1);
		cell.setCellValue("거래처명");
		cell.setCellStyle(tStyleM);
		
		cell = row.createCell(2);
		cell.setCellValue("CRM코드");
		cell.setCellStyle(tStyleM);
		
		cell = row.createCell(3);
		cell.setCellValue("거래상태");
		cell.setCellStyle(tStyleM);
		
		cell = row.createCell(4);
		cell.setCellValue("HIS ver");
		cell.setCellStyle(tStyleM);
		
		cell = row.createCell(5);
		cell.setCellValue("사업장 소재지");
		cell.setCellStyle(tStyleM);
		
		//두 번째 행 세팅
		rowNum++;
		row = sheet.createRow(rowNum);

		if (resultList != null && resultList.size() > 0) {
			for (int i = 0; i < resultList.size(); i++) {
				CustVO temp = resultList.get(i);
				row = sheet.createRow(rowNum);
				rowNum++;
				
				for (int a = 0; a < title.length; a++) {
					cell = row.createCell(a) ;
					cell.setCellStyle(bStyleM);
					
					String cellValue = "" ; 
					cellValue = SsStringUtil.normalizeNull(BeanUtils.getProperty(temp, refColumn[a]));
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
	
	
}
