package egovframework.com.comm.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.comm.model.CommonCodeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("commonCodeDAO")
public class CommonCodeDaoImpl extends EgovAbstractMapper {

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getCodeList(CommonCodeVO vo) throws Exception{
		return selectList("commonCodeDAO.getCodeList", vo);
	}

		public String getCodeName(CommonCodeVO vo) throws Exception{
		return (String) selectOne( "commonCodeDAO.getCodeName" , vo );
	}

	public List<Map<String, Object>> selectCode(HashMap<String, Object> map) {
		return selectList("commonCodeDAO.selectCode", map);
	}
}
