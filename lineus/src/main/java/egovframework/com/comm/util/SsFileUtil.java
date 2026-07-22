package egovframework.com.comm.util;

import java.io.InputStream;
import java.util.List;

import org.apache.tika.Tika;
import org.apache.tika.config.TikaConfig;
import org.apache.tika.mime.MimeTypes;


public class SsFileUtil {
	public static String mimeType(InputStream inputStream) throws Exception {
		return new Tika().detect(inputStream) ; 
	}
	
	public static boolean uploadType(String mimeType , String fileExtNm) throws Exception {
		
		boolean isResult = false ; 
		
		TikaConfig config = TikaConfig.getDefaultConfig() ;
		
		MimeTypes allTypes = config.getMimeRepository()  ; 
		
		List<String> resultList = allTypes.forName(mimeType).getExtensions() ; 
		
		String isif = "." + fileExtNm ; 
		
		
		
		if(resultList != null && resultList.size() > 0){
			
			for(int i = 0 ; i < resultList.size() ; i++){
				
				if(resultList.get(i).indexOf(isif) != -1){
					isResult = true ; 
					break ; 
				}
			}
		}else{
			 
		}
		
		if(!isResult){
			if("application/x-tika-msoffice".equals(mimeType) && "xls".equals(fileExtNm)) isResult = true ; 
			else if("application/x-tika-ooxml".equals(mimeType) && "xlsx".equals(fileExtNm)) isResult = true ;
			else if("application/x-tika-msoffice".equals(mimeType) && "doc".equals(fileExtNm)) isResult = true ;
			else if("application/zip".equals(mimeType) && "docx".equals(fileExtNm)) isResult = true ;
		}
		
		
		return  isResult ; 
	}
}
