package egovframework.com.service.impl;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
//import egovframework.com.comm.dao.CommonMsDao;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.model.AsStatsVo;
import egovframework.com.service.AsStatsService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : AsStatsServiceImpl.java
 * @
 * @  	수정일     		  수정자              수정내용
 * @ -----------   ---------   -------------------
 * @ 2021.02.15      이설아              최초생성 
 *
 *  Copyright (C) by MOPAS All right reserved.
 */


@Service("asStatsService")	
public class AsStatsServiceImpl extends EgovAbstractServiceImpl implements AsStatsService {  

	@Autowired CommonDao commonDAO ;
	//@Autowired CommonMsDao commonMsDAO;
	@Autowired CommonFileService commonFileService ;
	@Autowired CommonSmsService commonSmsService ;

	@Override
	@SuppressWarnings("unchecked")
	public List<AsStatsVo> getList(AsStatsVo vo, String query) throws Exception {
		return (List<AsStatsVo>) commonDAO.list(vo, query);
	}
	@Override
	public int getTotalCnt(AsStatsVo vo, String query) throws Exception {
		return commonDAO.selectOneInt(vo, query);
	}


	
}
