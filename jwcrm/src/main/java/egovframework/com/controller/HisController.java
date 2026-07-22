package egovframework.com.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.comm.TreeCode;
import egovframework.com.comm.TreeCodeManager;
import egovframework.com.comm.model.Code2VO;
import egovframework.com.comm.model.UserVO;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.BoardVO;
import egovframework.com.service.BoardService;
import egovframework.com.service.LoginService;

@Controller
public class HisController {
	
	@Autowired BoardService boardService ; 
	@Autowired LoginService loginService ;
	
	@Autowired TreeCodeManager treeCodeManager;
	
	@RequestMapping(value = "/his/login.do")
	@ResponseBody
	public String hisLogin(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		String crmCode = vo.getCrm_code();
		
		loginService.selectUserInfo(vo) ;
		List<UserVO> userList = vo.getOUTCURSOR() ; 
		
		if(userList != null && userList.size() > 0){
			UserVO userVO = userList.get(0) ; 
			if("N".equals(SsStringUtil.normalizeNull(userVO.getUse_yn()))){
				return "Error";
			} else {
				HttpSession session = request.getSession() ;
				userVO.setCrm_code(crmCode);
				session.setAttribute("HisUserInfo", userVO);
				/**	정상 처리	*/
				response.sendRedirect("/his/crmNotice.do");
				return "Success";
			}
		}else{
			return "Error";
		}
	}
	
	@RequestMapping(value = "/his/crmNotice.do")
	public String crmNotice(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("HisUserInfo");
		
		// vo를 이용해 로그인 체크
		if (vo == null || !"95320".equals(vo.getEmp_no())){
			response.setContentType("text/html;charset=utf-8");
			PrintWriter pw = null;
			try {
				pw = response.getWriter();
				pw.print("Fail");
				pw.flush();  
				pw.close();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (pw != null) pw.close();
			}
			return "ad/login/fail";
		}

		return "his/crmNotice";
	}
	
	@RequestMapping(value = "/his/getNotice.do")
	public void getCrmNotice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		HttpSession session = request.getSession() ;
		UserVO vo = (UserVO) session.getAttribute("HisUserInfo");
		
		// vo를 이용해 로그인 체크
		if (vo == null || !"95320".equals(vo.getEmp_no())){
			response.setContentType("text/html;charset=utf-8");
			PrintWriter pw = null;
			try {
				pw = response.getWriter();
				pw.print("Fail");
				pw.flush();  
				pw.close();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (pw != null) pw.close();
			}
			
			return;
		}
		
		
		BoardVO boardVO = new BoardVO();
		boardVO.setBoard_gbn("0000");
		boardVO.setCrmCode(vo.getCrm_code());

		List<BoardVO> boardList = boardService.getHisNoticeList(boardVO);
		
		
		String res_data = "" ; 
		try{
			ObjectMapper om = new ObjectMapper() ;
			res_data = om.writeValueAsString(boardList); 
		}catch(Exception e){
			e.printStackTrace();  
		}finally{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter pw = response.getWriter() ; 
			pw.print(res_data);
			pw.flush();  
			pw.close();
		}
		
	}
	
	
	@RequestMapping(value = "/his/exception.do")
	@ResponseBody
	public String hisTest(@ModelAttribute("vo") UserVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		if (true) throw new Exception("hihi");
		
		return "1";
	}
}
