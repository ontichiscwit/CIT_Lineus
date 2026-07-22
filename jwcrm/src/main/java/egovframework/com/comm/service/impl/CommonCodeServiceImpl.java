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
		
		String del_p_code = SsStringUtil.normalizeNull(vo.getDel_p_code()).trim() ; 
		String del_code = SsStringUtil.normalizeNull(vo.getDel_code()).trim() ;
		String group_addCnt = SsStringUtil.normalize(vo.getGroup_addCnt(), "0").trim() ;
		String code_addCnt = SsStringUtil.normalize(vo.getCode_addCnt(), "0").trim() ;
		String code_group = SsStringUtil.normalizeNull(vo.getCode_group()).trim() ; 
		String p_code = SsStringUtil.normalizeNull(request.getParameter("p_code")).trim() ;
		
		if(!"".equals(del_p_code)){
			String[] code_group_arr = del_p_code.split("@") ;
			
			if(code_group_arr != null && code_group_arr.length > 0){
				for(String cg : code_group_arr){
					CommonCodeVO temp = new CommonCodeVO() ; 
					temp.setCode_group(cg);
					temp.setP_code(p_code);
					returnValue += commonDAO.delete(temp, "commmonDAO.deleteCodeMaster") ; 
					returnValue += commonDAO.delete(temp, "commmonDAO.deleteCodeDetailAll") ; 
				}
			}
		}
		
		if(!"".equals(code_group)){
			if(!"".equals(del_code)){
				String[] code = del_code.split("@") ; 
				if(code != null && code.length > 0){
					for(String cd : code){
						CommonCodeVO temp = new CommonCodeVO() ;
						temp.setCode_group(code_group);
						temp.setP_code(p_code);
						temp.setCode(cd);
						returnValue += commonDAO.delete(temp, "commmonDAO.deleteCodeDetail") ;
					}
				}
			}
		}
		
		if(!"0".equals(group_addCnt)){
			int cnt = Integer.parseInt(group_addCnt) ; 
			for(int i = 1 ; i <= cnt ; i++){
				CommonCodeVO temp = new CommonCodeVO() ;
				
				String list_code = SsStringUtil.normalizeNull(request.getParameter("p_code_" + i)).trim() ; 
				String list_code_grp_nm = SsStringUtil.normalizeNull(request.getParameter("p_code_name_" + i)).trim() ; 
				String list_use_yn = SsStringUtil.normalizeNull(request.getParameter("use_yn_" + i)).trim() ;
				
				if(!"".equals(code_group)){
					if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("p_code_" + i)))) {
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
				CommonCodeVO temp = new CommonCodeVO() ;
				
				String list_code = SsStringUtil.normalizeNull(request.getParameter("code_" + i)).trim() ; 
				String list_code_nm = SsStringUtil.normalizeNull(request.getParameter("code_name_" + i)).trim() ; 
				String list_use_yn = SsStringUtil.normalizeNull(request.getParameter("code_use_yn_"+ i)).trim() ;
				
				if(!"".equals(code_group)){
					if (!"".equals(SsStringUtil.normalizeNull(request.getParameter("code_" + i)))) {
						temp.setCode_group(code_group);
						temp.setP_code(p_code);
						temp.setCode(list_code);
						temp.setCode_name(list_code_nm);
						temp.setUse_yn(list_use_yn);
						temp.setReg_id(vo.getReg_id());
						
						returnValue += commonDAO.update(temp, "commmonDAO.updateCodeDetailMerge") ;
					}
				}
			}
		}
		
		return returnValue;
	}

}
