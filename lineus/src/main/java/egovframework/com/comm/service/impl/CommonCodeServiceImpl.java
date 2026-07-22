package egovframework.com.comm.service.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.CommonCodeVO;
import egovframework.com.comm.service.CommonCodeService;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("commonCodeService")
public class CommonCodeServiceImpl extends EgovAbstractServiceImpl implements CommonCodeService{

	@Autowired CommonDao commonDAO ;

	@Override
	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getCodeList(CommonCodeVO vo) throws Exception {
		return (List<CommonCodeVO>)commonDAO.list(vo , "commmonDAO.getCodeList");
	}

	@Override
	public CommonCodeVO getCodeNm(CommonCodeVO vo) throws Exception {
		return (CommonCodeVO) commonDAO.selectOne(vo, "commmonDAO.getCodeNm");
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getList(CommonCodeVO vo, String query) throws Exception {
		return (List<CommonCodeVO>)commonDAO.list(vo , query);
	}

	@Override
	public int registCodeInfo(CommonCodeVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0 ;
		
		String group_addCnt = SsStringUtil.normalize(vo.getGroup_addCnt(), "0").trim() ;
		String code_addCnt = SsStringUtil.normalize(vo.getCode_addCnt(), "0").trim() ;
		String code_group = SsStringUtil.normalizeNull(vo.getCode_group()).trim() ; 
		String p_code = SsStringUtil.normalizeNull(request.getParameter("p_code")).trim() ;
			
		if(!"0".equals(group_addCnt)){
			int cnt = Integer.parseInt(group_addCnt) ; 
			for(int i = 1 ; i <= cnt ; i++){
				String list_code = SsStringUtil.normalizeNull(request.getParameter("p_code_" + i)).trim() ; 
				String list_code_grp_nm = SsStringUtil.normalizeNull(request.getParameter("p_code_name_" + i)).trim() ; 
				String list_use_yn = SsStringUtil.normalizeNull(request.getParameter("use_yn_" + i)).trim() ;
				if("on".equals(list_use_yn)){
					list_use_yn = "Y";
				} else {
					list_use_yn = "N";
				}
				
				if(!"".equals(code_group)){
					if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("p_code_" + i)))) {
						CommonCodeVO temp = new CommonCodeVO() ;
						temp.setCode_group(code_group);
						temp.setP_code(list_code);
						temp.setP_code_name(list_code_grp_nm);
						temp.setUse_yn(list_use_yn);
						temp.setReg_id(vo.getReg_id());
						
						returnValue += commonDAO.update(temp, "commmonDAO.updateCodeMasterMerge") ;
					}
				}
			}
		}
		
		if(!"0".equals(code_addCnt)){
			int cnt = Integer.parseInt(code_addCnt) ; 
			for(int i = 1 ; i <= cnt ; i++){
				String list_code = SsStringUtil.normalizeNull(request.getParameter("code_" + i)).trim() ; 
				String list_code_nm = SsStringUtil.normalizeNull(request.getParameter("code_name_" + i)).trim() ; 
				String list_use_yn = SsStringUtil.normalizeNull(request.getParameter("use_yn_dtl_"+ i)).trim() ;
				String val1 = SsStringUtil.normalizeNull(request.getParameter("val1_"+ i)).trim() ;
				String val2 = SsStringUtil.normalizeNull(request.getParameter("val2_"+ i)).trim() ;
				String val3 = SsStringUtil.normalizeNull(request.getParameter("val3_"+ i)).trim() ;
				String val4 = SsStringUtil.normalizeNull(request.getParameter("val4_"+ i)).trim() ;
				String val5 = SsStringUtil.normalizeNull(request.getParameter("val5_"+ i)).trim() ;
				String val6 = SsStringUtil.normalizeNull(request.getParameter("val6_"+ i)).trim() ;
				String val7 = SsStringUtil.normalizeNull(request.getParameter("val7_"+ i)).trim() ;
				String val8 = SsStringUtil.normalizeNull(request.getParameter("val8_"+ i)).trim() ;
				String val9 = SsStringUtil.normalizeNull(request.getParameter("val9_"+ i)).trim() ;
				String val10 = SsStringUtil.normalizeNull(request.getParameter("val10_"+ i)).trim() ;
				String sort_ord = SsStringUtil.normalizeNull(request.getParameter("sort_ord_"+ i)).trim() ;
				if("on".equals(list_use_yn)){
					list_use_yn = "Y";
				} else {
					list_use_yn = "N";
				}
				if(!"".equals(code_group) && !"".equals(p_code)){
					if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("code_" + i)))) {
						CommonCodeVO temp = new CommonCodeVO() ;
						temp.setCode_group(code_group);
						temp.setP_code(p_code);
						temp.setCode(list_code);
						temp.setCode_name(list_code_nm);
						temp.setUse_yn(list_use_yn);
						temp.setReg_id(vo.getReg_id());
						temp.setVal1(val1);
						temp.setVal2(val2);
						temp.setVal3(val3);
						temp.setVal4(val4);
						temp.setVal5(val5);
						temp.setVal6(val6);
						temp.setVal7(val7);
						temp.setVal8(val8);
						temp.setVal9(val9);
						temp.setVal10(val10);
						temp.setSort_ord(sort_ord);
						returnValue += commonDAO.update(temp, "commmonDAO.updateCodeDetailMerge") ;
					}
				}
			}
		}
		
		return returnValue;
	}
	
	@Override
	public int deleteCodeInfo(CommonCodeVO vo, HttpServletRequest request) throws Exception {
		int returnValue = 0 ;
		String code_group = SsStringUtil.normalizeNull(vo.getCode_group()).trim() ; 
		String p_code = SsStringUtil.normalizeNull(request.getParameter("p_code")).trim() ;
		String del_p_code = SsStringUtil.normalizeNull(vo.getDel_p_code()).trim() ; 
		String del_code = SsStringUtil.normalizeNull(vo.getDel_code()).trim() ; 
		
		if (!"".equals(code_group) && !"".equals(del_p_code)) {
			String[] del_p_code_arr = del_p_code.split("@");
			if(del_p_code_arr != null && del_p_code_arr.length > 0){
				for(int i = 0 ; i < del_p_code_arr.length; i++){
					CommonCodeVO temp = new CommonCodeVO() ;
					temp.setCode_group(code_group);
					temp.setP_code(del_p_code_arr[i]);
					returnValue += commonDAO.delete(temp, "commmonDAO.deleteCodeMaster");
					returnValue += commonDAO.delete(temp, "commmonDAO.deleteCodeDetailAll") ; 
				}
			}
		}
		
		if (!"".equals(code_group) && !"".equals(p_code)) {
			if(!"".equals(del_code)){
				String[] del_code_arr = del_code.split("@");
				if(del_code_arr != null && del_code_arr.length > 0){
					for(String cd : del_code_arr){
						CommonCodeVO temp = new CommonCodeVO() ;
						temp.setCode_group(code_group);
						temp.setP_code(p_code);
						temp.setCode(cd);
						returnValue += commonDAO.delete(temp, "commmonDAO.deleteCodeDetail") ;
					}
				}
			}
		}
		return returnValue;
	
	}

}
