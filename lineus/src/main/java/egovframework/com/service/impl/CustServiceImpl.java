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
import egovframework.com.model.ServerVO;
import egovframework.com.model.ServiceVO;
import egovframework.com.model.DbVO;
import egovframework.com.model.AppVO;
import egovframework.com.model.ProjectVO;
import egovframework.com.model.RetireVO;
import egovframework.com.model.OperateVO;
import egovframework.com.model.NetworkVO;
import egovframework.com.service.CustService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : CustServiceImpl.java
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2018.10.29             최초생성
 *
 * @author 기업운영팀 개발팀
 * @since 2018. 10.01
 * @version 1.0
 * @see
 *
 *  Copyright (C) by 중외정보기술 All right reserved.
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
	public int getListCnt(CustVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, queryName);
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
	public int getProjectCnt(ProjectVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, queryName);
	}
	
	
	@Override
	public int getOperateCnt(OperateVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, queryName);
	}

	/*운영정보*/
	@Override
	@SuppressWarnings("unchecked")
	public List<OperateVO> getOperateList(OperateVO vo, String queryName) throws Exception {
		return (List<OperateVO>) commonDAO.list(vo,queryName );
	}
	
	/*서버리스트*/
	@Override
	@SuppressWarnings("unchecked")
	public List<ServerVO> getServerList(ServerVO vo, String queryName) throws Exception {
		return (List<ServerVO>) commonDAO.list(vo, queryName);
	}
	
	/*DB리스트*/
	@Override
	@SuppressWarnings("unchecked")
	public List<DbVO> getDbList(DbVO vo, String queryName) throws Exception {
		return (List<DbVO>) commonDAO.list(vo, queryName);
	}
	
	/*App리스트*/
	@Override
	@SuppressWarnings("unchecked")
	public List<AppVO> getAppList(AppVO vo, String queryName) throws Exception {
		return (List<AppVO>) commonDAO.list(vo, queryName);
	}
	
	/*서비스 리스트*/
	@Override
	@SuppressWarnings("unchecked")
	public List<ServiceVO> getServiceList(ServiceVO vo, String queryName) throws Exception {
		return (List<ServiceVO>) commonDAO.list(vo, queryName);
	}
	
	
	/*네트워크리스트*/
	@Override
	@SuppressWarnings("unchecked")
	public List<NetworkVO> getNetworkList(NetworkVO vo, String queryName) throws Exception {
		return (List<NetworkVO>) commonDAO.list(vo, queryName);
	}
	
	/*프로젝트리스트*/
	@Override
	@SuppressWarnings("unchecked")
	public List<ProjectVO> getProjectList(ProjectVO vo, String queryName) throws Exception {
		return (List<ProjectVO>) commonDAO.list(vo, queryName);
	}

	
	/*거래처관리 업데이트*/
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
					/*if ("update".equals(vo.getPageType())) {
						issueVO.setUpd_date(DateTimeUtil.getDate());
						issueVO.setUpd_id(vo.getReg_id());
					}*/
					
					if ("update".equals(vo.getPageType())) {
					issueVO.setReg_date(DateTimeUtil.getDate());
					issueVO.setReg_id(vo.getReg_id());
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
	
	
	
	/*네트워크 업데이트*/
	@Override
	public int updateNetwork(NetworkVO vo, HttpServletRequest request) throws Exception {
		
		/* 관리정보 업데이트 */
		int returnValue = 0 ;
		if (!"".equals(SsStringUtil.normalizeNull(vo.getAdopt_dt())))
			vo.setAdopt_dt(vo.getAdopt_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getFree_start_dt())))
			vo.setFree_start_dt(vo.getFree_start_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getFree_end_dt())))
			vo.setFree_end_dt(vo.getFree_end_dt().replaceAll("/", ""));
		
		if ("insert".equals(vo.getPageType())) {
			int maxseq = commonDAO.selectOneInt(null,"custDAO.getMaxNetworkSeq");
			vo.setSeq(SsStringUtil.normalizeNull(maxseq));
			vo.setNetwork_seq(SsStringUtil.normalizeNull(maxseq));
			returnValue = commonDAO.update(vo, "custDAO.insertNetwork");
		}else if("update".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.updateNetwork");
		}
		
		/**	하단 정보 입력	*/
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getCg_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getCg_cnt()) ; i++) {
				NetworkVO chVO = new NetworkVO() ;
				
				chVO.setNetwork_seq(vo.getSeq());
				chVO.setCh_seq(SsStringUtil.normalizeNull(request.getParameter("ch_seq" + (i+1))));	
				chVO.setCharge_code(SsStringUtil.normalizeNull(request.getParameter("charge_code" + (i+1))));
				chVO.setCharge_nm(SsStringUtil.normalizeNull(request.getParameter("charge_nm" + (i+1))));
				chVO.setCompany_tel_no(SsStringUtil.normalizeNull(request.getParameter("company_tel_no" + (i+1))));
				chVO.setHp_no(SsStringUtil.normalizeNull(request.getParameter("hp_no" + (i+1))));
				chVO.setEmail(SsStringUtil.normalizeNull(request.getParameter("email" + (i+1))));
				chVO.setCh_etc(SsStringUtil.normalizeNull(request.getParameter("ch_etc" + (i+1))));
				chVO.setCompany_nm(SsStringUtil.normalizeNull(request.getParameter("company_nm" + (i+1))));
				chVO.setReg_id(vo.getReg_id());
				commonDAO.update(chVO, "custDAO.updateNetworkCharge");
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq1()))) {
			NetworkVO delVO1 = new NetworkVO();
			String[] arr = vo.getDel_dtl_seq1().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO1.setNetwork_seq(vo.getSeq());
				delVO1.setCh_seq(arr[i]);
				delVO1.setPageType("DELETE");
				commonDAO.update(delVO1, "custDAO.deleteNetCharge");
			}
		}
		
		
		
		if(!"".equals(SsStringUtil.normalizeNull(vo.getHt_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getHt_cnt()) ; i++) {
				NetworkVO htVO = new NetworkVO() ;
				
				htVO.setNetwork_seq(vo.getSeq());
				htVO.setHist_seq(SsStringUtil.normalizeNull(request.getParameter("hist_seq" + (i+1))));	
				htVO.setWork_type(SsStringUtil.normalizeNull(request.getParameter("work_type" + (i+1))));
				htVO.setInfra_gubun(SsStringUtil.normalizeNull(request.getParameter("infra_gubun" + (i+1))));
				htVO.setEquipment_nm(SsStringUtil.normalizeNull(request.getParameter("equipment_nm" + (i+1))));
				htVO.setWork_content(SsStringUtil.normalizeNull(request.getParameter("work_content" + (i+1))));
				htVO.setWork_charge(SsStringUtil.normalizeNull(request.getParameter("work_charge" + (i+1))));
				htVO.setWork_cust(SsStringUtil.normalizeNull(request.getParameter("work_cust" + (i+1))));
				htVO.setCust_charge(SsStringUtil.normalizeNull(request.getParameter("cust_charge" + (i+1))));
				
				htVO.setEnd_dt(SsStringUtil.normalizeNull(request.getParameter("end_dt" + (i+1))).replaceAll("/", ""));
				htVO.setStr_dt(SsStringUtil.normalizeNull(request.getParameter("str_dt" + (i+1))).replaceAll("/", ""));
				
				htVO.setWork_time(SsStringUtil.normalizeNull(request.getParameter("work_time" + (i+1))));
				htVO.setHist_etc(SsStringUtil.normalizeNull(request.getParameter("hist_etc" + (i+1))));
				
				
				htVO.setReg_id(vo.getReg_id());
				commonDAO.update(htVO, "custDAO.updateNetworkHist");
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq2()))) {
			NetworkVO delVO2 = new NetworkVO();
			String[] arr = vo.getDel_dtl_seq2().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO2.setNetwork_seq(vo.getSeq());
				delVO2.setHist_seq(arr[i]);
				delVO2.setPageType("DELETE");
				commonDAO.update(delVO2, "custDAO.deleteNetHist");
			}
		}
		
			
		/* 관리정보 삭제 */
		if ("delete".equals(vo.getPageType())) {
			vo.setPageType("DELETEALL");
			commonDAO.update(vo, "custDAO.updateInfo");
		}
		
		return returnValue;
	}
	
	/*프로젝트 업데이트*/
	@Override
	public int updateProject(ProjectVO vo, HttpServletRequest request) throws Exception {
		
		/* 프로젝트 업데이트 */
		int returnValue = 0 ;
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTest_dt())))
			vo.setTest_dt(vo.getTest_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getOpen_dt())))
			vo.setOpen_dt(vo.getOpen_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTerm_start_dt())))
			vo.setTerm_start_dt(vo.getTerm_start_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTerm_end_dt())))
			vo.setTerm_end_dt(vo.getTerm_end_dt().replaceAll("/", ""));
		
		if ("insert".equals(vo.getPageType())) {
			int maxseq = commonDAO.selectOneInt(null,"custDAO.getMaxProjectSeq");
			vo.setPro_seq(SsStringUtil.normalizeNull(maxseq));
			returnValue = commonDAO.update(vo, "custDAO.insertProject");
		}else if("update".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.updateProject");
		}
		
		
		/*연결서버정보*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSv_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getSv_cnt()) ; i++) {
				ProjectVO svVO = new ProjectVO() ;
				
				svVO.setPro_seq(vo.getPro_seq());
				svVO.setServer_seq(SsStringUtil.normalizeNull(request.getParameter("server_seq" + (i+1))));
				svVO.setReg_id(vo.getReg_id());
				if( SsStringUtil.normalizeNull(request.getParameter("dtl_seq" + (i+1))) == ""){
					commonDAO.update(svVO, "custDAO.updateProjectServer");
				}
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq1()))) {
			ProjectVO delVO1 = new ProjectVO();
			String[] arr = vo.getDel_dtl_seq1().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO1.setPro_seq(vo.getPro_seq());
				delVO1.setDtl_seq(arr[i]);
				delVO1.setPageType("DELETE");
				commonDAO.update(delVO1, "custDAO.deleteProjectServer");
			}
		}
		
		
		/**	참여인력 정보 입력	*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getWk_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getWk_cnt()) ; i++) {
				ProjectVO wkVO = new ProjectVO() ;
				
				wkVO.setPro_seq(vo.getPro_seq());
				wkVO.setWk_seq(SsStringUtil.normalizeNull(request.getParameter("wk_seq" + (i+1))));	
				wkVO.setTask_code(SsStringUtil.normalizeNull(request.getParameter("task_code" + (i+1))));
				wkVO.setWk_company(SsStringUtil.normalizeNull(request.getParameter("wk_company" + (i+1))));
				wkVO.setWorker_nm(SsStringUtil.normalizeNull(request.getParameter("worker_nm" + (i+1))));
				wkVO.setWork_start_dt(SsStringUtil.normalizeNull(request.getParameter("work_start_dt" + (i+1)).replaceAll("/", "")));
				wkVO.setWork_end_dt(SsStringUtil.normalizeNull(request.getParameter("work_end_dt" + (i+1)).replaceAll("/", "")));
				wkVO.setWk_hp_no(SsStringUtil.normalizeNull(request.getParameter("wk_hp_no" + (i+1))));
				
				wkVO.setWk_email(SsStringUtil.normalizeNull(request.getParameter("wk_email" + (i+1))));
				wkVO.setWk_company(SsStringUtil.normalizeNull(request.getParameter("wk_company" + (i+1))));
				wkVO.setWk_etc(SsStringUtil.normalizeNull(request.getParameter("wk_etc" + (i+1))));
				wkVO.setReg_id(vo.getReg_id());
				commonDAO.update(wkVO, "custDAO.updateProjectWorker");
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq2()))) {
			ProjectVO delVO2 = new ProjectVO();
			String[] arr = vo.getDel_dtl_seq2().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO2.setPro_seq(vo.getPro_seq());
				delVO2.setWk_seq(arr[i]);
				delVO2.setPageType("DELETE");
				commonDAO.update(delVO2, "custDAO.deleteProjectWorker");
			}
		}
		
		
		/*담당자정보*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getCg_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getCg_cnt()) ; i++) {
				ProjectVO chVO = new ProjectVO() ;
				
				chVO.setPro_seq(vo.getPro_seq());
				chVO.setCh_seq(SsStringUtil.normalizeNull(request.getParameter("ch_seq" + (i+1))));	
				chVO.setCharge_code(SsStringUtil.normalizeNull(request.getParameter("charge_code" + (i+1))));
				chVO.setCharge_nm(SsStringUtil.normalizeNull(request.getParameter("charge_nm" + (i+1))));
				chVO.setCompany_tel_no(SsStringUtil.normalizeNull(request.getParameter("company_tel_no" + (i+1))));
				chVO.setHp_no(SsStringUtil.normalizeNull(request.getParameter("hp_no" + (i+1))));
				chVO.setEmail(SsStringUtil.normalizeNull(request.getParameter("email" + (i+1))));
				chVO.setCh_etc(SsStringUtil.normalizeNull(request.getParameter("ch_etc" + (i+1))));
				chVO.setCompany_nm(SsStringUtil.normalizeNull(request.getParameter("company_nm" + (i+1))));
				chVO.setReg_id(vo.getReg_id());
				commonDAO.update(chVO, "custDAO.updateProjectCharge");
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq3()))) {
			ProjectVO delVO3 = new ProjectVO();
			String[] arr = vo.getDel_dtl_seq3().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO3.setPro_seq(vo.getPro_seq());
				delVO3.setCh_seq(arr[i]);
				delVO3.setPageType("DELETE");
				commonDAO.update(delVO3, "custDAO.deleteProjectCharge");
			}
		}
		
		
		
			
		/* 관리정보 삭제 */
		if ("delete".equals(vo.getPageType())) {
			vo.setPageType("DELETEALL");
			commonDAO.update(vo, "custDAO.updateInfo");
		}
		
		return returnValue;
	}
	
	
	
	
	/*운영정보 업데이트*/
	@Override
	public int updateOperate(OperateVO vo, HttpServletRequest request) throws Exception {
		
		/* 운영정보 업데이트 */
		int returnValue = 0 ;
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getTest_dt())))
			vo.setTest_dt(vo.getTest_dt().replaceAll("/", ""));
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getOpen_dt())))
			vo.setOpen_dt(vo.getOpen_dt().replaceAll("/", ""));
		
		
		if ("insert".equals(vo.getPageType())) {
			int maxseq = commonDAO.selectOneInt(null,"custDAO.getMaxOperateSeq");
			vo.setOper_seq(SsStringUtil.normalizeNull(maxseq));
			returnValue = commonDAO.update(vo, "custDAO.insertOperate");
		}else if("update".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.updateOperate");
		}
		
		
		/*연결서버정보*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getSv_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getSv_cnt()) ; i++) {
				OperateVO svVO = new OperateVO() ;
				svVO.setOper_seq(vo.getOper_seq());
				svVO.setServer_seq(SsStringUtil.normalizeNull(request.getParameter("server_seq" + (i+1))));
				
				/*서버SEQ체크*/
				if( !"".equals(SsStringUtil.normalizeNull(svVO.getServer_seq()))){
					svVO.setReg_id(vo.getReg_id());
					if( SsStringUtil.normalizeNull(request.getParameter("dtl_seq" + (i+1))) == ""){
						commonDAO.update(svVO, "custDAO.updateOperateServer");
					}
				}
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq1()))) {
			OperateVO delVO1 = new OperateVO();
			String[] arr = vo.getDel_dtl_seq1().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO1.setOper_seq(vo.getOper_seq());
				delVO1.setDtl_seq(arr[i]);
				delVO1.setPageType("DELETE");
				commonDAO.update(delVO1, "custDAO.deleteOperateServer");
			}
		}
		
		
		/**	참여인력 정보 입력	*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getWk_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getWk_cnt()) ; i++) {
				OperateVO wkVO = new OperateVO() ;
				
				wkVO.setOper_seq(vo.getOper_seq());
				wkVO.setWk_seq(SsStringUtil.normalizeNull(request.getParameter("wk_seq" + (i+1))));	
				wkVO.setTask_code(SsStringUtil.normalizeNull(request.getParameter("task_code" + (i+1))));
				wkVO.setWk_emp_no(SsStringUtil.normalizeNull(request.getParameter("wk_emp_no" + (i+1))));
				
				if("1".equals(SsStringUtil.normalizeNull(request.getParameter("master_yn" + (i+1)))) ) {
					wkVO.setMaster_yn("Y");
				}else {
					wkVO.setMaster_yn("");
				}
				wkVO.setIs_use(SsStringUtil.normalizeNull(request.getParameter("is_use" + (i+1))));
				
				wkVO.setWk_hp_no(SsStringUtil.normalizeNull(request.getParameter("wk_hp_no" + (i+1))));
				wkVO.setWk_email(SsStringUtil.normalizeNull(request.getParameter("wk_email" + (i+1))));
				wkVO.setWk_etc(SsStringUtil.normalizeNull(request.getParameter("wk_etc" + (i+1))));
				wkVO.setReg_id(vo.getReg_id());
				/*직원 id 유무 체크*/
				if( !"".equals(SsStringUtil.normalizeNull(wkVO.getWk_emp_no()))){
					commonDAO.update(wkVO, "custDAO.updateOperateWorker");
				}
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq2()))) {
			OperateVO delVO2 = new OperateVO();
			String[] arr = vo.getDel_dtl_seq2().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO2.setOper_seq(vo.getOper_seq());
				delVO2.setWk_seq(arr[i]);
				delVO2.setPageType("DELETE");
				commonDAO.update(delVO2, "custDAO.deleteOperateWorker");
			}
		}
		
		
		/*담당자정보*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getCg_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getCg_cnt()) ; i++) {
				OperateVO chVO = new OperateVO() ;
				
				chVO.setOper_seq(vo.getOper_seq());
				chVO.setCh_seq(SsStringUtil.normalizeNull(request.getParameter("ch_seq" + (i+1))));	
				chVO.setCharge_code(SsStringUtil.normalizeNull(request.getParameter("charge_code" + (i+1))));
				chVO.setCharge_nm(SsStringUtil.normalizeNull(request.getParameter("charge_nm" + (i+1))));
				chVO.setCompany_tel_no(SsStringUtil.normalizeNull(request.getParameter("company_tel_no" + (i+1))));
				chVO.setHp_no(SsStringUtil.normalizeNull(request.getParameter("hp_no" + (i+1))));
				chVO.setEmail(SsStringUtil.normalizeNull(request.getParameter("email" + (i+1))));
				chVO.setCh_etc(SsStringUtil.normalizeNull(request.getParameter("ch_etc" + (i+1))));
				chVO.setCompany_nm(SsStringUtil.normalizeNull(request.getParameter("company_nm" + (i+1))));
				chVO.setReg_id(vo.getReg_id());
				commonDAO.update(chVO, "custDAO.updateOperateCharge");
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq3()))) {
			OperateVO delVO3 = new OperateVO();
			String[] arr = vo.getDel_dtl_seq3().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO3.setOper_seq(vo.getOper_seq());
				delVO3.setCh_seq(arr[i]);
				delVO3.setPageType("DELETE");
				commonDAO.update(delVO3, "custDAO.deleteOperateCharge");
			}
		}
		
		
		
		/*관리비고정보*/
		if(!"".equals(SsStringUtil.normalizeNull(vo.getNt_cnt()))) {
			for(int i = 0 ; i < Integer.parseInt(vo.getNt_cnt()) ; i++) {
				OperateVO ntVO = new OperateVO() ;
				
				ntVO.setOper_seq(vo.getOper_seq());
				ntVO.setNt_seq(SsStringUtil.normalizeNull(request.getParameter("nt_seq" + (i+1))));	
				ntVO.setNote_code(SsStringUtil.normalizeNull(request.getParameter("note_code" + (i+1))));
				ntVO.setContent(SsStringUtil.normalizeNull(request.getParameter("content" + (i+1))));
				ntVO.setReg_id(vo.getReg_id());
				commonDAO.update(ntVO, "custDAO.updateOperateNote");
			}
			
		}
		
		if (!"".equals(SsStringUtil.normalizeNull(vo.getDel_dtl_seq4()))) {
			OperateVO delVO4 = new OperateVO();
			String[] arr = vo.getDel_dtl_seq4().split("@");
			
			for (int i=0; i<arr.length; i++) {
				delVO4.setOper_seq(vo.getOper_seq());
				delVO4.setNt_seq(arr[i]);
				delVO4.setPageType("DELETE");
				commonDAO.update(delVO4, "custDAO.deleteOperateNote");
			}
		}
		
		
			
		/* 관리정보 삭제 */
		if ("delete".equals(vo.getPageType())) {
			vo.setPageType("DELETEALL");
			commonDAO.update(vo, "custDAO.updateInfo");
		}
		
		return returnValue;
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
	
	
	/*서버정보 업데이트*/
	@Override
	public int updateServer(ServerVO vo , HttpServletRequest request) throws Exception {
		
		int returnValue = 0;
		
		if ("insert".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.insertServer");
		}else if("update".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.updateServer");
		}
		
		return returnValue;
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
	@SuppressWarnings("unchecked")
	public Map<String , Object> getDocInfo(CustVO vo, String query) throws Exception {
		
		Map<String , Object> returnMap = new HashMap<String , Object>() ;
		List<CustVO> resultList = (List<CustVO>)commonDAO.list(vo, query);
		returnMap.put("resultList", resultList) ; 
		return returnMap ; 
	}

	@Override
	public int getServerListCnt(ServerVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo,queryName);
	}
	
	@Override
	public int getDbListCnt(DbVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo,queryName);
	}
	
	
	@Override
	public int getAppListCnt(AppVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo,queryName);
	}

	
	@Override
	public int getServiceListCnt(ServiceVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo,queryName);
	}

	

	@Override
	public int getNetworkListCnt(NetworkVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo,queryName);
	}

	

	@Override
	public int getSelectNetworkInt(CustVO vo, String queryName) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	
	@Override
	public Map<String, Object> getServerInfo(ServerVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getServerInfo"));
		
		return returnMap;
	}
	
	@Override
	public Map<String, Object> getServerInfo2(ServerVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getServerInfo2"));
		
		return returnMap;
	}
	
	
	@Override
	public Map<String, Object> getDbInfo(DbVO vo) throws Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getDbInfo"));
		
		return returnMap;
	}
	
	
	@Override
	public Map<String, Object> getAppInfo(AppVO vo) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getAppInfo"));
		
		return returnMap;
	}
	
	
	@Override
	public Map<String, Object> getServiceInfo(ServiceVO vo) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getServiceInfo"));
		
		return returnMap;
	}
	
	

	@Override
	public Map<String, Object> getNetworkInfo(NetworkVO vo) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getNetworkInfo"));
		returnMap.put("charge", commonDAO.list(vo, "custDAO.selectNetChargeList"));
		returnMap.put("hist", commonDAO.list(vo, "custDAO.selectNetHistList"));
		
		return returnMap;
	}
	
	
	@Override
	public Map<String, Object> getProjectInfo(ProjectVO vo) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getProjectInfo"));
		returnMap.put("charge", commonDAO.list(vo, "custDAO.selectProjectChargeList"));
		returnMap.put("worker", commonDAO.list(vo, "custDAO.selectProjectWorkerList"));
		returnMap.put("server", commonDAO.list(vo, "custDAO.selectProjectServerList"));
		
		return returnMap;
	}
	
	
	@Override
	public Map<String, Object> getOperateInfo(OperateVO vo) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("info", commonDAO.selectOne(vo, "custDAO.getOperateInfo"));
		returnMap.put("charge", commonDAO.list(vo, "custDAO.selectOperateChargeList"));
		returnMap.put("worker", commonDAO.list(vo, "custDAO.selectOperateWorkerList"));
		returnMap.put("server", commonDAO.list(vo, "custDAO.selectOperateServerList"));
		returnMap.put("note", commonDAO.list(vo, "custDAO.selectOperateNoteList"));
		
		return returnMap;
	}
	
	
	

	@Override
	public OperateVO getOperatInfoOne(OperateVO vo) throws Exception {
		return (OperateVO) commonDAO.selectOne(vo, "custDAO.getOperateInfo");
	}
	
	
	@Override
	public int updateDb(DbVO vo, HttpServletRequest request) throws Exception {
		
		int returnValue = 0;
		
		if ("insert".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.insertDb");
		}else if("update".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.updateDb");
		}else if("delete".equals(vo.getPageType())) {
			
			String[] delArr = vo.getDel_db_seq().split("@");
			for (int i=0; i<delArr.length; i++) {
				vo.setSeq(delArr[i]);
				returnValue = commonDAO.update(vo, "custDAO.deleteDb");	
			}
			
		}
		
		return returnValue;
	}

	@Override
	public int updateApp(AppVO vo, HttpServletRequest request) throws Exception {
		
		int returnValue = 0;
		
		if ("insert".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.insertApp");
		}else if("update".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.updateApp");
		}else if("delete".equals(vo.getPageType())) {
			
			String[] delArr = vo.getDel_app_seq().split("@");
			for (int i=0; i<delArr.length; i++) {
				vo.setSeq(delArr[i]);
				returnValue = commonDAO.update(vo, "custDAO.deleteApp");	
			}
			
		}
		
		return returnValue;
	}
	
	
	@Override
	public int updateService(ServiceVO vo, HttpServletRequest request) throws Exception {
		
		int returnValue = 0;
		
		if ("insert".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.insertService");
		}else if("update".equals(vo.getPageType())) {
			returnValue = commonDAO.update(vo, "custDAO.updateService");
		}else if("delete".equals(vo.getPageType())) {
			
			String[] delArr = vo.getDel_service_seq().split("@");
			for (int i=0; i<delArr.length; i++) {
				vo.setSeq(delArr[i]);
				returnValue = commonDAO.update(vo, "custDAO.deleteService");	
			}
			
		}
		
		return returnValue;
	}

	@Override
	public int delOperateProc(OperateVO vo) throws Exception  {
		int returnValue = 0;
		int val = 0;
		
		/*유효성 체크 - AS가 있는 경우 삭제 불가(oper seq를 return한다)*/
		String[] delArr = vo.getDel_dtl_seq().split("@");
		for (int i=0; i<delArr.length; i++) {
			vo.setOper_seq(delArr[i]);
			val = commonDAO.selectOneInt(vo, "custDAO.checkOperdel");
			if( val > 0 ) {return returnValue = Integer.parseInt(delArr[i]);}
		}
		
		for (int i=0; i<delArr.length; i++) {
			vo.setOper_seq(delArr[i]);
			returnValue = commonDAO.update(vo, "custDAO.delOperateProc");
		}
		
		return returnValue;
	}

	
	@Override
	public int getRetireListCnt(RetireVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, "custDAO.getRetireListCnt");
	}

	@Override
	public int getRetireInitCnt(RetireVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, "custDAO.getRetireInitCnt");
	} 
	
	@Override
	public int getRetireCheckCnt(RetireVO vo, String queryName) throws Exception {
		return commonDAO.selectOneInt(vo, "custDAO.getRetireCheckCnt");
	}
	
	/*퇴사자 관리 리스트  */
	@SuppressWarnings("unchecked")
	@Override
	public List<RetireVO> getRetireList(RetireVO vo, String queryName) throws Exception {
		return (List<RetireVO>) commonDAO.list(vo, "custDAO.getRetireList");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<RetireVO> getRetireExl(RetireVO vo, String queryName) throws Exception {
		return (List<RetireVO>) commonDAO.list(vo, "custDAO.getRetireExl");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<RetireVO> getRetireInit(RetireVO vo, String queryName) throws Exception {
		return (List<RetireVO>) commonDAO.list(vo, "custDAO.getRetireInit");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<RetireVO> getRetireCheck(RetireVO vo, String queryName) throws Exception {
		return (List<RetireVO>) commonDAO.list(vo, "custDAO.getRetireCheck");
	} 

	@Override
	public RetireVO getSelectOne(RetireVO vo, String queryName) throws Exception {
		return (RetireVO) commonDAO.selectOne(vo, queryName);
	}

	@Override
	public int updateRetire(RetireVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0;
		
		returnValue = commonDAO.update(vo, "custDAO.mergeRetire");
		
		return returnValue;
	}




	

	

	

	
	

	

	
	
	



}
