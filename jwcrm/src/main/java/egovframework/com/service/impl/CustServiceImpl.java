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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.FileVO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.service.CommonFileService;
import egovframework.com.comm.util.DateTimeUtil;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.BoardVO;
import egovframework.com.model.CustVO;
import egovframework.com.service.CustService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : CustServiceImpl.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2017.09.08             최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Service("custService")	
public class CustServiceImpl extends EgovAbstractServiceImpl implements CustService {

	@Autowired CommonDao commonDAO ;
	@Autowired CommonFileService commonFileService ;
	
	@Override
	public int getSelectInt(CustVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, queryName);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<CustVO> getList(CustVO vo, String queryName) throws Exception {
		return (List<CustVO>) commonDAO.list(vo, queryName);
	}
	
	
	
	@Override
	public CustVO getSelectOne(CustVO vo, String queryName) throws Exception {
		return (CustVO) commonDAO.selectOne(vo, queryName);
	}
	
	

	@Override
	@SuppressWarnings("unchecked")
	public List<CustVO> getCustList(CustVO vo) throws Exception {
		return (List<CustVO>) commonDAO.list(vo, "custDAO.getCustList");
	}

	@Override
	public int getCustListCnt(CustVO vo) throws Exception {
		return commonDAO.selectOneInt(vo, "custDAO.getCustListCnt");
	}
	
	@Override
	public int crmCodeChk(CustVO vo) throws Exception {
		return commonDAO.selectOneInt(vo, "custDAO.crmCodeChk");
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<CustVO> getLinkCustInfo(CustVO vo) throws Exception {
		return (List<CustVO>) commonDAO.list(vo, "custDAO.getLinkCustInfo");
	}
	
	
	

	@Override
	public int updateInfo(CustVO vo, HttpServletRequest request) throws Exception {
		
		/* 관리정보 업데이트 */
		commonDAO.update(vo, "custDAO.updateInfo");

		if(!"-1".equals(SsStringUtil.normalize(vo.getV_return_seq(), "-1"))) {
			/**	하단 정보 입력	*/
			
			if(!"".equals(SsStringUtil.normalizeNull(vo.getI_cnt()))) {
				for(int i = 0 ; i < Integer.parseInt(vo.getI_cnt()) ; i++) {
					CustVO issueVO = new CustVO() ;
					
					issueVO.setSeq(vo.getV_return_seq());
					issueVO.setDtl_seq(String.valueOf((i+1)));	
					issueVO.setGubun_code(SsStringUtil.normalizeNull(request.getParameter("gubun_code" + (i+1))));
					issueVO.setContents(SsStringUtil.normalizeNull(request.getParameter("contents" + (i+1))));
					issueVO.setReg_id(vo.getReg_id());
					issueVO.setAction_result_code(SsStringUtil.normalizeNull(request.getParameter("action_result_code" + (i+1))));
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("action_result_code" + (i+1))))) {
						issueVO.setAction_result_etc(SsStringUtil.normalizeNull(request.getParameter("action_result_etc" + (i+1))));
						issueVO.setAction_change_date(DateTimeUtil.getDate());
						issueVO.setAction_emp_id(vo.getReg_id());
					}
					issueVO.setPageType(vo.getPageType());
					if ("update".equals(vo.getPageType())) {
						issueVO.setUpd_date(DateTimeUtil.getDate());
						issueVO.setUpd_id(vo.getReg_id());
					}
					
					commonDAO.update(issueVO, "custDAO.insertIssue");
				}
				
			}
			
			if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq()))) {
				CustVO delVO = new CustVO();
				String[] arr = vo.getDel_dtl_seq().split("@");
				
				for (int i=0; i<arr.length; i++) {
					delVO.setSeq(vo.getSeq());
					delVO.setDtl_seq(arr[i]);
					delVO.setPageType("DELETE");
					commonDAO.update(delVO, "custDAO.insertIssue");
				}
			}
		}
		
		/* 관리정보 삭제 */
		if ("delete".equals(vo.getPageType())) {
			vo.setPageType("DELETEALL");
			//custService.insertIssue(vo) ;
			commonDAO.update(vo, "custDAO.updateInfo");
		}
		
		return 1;
	}

	@Override
	public Map<String , Object> getCustInfo(CustVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		commonDAO.selectOne(vo, "custDAO.getCustInfo");
		returnMap.put("info", vo.getOUTCURSOR());
		
		commonDAO.list(vo, "custDAO.getCustIssueList");
		returnMap.put("hist", vo.getOUTCURSOR());
		
		return returnMap;
	}
	
	@Override
	public Map<String , Object> getProjectInfo(CustVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		commonDAO.selectOne(vo, "custDAO.getProjectInfo");
		returnMap.put("info", vo.getOUTCURSOR());
		
		/* 서버 유지보수 업체 List */
		commonDAO.list(vo, "custDAO.getMtacInfo");
		returnMap.put("mtac", vo.getOUTCURSOR());
		
		/* 백신 List */
		commonDAO.list(vo, "custDAO.getVcInfo");
		returnMap.put("vc", vo.getOUTCURSOR());
		
		/* 건물구조 List */
		commonDAO.list(vo, "custDAO.getBdInfo");
		returnMap.put("bd", vo.getOUTCURSOR());
		
		/* 담당자정보 List */
		commonDAO.list(vo, "custDAO.getChargeInfo");
		returnMap.put("charge", vo.getOUTCURSOR());
		
		return returnMap;
	}
	
	@Override
	public int getProjectCnt(CustVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		/* 프로젝트 정보 입력 유무 카운트 */
		int returnValue = commonDAO.selectOneInt(vo, "custDAO.getProjectInfoCnt");
		
		return returnValue;
	}
	
	@Override
	public Map<String , Object> getOperateInfo(CustVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		/* 운영정보 view */
		commonDAO.selectOne(vo, "custDAO.getOperateInfo");
		returnMap.put("info", vo.getOUTCURSOR());
		
		/* 서버 유지보수 업체 List */
		commonDAO.list(vo, "custDAO.getOperateMtacInfo");
		returnMap.put("mtac", vo.getOUTCURSOR());
		
		/* 백신 List */
		commonDAO.list(vo, "custDAO.getOperateVcInfo");
		returnMap.put("vc", vo.getOUTCURSOR());
		
		/* 담당자정보 List */
		commonDAO.list(vo, "custDAO.getOperateChargeInfo");
		returnMap.put("charge", vo.getOUTCURSOR());
		
		/* 관리비고내역 List */
		commonDAO.list(vo, "custDAO.getOperateNoteInfo");
		returnMap.put("note", vo.getOUTCURSOR());
		
		return returnMap;
	}
	
	@Override
	public Map<String , Object> getMtacHistInfo(CustVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		/* 유지보수이력 List */
		commonDAO.list(vo, "custDAO.getMtacHistInfo");
		returnMap.put("list", vo.getOUTCURSOR());
		
		return returnMap;
	}
	
	
	
	
	
	
	@Override
	public int updateProject(CustVO vo , HttpServletRequest request ) throws Exception {
		/**	프로젝트 기본정보		*/
		
		if ("all".equals(vo.getProcFlag())) {
			//프로젝트정보,운영정보 업데이트
			commonDAO.update(vo, "custDAO.updateProject");
			commonDAO.update(vo, "custDAO.updateOperateForProcject");
			/**	서버 유지보수 업체	- mt_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getMt_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateOperateMtac");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getMt_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("mtac_cust_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setMtac_cust_code(request.getParameter("mtac_cust_code" + (i+1)));
						mtVO.setReg_id(vo.getReg_id());
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateOperateMtac");
					}
					
				}
				
			}
			/**	백신	- vc_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getVc_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateOperateVc");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getVc_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("vc_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setVc_code(request.getParameter("vc_code" + (i+1)));
						mtVO.setReg_id(vo.getReg_id());
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateOperateVc");
					}
				}
			}
		} else {
			//프로젝트정보 업데이트
			commonDAO.update(vo, "custDAO.updateProject");
		}
		
		//commonDAO.update(vo, "custDAO.updateProject");
		
		if(!"-1".equals(SsStringUtil.normalize(vo.getV_return_seq(), "-1"))) {
			/**	서버 유지보수 업체	- mt_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getMt_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateMtac");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getMt_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("mtac_cust_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setMtac_cust_code(request.getParameter("mtac_cust_code" + (i+1)));
						mtVO.setReg_id(vo.getReg_id());
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateMtac");
					}
					
				}
				
			}
			/**	백신	- vc_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getVc_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateVc");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getVc_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("vc_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setVc_code(request.getParameter("vc_code" + (i+1)));
						mtVO.setReg_id(vo.getReg_id());
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateVc");
					}
				}
			}
			/**	건물구조	- bd_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getBd_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateBd");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getBd_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("bd_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setBd_code(request.getParameter("bd_code" +(i+1)));
						mtVO.setBd_etc(SsStringUtil.normalizeNull(request.getParameter("bd_etc" + (i+1))));
						mtVO.setReg_id(vo.getReg_id());
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateBd");
					}
				}
			}
			
			/**	담당자 정보	- cg_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getCg_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateCharge");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getCg_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("charge_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setCharge_code(SsStringUtil.normalizeNull(request.getParameter("charge_code" + (i+1))));
						mtVO.setCharge_nm(SsStringUtil.normalizeNull(request.getParameter("charge_nm" + (i+1))));
						mtVO.setCompany_tel_no(SsStringUtil.normalizeNull(request.getParameter("company_tel_no" + (i+1))));
						mtVO.setHp_no(SsStringUtil.normalizeNull(request.getParameter("hp_no" + (i+1))));
						mtVO.setEmail(SsStringUtil.normalizeNull(request.getParameter("email" + (i+1))));
						mtVO.setEtc(SsStringUtil.normalizeNull(request.getParameter("etc" + (i+1))));
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateCharge");
					}
				}
			}
			
		}
		
		// 20180219  프로젝트 정보 업데이트시에 무상유지보수 자동 등록 실행
//		try{
//			int chkCnt = commonDAO.insert(null, "custDAO.insertVirtualContractAuto");
//			if (chkCnt > 0){
//				commonDAO.insert(null, "custDAO.insertCustMaintenanceAddAuto");
//			}
//		}catch(Exception e){
//			e.printStackTrace();
//		}
		
		return 1 ; 
	}

	@Override
	public int updateOperate(CustVO vo, HttpServletRequest request) throws Exception {
		
		/**	프로젝트 기본정보		*/
		String pageType = SsStringUtil.normalizeNull(vo.getPageType());
		
		vo.setPageType(pageType);
		commonDAO.update(vo, "custDAO.updateOperate");
		
		/**	담당자 정보 처리	*/
		if(!"-1".equals(SsStringUtil.normalize(vo.getV_return_seq() , "-1"))) {
			
			vo.setPageType("DELETEALL");
			commonDAO.update(vo, "custDAO.updateOperateCharge");
			
			if(!"".equals(SsStringUtil.normalizeNull(vo.getCg_cnt()))) {
				for(int i = 0 ; i <= Integer.parseInt(vo.getCg_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("charge_nm" + (i+1))))) {
						CustVO tempVO = new CustVO() ;
						
						tempVO.setSeq(vo.getV_return_seq());
						tempVO.setDtl_seq(String.valueOf((i+1)));
						tempVO.setCharge_code(SsStringUtil.normalizeNull(request.getParameter("charge_code" + (i+1))));
						tempVO.setCharge_nm(SsStringUtil.normalizeNull(request.getParameter("charge_nm" + (i+1))));
						tempVO.setCompany_tel_no(SsStringUtil.normalizeNull(request.getParameter("company_tel_no" + (i+1))));
						tempVO.setHp_no(SsStringUtil.normalizeNull(request.getParameter("hp_no" + (i+1)))); 
						tempVO.setEmail(SsStringUtil.normalizeNull(request.getParameter("email" + (i+1)))); 
						tempVO.setEtc(SsStringUtil.normalizeNull(request.getParameter("etc" + (i+1))));
						tempVO.setPageType("INSERT");
						commonDAO.update(tempVO, "custDAO.updateOperateCharge");
					}
				}
			}
			
			//vo.setPageType("DELETEALL");
			//commonDAO.update(vo, "custDAO.updateOperateNote");
			/**	관리비고 내역 처리	*/
			vo.setPageType(pageType);
			if(!"".equals(SsStringUtil.normalizeNull(vo.getNt_cnt()))) {
				for(int i = 0 ; i <= Integer.parseInt(vo.getNt_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("gubun" + (i+1))))) {
						CustVO tempVO = new CustVO() ;
						
						tempVO.setSeq(vo.getV_return_seq());
						tempVO.setDtl_seq(String.valueOf((i+1)));
						tempVO.setGubun(SsStringUtil.normalizeNull(request.getParameter("gubun" + (i+1))));
						tempVO.setContents(SsStringUtil.normalizeNull(request.getParameter("contents" + (i+1))));
						tempVO.setReg_id(vo.getReg_id());
						tempVO.setEtc(SsStringUtil.normalizeNull(request.getParameter("n_etc" + (i+1))));
						tempVO.setPageType(vo.getPageType());
						commonDAO.update(tempVO, "custDAO.updateOperateNote");
					}
				}
			}
			
			
			/**	서버 유지보수 업체	- mt_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getMt_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateOperateMtac");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getMt_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("mtac_cust_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setMtac_cust_code(request.getParameter("mtac_cust_code" + (i+1)));
						mtVO.setReg_id(vo.getReg_id());
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateOperateMtac");
					}
					
				}
				
			}
			/**	백신	- vc_cnt	*/
			if(!"".equals(SsStringUtil.normalizeNull(vo.getVc_cnt()))) {
				vo.setPageType("DELETEALL");
				commonDAO.update(vo, "custDAO.updateOperateVc");
				
				for(int i = 0 ; i <= Integer.parseInt(vo.getVc_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("vc_code" + (i+1))))) {
						CustVO mtVO = new CustVO() ;
						mtVO.setSeq(vo.getV_return_seq());
						mtVO.setDtl_seq(String.valueOf((i+1)));
						mtVO.setVc_code(request.getParameter("vc_code" + (i+1)));
						mtVO.setReg_id(vo.getReg_id());
						mtVO.setPageType("INSERT");
						commonDAO.update(mtVO, "custDAO.updateOperateVc");
					}
				}
			}
			
			if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq()))) {
				CustVO delVO = new CustVO();
				String[] arr = vo.getDel_dtl_seq().split("@");
				
				for (int i=0; i<arr.length; i++) {
					delVO.setSeq(vo.getSeq());
					delVO.setDtl_seq(arr[i]);
					delVO.setPageType("DELETE");
					commonDAO.update(delVO, "custDAO.updateOperateNote");
				}
			}
		}
		
		// 20180219  운영 정보 업데이트시에 무상유지보수 자동 등록 실행
//		try{
//			int chkCnt = commonDAO.insert(null, "custDAO.insertVirtualContractAuto");
//			if (chkCnt > 0){
//				commonDAO.insert(null, "custDAO.insertCustMaintenanceAddAuto");
//			}
//		}catch(Exception e){
//			e.printStackTrace();
//		}
		
		return 1;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<CustVO> getErpList(CustVO vo) throws Exception {
		return (List<CustVO>)commonDAO.list(vo, "custDAO.getErpList");
	}

	@Override
	public int updateMtac(CustVO vo, HttpServletRequest request) throws Exception {
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getHt_cnt()))) {
			for(int i = 0 ; i <= Integer.parseInt(vo.getHt_cnt()) ; i++) {
				
				if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("contract_seq" + (i+1))))) {
					CustVO temp = new CustVO() ; 
					
					temp.setSeq(vo.getSeq());
					temp.setDtl_seq(String.valueOf((i+1)));
					temp.setContract_seq(SsStringUtil.normalizeNull(request.getParameter("contract_seq" + (i+1))));
					temp.setContract_nm(SsStringUtil.normalizeNull(request.getParameter("contract_nm" + (i+1))));
					temp.setContract_dt(SsStringUtil.normalizeNull(request.getParameter("contract_dt" + (i+1))).replaceAll("/", ""));
					temp.setBill_code(SsStringUtil.normalizeNull(request.getParameter("bill_code" + (i+1))));
					temp.setMtac_code(SsStringUtil.normalizeNull(request.getParameter("mtac_code" + (i+1))));
					temp.setMtac_start_dt(SsStringUtil.normalizeNull(request.getParameter("mtac_start_dt" + (i+1))).replaceAll("/", ""));
					temp.setMtac_end_dt(SsStringUtil.normalizeNull(request.getParameter("mtac_end_dt" + (i+1))).replaceAll("/", ""));
					temp.setMon_off_amt(SsStringUtil.normalizeNull(request.getParameter("mon_off_amt" + (i+1))));
					temp.setYear_off_amt(SsStringUtil.normalizeNull(request.getParameter("year_off_amt" + (i+1))));

					/* 171012 추가 */
					temp.setDeal_code(SsStringUtil.normalizeNull(request.getParameter("deal_code" + (i+1))));
					temp.setBuy_busi_name(SsStringUtil.normalizeNull(request.getParameter("buy_busi_name" + (i+1))));
					temp.setBuy_cost(SsStringUtil.normalizeNull(request.getParameter("buy_cost" + (i+1))));
					temp.setService_period(SsStringUtil.normalizeNull(request.getParameter("service_period" + (i+1))));
					temp.setService_method(SsStringUtil.normalizeNull(request.getParameter("service_method" + (i+1))));
					temp.setAuto_renew_yn(SsStringUtil.normalizeNull(request.getParameter("auto_renew_yn" + (i+1))));
					
					temp.setEtc(SsStringUtil.normalizeNull(request.getParameter("etc" + (i+1))));
					temp.setReg_id(vo.getReg_id());
					temp.setPageType("INSERT");
					temp.setHt_cnt(vo.getHt_cnt());
					
					commonDAO.update(temp, "custDAO.updateMtacList") ; 
					
				}
				
			}
			
			if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq()))) {
				CustVO delVO = new CustVO();
				String[] arr = vo.getDel_dtl_seq().split("@");
				
				for (int i=0; i<arr.length; i++) {
					delVO.setSeq(vo.getSeq());
					delVO.setDtl_seq(arr[i]);
					delVO.setPageType("DELETE");
					commonDAO.update(delVO, "custDAO.updateMtacList");
				}
			}
			
			return 1;
		}else {
			return 0;
		}		
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<CustVO> getGroupCodeList(CustVO vo) throws Exception {
		return (List<CustVO>)commonDAO.list(vo, "custDAO.getGroupCodeList");
	}

	@Override
	public int updateInstall(CustVO vo, HttpServletRequest request) throws Exception {
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getIns_cnt()))) {
			for(int i = 0 ; i <= Integer.parseInt(vo.getIns_cnt()); i++) {
				
				if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("erp_code" + (i+1))))) {
					CustVO temp = new CustVO() ; 
					
					temp.setSeq(vo.getSeq());
					temp.setDtl_seq(String.valueOf((i+1)));
					temp.setErp_code(SsStringUtil.normalizeNull(request.getParameter("erp_code" + (i+1))));
					temp.setGroup_code1(SsStringUtil.normalizeNull(request.getParameter("group_code1_" + (i+1))));
					temp.setGroup_code2(SsStringUtil.normalizeNull(request.getParameter("group_code2_" + (i+1))));
					temp.setGroup_code3(SsStringUtil.normalizeNull(request.getParameter("group_code3_" + (i+1))));
					temp.setMatr_code(SsStringUtil.normalizeNull(request.getParameter("matr_code" + (i+1))));
					
					/**	2017-10-30 민지씨 요청 사항	*/
					if(!"ERP".equals(SsStringUtil.normalizeNull(request.getParameter("emp_nm" + (i+1))))) temp.setReg_id(vo.getReg_id());
					else temp.setReg_id("ERP");
					
					temp.setEtc(SsStringUtil.normalizeNull(request.getParameter("etc" + (i+1))));
					temp.setSerial_no(SsStringUtil.normalizeNull(request.getParameter("serial_no" + (i+1))));
					temp.setPageType("INSERT");
					temp.setIns_cnt(vo.getIns_cnt());
					
					commonDAO.update(temp, "custDAO.updateInstall") ; 
				}
				
			}
			
			if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq()))) {
				CustVO delVO = new CustVO();
				String[] arr = vo.getDel_dtl_seq().split("@");
				
				for (int i=0; i<arr.length; i++) {
					delVO.setSeq(vo.getSeq());
					delVO.setDtl_seq(arr[i]);
					delVO.setPageType("DELETE");
					commonDAO.update(delVO, "custDAO.updateInstall");
				}
			}
		}
		
		return 1;
	}
	
	
	@Override
	public int updateDoc(CustVO vo, HttpServletRequest request, List<FileVO> fileList) throws Exception {
		/** 문서 정보 처리	*/
		
		@SuppressWarnings("unused")
		int file_cnt = 0;
		String st= ""; 
		if(!"-1".equals(SsStringUtil.normalize(vo.getCust_seq() , "-1"))) {
			if(!"".equals(SsStringUtil.normalizeNull(vo.getDc_cnt()))) {
				for(int i = 0 ; i <= Integer.parseInt(vo.getDc_cnt()) ; i++) {
					if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("doc_type" + (i+1))))) {
						
						CustVO tempVO = new CustVO() ;
						FileVO temp = new FileVO(); 
						
						
						//if(temp == null) {st = "300" ; }
						
						int attach_seq = 0;
						
						if(fileList != null && fileList.size() > 0){
							temp = fileList.get(file_cnt);
							if(temp.getAttach_tag_name().startsWith("uploadFile_")){
								if(attach_seq == 0) attach_seq = commonFileService.getMaxFileSeq() ;
								temp.setAttach_seq(attach_seq);
								temp.setAttach_ord(Integer.parseInt(temp.getAttach_tag_name().replaceAll("uploadFile_", "")));
								commonFileService.insertFile(temp);
							}
						}
						
						tempVO.setFile_seq(String.valueOf(attach_seq));
						tempVO.setCust_seq(SsStringUtil.normalizeNull(request.getParameter("cust_seq")));
						tempVO.setD_doc_type(SsStringUtil.normalizeNull(request.getParameter("doc_type" + (i+1))));
						tempVO.setD_detail_type(SsStringUtil.normalizeNull(request.getParameter("detail_type" + (i+1))));
						tempVO.setD_doc_comment(SsStringUtil.normalizeNull(request.getParameter("doc_comment" + (i+1)))); 
						tempVO.setD_reg_id(vo.getReg_id());
						
						if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("std_dt" + (i+1)))))
							tempVO.setD_std_dt(request.getParameter("std_dt" + (i+1)).replaceAll("/", ""));
						
						tempVO.setPageType("INSERT");
						
						file_cnt++;
						
						commonDAO.insert(tempVO, "custDAO.insertDoc");
					}
				}
			}
		}
		return 1;
	}
	
	
	@Override
	public int deleteDoc(CustVO vo, HttpServletRequest request) throws Exception {
		
		
		@SuppressWarnings("unused")
		int del_cnt = 0;
		if(!"".equals(SsStringUtil.normalizeNull(request.getParameter("del_cnt")))) {
			for(int i = 0 ; i < Integer.parseInt(request.getParameter("del_cnt")) ; i++) {
				CustVO tempVO = new CustVO() ;
				FileVO temp = new FileVO() ;
				tempVO.setDoc_seq(SsStringUtil.normalizeNull(request.getParameter("doc_seq" + (i))));
				commonDAO.delete(tempVO, "custDAO.deleteDoc");
				
				temp.setAttach_seq(Integer.parseInt(request.getParameter("file_seq" + (i))));
				temp.setAttach_ord(Integer.parseInt(request.getParameter("attach_ord" + (i))));
				commonFileService.deleteFileInfo(temp) ; 
				
			}
			
			
		}
		
		return 1;
		
	}
	
	
	
	
	@Override
	@SuppressWarnings("unchecked")
	public List<CustVO> getForm4List(CustVO vo) throws Exception {
//		return (List<CustVO>)commonDAO.list(vo, "custDAO.getForm4List");
		return (List<CustVO>)commonDAO.list(vo, "custDAO.getForm4List2");
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<CustVO> getPayInfo(CustVO vo) throws Exception {
		return (List<CustVO>)commonDAO.list(vo, "custDAO.getPayInfo");
	}

	@Override
	public int updateOperateState(CustVO vo) throws Exception {
		int returnValue = 0 ; 
		String del_dtl_seq = SsStringUtil.normalizeNull(vo.getDel_dtl_seq()) ; 
		
		if("".equals(del_dtl_seq)) return -100 ; 
		
		String[] seq = del_dtl_seq.split("@") ; 
		
		if(seq != null && seq.length > 0) {
			for(String a : seq) {
				CustVO temp = new CustVO() ; 
				
				temp.setSeq(a);
				
				returnValue = commonDAO.update(temp, "custDAO.updateOperateState") ; 
			}
		}
		
		
		return returnValue;
	}
	
	
	
	@Override
	@SuppressWarnings("unchecked")
	public Map<String , Object> getDocInfo(CustVO vo, String query) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<CustVO> resultList = (List<CustVO>)commonDAO.list(vo, query);
		
		/*if(resultList != null) {
			for(int i = 0 ; i <= resultList.size() ; i++) {
				FileVO fileVO = new FileVO() ;
				fileVO.setAttach_seq( Integer.parseInt(resultList.get(i).getFile_seq()) );
				returnMap.put("attachList", commonFileService.getFileList(fileVO)) ;
			}
		}*/
		
		returnMap.put("resultList", resultList) ; 
		return returnMap ; 
	}


}
