package egovframework.com.comm.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.comm.model.FileVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("commonFileDAO")
public class CommonFileDaoImpl extends EgovAbstractMapper {
	
	 public FileVO getFileInfo(FileVO vo) throws Exception {
		 return (FileVO) selectOne("commonFileDAO.getFileInfo" , vo) ; 
	 }
	 
	 @SuppressWarnings("unchecked")
	 public List<FileVO> getFileList(FileVO vo) throws Exception {
		 return selectList("commonFileDAO.getFileList" , vo) ; 
	 }
	 
	 /***
	  * 일련번호를 생성하는 테이블에 값을 넣고 LAST_INSERT_ID()를 사용하여 값을 넘겨준다.
	  * @return
	  * @throws Exception
	  */
	 public int getMaxFileSeq() throws Exception {
		 
		 insert("commonFileDAO.getMaxFileSeq") ; 
		 
		 return (Integer) selectOne("commonDAO.getLastIndex") ; 
	 }
	 
	 public int insertFile(FileVO vo) throws Exception {
		 return  update("commonFileDAO.insertFile" , vo) ; 
	 }
	 
	 public int updateFile(FileVO vo) throws Exception {
		 return  update("commonFileDAO.updateFile" , vo) ; 
	 }
	 
	 public int getMaxFileDepth(FileVO vo) throws Exception {
		 return (Integer) selectOne("commonFileDAO.getMaxFileDepth", vo) ; 
	 }
	 
	 public int deleteFileInfoAll(FileVO vo) throws Exception {
		 return delete("commonFileDAO.deleteFileInfoAll", vo) ; 
	 }
	 
	 public int deleteFileInfo(FileVO vo) throws Exception {
		 return delete("commonFileDAO.deleteFileInfo", vo) ; 
	 }
}
