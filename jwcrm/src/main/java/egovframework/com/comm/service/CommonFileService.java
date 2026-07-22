package egovframework.com.comm.service;

import java.util.List;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.comm.model.FileVO;


public interface CommonFileService {
	
	public List<FileVO> uploadFormFile(MultipartHttpServletRequest request, String realPath) throws Exception ;
	
	public void deleteFiles(List<FileVO> fileList) throws Exception ;
	public void deleteFile(FileVO vo) throws Exception ;
	
	public FileVO fileInfo(FileVO vo) throws Exception ; 
	public List<FileVO> getFileList(FileVO vo) throws Exception ;
	
	public int deleteFileInfoAll(FileVO vo) throws Exception ;
	public int deleteFileInfo(FileVO vo) throws Exception ;
	
	public int getMaxFileSeq() throws Exception ;
	public int getMaxFileOrd(FileVO vo) throws Exception ;
	public int deleteFileByAttachSeq(FileVO vo) throws Exception ;
	
	
	public int insertFile(FileVO vo) throws Exception ;
	
	public int updateFile(FileVO vo) throws Exception ;
	public int updateFileMerge(FileVO vo) throws Exception ;
}
