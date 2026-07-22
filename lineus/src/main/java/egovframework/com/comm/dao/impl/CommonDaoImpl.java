package egovframework.com.comm.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.comm.dao.CommonDao;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("commonDAO")
public class CommonDaoImpl extends EgovAbstractMapper implements CommonDao {
	
	
	@SuppressWarnings("unchecked")
	public List<?> list(Object vo , String queryName) throws Exception{
		return selectList(queryName, vo) ; 
	}
	
	public int selectOneInt(Object vo , String queryName) throws Exception{
		
		return selectOne(queryName, vo);
	}
	
	public Object selectOne(Object vo , String queryName) throws Exception{
		return  selectOne(queryName, vo);
	}

	public int insert(Object vo , String queryName) throws Exception{
		return update(queryName, vo);
	}
	
	public int update(Object vo , String queryName) throws Exception{
		return update(queryName, vo);
	}
	
	public int delete(Object vo , String queryName) throws Exception{
		return delete(queryName, vo);
	}
	
	

}
