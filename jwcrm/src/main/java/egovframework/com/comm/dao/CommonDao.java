package egovframework.com.comm.dao;

import java.util.List;

public interface CommonDao {
	public List<?> list(Object vo , String queryName) throws Exception ; 
	
	public int selectOneInt(Object vo , String queryName) throws Exception ; 
	
	public Object selectOne(Object vo , String queryName) throws Exception ; 

	public int insert(Object vo , String queryName) throws Exception ; 
	
	public int update(Object vo , String queryName) throws Exception ;
	
	public int delete(Object vo , String queryName) throws Exception ; 
	
	
}
