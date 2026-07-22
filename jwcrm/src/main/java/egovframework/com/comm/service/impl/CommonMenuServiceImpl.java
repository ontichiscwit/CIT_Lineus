package egovframework.com.comm.service.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.dao.impl.CommonFileDaoImpl;
import egovframework.com.comm.model.MenuVO;
import egovframework.com.comm.service.CommonMenuService;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("commonMenuService")
public class CommonMenuServiceImpl extends EgovAbstractServiceImpl implements CommonMenuService{
	
	@Autowired CommonDao commonDAO ; 

	@Override
	@SuppressWarnings("unchecked")
	public List<MenuVO> selectAuthMenuList(MenuVO vo) throws Exception {
		return (List<MenuVO>) commonDAO.list(vo, "commonMenuDAO.selectAuthMenuList");
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<MenuVO> getMenuList(MenuVO vo) throws Exception {
		return (List<MenuVO>) commonDAO.list(vo, "commmonDAO.getMenuList");
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<MenuVO> getAuthListAll(MenuVO vo) throws Exception {
		return (List<MenuVO>) commonDAO.list(vo, "commonMenuDAO.getAuthListAll");
	}

	@Override
	public MenuVO getTnList(MenuVO vo) throws Exception {
		return (MenuVO) commonDAO.selectOne(vo, "commonMenuDAO.getTnList");
	}

	@Override
	public int registMenuAuth(MenuVO vo, HttpServletRequest request) throws Exception {
		
		int returnValue = 0 ; 
		
		String list_menu_code = SsStringUtil.normalizeNull(vo.getList_menu_code()).trim() ;
		String list_depth = SsStringUtil.normalizeNull(vo.getList_depth()).trim() ; 
		
		if(!"".equals(list_menu_code)){
			vo.setDel_menu_code(list_menu_code.split("@"));
			commonDAO.delete(vo, "commonMenuDAO.deleteMenuAuth") ; 
			
			String[] menu_code = list_menu_code.split("@") ; 
			String[] menu_depth = list_depth.split("@") ; 
			
			for(int i = 0 ; i < menu_code.length ; i++){
				
				MenuVO insertVO = new MenuVO() ; 
				
				String sel_yn = SsStringUtil.normalizeNull(request.getParameter("sel_yn_"+menu_code[i]+"_" + menu_depth[i])).trim() ;
				String reg_yn = SsStringUtil.normalizeNull(request.getParameter("reg_yn_"+menu_code[i]+"_" + menu_depth[i])).trim() ;
				String upd_yn = SsStringUtil.normalizeNull(request.getParameter("upd_yn_"+menu_code[i]+"_" + menu_depth[i])).trim() ;
				String del_yn = SsStringUtil.normalizeNull(request.getParameter("del_yn_"+menu_code[i]+"_" + menu_depth[i])).trim() ;
				
				if("".equals(sel_yn)) sel_yn = "N" ; 
				if("".equals(reg_yn)) reg_yn = "N" ; 
				if("".equals(upd_yn)) upd_yn = "N" ; 
				if("".equals(del_yn)) del_yn = "N" ; 
				
				
				insertVO.setMenu_code(menu_code[i]);
				insertVO.setUsr_grade(vo.getUsr_grade());
				insertVO.setSel_yn(sel_yn);
				insertVO.setReg_yn(reg_yn);
				insertVO.setUpd_yn(upd_yn);
				insertVO.setDel_yn(del_yn);
				insertVO.setReg_id(vo.getReg_id());
				
				returnValue += commonDAO.update(insertVO, "commonMenuDAO.insertMenuAuth") ;
				if("M008".equals(menu_code[i])){
					insertVO.setMenu_code("M004");
					returnValue += commonDAO.update(insertVO, "commonMenuDAO.insertMenuAuth") ;
				}
			}
		}
		
		if("".equals(SsStringUtil.normalizeNull(vo.getT_yn()))) vo.setT_yn("N");
		if("".equals(SsStringUtil.normalizeNull(vo.getN_yn()))) vo.setN_yn("N");
		
		returnValue += commonDAO.update(vo, "commonMenuDAO.updateSearchAuth") ; 
		
		
		return returnValue;
	} 
}
