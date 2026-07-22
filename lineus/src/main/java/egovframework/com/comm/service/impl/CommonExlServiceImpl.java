package egovframework.com.comm.service.impl;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Service;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.service.CommonExlService;

@Service("commonExlService")
public class CommonExlServiceImpl implements CommonExlService{

	@Override
	public List<HashMap<String, Object>> getExlReadList(FileVO vo) throws Exception {
		
		List<HashMap<String, Object>> returnList = new ArrayList<HashMap<String, Object>>() ;
		
		/**	FILEVO에 있는 데이터를 기준으로 경로를 가져온다.		*/
		
		String real_path = "D:\\Tool\\eGovFrameDev-3.5.1-64bit\\workspace\\document\\90. 기타자료\\TC_Sample.xls" ; 
		
		FileInputStream fis = new FileInputStream(real_path) ; 
		HSSFWorkbook workbook = new HSSFWorkbook(fis) ;
		
		int rowindex = 0 ; 
		int columnindex = 0 ; 
		
		/**	sheet1만 가지고 온다.	*/
		HSSFSheet sheet = workbook.getSheetAt(0) ; 
		
		/**	line 수를 가져온다.	*/
		int rows = sheet.getPhysicalNumberOfRows() ; 
		
		for(rowindex = 0; rowindex < rows ; rowindex++ ){
			/**	행을 읽는다.	*/
			HSSFRow row = sheet.getRow(rowindex) ; 
			
			
			if(row != null){
				
				HashMap<String, Object> hashMap = new HashMap<String,Object>() ;
				
				/**	cell의 수	*/
				int cells = row.getPhysicalNumberOfCells() ;
				
				for(columnindex = 0 ; columnindex <= cells ; columnindex++){
					/**	cell 값을 읽는다.	*/
					HSSFCell cell = row.getCell(columnindex) ; 
					if(cell == null){
						continue ; 
					}else{
						switch(cell.getCellType()){
						case HSSFCell.CELL_TYPE_FORMULA : hashMap.put("cell" + columnindex, cell.getCellFormula()) ; break ;  
						case HSSFCell.CELL_TYPE_NUMERIC : hashMap.put("cell" + columnindex, String.valueOf(cell.getNumericCellValue())) ; break ;  
						case HSSFCell.CELL_TYPE_STRING : hashMap.put("cell" + columnindex, cell.getStringCellValue()) ; break ;  
						case HSSFCell.CELL_TYPE_BLANK : hashMap.put("cell" + columnindex, String.valueOf(cell.getBooleanCellValue())) ; break ;  
						case HSSFCell.CELL_TYPE_ERROR : hashMap.put("cell" + columnindex, String.valueOf(cell.getErrorCellValue())) ; break ;  
						}
					}
				}
				
				returnList.add(hashMap) ; 
				
			}
			
		}
		
		return returnList ;
	}
	
}
