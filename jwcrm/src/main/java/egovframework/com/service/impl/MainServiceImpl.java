/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.MainVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.service.MainService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : MainServiceImpl.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Service("mainService")	
public class MainServiceImpl extends EgovAbstractServiceImpl implements MainService {

	@Autowired CommonDao commonDAO ;

	@Override
	public int getSelectInt(MainVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, queryName);
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<MainVO> getList(MainVO vo, String queryName) throws Exception {
		return (List<MainVO>) commonDAO.list(vo, queryName);
	}

	@Override
	public MainVO getSelectOne(MainVO vo, String queryName) throws Exception {
		return (MainVO)commonDAO.selectOne(vo, queryName);
	}
}
