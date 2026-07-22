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
import javax.servlet.http.HttpServletRequest;
import egovframework.com.model.SmsVO;

/**
 * @Class Name : SmsService.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.10.16	정연호    최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2016. 06.20
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */
public interface SmsService {
	public List<SmsVO> getList(SmsVO vo, String string) throws Exception;
	public int insertProc(SmsVO vo, HttpServletRequest request) throws Exception;
	public int updateProc(SmsVO vo, HttpServletRequest request) throws Exception;
	public SmsVO getDetail(SmsVO vo) throws Exception;
	public SmsVO getSenderTel(SmsVO vo) throws Exception;
	public SmsVO getSenderEmail(SmsVO vo) throws Exception;
}
