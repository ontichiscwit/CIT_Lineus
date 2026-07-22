package egovframework.com.comm.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.comm.dao.CommonMsDao;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("commonMsDAO")
public class CommonMsDaoImpl extends EgovAbstractMapper implements CommonMsDao {


	@Resource(name="otherSqlSession")
	public void setSqlSessionFactory(SqlSessionFactory sqlSession) {
		super.setSqlSessionFactory(sqlSession);
	}
	
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
