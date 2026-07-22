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

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;
import egovframework.com.model.OperateVO;
import egovframework.com.service.AsService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : AsServiceImpl.java
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @
 *   2017.09.08 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 		Copyright (C) by MOPAS All right reserved.
 */

@Service("asService")
public class AsServiceImpl extends EgovAbstractServiceImpl implements AsService {

	@Autowired
	CommonDao commonDAO;
	@Autowired
	CommonFileService commonFileService;
	@Autowired
	CommonSmsService commonSmsService;

	@Override
	public Map<String, Object> getAsCustInfo(AsVO vo) throws Exception {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		commonDAO.selectOne(vo, "asDAO.getAsCustInfo");
		returnMap.put("info", vo.getOUTCURSOR());

		return returnMap;
	}

	@Override
	public int getMaxSeq() throws Exception {
		return commonDAO.selectOneInt(null, "asDAO.getMaxSeq");
	}

	@Override
	public int insertAsInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {

	    int returnValue = 0;
	    int attach_seq = 0;
	    int attach_seq2 = 0;

	    String mobile_no = "";
	    String emp_nm = "";
	    AsVO asTypeVO;

	    if (fileList != null && fileList.size() > 0) {
			for (FileVO temp : fileList) {
				if (temp.getAttach_tag_name().startsWith("uploadFile_")) {
					if (attach_seq == 0)
						attach_seq = commonFileService.getMaxFileSeq();
					temp.setAttach_seq(attach_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				} else if (temp.getAttach_tag_name().startsWith("upFile_")) {
					if (attach_seq2 == 0)
						attach_seq2 = commonFileService.getMaxFileSeq();
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
				}
			}
		}

		vo.setFile_seq(String.valueOf(attach_seq));
		vo.setAttach_seq2(attach_seq2);


	    /* =========================
	       2. AS 번호 채번 및 INSERT
	       ========================= */
	    vo.setAs_no((String) commonDAO.selectOne(vo, "asDAO.getMaxSeq"));
	    vo.setAccept_dt(DateTimeUtil.getDate());
	    vo.setAccept_time(DateTimeUtil.getTime());

	    returnValue = commonDAO.update(vo, "asDAO.insertAsInfo");

	    if (returnValue <= 0) {
	        return 0;
	    }

	    /* =====================================================
	       3. AS_NO_LINK 그룹 구성 및 통합
	       ===================================================== */
	    java.util.Set<String> groupSet = new java.util.LinkedHashSet<>();

	    // 화면에서 넘어온 연관 AS
	    if (vo.getAs_no_link() != null && !"".equals(vo.getAs_no_link().trim())) {
	        for (String s : vo.getAs_no_link().split(",")) {
	            if (s != null && !"".equals(s.trim())) {
	                groupSet.add(s.trim());
	            }
	        }
	    }

	    // 신규 AS 포함
	    groupSet.add(vo.getAs_no());

	    if (!groupSet.isEmpty()) {

	        java.util.Queue<String> queue =
	            new java.util.ArrayDeque<>(groupSet);

	        while (!queue.isEmpty()) {

	            java.util.List<String> batch = new java.util.ArrayList<>();
	            while (!queue.isEmpty()) {
	                batch.add(queue.poll());
	            }

	            java.util.Map<String, Object> param = new java.util.HashMap<>();
	            param.put("cust_code", vo.getCust_code());
	            param.put("asNoList", batch);

	            @SuppressWarnings("unchecked")
	            java.util.List<AsVO> rows =(java.util.List<AsVO>) commonDAO.list(param,"asDAO.selectLinkedAsGroup");

	            if (rows != null) {
	                for (AsVO row : rows) {

	                    String asNo = SsStringUtil
	                        .normalizeNull(row.getAs_no()).trim();
	                    if (!"".equals(asNo) && groupSet.add(asNo)) {
	                        queue.add(asNo);
	                    }

	                    String link =
	                        SsStringUtil.normalizeNull(row.getAs_no_link()).trim();
	                    if (!"".equals(link)) {
	                        for (String t : link.split(",")) {
	                            if (t != null && !"".equals(t.trim())
	                                && groupSet.add(t.trim())) {
	                                queue.add(t.trim());
	                            }
	                        }
	                    }
	                }
	            }
	        }

	        /* =====================================================
	        3.5 file_seq 보정 (수정본)
	        - as_no_link(연관 AS)가 존재하면
	        - 본인 포함(groupSet 그대로)해서
	        - groupSet 중 "가장 최신 AS"의 file_seq를 가져와서 현재 AS에 세팅
	        ===================================================== */
		     {
		         // as_no_link가 있을 때만 실행 (연관 AS가 존재하는 경우)
		         if (vo.getAs_no_link() != null && !"".equals(vo.getAs_no_link().trim())) {
	
		             Map<String, Object> fsParam = new HashMap<>();
		             fsParam.put("cust_code", vo.getCust_code());
		             fsParam.put("asNoList", new ArrayList<>(groupSet)); // 본인 포함
	
		             // 최신 AS의 file_seq (null/0/공백 제외) 1건
		             String latestFileSeq = (String) commonDAO.selectOne(fsParam,"asDAO.selectLatestFileSeqByAsNoListIncludeSelf");
	
		             latestFileSeq = SsStringUtil.normalizeNull(latestFileSeq).trim();
	
		             if (!"".equals(latestFileSeq) && !"0".equals(latestFileSeq)) {
		                 vo.setFile_seq(latestFileSeq);
		                 commonDAO.update(vo, "asDAO.updateFileSeqSingle"); // 현재 as_no의 file_seq 업데이트
		             }
		         }
		     }

	        /* =========================
	           4. AS_NO_LINK 문자열 생성
	           ========================= */
	        StringBuilder sb = new StringBuilder();
	        boolean first = true;
	        for (String s : groupSet) {
	            if (!first) sb.append(",");
	            sb.append(s);
	            first = false;
	        }
	        String fullLink = sb.toString();

	        if (!fullLink.equals(vo.getAs_no())) {
	            vo.setAs_no_link(fullLink);
	            commonDAO.update(vo, "asDAO.updateAsNoLinkSingle");

	            Map<String, Object> updateMap = new HashMap<>();
	            updateMap.put("asNoLink", fullLink);
	            updateMap.put("asNoList", new ArrayList<>(groupSet));
	            updateMap.put("cust_code", vo.getCust_code());

	            commonDAO.update(updateMap, "asDAO.updateAsNoLinkForGroup");
	        }

	        /* =====================================================
		        5. 재문의 담당자 자동배정 (우선순위 + 퇴사자 제외)
		        기준: 처리완료 담당자 > 처리중 담당자 > 접수 담당자
		             (각 그룹 내 최신 AS 우선)
		        ===================================================== */
		     {
		         Map<String, Object> assignParam = new HashMap<>();
		         assignParam.put("asNoList", new ArrayList<>(groupSet));
		         assignParam.put("as_no", vo.getAs_no()); // 신규 AS 제외 (유지)
	
		         String unifiedAssignId = (String) commonDAO.selectOne(assignParam,"asDAO.selectAssignIdByPriorityFromAsNoList");
	
		         unifiedAssignId = SsStringUtil.normalizeNull(unifiedAssignId).trim();
	
		         if (!"".equals(unifiedAssignId) && !unifiedAssignId.equals(vo.getAssign_id())) {
		             vo.setAssign_id(unifiedAssignId);
		             commonDAO.update(vo, "asDAO.updateAssignIdSingle");
		         }
		     }
	    }

	    /* =========================
	       6. 기존 후처리 로직
	       ========================= */
	    commonDAO.update(vo, "asDAO.updateAsWkCount");

	    // 알림, 긴급알림, 히스토리 insert (기존 코드 유지)
	    vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	    commonDAO.insert(vo, "asDAO.insertAsInfoHist");

	    return returnValue;
	}


	@Override
	public int insertVoicebotAsInfo(AsVO vo, HttpServletRequest request) throws Exception {
		
		int returnValue = 0;
		int cnt = 0;
		
		vo.setAccept_dt(DateTimeUtil.getDate());
		vo.setAccept_time(DateTimeUtil.getTime());
		vo.setApply_nm(vo.getCust_nm());
		vo.setApply_id(vo.getCust_code());
		vo.setAccept_route("C010");
		vo.setRequest_type("C999");
		vo.setProc_status("C001");
		vo.setReg_id("SYSTEM");
		vo.setCust_kor_name(vo.getCust_nm());
		
		commonDAO.insert(vo, "asDAO.insertAsVoiceHist");
		
		if("Y".equals(vo.getSuccess_yn())) {
			
			/**알림톡 체크 컬럼 Y 값으로 모두 변경 */
			commonDAO.update(vo, "asDAO.updateAsVoiceHistCheckyn");
			
			vo.setAs_no((String) commonDAO.selectOne(vo, "asDAO.getMaxSeq"));
			
			vo.setAssign_id((String) commonDAO.selectOne(vo, "asDAO.getVoiceWorker"));
			
			commonDAO.update(vo, "asDAO.updateAsWkCount");
			
			returnValue = commonDAO.update(vo, "asDAO.insertAsInfo");
			
			/** HIST 등록 */
			if (returnValue > 0) {
				if("Y".equals(vo.getSend_sms())) {
					vo.setCnt(1);
					vo.setAlimTalk_message(getAlimTalkMessage(vo));
					vo.setSms_message(getSmsMessage(vo));
					//vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
					vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
					commonDAO.update(vo, "asDAO.insertMsgInfo");
				}
	
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
			
		}else {
			/**1시간 이내 같은 번호로 연속 실패 3건 체크 여부(알림톡 발송 후 체크) */
			vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
			vo.setFlc_yn((String) commonDAO.selectOne(vo, "asDAO.getAsVoiceHistFlcyn"));
			
			if("Y".equals(vo.getFlc_yn())) {
				/**알림톡 체크 컬럼 Y 값으로 모두 변경 */
				commonDAO.update(vo, "asDAO.updateAsVoiceHistCheckyn");
				
				/**알림톡 관련 변수 설정 및 알림톡 발송 */
				
				@SuppressWarnings("unchecked")
				List<String> mobileNoList = (List<String>) commonDAO.list(vo, "asDAO.getVoiceMobileNo");
				
				if (mobileNoList != null) {
					for (String mobile : mobileNoList) {
						if (mobile == null) {
				            continue;  // mobile이 null인 경우 패스
				        }
						vo.setMobile_no(mobile);
						
						cnt = commonDAO.selectOneInt(vo, "asDAO.getVoiceBotMsgCnt");
						vo.setCnt(cnt);
						
						vo.setAlimTalk_message(getVoiceBotAlimTalkMessage(vo));
						vo.setSms_message(getVoiceBotSmsMessage(vo));
						
						commonDAO.update(vo, "asDAO.insertAsVoiceBotMsgInfo");
						
					}
				}
			}
			
		}
		return returnValue;
	}
	
	@Override
	public int insertAsCnInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		int returnValue = 0;
		int attach_seq = 0;
		int attach_seq2 = 0;

		if (fileList != null && fileList.size() > 0) {
			for (FileVO temp : fileList) {
				if (temp.getAttach_tag_name().startsWith("uploadFile_")) {
					if (attach_seq == 0)
						attach_seq = commonFileService.getMaxFileSeq();
					temp.setAttach_seq(attach_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				} else if (temp.getAttach_tag_name().startsWith("upFile_")) {
					if (attach_seq2 == 0)
						attach_seq2 = commonFileService.getMaxFileSeq();
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
				}
			}
		}

		vo.setFile_seq(String.valueOf(attach_seq));
		vo.setAttach_seq2(attach_seq2);

		/*
		 * vo.setCn_as_no(vo.getAs_no()); vo.setAs_no((String)commonDAO.selectOne(vo,
		 * "asDAO.getMaxSubSeq"));
		 */
		vo.setAccept_dt(DateTimeUtil.getDate());
		vo.setAccept_time(DateTimeUtil.getTime());

		returnValue = commonDAO.update(vo, "asDAO.insertAsInfo");
		/** HIST 등록 */
		if (returnValue > 0) {
			commonDAO.update(vo, "asDAO.updateCnAsState");

			vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
			commonDAO.insert(vo, "asDAO.insertAsInfoHist");
		}

		return returnValue;
	}

	@Override
	public int updateAsInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList, UserVO adUserInfo)
	        throws Exception {

	    int returnValue = 0;

	    int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0"));
	    int attach_seq2 = vo.getAttach_seq2();
	    boolean flag_attach_2 = false;
	    int cnt = 0;
	    int cnt2 = 0;

	    String change_yn = "N";
	    String init_yn = "N";
	    String assign_change_yn = "N";
	    String inportance_change_yn = "N";
	    String procstatus_change_yn = "N";
	    String sms_send_yn = "N";

	    String mobile_no = "";
	    String emp_nm = "";
	    AsVO asTypeVO;

	    String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1());

	    // 1) 파일 삭제 처리
	    if (file_seq > 0) {
	        if (!"".equals(delAttach1)) {
	            String[] del_attach_seq = delAttach1.split("@");
	            if (del_attach_seq != null && del_attach_seq.length > 0) {
	                for (String temp : del_attach_seq) {
	                    FileVO fileVO = new FileVO();
	                    fileVO.setAttach_seq(file_seq);
	                    fileVO.setAttach_ord(Integer.parseInt(temp));
	                    commonFileService.deleteFileInfo(fileVO);
	                }
	            }
	        }
	    }

	    // 2) 파일 업로드 처리
	    if (fileList != null && fileList.size() > 0) {
	        for (FileVO temp : fileList) {
	            if (temp.getAttach_tag_name().startsWith("uploadFile_")) {
	                if (file_seq == 0) {
	                    file_seq = commonFileService.getMaxFileSeq();
	                }
	                temp.setAttach_seq(file_seq);
	                temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
	                commonFileService.insertFile(temp);

	            } else if (temp.getAttach_tag_name().startsWith("upFile_")) {
	                if (attach_seq2 == 0) {
	                    attach_seq2 = commonFileService.getMaxFileSeq();
	                }
	                temp.setAttach_seq(attach_seq2);
	                temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
	                commonFileService.insertFile(temp);
	                flag_attach_2 = true;
	            }
	        }
	    }

	    vo.setFile_seq(String.valueOf(file_seq));
	    vo.setAttach_seq2(attach_seq2);
	    vo.setAssign_id(vo.getAssign_id());
	    vo.setReg_id(adUserInfo.getEmp_no());

	    init_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtInitYn");
	    change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtChangeYn");
	    assign_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getAssignIdChangeYn");
	    inportance_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getInportanceChangeYn");
	    procstatus_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcstatusChangeYn");
	    sms_send_yn = (String) commonDAO.selectOne(vo, "asDAO.getSmsSendYn");

	    // =========================
	    // 링크 처리: 기존 그룹(oldSet) 확보 (업데이트 전에 DB에서 읽어야 함)
	    // =========================
	    String currentAsNo = SsStringUtil.normalizeNull(vo.getAs_no());
	    String dbOldLinkStr = SsStringUtil.normalizeNull((String) commonDAO.selectOne(vo, "asDAO.getAsNoLinkByAsNo"));

	    java.util.LinkedHashSet<String> oldSet = new java.util.LinkedHashSet<>();
	    if (!"".equals(dbOldLinkStr)) {
	        for (String x : dbOldLinkStr.split(",")) {
	            if (x == null) continue;
	            String t = x.trim();
	            if ("".equals(t)) continue;
	            oldSet.add(t);
	        }
	    }
	    if (!"".equals(currentAsNo)) oldSet.add(currentAsNo);

	    // =========================
	    // 링크 문자열 정규화: 화면에서 넘어온 값(newSet)
	    // =========================
	    String asNoLinkStr = SsStringUtil.normalizeNull(vo.getAs_no_link());

	    java.util.LinkedHashSet<String> linkSet = new java.util.LinkedHashSet<>();
	    if (!"".equals(asNoLinkStr)) {
	        String[] linkArr = asNoLinkStr.split(",");
	        for (String x : linkArr) {
	            if (x == null) continue;
	            String t = x.trim();
	            if ("".equals(t)) continue;
	            linkSet.add(t);
	        }
	    }

	    // 현재 AS는 반드시 포함
	    if (!"".equals(currentAsNo)) linkSet.add(currentAsNo);

	    // 최종 링크 문자열 (newSet)
	    String normalizedLinkStr = "";
	    if (!linkSet.isEmpty()) {
	        StringBuilder sb = new StringBuilder();
	        for (String x : linkSet) {
	            if (sb.length() > 0) sb.append(",");
	            sb.append(x);
	        }
	        normalizedLinkStr = sb.toString();
	    }
	    
	    if ("C005".equals(vo.getProc_status())) {
	    	vo.setAs_no_link("");
	    }else {
	    	vo.setAs_no_link(normalizedLinkStr);
	    }
		

	    // 3) 현재 AS 업데이트 (원래 로직)
	    returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");

	    if (returnValue > 0) {

	        // =========================
	        // 3-1) 메시지/알림 로직 (원본 유지)
	        // =========================
	        cnt = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt");

	        vo.setInit_yn(init_yn);
	        vo.setChange_yn(change_yn);

	        if ("Y".equals(vo.getSend_sms()) && "Y".equals(sms_send_yn)) {

	            if (("C001".equals(vo.getProc_status()) || "C005".equals(vo.getProc_status()) || "C006".equals(vo.getProc_status()))
	                    && cnt == 0 && "Y".equals(procstatus_change_yn)) {
	                cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");
	                vo.setAlimTalk_message(getAlimTalkMessage(vo));
	                vo.setSms_message(getSmsMessage(vo));
	                vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
	                vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	                vo.setCnt(cnt2);
	                commonDAO.update(vo, "asDAO.insertMsgInfo");
	            }

	            if (!"".equals(vo.getProc_dt())
	                    && !"C005".equals(vo.getProc_status())
	                    && ("Y".equals(init_yn) || "Y".equals(change_yn))) {
	                cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");
	                vo.setAlimTalk_message(getAlimTalkMessage2(vo));
	                vo.setSms_message(getSmsMessage2(vo));
	                vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
	                vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	                vo.setCnt(cnt2);
	                commonDAO.update(vo, "asDAO.insertMsgInfo2");
	            }
	        }

	        if ("C001".equals(vo.getInportance())
	                && !("C005".equals(vo.getProc_status()) || "C006".equals(vo.getProc_status()))
	                && ("Y".equals(assign_change_yn) || "Y".equals(inportance_change_yn))
	                && !vo.getAssign_id().equals(vo.getReg_id())
	                && "Y".equals(sms_send_yn)) {

	            mobile_no = (String) commonDAO.selectOne(vo, "asDAO.getMobileNo");
	            asTypeVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getServiceCateNm");
	            emp_nm = (String) commonDAO.selectOne(vo, "asDAO.getEmpNm");

	            vo.setMobile_no(mobile_no);
	            vo.setRequest_type_nm(asTypeVO.getRequest_type_nm());
	            vo.setService_cate_nm(asTypeVO.getService_cate_nm());
	            vo.setInquiry_type_nm(asTypeVO.getInquiry_type_nm());
	            vo.setEmp_nm(emp_nm);
	            cnt2 = commonDAO.selectOneInt(vo, "asDAO.getEmergencyMsgCnt");
	            vo.setAlimTalk_message(getEmergencyAlimTalkMessage(vo));
	            vo.setSms_message(getEmergencySmsMessage(vo));
	            vo.setCnt(cnt2);
	            commonDAO.update(vo, "asDAO.insertEmergencyMsgInfo");
	        }

	        commonDAO.update(vo, "asDAO.updateCnAsState");

	        // =========================
	        // 3-2) 현재 AS 히스토리 (원본 유지)
	        // =========================
	        boolean his_flag = false;
	        if (flag_attach_2) {
	            his_flag = true;
	        }

	        if (!his_flag) {
	            AsVO maxHisVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsHistMaxInfo");

	            if (maxHisVO != null) {
	                if (!SsStringUtil.normalizeNull(vo.getProc_status())
	                        .equals(SsStringUtil.normalizeNull(maxHisVO.getProc_status()))) {
	                    his_flag = true;
	                }
	                if (!SsStringUtil.normalizeNull(vo.getAction_content())
	                        .equals(SsStringUtil.normalizeNull(maxHisVO.getAction_content()))
	                        && !"".equals(SsStringUtil.normalizeNull(vo.getAction_content()))) {
	                    his_flag = true;
	                }
	                if (!SsStringUtil.normalizeNull(adUserInfo.getEmp_no())
	                        .equals(SsStringUtil.normalizeNull(vo.getAssign_id()))) {
	                    his_flag = true;
	                }
	            } else {
	                his_flag = true;
	            }
	        }

	        if (his_flag) {
	            vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	            commonDAO.insert(vo, "asDAO.insertAsInfoHist");
	            
	            if ("C005".equals(vo.getProc_status())) {
	            	vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	        	    vo.setAction_content2(normalizedLinkStr);
	        	    commonDAO.insert(vo, "asDAO.insertAsInfoHist2");
	            }
	            
        	    
	        }

	        // =========================
	        // 4) 링크 그룹 동기화
	        // 원하는 결과:
	        // newSet: (예 1,4) 는 "1,4"
	        // removedSet: (예 2,3) 는 "2,3"
	        // =========================
	        java.util.LinkedHashSet<String> newSet = new java.util.LinkedHashSet<>(linkSet);

	        java.util.LinkedHashSet<String> removedSet = new java.util.LinkedHashSet<>(oldSet);
	        removedSet.removeAll(newSet);   // old - new

	        // 4-1) newSet 문자열 만들기
	        String normalizedNewStr = "";
	        if (!newSet.isEmpty()) {
	            StringBuilder sb = new StringBuilder();
	            for (String x : newSet) {
	                if (sb.length() > 0) sb.append(",");
	                sb.append(x);
	            }
	            normalizedNewStr = sb.toString();
	        }

	        // 4-2) removedSet 문자열 만들기
	        String normalizedRemovedStr = "";
	        if (!removedSet.isEmpty()) {
	            StringBuilder sb = new StringBuilder();
	            for (String x : removedSet) {
	                if (sb.length() > 0) sb.append(",");
	                sb.append(x);
	            }
	            normalizedRemovedStr = sb.toString();
	        }

	        // 4-3) newSet 전체를 "new 문자열"로 통일 업데이트
	        if (!newSet.isEmpty()) {
	            java.util.Map<String, Object> m1 = new java.util.HashMap<>();
	            m1.put("as_no_link", normalizedNewStr);
	            m1.put("asNoList", new java.util.ArrayList<>(newSet));
	            
	            if ("C005".equals(vo.getProc_status())) {
	            	commonDAO.update(m1, "asDAO.removeLinkedAsNoLinkAll");
	    	    }else {
	    	    	commonDAO.update(m1, "asDAO.updateLinkedAsNoLinkAll");
	    	    }
	        }

	        // 4-4) removedSet 전체를 "removed 문자열"로 통일 업데이트
	        // removedSet이 1개면 그 1개만 들어간 문자열이 되므로 사실상 자기자신만 연결 상태
	        if (!removedSet.isEmpty()) {
	            java.util.Map<String, Object> m2 = new java.util.HashMap<>();
	            m2.put("as_no_link", normalizedRemovedStr);
	            m2.put("asNoList", new java.util.ArrayList<>(removedSet));
	            commonDAO.update(m2, "asDAO.removeLinkedAsNoLinkAll");
	        }

	        // =========================
	        // 4-5) 나머지 링크 건들에 대한 부분 업데이트 + 히스토리 (너 원본 로직 유지)
	        // newSet 중에서 본인 제외만 처리
	        // =========================
	        if (!newSet.isEmpty()) {

	        	for (String linkNo : newSet) {

	        	    if (linkNo == null) continue;
	        	    if ("".equals(linkNo)) continue;
	        	    if (linkNo.equals(currentAsNo)) continue; // 본인 AS skip
	        	    
	        	    AsVO paramVo = new AsVO();
	        	    paramVo.setAs_no(linkNo);

	        	    String beforeStatus = (String) commonDAO.selectOne(paramVo, "asDAO.selectProcStatusByAsNo");
	        	    
	        	    AsVO eachVo = new AsVO();

	        	    eachVo.setAs_no(linkNo);
	        	    eachVo.setProc_dt(vo.getProc_dt());
	        	    eachVo.setTel_confirm(vo.getTel_confirm());
	        	    eachVo.setProc_time(vo.getProc_time());
	        	    eachVo.setCause_type(vo.getCause_type());
	        	    eachVo.setAction_type(vo.getAction_type());
	        	    eachVo.setWork_time("0");
	        	    eachVo.setComplete_dt(vo.getComplete_dt());
	        	    eachVo.setAction_content(vo.getAction_content());
	        	    eachVo.setProc_status(vo.getProc_status());
	        	    eachVo.setAssign_id(vo.getAssign_id());
	        	    eachVo.setProc_gubun(vo.getProc_gubun());
	        	    eachVo.setProc_build_info(vo.getProc_build_info());
	        	    eachVo.setProc_test_info(vo.getProc_test_info());
	        	    eachVo.setProc_process_sp(vo.getProc_process_sp());
	        	    eachVo.setProc_screen_sp(vo.getProc_screen_sp());
	        	    eachVo.setProc_table_sp(vo.getProc_table_sp());
	        	    eachVo.setProc_function_sp(vo.getProc_function_sp());
	        	    eachVo.setProc_interface_sp(vo.getProc_interface_sp());
	        	    eachVo.setUpd_id(adUserInfo.getEmp_no());
	        	    eachVo.setReg_id(adUserInfo.getEmp_no());
	        	    
	        	    if (!("C005".equals(beforeStatus))) {
	        	    	
	        	    // ✅ 1. UPDATE 전에 SMS 판단값 먼저 가져오기
	        	    SmsCheck chk = getSmsCheck(eachVo);

	        	    // ✅ 2. 상태 동기화
	        	    commonDAO.update(eachVo, "asDAO.updateLinkedAsSimple");
	        	    
	        	    // ✅ 3. SMS 발송
	        	    sendSms(eachVo, chk);
	        	    }
	        	    
	        	    // ✅ 4. 히스토리
	        	    AsVO histVo = new AsVO();
	        	    
	        	    histVo.setAs_no(linkNo);
	        	    histVo.setProc_dt(vo.getProc_dt());
	        	    histVo.setAssign_id(vo.getAssign_id());
	        	    histVo.setProc_status(vo.getProc_status());
	        	    histVo.setAction_content(vo.getAction_content());
	        	    histVo.setAttach_seq2(vo.getAttach_seq2());
	        	    histVo.setReg_id(adUserInfo.getEmp_no());
	        	    histVo.setRequest_type(vo.getRequest_type());
	        	    histVo.setService_cate(vo.getService_cate());
	        	    histVo.setInquiry_type(vo.getInquiry_type());
	        	    histVo.setInportance(vo.getInportance());
	        	    
	        	    
	        	    histVo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	        	    commonDAO.insert(histVo, "asDAO.insertAsInfoHist");
	        	    
	        	    if ("C005".equals(vo.getProc_status())) {
	        	    	histVo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	        	    	histVo.setAction_content2(normalizedLinkStr);
		        	    commonDAO.insert(histVo, "asDAO.insertAsInfoHist2");
	        	    }
	        	    
	        	    
	        	}
	        }
	        
	        if (SsStringUtil.normalizeNull(vo.getAs_no_link()).trim()
	                .equals(SsStringUtil.normalizeNull(vo.getAs_no()).trim())) {
	            commonDAO.update(vo, "asDAO.updateLinkedAsNoLink");
	        }
	        
	    }

	    return returnValue;
	}
	
	private void sendSms(AsVO vo, SmsCheck chk) throws Exception {

	    vo.setInit_yn(chk.init_yn);
	    vo.setChange_yn(chk.change_yn);

	    if ("Y".equals(vo.getSend_sms()) && "Y".equals(chk.sms_send_yn)) {

	        // 1) 상태 변경 알림
	        if (("C001".equals(vo.getProc_status())
	                || "C005".equals(vo.getProc_status())
	                || "C006".equals(vo.getProc_status()))
	                && chk.msgCnt == 0
	                && "Y".equals(chk.procstatus_change_yn)) {

	            int cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");

	            vo.setAlimTalk_message(getAlimTalkMessage(vo));
	            vo.setSms_message(getSmsMessage(vo));
	            vo.setAlimTalk_btn(getAlimTalk_Btn(vo));

	            if (vo.getApply_tel() != null) {
	                vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	            }

	            vo.setCnt(cnt2);
	            commonDAO.update(vo, "asDAO.insertMsgInfo");
	        }

	        // 2) 처리일/예정일 변경 알림
	        if (!"".equals(SsStringUtil.normalizeNull(vo.getProc_dt()))
	                && !"C005".equals(vo.getProc_status())
	                && ("Y".equals(chk.init_yn) || "Y".equals(chk.change_yn))) {

	            int cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");

	            vo.setAlimTalk_message(getAlimTalkMessage2(vo));
	            vo.setSms_message(getSmsMessage2(vo));
	            vo.setAlimTalk_btn(getAlimTalk_Btn(vo));

	            if (vo.getApply_tel() != null) {
	                vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	            }

	            vo.setCnt(cnt2);
	            commonDAO.update(vo, "asDAO.insertMsgInfo2");
	        }
	    }

	    // 3) 긴급 알림
	    if ("C001".equals(vo.getInportance())
	            && !("C005".equals(vo.getProc_status()) || "C006".equals(vo.getProc_status()))
	            && ("Y".equals(chk.assign_change_yn) || "Y".equals(chk.inportance_change_yn))
	            && !SsStringUtil.normalizeNull(vo.getAssign_id()).equals(SsStringUtil.normalizeNull(vo.getReg_id()))
	            && "Y".equals(chk.sms_send_yn)) {

	        String mobile_no = (String) commonDAO.selectOne(vo, "asDAO.getMobileNo");
	        AsVO asTypeVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getServiceCateNm");
	        String emp_nm = (String) commonDAO.selectOne(vo, "asDAO.getEmpNm");

	        vo.setMobile_no(mobile_no);

	        if (asTypeVO != null) {
	            vo.setRequest_type_nm(asTypeVO.getRequest_type_nm());
	            vo.setService_cate_nm(asTypeVO.getService_cate_nm());
	            vo.setInquiry_type_nm(asTypeVO.getInquiry_type_nm());
	        }

	        vo.setEmp_nm(emp_nm);

	        int cnt2 = commonDAO.selectOneInt(vo, "asDAO.getEmergencyMsgCnt");

	        vo.setAlimTalk_message(getEmergencyAlimTalkMessage(vo));
	        vo.setSms_message(getEmergencySmsMessage(vo));
	        vo.setCnt(cnt2);

	        commonDAO.update(vo, "asDAO.insertEmergencyMsgInfo");
	    }
	}

	
	private SmsCheck getSmsCheck(AsVO vo) throws Exception {
	    SmsCheck chk = new SmsCheck();
	    chk.init_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtInitYn");
	    chk.change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtChangeYn");
	    chk.assign_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getAssignIdChangeYn");
	    chk.inportance_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getInportanceChangeYn");
	    chk.procstatus_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcstatusChangeYn");
	    chk.sms_send_yn = (String) commonDAO.selectOne(vo, "asDAO.getSmsSendYn");
	    chk.msgCnt = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt");
	    return chk;
	}
	
	private static class SmsCheck {
	    String init_yn;
	    String change_yn;
	    String assign_change_yn;
	    String inportance_change_yn;
	    String procstatus_change_yn;
	    String sms_send_yn;
	    int msgCnt;
	}
	
	@Override
	public int updateAsInfoAll(AsVO vo, HttpServletRequest request, List<FileVO> fileList, UserVO adUserInfo)
	        throws Exception {

	    int returnValue = 0;

	    int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0"));
	    int attach_seq2 = vo.getAttach_seq2();
	    boolean flag_attach_2 = false;
	    int cnt = 0;
	    int cnt2 = 0;

	    String change_yn = "N";
	    String init_yn = "N";
	    String assign_change_yn = "N";
	    String inportance_change_yn = "N";
	    String procstatus_change_yn = "N";
	    String sms_send_yn = "N";

	    String mobile_no = "";
	    String emp_nm = "";
	    AsVO asTypeVO;

	    String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1());

	    // 1) 파일 삭제 처리
	    if (file_seq > 0) {
	        if (!"".equals(delAttach1)) {
	            String[] del_attach_seq = delAttach1.split("@");
	            if (del_attach_seq != null && del_attach_seq.length > 0) {
	                for (String temp : del_attach_seq) {
	                    FileVO fileVO = new FileVO();
	                    fileVO.setAttach_seq(file_seq);
	                    fileVO.setAttach_ord(Integer.parseInt(temp));
	                    commonFileService.deleteFileInfo(fileVO);
	                }
	            }
	        }
	    }

	    // 2) 파일 업로드 처리
	    if (fileList != null && fileList.size() > 0) {
	        for (FileVO temp : fileList) {
	            if (temp.getAttach_tag_name().startsWith("uploadFile_")) {
	                if (file_seq == 0) {
	                    file_seq = commonFileService.getMaxFileSeq();
	                }
	                temp.setAttach_seq(file_seq);
	                temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
	                commonFileService.insertFile(temp);

	            } else if (temp.getAttach_tag_name().startsWith("upFile_")) {
	                if (attach_seq2 == 0) {
	                    attach_seq2 = commonFileService.getMaxFileSeq();
	                }
	                temp.setAttach_seq(attach_seq2);
	                temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
	                commonFileService.insertFile(temp);
	                flag_attach_2 = true;
	            }
	        }
	    }

	    vo.setFile_seq(String.valueOf(file_seq));
	    vo.setAttach_seq2(attach_seq2);
	    vo.setAssign_id(vo.getAssign_id());
	    vo.setW_content(vo.getW_content_pop());
	    vo.setReg_id(adUserInfo.getEmp_no());

	    init_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtInitYn");
	    change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtChangeYn");
	    assign_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getAssignIdChangeYn");
	    inportance_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getInportanceChangeYn");
	    procstatus_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcstatusChangeYn");
	    sms_send_yn = (String) commonDAO.selectOne(vo, "asDAO.getSmsSendYn");


	    // 3) 현재 AS 업데이트 (원래 로직)
	    returnValue = commonDAO.update(vo, "asDAO.updateAsInfoAll");

	    if (returnValue > 0) {

	        // =========================
	        // 3-1) 메시지/알림 로직 (원본 유지)
	        // =========================
	        cnt = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt");

	        vo.setInit_yn(init_yn);
	        vo.setChange_yn(change_yn);

	        if ("Y".equals(vo.getSend_sms()) && "Y".equals(sms_send_yn)) {

	            if (("C001".equals(vo.getProc_status()) || "C005".equals(vo.getProc_status()) || "C006".equals(vo.getProc_status()))
	                    && cnt == 0 && "Y".equals(procstatus_change_yn)) {
	                cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");
	                vo.setAlimTalk_message(getAlimTalkMessage(vo));
	                vo.setSms_message(getSmsMessage(vo));
	                vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
	                vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	                vo.setCnt(cnt2);
	                commonDAO.update(vo, "asDAO.insertMsgInfo");
	            }

	            if (!"".equals(vo.getProc_dt())
	                    && !"C005".equals(vo.getProc_status())
	                    && ("Y".equals(init_yn) || "Y".equals(change_yn))) {
	                cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");
	                vo.setAlimTalk_message(getAlimTalkMessage2(vo));
	                vo.setSms_message(getSmsMessage2(vo));
	                vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
	                vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	                vo.setCnt(cnt2);
	                commonDAO.update(vo, "asDAO.insertMsgInfo2");
	            }
	        }

	        if ("C001".equals(vo.getInportance())
	                && !("C005".equals(vo.getProc_status()) || "C006".equals(vo.getProc_status()))
	                && ("Y".equals(assign_change_yn) || "Y".equals(inportance_change_yn))
	                && !vo.getAssign_id().equals(vo.getReg_id())
	                && "Y".equals(sms_send_yn)) {

	            mobile_no = (String) commonDAO.selectOne(vo, "asDAO.getMobileNo");
	            asTypeVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getServiceCateNm");
	            emp_nm = (String) commonDAO.selectOne(vo, "asDAO.getEmpNm");

	            vo.setMobile_no(mobile_no);
	            vo.setRequest_type_nm(asTypeVO.getRequest_type_nm());
	            vo.setService_cate_nm(asTypeVO.getService_cate_nm());
	            vo.setInquiry_type_nm(asTypeVO.getInquiry_type_nm());
	            vo.setEmp_nm(emp_nm);
	            cnt2 = commonDAO.selectOneInt(vo, "asDAO.getEmergencyMsgCnt");
	            vo.setAlimTalk_message(getEmergencyAlimTalkMessage(vo));
	            vo.setSms_message(getEmergencySmsMessage(vo));
	            vo.setCnt(cnt2);
	            commonDAO.update(vo, "asDAO.insertEmergencyMsgInfo");
	        }

	        commonDAO.update(vo, "asDAO.updateCnAsState");

	        // =========================
	        // 3-2) 현재 AS 히스토리 (원본 유지)
	        // =========================
	        boolean his_flag = false;
	        if (flag_attach_2) {
	            his_flag = true;
	        }

	        if (!his_flag) {
	            AsVO maxHisVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsHistMaxInfo");

	            if (maxHisVO != null) {
	                if (!SsStringUtil.normalizeNull(vo.getProc_status())
	                        .equals(SsStringUtil.normalizeNull(maxHisVO.getProc_status()))) {
	                    his_flag = true;
	                }
	                if (!SsStringUtil.normalizeNull(vo.getAction_content())
	                        .equals(SsStringUtil.normalizeNull(maxHisVO.getAction_content()))
	                        && !"".equals(SsStringUtil.normalizeNull(vo.getAction_content()))) {
	                    his_flag = true;
	                }
	                if (!SsStringUtil.normalizeNull(adUserInfo.getEmp_no())
	                        .equals(SsStringUtil.normalizeNull(vo.getAssign_id()))) {
	                    his_flag = true;
	                }
	            } else {
	                his_flag = true;
	            }
	        }

	        if (his_flag) {
	            vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
	            commonDAO.insert(vo, "asDAO.insertAsInfoHist");
	            
	            
	        }
	        
	    }

	    return returnValue;
	}
	
	@Override
	public String getAlimTalkMessage(AsVO vo) {
		if("C001".equals(vo.getProc_status())) {
			return "■" + vo.getAs_no() + "건, 접수 및 담당자 자동 배정 완료 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n\r\n"
					+ vo.getCust_kor_name() + "님, 접수번호 " + vo.getAs_no() + " 건이 정상적으로 접수되었으며, 담당자가 자동 배정되었습니다.\r\n\r\n"
					+ "배정된 담당자가 확인 후 순차적으로 연락드리도록 하겠습니다.\r\n\r\n"
					+ "기다리는동안 AI챗봇에게 질문하여 빠르게 문제를 해결해보세요!";
		}else if("C005".equals(vo.getProc_status())) {
			return "■" + vo.getAs_no() + "건, 처리완료 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 A/S 신청이 처리완료되었습니다. 답변내역을 확인해주세요!\r\n\r\n"
					+ "추가 문의사항은 새롭게 A/S 등록을 부탁드립니다. 감사합니다.\r\n\r\n"
					+ "▶답변내역 확인 경로:\r\n"
					+ "라인어스 > 메인페이지 상단  “오늘의 AS답변”\r\n"
					+ "혹은 AS신청 > 신청등록현황Tab > AS신청 작성글 선택 > 답변내역Tab";
		} else if("C006".equals(vo.getProc_status())) {
			return "■" + vo.getAs_no() + "건, 철회 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 A/S 신청이 철회 되었습니다.\r\n\r\n"
					+ "추가 문의사항은 새롭게 A/S 등록을 부탁드립니다. 감사합니다.";
		}
		return "";
	}
	
	@Override
	public String getAlimTalkMessage2(AsVO vo) throws Exception {
		String procDt = changeDateFormat(vo.getProc_dt());
		
		if("Y".equals(vo.getInit_yn())) {
			return "■" + vo.getAs_no() + "건, 처리예정일 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 처리예정일이 등록되었습니다.\r\n\r\n"
					+ "▶처리예정일 : " + procDt + "\r\n\r\n" 
					+ "원활한 처리를 위해 최선을 다하겠습니다.";
		} else if("Y".equals(vo.getChange_yn())) {
			return "■" + vo.getAs_no() + "건, 처리예정일 변경안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 처리예정일이 변경되었습니다.\r\n\r\n"
					+ "▶변경된 처리예정일 : " + procDt + "\r\n\r\n" 
					+ "원활한 처리를 위해 최선을 다하겠습니다.";
		} 
		return "";
	}
	
	@Override
	public String getEmergencyAlimTalkMessage(AsVO vo) throws Exception {
		String acceptDt = changeDateFormat(vo.getAccept_dt());
		String acceptTime = changeTimeFormat(vo.getAccept_time());
		
		return "■ S등급(긴급건) A/S 등록 안내\r\n\r\n"
				+ "안녕하세요. " + vo.getEmp_nm() + " 담당자님.\r\n\r\n"
				+ "S등급(긴급건)으로 지정된 A/S 요청이 등록되었습니다. \r\n\r\n"
				+ "▶ 고객사명: " + vo.getCust_kor_name() + "\r\n" 
				+ "▶ 접수번호: " + vo.getAs_no() + "\r\n" 
				+ "▶ 접수일자: " + acceptDt + "\r\n" 
				+ "▶ 접수시간: " + acceptTime + "\r\n" 
				+ "▶ 문의유형: " + vo.getRequest_type_nm() + " / " + vo.getService_cate_nm() + " / " + vo.getInquiry_type_nm() + "\r\n\r\n" 
				+ "신속히 확인 후 조치 부탁드립니다. 항상 감사드립니다.";
	}
	
	@Override
	public String getVoiceBotAlimTalkMessage(AsVO vo) throws Exception {

		return "■ 보이스봇 3회 이상 발신 건 안내\r\n\r\n"
				+ "보이스봇을 통해 3회 이상 발신된 건이 발생하여 안내드립니다.\r\n\r\n"
				+ "▶ 고객사명 : " + vo.getCust_nm() + "\r\n"
				+ "▶ AS신청자명 : " + vo.getRl_apply_nm() + "\r\n"
				+ "▶ 발신번호 : " + vo.getApply_tel() + "\r\n\r\n"
				+ "신속히 확인 후 조치 부탁드립니다.";
	}
	
	@Override
	public String changeDateFormat(String str) throws Exception {
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyyMMdd"); 
		SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
		
		Date formatDate = formatter1.parse(str);
		String procDt = formatter2.format(formatDate);
		
		return procDt;
	}
	
	@Override
	public String changeTimeFormat(String str) throws Exception {
		SimpleDateFormat formatter1 = new SimpleDateFormat("HHmmss"); 
		SimpleDateFormat formatter2 = new SimpleDateFormat("HH:mm:ss");
		
		Date formatDate = formatter1.parse(str);
		String procTime = formatter2.format(formatDate);
		
		return procTime;
	}
	
	@Override
	public String getSmsMessage(AsVO vo) {
		if("C001".equals(vo.getProc_status())) {
			return "■" + vo.getAs_no() + "건, 접수완료 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n" 
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + "건이 정상적으로 접수되었으며, 담당자가 자동 배정되었습니다.\r\n" 
					+ "배정된 담당자가 확인 후 순차적으로 연락드리도록 하겠습니다.\r\n" + "기다리는동안 AI챗봇에게 질문하여 빠르게 문제를 해결해보세요!\r\n\r\n"
					+ "라인어스 바로가기: https://lineus.cwit.co.kr/fr/login/form.do\r\n"
					+ "AI챗봇에게 문의하기: https://ai.cwit.co.kr/his/\r\n\r\n"
					+ "※ 이 번호는 발신 전용입니다. 문자 회신은 불가합니다.";
		}else if("C005".equals(vo.getProc_status())) {
			return "■" + vo.getAs_no() + "건, 처리완료 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 A/S 신청이 처리완료되었습니다. 답변내용을 확인해주세요!\r\n"
					+ "추가 문의사항은 새롭게 A/S 등록을 부탁드립니다. 감사합니다\r\n"
					+ "▶답변내역 확인 경로:"
					+ "라인어스 > 메인페이지 상단 \"오늘의 AS답변\"\r\n"
					+ "혹은 AS신청 > 신청등록현황Tab > AS신청 작성글 선택 > 답변내역Tab\r\n\r\n"
					+ "라인어스 바로가기: https://lineus.cwit.co.kr/fr/login/form.do\r\n\r\n"
					+ "※ 이 번호는 발신 전용입니다. 문자 회신은 불가합니다.";
		} else if("C006".equals(vo.getProc_status())) {
			return "■" + vo.getAs_no() + "건, 철회 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 A/S 신청이 철회 되었습니다.\r\n"
					+ "추가 문의사항은 새롭게 A/S 등록을 부탁드립니다. 감사합니다\r\n\r\n"
					+ "※ 이 번호는 발신 전용입니다. 문자 회신은 불가합니다.\r\n"
					+ "라인어스 바로가기: https://lineus.cwit.co.kr/fr/login/form.do";
		} 
		return "";
	}
	
	@Override
	public String getSmsMessage2(AsVO vo) throws Exception {
		String procDt = changeDateFormat(vo.getProc_dt());
		
		if("Y".equals(vo.getInit_yn())) {
			return "■" + vo.getAs_no() + "건, 처리예정일 안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 처리예정일이 등록되었습니다.\r\n\r\n"
					+ "▶처리예정일 : " + procDt + "\r\n\r\n"
					+ "원활한 처리를 위해 최선을 다하겠습니다.\r\n\r\n"
					+ "※ 이 번호는 발신 전용입니다. 문자 회신은 불가합니다.\r\n"
					+ "라인어스 바로가기: https://lineus.cwit.co.kr/fr/login/form.do";
		} else if("Y".equals(vo.getChange_yn())) {
			return "■" + vo.getAs_no() + "건, 처리예정일 변경안내\r\n\r\n"
					+ "안녕하세요. 중외정보기술입니다.\r\n\r\n"
					+ vo.getCust_kor_name() + " " + "님, 접수번호 " + vo.getAs_no() + " 건의 처리예정일이 변경되었습니다.\r\n\r\n"
					+ "▶변경된 처리예정일 : " + procDt + "\r\n\r\n"
					+ "원활한 처리를 위해 최선을 다하겠습니다.\r\n\r\n"
					+ "※ 이 번호는 발신 전용입니다. 문자 회신은 불가합니다.\r\n"
					+ "라인어스 바로가기: https://lineus.cwit.co.kr/fr/login/form.do";
		} 
		return "";
	}

	
	@Override
	public String getEmergencySmsMessage(AsVO vo) throws Exception {
		String acceptDt = changeDateFormat(vo.getAccept_dt());
		String acceptTime = changeTimeFormat(vo.getAccept_time());
		
		return "■ S등급(긴급건) A/S 등록 안내\r\n\r\n"
				+ "안녕하세요. " + vo.getEmp_nm() + " 담당자님.\r\n\r\n"
				+ "S등급(긴급건)으로 지정된 A/S 요청이 등록되었습니다. \r\n\r\n"
				+ "▶ 고객사명: " + vo.getCust_kor_name() + "\r\n" 
				+ "▶ 접수번호: " + vo.getAs_no() + "\r\n" 
				+ "▶ 접수일자: " + acceptDt + "\r\n" 
				+ "▶ 접수시간: " + acceptTime + "\r\n" 
				+ "▶ 문의유형: " + vo.getRequest_type_nm() + " / " + vo.getService_cate_nm() + " / " + vo.getInquiry_type_nm() + "\r\n" 
				+ "신속히 확인 후 조치 부탁드립니다. 항상 감사드립니다.";
	}
	
	@Override
	public String getVoiceBotSmsMessage(AsVO vo) throws Exception {

		return "■ 보이스봇 3회 이상 발신 건 안내\r\n\r\n"
				+ "보이스봇을 통해 3회 이상 발신된 건이 발생하여 안내드립니다.\r\n\r\n"
				+ "▶ 고객사명 : " + vo.getCust_nm() + "\r\n"
				+ "▶ AS신청자명 : " + vo.getRl_apply_nm() + "\r\n"
				+ "▶ 발신번호 : " + vo.getApply_tel() + "\r\n\r\n"
				+ "신속히 확인 후 조치 부탁드립니다.";
	}
	
	@Override
	public String getAlimTalk_Btn(AsVO vo) {
		if("C001".equals(vo.getProc_status())) {
			return "[{\"url_mobile\":\"https://lineus.cwit.co.kr/fr/login/form.do\", \"url_pc\":\"https://lineus.cwit.co.kr/fr/login/form.do\", \"name\":\"라인어스 바로가기\",\"type\":\"WL\"}, {\"url_mobile\":\"https://ai.cwit.co.kr/his/\", \"url_pc\":\"https://ai.cwit.co.kr/his/\", \"name\":\"AI챗봇에게 문의하기\",\"type\":\"WL\"}]";
		} else {
			return "[{\"url_mobile\":\"https://lineus.cwit.co.kr/fr/login/form.do\", \"url_pc\":\"https://lineus.cwit.co.kr/fr/login/form.do\", \"name\":\"라인어스 바로가기\",\"type\":\"WL\"}]";
		} 
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<AsVO> getList(AsVO vo, String query) throws Exception {
		return (List<AsVO>) commonDAO.list(vo, query);
	}
    
	@Override
	@SuppressWarnings("unchecked")
	public AsVO getOneList(AsVO vo, String query) throws Exception {
		return (AsVO) commonDAO.selectOne(vo, query);
	}

	@Override
	public int getTotalCnt(AsVO vo, String query) throws Exception {
		return commonDAO.selectOneInt(vo, query);
	}

	@Override
	public AsVO getAsInfo(AsVO vo) throws Exception {
		return (AsVO) commonDAO.selectOne(vo, "asDAO.getAsInfo");
	}

	@Override
	public AsVO getSelectInfo(AsVO vo, String query) throws Exception {
		return (AsVO) commonDAO.selectOne(vo, query);
	}

	//////////////// 댓글//////////////////////////
	@Override
	public int insertAws(AsVO vo, HttpServletRequest request) throws Exception {
		vo.setSeq(String.valueOf(getAwsMaxSeq()));
		return commonDAO.update(vo, "asDAO.insertAws");
	}

	@Override
	public int updateAws(AsVO vo, HttpServletRequest request) throws Exception {
		return commonDAO.update(vo, "asDAO.updateAws");
	}

	@Override
	public int deleteAws(AsVO vo, HttpServletRequest request) throws Exception {
		return commonDAO.update(vo, "asDAO.deleteAws");
	}

	@Override
	public int getAwsMaxSeq() throws Exception {
		return commonDAO.selectOneInt(null, "asDAO.getAwsMaxSeq");
	}

	//////////////// 댓글 끝//////////////////////////////////

	@Override
	public int registChangeStatus(AsVO vo) throws Exception {
		int cnt = 0;
		AsVO infoVo = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsInfo");
		vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
		vo.setProc_status("C006"); // C006 :철회
		
		if("Y".equals(infoVo.getSend_sms())) {
			cnt = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");
			vo.setCust_kor_name(infoVo.getCust_kor_name());
			vo.setAlimTalk_message(getAlimTalkMessage(vo));
			vo.setSms_message(getSmsMessage(vo));
			vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
			vo.setApply_tel(infoVo.getApply_tel().replaceAll("-", ""));
			vo.setCnt(cnt);
			commonDAO.update(vo, "asDAO.insertMsgInfo");
		}
		commonDAO.insert(vo, "asDAO.insertAsInfoHist");

		return commonDAO.update(vo, "asDAO.updateStatus");
	}

	@Override
	public int registChangeStar(AsVO vo) throws Exception {
		return commonDAO.update(vo, "asDAO.updateStar");
	}

	@Override
	public int updateAsLayer(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		int returnValue = 0;

		int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0"));
		String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1());

		if (file_seq > 0) {
			if (!"".equals(delAttach1)) {
				String[] del_attach_seq = delAttach1.split("@");

				if (del_attach_seq != null && del_attach_seq.length > 0) {
					for (String temp : del_attach_seq) {
						FileVO fileVO = new FileVO();

						fileVO.setAttach_seq(file_seq);
						fileVO.setAttach_ord(Integer.parseInt(temp));

						commonFileService.deleteFileInfo(fileVO);
					}
				}
			}
		}

		if (fileList != null && fileList.size() > 0) {
			for (FileVO temp : fileList) {
				if (temp.getAttach_tag_name().startsWith("uploadFile_")) {
					if (file_seq == 0)
						file_seq = commonFileService.getMaxFileSeq();
					temp.setAttach_seq(file_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				}
			}
		}

		vo.setFile_seq(String.valueOf(file_seq));

		returnValue = commonDAO.update(vo, "asDAO.updateAsLayer");

		return returnValue;
	}

	@Override
	public int registContents(AsVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {

		int attach_seq = 0;
		if (fileList != null && fileList.size() > 0) {
			for (FileVO temp : fileList) {
				if (temp.getAttach_tag_name().startsWith("asw_uploadFile_")) {
					if (attach_seq == 0) {
						attach_seq = commonFileService.getMaxFileSeq();
						temp.setAttach_seq(attach_seq);
					} else {
						temp.setAttach_seq(attach_seq);
					}
					temp.setAttach_ord(commonFileService.getMaxFileOrd(temp));
					commonFileService.insertFile(temp);
				}
			}
			vo.setAttach_seq(attach_seq);
		}
		vo.setW_gubun("U");
		vo.setSeq(String.valueOf(getAwsMaxSeq()));
		return commonDAO.update(vo, "asDAO.insertAwsFront");
	}

	@Override
	public int registDelContents(AsVO vo) throws Exception {
		return commonDAO.delete(vo, "asDAO.deleteAwsFront");
	}

	@Override
	public int updateAsCnInfo(AsVO vo, HttpServletRequest request, List<FileVO> fileList, UserVO adUserInfo)
			throws Exception {
		int returnValue = 0;

		int file_seq = Integer.parseInt(SsStringUtil.normalize(vo.getFile_seq(), "0"));
		int attach_seq2 = vo.getAttach_seq2();
		boolean flag_attach_2 = false;

		String delAttach1 = SsStringUtil.normalizeNull(vo.getDelAttach1());

		if (file_seq > 0) {
			if (!"".equals(delAttach1)) {
				String[] del_attach_seq = delAttach1.split("@");

				if (del_attach_seq != null && del_attach_seq.length > 0) {
					for (String temp : del_attach_seq) {
						FileVO fileVO = new FileVO();

						fileVO.setAttach_seq(file_seq);
						fileVO.setAttach_ord(Integer.parseInt(temp));

						commonFileService.deleteFileInfo(fileVO);
					}
				}
			}
		}

		if (fileList != null && fileList.size() > 0) {
			for (FileVO temp : fileList) {
				if (temp.getAttach_tag_name().startsWith("uploadFile_")) {
					if (file_seq == 0)
						file_seq = commonFileService.getMaxFileSeq();
					temp.setAttach_seq(file_seq);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
					commonFileService.insertFile(temp);
				} else if (temp.getAttach_tag_name().startsWith("upFile_")) {
					if (attach_seq2 == 0)
						attach_seq2 = commonFileService.getMaxFileSeq();
					temp.setAttach_seq(attach_seq2);
					temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("upFile_", "")));
					commonFileService.insertFile(temp);
					flag_attach_2 = true;
				}
			}
		}

		vo.setFile_seq(String.valueOf(file_seq));
		vo.setAttach_seq2(attach_seq2);

		String cn_as_no = vo.getAs_no();
		String as_no = vo.getCn_as_no();

		vo.setCn_as_no(cn_as_no);
		vo.setAs_no(as_no);

		vo.setReg_id(adUserInfo.getEmp_no());

		returnValue = commonDAO.update(vo, "asDAO.updateAsInfo");

		if (returnValue > 0) {
			commonDAO.update(vo, "asDAO.updateCnAsState");

//			if (!"".equals(SsStringUtil.normalizeNull(vo.getApply_id()))
//					|| !"".equals(SsStringUtil.normalizeNull(vo.getApply_tel()))) {
//				if (!"".equals(vo.getChg_assign_id()))
//					commonSmsService.sendSms("CD06", "C002", "0", vo.getApply_id(),
//							vo.getApply_tel()); /* A/S 담당자 배정 완료 */
//				if (!"".equals(vo.getChg_assign_id()) && !vo.getChg_assign_id().equals(vo.getAssign_id()))
//					commonSmsService.sendSms("CD06", "C003", "0", vo.getApply_id(),
//							vo.getApply_tel()); /* A/S 담당자 배정 중 (변경) */
//				if ("C004".equals(vo.getProc_status()))
//					commonSmsService.sendSms("CD06", "C004", "0", vo.getApply_id(), vo.getApply_tel()); /* A/S 처리 중 */
//				if ("C005".equals(vo.getProc_status()))
//					commonSmsService.sendSms("CD06", "C005", "0", vo.getApply_id(), vo.getApply_tel()); /* A/S 처리 완료 */
//			}

			boolean his_flag = false;
			if (flag_attach_2)
				his_flag = true;

			if (!his_flag) {
				AsVO maxHisVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getAsHistMaxInfo");

				if (maxHisVO != null) {
					if (!SsStringUtil.normalizeNull(vo.getProc_status())
							.equals(SsStringUtil.normalizeNull(maxHisVO.getProc_status())))
						his_flag = true;
					if (!SsStringUtil.normalizeNull(vo.getAction_content())
							.equals(SsStringUtil.normalizeNull(maxHisVO.getAction_content())))
						his_flag = true;

					/* 등록자와 처리담당자가 다를경우 */
					if (!SsStringUtil.normalizeNull(adUserInfo.getEmp_no())
							.equals(SsStringUtil.normalizeNull(vo.getAssign_id())))
						his_flag = true;
				} else {
					his_flag = true;
				}

			}
			if (his_flag) {
				vo.setSeq(String.valueOf(commonDAO.selectOneInt(vo, "asDAO.getAsHistMaxSeq")));
				commonDAO.insert(vo, "asDAO.insertAsInfoHist");
			}
		}

		return returnValue;
	}

	@Override
	public int deleteAsProc(AsVO vo, HttpServletRequest request) throws Exception {

	    int returnValue = 0;

	    String delAsStr = SsStringUtil.normalizeNull(vo.getDel_as_no());
	    if (delAsStr.isEmpty()) {
	        return -100;
	    }

	    String[] delArr = delAsStr.split("@");

	    for (String delAsNo : delArr) {

	        vo.setAs_no(delAsNo);

	        String linkStr = SsStringUtil.normalizeNull(
	            (String) commonDAO.selectOne(vo, "asDAO.getAsNoLinkByAsNo")
	        );

	        LinkedHashSet<String> linkSet = new LinkedHashSet<>();
	        if (!linkStr.isEmpty()) {
	            for (String x : linkStr.split(",")) {
	                if (x == null) continue;
	                String t = x.trim();
	                if (t.isEmpty()) continue;
	                if (t.equals(delAsNo)) continue; // 🔥 삭제 대상 제거
	                linkSet.add(t);
	            }
	        }

	        String newLinkStr = "";
	        if (linkSet.size() > 1) {
	            newLinkStr = String.join(",", linkSet);
	        }

	        if (!linkSet.isEmpty()) {
	            Map<String, Object> m = new HashMap<>();
	            m.put("as_no_link", newLinkStr);
	            m.put("asNoList", new ArrayList<>(linkSet));
	            commonDAO.update(m, "asDAO.updateLinkedAsNoLinkAll");
	        }

	        returnValue = commonDAO.update(vo, "asDAO.deleteAsProc");
	    }

	    return returnValue;
	}
	
	private void processSmsForOneAs(AsVO vo, UserVO adUserInfo) throws Exception {
		
		
		String inportance = (String) commonDAO.selectOne(vo, "asDAO.getInportant");
		vo.setInportance(inportance);

	    String init_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtInitYn");
	    String change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcDtChangeYn");
	    String assign_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getAssignIdChangeYn");
	    String inportance_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getInportanceChangeYn");
	    String procstatus_change_yn = (String) commonDAO.selectOne(vo, "asDAO.getProcstatusChangeYn");
	    String sms_send_yn = (String) commonDAO.selectOne(vo, "asDAO.getSmsSendYn");

	    int cnt = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt");
	    int cnt2 = 0;

	    vo.setInit_yn(init_yn);
	    vo.setChange_yn(change_yn);

	    if ("Y".equals(vo.getSend_sms()) && "Y".equals(sms_send_yn)) {

	        if (("C001".equals(vo.getProc_status())
	                || "C005".equals(vo.getProc_status())
	                || "C006".equals(vo.getProc_status()))
	                && cnt == 0
	                && "Y".equals(procstatus_change_yn)) {

	            cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");
	            vo.setAlimTalk_message(getAlimTalkMessage(vo));
	            vo.setSms_message(getSmsMessage(vo));
	            vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
	            vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	            vo.setCnt(cnt2);
	            commonDAO.update(vo, "asDAO.insertMsgInfo");
	        }

	        if (!"".equals(vo.getProc_dt())
	                && !"C005".equals(vo.getProc_status())
	                && ("Y".equals(init_yn) || "Y".equals(change_yn))) {

	            cnt2 = commonDAO.selectOneInt(vo, "asDAO.getMsgCnt2");
	            vo.setAlimTalk_message(getAlimTalkMessage2(vo));
	            vo.setSms_message(getSmsMessage2(vo));
	            vo.setAlimTalk_btn(getAlimTalk_Btn(vo));
	            vo.setApply_tel(vo.getApply_tel().replaceAll("-", ""));
	            vo.setCnt(cnt2);
	            commonDAO.update(vo, "asDAO.insertMsgInfo2");
	        }
	    }

	    if ("C001".equals(vo.getInportance())
	            && !("C005".equals(vo.getProc_status()) || "C006".equals(vo.getProc_status()))
	            && ("Y".equals(assign_change_yn) || "Y".equals(inportance_change_yn))
	            && !vo.getAssign_id().equals(vo.getReg_id())
	            && "Y".equals(sms_send_yn)) {

	        String mobile_no = (String) commonDAO.selectOne(vo, "asDAO.getMobileNo");
	        AsVO asTypeVO = (AsVO) commonDAO.selectOne(vo, "asDAO.getServiceCateNm");
	        String emp_nm = (String) commonDAO.selectOne(vo, "asDAO.getEmpNm");

	        vo.setMobile_no(mobile_no);
	        vo.setRequest_type_nm(asTypeVO.getRequest_type_nm());
	        vo.setService_cate_nm(asTypeVO.getService_cate_nm());
	        vo.setInquiry_type_nm(asTypeVO.getInquiry_type_nm());
	        vo.setEmp_nm(emp_nm);

	        cnt2 = commonDAO.selectOneInt(vo, "asDAO.getEmergencyMsgCnt");
	        vo.setAlimTalk_message(getEmergencyAlimTalkMessage(vo));
	        vo.setSms_message(getEmergencySmsMessage(vo));
	        vo.setCnt(cnt2);

	        commonDAO.update(vo, "asDAO.insertEmergencyMsgInfo");
	    }
	}
	
	@Override
	public int deleteAsProcAllLinked(AsVO vo, HttpServletRequest request) throws Exception {

	    int total = 0;

	    String delAsStr = SsStringUtil.normalizeNull(vo.getDel_as_no());
	    String[] baseArr = delAsStr.split("@");

	    LinkedHashSet<String> deleteSet = new LinkedHashSet<>();

	    for (String baseAsNo : baseArr) {

	        vo.setAs_no(baseAsNo);

	        String linkStr = SsStringUtil.normalizeNull(
	            (String) commonDAO.selectOne(vo, "asDAO.getAsNoLinkByAsNo")
	        );

	        if (!linkStr.isEmpty()) {
	            for (String x : linkStr.split(",")) {
	                if (x != null && !x.trim().isEmpty()) {
	                    deleteSet.add(x.trim());
	                }
	            }
	        } else {
	            deleteSet.add(baseAsNo);
	        }
	    }

	    for (String asNo : deleteSet) {
	        vo.setAs_no(asNo);
	        total += commonDAO.update(vo, "asDAO.deleteAsProc");
	    }

	    return total;
	}

	@Override
	public int updateAsHistAction(AsVO vo) throws Exception {
		return commonDAO.update(vo, "asDAO.updateAsHistAction");
	}

	@Override
	public int updateAsHistFileSeq(AsVO vo) throws Exception {
		return commonDAO.update(vo, "asDAO.updateAsHistFileSeq");
	}

	public int selectAsMgtCntByAssignId(String id) throws Exception {
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("id", id);
		return commonDAO.selectOneInt(param, "asDAO.selectAsMgtCntByAssignId");
	}
	
	/*처리담당자 관리*/
	@Override
	public int getOperateCnt(OperateVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, queryName);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<OperateVO> getOperateList(OperateVO vo, String queryName) throws Exception {
		return (List<OperateVO>) commonDAO.list(vo,queryName );
	}
	
	@Override
	public Map<String, Object> getOperateInfo(OperateVO vo) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "asDAO.getOperateInfo"));
		return returnMap;
	}
	
	/*처리담당자정보 업데이트*/
	@Override
	public int updateOperate(OperateVO vo, HttpServletRequest request) throws Exception {
		
		/* 처리담당자정보 업데이트(0보다 클 경우 등록성공 / 음수인 경우 지정배정인데 이미 등록된 건이 있어서 등록실패 ) */
		int returnValue = 0 ;
		
		String regist_yn = "";
		String change_yn = "";
		
		if ("insert".equals(vo.getPageType())) {
			
			/* 2차분류 여부(구분이 존재할 경우) */
			if(!"".equals(vo.getVal2())) {
							
					regist_yn = (String) commonDAO.selectOne(vo, "asDAO.getOperateIRegistYn");
					
					/* 처리담당자 추가 가능(지정된 담당자가 현재 문의유형:시스템(대):시스템(소) 처리담당자에 없는 경우) */
					if("Y".equals(regist_yn)) {
						if("Y".equals(vo.getUse_yn())) {
							if("Y".equals(vo.getMaster_yn())) {
								commonDAO.update(vo, "asDAO.updateOperateWkCount");
							}
						}
						int maxseq = commonDAO.selectOneInt(null,"asDAO.getMaxOperateSeq");
						vo.setOper_seq(SsStringUtil.normalizeNull(maxseq));
						returnValue = commonDAO.update(vo, "asDAO.insertOperate");
					}else {
						returnValue = -3;
					}
				
			/* 2차분류 여부(구분이 존재하지 않을 경우) */
			}else {
				returnValue = -99;
			}
			
		}else if("update".equals(vo.getPageType())) {
			
			/* 2차분류 여부(구분이 존재할 경우) */
			if(!"".equals(vo.getVal2())) {
				
					change_yn = (String) commonDAO.selectOne(vo, "asDAO.getOperateURegistYn");
					
					/* 처리담당자 변경 가능(지정된 담당자가 현재 문의유형,시스템(대),시스템(소) 처리담당자에 없는 경우) */
					if("Y".equals(change_yn)) {
						if("Y".equals(vo.getUse_yn())) {
							if("Y".equals(vo.getMaster_yn())) {
								commonDAO.update(vo, "asDAO.updateOperateWkCount");
							}
						}
						returnValue = commonDAO.update(vo, "asDAO.updateOperate");
					}else {
						returnValue = -3;
					}
				
			/* 2차분류 여부(구분이 존재하지 않을 경우) */
			}else {
				returnValue = -99;
			}	
		}
		
		return returnValue;
	}
}
