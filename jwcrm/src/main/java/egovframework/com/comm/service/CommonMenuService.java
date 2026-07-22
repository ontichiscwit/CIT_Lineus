package egovframework.com.comm.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.comm.model.MenuVO;

public interface CommonMenuService {
	public List<MenuVO> selectAuthMenuList(MenuVO vo) throws Exception;
	public List<MenuVO> getMenuList(MenuVO vo) throws Exception;
	public List<MenuVO> getAuthListAll(MenuVO vo) throws Exception;
	public MenuVO getTnList(MenuVO vo) throws Exception;
	
	public int registMenuAuth(MenuVO vo , HttpServletRequest request) throws Exception;
}
