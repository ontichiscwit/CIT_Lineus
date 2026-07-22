package egovframework.com.comm.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.dao.CommonDao;
/*import egovframework.com.comm.dao.CommonMsDao;*/
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.InterfaceVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.DownHistVO;
import egovframework.com.model.MssqlVO;
import egovframework.com.service.BoardService;

@Controller
public class CommonFileController {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonFileController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired BoardService boardService ; 
	@Autowired CommonDao commonDAO ; 
	/*@Autowired CommonMsDao commonMsDAO ;*/ 
	
	
	@RequestMapping(value = "/comm/fileDown.do")
	public void fileDown(ModelMap model, @ModelAttribute("vo") FileVO vo, HttpServletRequest request, HttpServletResponse response,  HttpSession session){
		
		BufferedInputStream fin =  null ;
		BufferedOutputStream outs = null ; 
		
		try{
			
			FileVO fileDetail = commonFileService.fileInfo(vo) ;
			
			if(fileDetail != null){
				
				File f = new File(fileDetail.getAttach_path_dtl() + fileDetail.getAttach_save_nm()) ; 
				
				if(f.exists()){
					byte[] b = new byte[4096] ;
					
					response.setHeader("Content-Type", "application/octet-stream") ;
					response.setHeader("Content-Transfer-Encoding", "binary") ; 
					response.setHeader("Content-Disposition", "attachment;filename=" + new String(SsStringUtil.normalize(fileDetail.getAttach_ori_nm(), "파일 다운로드").getBytes("EUC-KR"), "8859_1") + ";") ; 
					response.setHeader("Pragma", "no-cache;") ; 
					response.setHeader("Expires", "-1") ; 
					//response.setContentLength((int)f.length());
					
					fin = new BufferedInputStream(new FileInputStream(f)) ; 
					outs = new BufferedOutputStream(response.getOutputStream()) ; 
					
					int read = 0 ; 
					
					while((read = fin.read(b)) != -1){
						outs.write(b, 0 , read) ; 
					}
					
					outs.close() ; 
					fin.close() ; 
					
					
				}else{
					logger.info("File DOWN Fail :: is not exist");
				}
				
				// fr 사용자만 로그남기기
				if (session.getAttribute("frUserInfo") != null && session.getAttribute("adUserInfo") == null){
					// 20171115 파일 다운로드 후에 다운로드 로그 기록하기
					UserVO userInfo = session.getAttribute("adUserInfo") != null ? (UserVO) session.getAttribute("adUserInfo") : (UserVO) session.getAttribute("frUserInfo") ;
					
					String empId = SsStringUtil.isDefined(userInfo.getEmp_no()) ? userInfo.getEmp_no() : userInfo.getEmp_id(); 
					logger.debug("userInfo.getCust_code() : " + userInfo.getCust_code());
					logger.debug("userInfo.getEmp_no() : " + userInfo.getEmp_no());
					logger.debug("userInfo.getEmp_no() : " + userInfo.getEmp_id());
					
					DownHistVO downHistVo = new DownHistVO();
					
					downHistVo.setAttach_seq(vo.getAttach_seq());
					downHistVo.setAttach_ord(vo.getAttach_ord());
					downHistVo.setCrm_code(userInfo.getCust_code());
					downHistVo.setReg_id(empId);
					downHistVo.setAttach_ori_nm(fileDetail.getAttach_ori_nm());
					
					boardService.insertDownHist(downHistVo);
				}
			}
			
		}catch(Exception e){
			logger.error("File DOWN Fail",e);
		}finally{
			try{
				if(outs != null) outs.close() ; 
				if(fin != null) fin.close() ;
			}catch(Exception e){
				logger.error("File DOWN Fail",e);
			}
		}
	}
	
	@RequestMapping(value = "/comm/appDown.do")
	public void appDown(ModelMap model, @ModelAttribute("vo") FileVO vo, HttpServletRequest request, HttpServletResponse response){
		
		BufferedInputStream fin =  null ;
		BufferedOutputStream outs = null ; 
		
		String file_nm = "app-debug.apk" ; 	/**	파일 경로	*/
		
		try{
			
			File f = new File("D:\\upload\\file" + File.separator + file_nm) ; /**	APP 경로	*/ 
			
			if(f.exists()){
				byte[] b = new byte[4096] ;
				
				response.setHeader("Content-Type", "application/octet-stream") ;
				response.setHeader("Content-Transfer-Encoding", "binary") ; 
				response.setHeader("Content-Disposition", "attachment;filename=" + new String(SsStringUtil.normalize(file_nm, "파일 다운로드").getBytes("EUC-KR"), "8859_1") + ";") ; 
				response.setHeader("Pragma", "no-cache;") ; 
				response.setHeader("Expires", "-1") ; 
				
				fin = new BufferedInputStream(new FileInputStream(f)) ; 
				outs = new BufferedOutputStream(response.getOutputStream()) ; 
				
				int read = 0 ; 
				
				while((read = fin.read(b)) != -1){
					outs.write(b, 0 , read) ; 
				}
				
				outs.close() ; 
				fin.close() ; 
				
			}
			
		}catch(Exception e){
			// System.out.println("File DOWN Fail");
		}finally{
			try{
				if(outs != null) outs.close() ; 
				if(fin != null) fin.close() ;
			}catch(Exception e){
				// System.out.println("File DOWN Fail");
			}
		}
	}
	
	
	private byte[] getFile4Url(String urlStr) throws IOException {
	  
	  ByteArrayOutputStream baos = new ByteArrayOutputStream();
      URL url = new URL(urlStr);
      InputStream is = url.openStream();
      byte[] buffer = new byte[4096];
      int readByte = 0;
      
      while ((readByte = is.read(buffer)) != -1) {
         baos.write(buffer, 0, readByte);
         baos.flush();
      }
      
      return baos.toByteArray();
	}
	
	
	/*
	@RequestMapping(value = "/comm/fileDownByLink.do")
    public void fileDown2(ModelMap model, @ModelAttribute("vo") FileVO vo, HttpServletRequest request, HttpServletResponse response,  HttpSession session){
		
		BufferedInputStream fin =  null ;
		BufferedOutputStream outs = null ; 
		//String ssAddress =  "172.24.80.70";
		String ssAddress =  "10.12.10.50";
		
		String prototype ="http:";
		
		try{
			
			MssqlVO tempVo = new MssqlVO();
			tempVo.setDocid(vo.getShared_doc_id());
			tempVo = (MssqlVO) commonMsDAO.selectOne(tempVo, "asDAO.getDocattach");
			

			response.setHeader("Content-Type", "application/octet-stream") ;
			response.setHeader("Content-Transfer-Encoding", "binary") ;
			response.setHeader("Content-Disposition", "attachment;filename=" + new String(SsStringUtil.normalize(tempVo.getFilenm(), "파일 다운로드").getBytes("EUC-KR"), "8859_1") + ";") ; 
			response.setHeader("Pragma", "no-cache;") ; 
			response.setHeader("Expires", "-1") ; 
			
			
			String strUrl = tempVo.getFilepath().replaceAll("\\\\", "/");
			strUrl = strUrl.replaceAll("JWGW-SQL01", ssAddress);
			
			String[] words = strUrl.split("/");
			String fileNm = words[words.length -1];
			
			String urlPath ="";
			for(int i = 0 ; i < words.length -1 ; i++) {
				urlPath += words[i];
				urlPath += "/";
			}
			
			String sendUrl = prototype + urlPath + URLEncoder.encode(fileNm, "UTF-8");
			
			
			logger.error(sendUrl);
			
			byte[] readBytes = getFile4Url(sendUrl);
			
			OutputStream sos = response.getOutputStream();
			sos.write(readBytes);
			sos.flush();
			sos.close();
			
		}catch(Exception e){
			logger.error("File DOWN Fail",e);
		}finally{
			try{
				if(outs != null) outs.close() ; 
				if(fin != null) fin.close() ;
			}catch(Exception e){
				logger.error("File DOWN Fail",e);
			}
		}
	}
	 */
	
	
	
	
	
	
	/***
	 * editor 단일 파일 첨부 처리
	 * @param model
	 * @param vo
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/editor/photoUpload.do")
	public void photoUpload(ModelMap model, @ModelAttribute("vo") FileVO vo, HttpServletRequest request, HttpServletResponse response, MultipartHttpServletRequest multiReqeust){
		try{
			
			String callback = SsStringUtil.normalizeNull(request.getParameter("callback")) ; 
			callback = callback + "?callback_func=" + SsStringUtil.normalizeNull(request.getParameter("callback_func")) ; 
			
			List<FileVO> fileList = commonFileService.uploadFormFile(multiReqeust, "editor") ;
			
			if(fileList != null && fileList.size() > 0){
				FileVO fileInfo = fileList.get(0) ;
				
				if(SsStringUtil.isImageFile(fileInfo.getAttach_ori_nm().toLowerCase())){
					
					fileInfo.setAttach_seq(commonFileService.getMaxFileSeq());
					
					callback += "&bNewLine=true" ; 
					callback += "&sFileName=" + URLEncoder.encode(fileInfo.getAttach_ori_nm(), "UTF-8") ; 
					callback += "&sFileURL=" + fileInfo.getAttach_path() + URLEncoder.encode(fileInfo.getAttach_save_nm(), "UTF-8") ;
					
					/*callback += "&attach_seq=" + fileInfo.getAttach_seq() ; 
					fileInfo.setAttach_depth(1);
					commonFileService.insertFile(fileInfo) ; */
					
					
				}else{
					callback += "&errstr" + fileInfo.getAttach_ori_nm() ;  
				}
				
			}
			
			response.sendRedirect(callback);
			
		}catch(Exception e){
			// System.out.println("EDITOR FILE UPLOAD ERROR!!");
		}
	}
	

	/***
	 * editor 단일 파일 첨부 처리
	 * @param model
	 * @param vo
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/editor/multiplePhotoUpload.do")
	public void multiplePhotoUpload(ModelMap model, @ModelAttribute("vo") FileVO vo, HttpServletRequest request, HttpServletResponse response, MultipartHttpServletRequest multiReqeust){
		
		PrintWriter out = null ; 
		
		String sFileInfo = "" ; 
		
		try{
			
			List<FileVO> fileList = commonFileService.uploadFormFile(multiReqeust, "editor") ;
			
			if(fileList != null && fileList.size() > 0){
				out = response.getWriter() ; 
				
				for(int i = 0 ; i < fileList.size() ; i++){
					FileVO fileInfo = fileList.get(i) ;
					
					if(SsStringUtil.isImageFile(fileInfo.getAttach_ori_nm().toLowerCase())){
	 
						sFileInfo += "&bNewLine=true";    
				        sFileInfo += "&sFileName=" + vo.getAttach_ori_nm();    
				        sFileInfo += "&sFileURL=" + vo.getAttach_path() + vo.getAttach_save_nm();
				        out.println(sFileInfo);
						
					}else{
						out.print("NOTALLOW_" + vo.getAttach_ori_nm());
					}
					
				}
			}
			
		}catch(Exception e){
			// System.out.println("EDITOR FILE UPLOAD ERROR!!");
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@RequestMapping(value = "/upload/editor/{year}/{month}/{day}/{fileNm}")
	public HttpEntity<byte[]> editorImageDownLoad(@PathVariable("year") String year
			,@PathVariable("month") String month
			,@PathVariable("day") String day
			,@PathVariable("fileNm") String fileNm ){
		byte[] documentBody =null;
		HttpHeaders header = new HttpHeaders();
		
		
		String saveDir = "c:/upload/editor/"
			+ year + "/"
			+ month + "/"
			+ day + "/";
		
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(saveDir + "/" + fileNm);
			documentBody = new byte[fis.available()];
			fis.read(documentBody);
			
			header.set("Content-Type","image");
		    header.set("Content-Disposition", "attachment; filename=" + fileNm);
		    header.setContentLength(documentBody.length);
			
		}catch(Exception e) {
			logger.error("파일 입출력 에러",e);
			
		}finally {
			if (fis != null) try {fis.close();}catch(Exception e) {}
		}
		
		return new HttpEntity<byte[]>(documentBody, header);
	}
	
}
