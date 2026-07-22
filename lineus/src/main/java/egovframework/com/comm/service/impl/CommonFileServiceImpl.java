package egovframework.com.comm.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.dao.impl.CommonFileDaoImpl;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsFileUtil;
import egovframework.com.comm.util.SsStringUtil;

@Service("commonFileService")
public class CommonFileServiceImpl implements CommonFileService{
	
	@Autowired CommonFileDaoImpl commonFileDAO ;
	
	@Autowired CommonDao commonDAO ; 
	
	
	@Resource(name="uploadDirTempResource")
	protected FileSystemResource fileSystemResource ; 
	
	// protected final String secu_file_path = "/data/files" ;
	//protected final String secu_file_path = "C:\\Users\\pjh\\Desktop\\eGovFrameDev-3.6.0-64bit\\workspace\\jwpj\\src\\main\\webapp\\upload" ;
	//protected final String secu_file_path = "D:\\project\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp1\\wtpwebapps\\jwcrm\\upload" ;
	//protected final String secu_file_path = "D:\\project\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp1\\wtpwebapps\\jwcrm\\upload" ;
	protected final String secu_file_path = "C:\\upload" ;
	
	@Override
	public List<FileVO> uploadFormFile(MultipartHttpServletRequest request, String realPath) throws Exception {
		
		/***
		 * fileSystemResource.getpath() : editor, banner
		 * secu_file_path : progress, individual, notice, user
		 * 둘다 : swregister
		 */
		
		MultipartHttpServletRequest mpRequest = request ; 
		Iterator fileNameIterator = mpRequest.getFileNames() ; 
		
		InputStream stream = null ; 
		String tempFileName = "" ; 
		
		String targetDir = fileSystemResource.getPath() + File.separator + realPath + File.separator + DateTimeUtil.getDateFormatText(DateTimeUtil.getDate(), File.separator) + File.separator ;
		
		/**	경로 존재여부 체크	 - 없을 경우 생성	*/
		File target = new File(targetDir) ;
		if(!target.exists()) target.mkdirs() ; 
		
		List<FileVO> fileList = new ArrayList<FileVO>() ; 
		
		while(fileNameIterator.hasNext()){
			
			boolean isSecc = false ; 
			MultipartFile multiFile = mpRequest.getFile((String)fileNameIterator.next()) ;
			
			if(multiFile.getSize() > 0){
				
				tempFileName = multiFile.getOriginalFilename() ; 
				
				String namePartStr = tempFileName.substring(0 , tempFileName.indexOf(".")) ; 
				String extPartStr = tempFileName.substring(tempFileName.lastIndexOf(".") + 1 , tempFileName.length()) ; 
				String savePartStr = SsStringUtil.GetRandom(5) ;
				
				/*
				String header_mimeType = SsFileUtil.mimeType(multiFile.getInputStream()) ;
				
				if(!SsFileUtil.uploadType(header_mimeType, extPartStr)){
					throw new Exception("FileMimeType") ; 
				}*/
				
				stream = multiFile.getInputStream() ; 
				OutputStream bos = new FileOutputStream(targetDir + savePartStr + "." + extPartStr) ;
				
				
				int bytesRead = 0 ; 
				byte[] buffer = new byte[8192] ; 
				
				while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
					bos.write(buffer, 0, bytesRead);
				}
				
				bos.close(); 
				stream.close(); 
				
				FileVO vo = new FileVO() ; 
				
				vo.setAttach_ori_nm(multiFile.getOriginalFilename());
				vo.setAttach_save_nm(savePartStr + "." + extPartStr);
				
				vo.setAttach_path("/upload/" + realPath + "/" + DateTimeUtil.getDateText() + "/");
				
				vo.setFile_size(multiFile.getSize());
				
				vo.setAttach_path_dtl(targetDir);
				
				vo.setAttach_tag_name(multiFile.getName());
//				vo.setAttach_size(multiFile.getSize());

				fileList.add(vo);
			}
			
		} /**	while	*/
		
		return fileList;
	}

	@Override
	public void deleteFiles(List<FileVO> fileList) throws Exception {
		if(fileList != null && fileList.size() > 0){
			for(int i = 0 ; i < fileList.size() ; i++){
				FileVO vo = (FileVO) fileList.get(i) ; 
				
				File f = new File(vo.getAttach_path_dtl() + vo.getAttach_save_nm()) ;
				if(f.exists()) f.delete() ; 
			}
		}
	}
	
	@Override
	public void deleteFile(FileVO vo) throws Exception {
		if(vo != null){
			if(!"".equals(SsStringUtil.normalizeNull(vo.getAttach_path_dtl())) && !"".equals(SsStringUtil.normalizeNull(vo.getAttach_save_nm()))){
				File f = new File(vo.getAttach_path_dtl() + vo.getAttach_save_nm()) ; 
				if(f.exists()) f.delete() ; 
			}
		}
		
	}

	@Override
	public int deleteFileInfo(FileVO vo) throws Exception {
		//return commonFileDAO.deleteFileInfo(vo);
		return commonDAO.delete(vo, "commmonDAO.deleteFileInfo");
	}

	@Override
	public FileVO fileInfo(FileVO vo) throws Exception {
		return (FileVO)commonDAO.selectOne(vo, "commmonDAO.getFileInfo" );
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<FileVO> getFileList(FileVO vo) throws Exception {
	//	return commonFileDAO.getFileList(vo);
		return (List<FileVO>)commonDAO.list(vo, "commmonDAO.getFileList");
	}

	@Override
	public int deleteFileInfoAll(FileVO vo) throws Exception {
		//return commonFileDAO.deleteFileInfoAll(vo);
		return commonDAO.delete(vo, "commonFileDAO.deleteFileInfoAll" );
	}

	@Override
	public int getMaxFileSeq() throws Exception {
		//return commonFileDAO.getMaxFileSeq();
		return commonDAO.selectOneInt(null, "commmonDAO.maxSeq");
	}

	@Override
	public int insertFile(FileVO vo) throws Exception {
		return commonDAO.update(vo, "commmonDAO.insertFile") ; 
		//return commonFileDAO.insertFile(vo);
	}

	@Override
	public int updateFile(FileVO vo) throws Exception {
		return commonDAO.update(vo, "commonFileDAO.updateFile") ;
	}

	@Override
	public int getMaxFileOrd(FileVO vo) throws Exception {
		return commonDAO.selectOneInt(vo, "commmonDAO.maxOrd");
	}

	@Override
	public int updateFileMerge(FileVO vo) throws Exception {
		return commonDAO.update(vo, "commonFileDAO.updateFileMerge") ;
	}

}
