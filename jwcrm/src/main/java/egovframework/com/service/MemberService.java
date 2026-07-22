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
package egovframework.com.service;

import java.util.List;

import egovframework.com.comm.model.UserVO;

/**
 * @Class Name : MemberService.java
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
public interface MemberService {
	
	public int getSelectInt(UserVO vo , String queryName) throws Exception ; 
	public List<UserVO> getList(UserVO vo , String queryName) throws Exception ; 
	public UserVO getSelectOne(UserVO vo , String queryName) throws Exception ; 
	
	public int registMemberChange(UserVO vo ) throws Exception ; 
	public int registMemberPassChange(UserVO vo ) throws Exception ; 
	public int registMemberInsert(UserVO vo ) throws Exception ; 
	public int registMemberUpdate(UserVO vo ) throws Exception ; 
	public int registMemberPUpdate(UserVO vo ) throws Exception ; 
	
	public int registErpChange(UserVO vo ) throws Exception ; 
	public int registErpPassChange(UserVO vo ) throws Exception ; 
	public int registErpInsert(UserVO vo ) throws Exception ; 
	public int registErpUpdate(UserVO vo ) throws Exception ;
	public int registErpUpdate2(UserVO vo ) throws Exception ;
	
	public int registRatingInfo(UserVO vo ) throws Exception ;
	public int custErpEmpId(UserVO vo) throws Exception ;
}
