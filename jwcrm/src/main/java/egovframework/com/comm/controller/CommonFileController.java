package egovframework.com.comm.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.DownHistVO;
import egovframework.com.service.BoardService;

@Controller
public class CommonFileController {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonFileController.class) ;
	
	@Autowired CommonFileService commonFileService ;
	@Autowired BoardService boardService ; 
	
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
					
					//response.setHeader("Content-Disposition", "attachment;filename=" + new String(SsStringUtil.normalize(fileDetail.getAttach_ori_nm(), "파일 다운로드").getBytes("EUC-KR"), "8859_1") + ";") ; 
					
					boolean ie = (request.getHeader("User-Agent").indexOf("MSIE") > -1) || (request.getHeader("User-Agent").indexOf("Trident") > -1);
					
					
					/*if(request.getHeader("User-Agent").contains("Firefox")) {
						response.setHeader("Content-Disposition", "attachment;filename=\"" + new String(SsStringUtil.normalize(fileDetail.getAttach_ori_nm(), "파일 다운로드").getBytes("UTF-8"), "IOS-8859-1") + "\";") ; 
					}else {
						response.setHeader("Content-Disposition", "attachment;filename=\"" + new String(SsStringUtil.normalize(fileDetail.getAttach_ori_nm(), "파일 다운로드").getBytes("UTF-8"), "8859_1") +"\";") ; 
					}*/
					
					
					String fileName ="";
					if (request.getHeader("User-Agent").contains("MSIE") || request.getHeader("User-Agent").contains("Trident") ) {
					    fileName = URLEncoder.encode(fileDetail.getAttach_ori_nm(),"UTF-8").replaceAll("\\+", "%20");
					    response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ";");
					} else {
					    fileName = new String(fileDetail.getAttach_ori_nm().getBytes("UTF-8"), "8859_1");
					    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
					}
					
					
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
	
}
