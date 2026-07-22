package egovframework.com.comm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import egovframework.com.comm.dao.CommonDao;
import egovframework.com.comm.model.Code2VO;
import egovframework.com.comm.util.SsStringUtil;


public class TreeCodeManager {
	
	private static final Logger logger = LoggerFactory.getLogger(TreeCodeManager.class) ;
	
	public static final String TOP_PCODE = "ROOT";
	public static final String DEFAULT_CODE_TYPE = "C";
	
	@Autowired
	CommonDao commonDAO;
	
	private ArrayList<TreeCode> rootCodeList;
	private ArrayList<TreeCode> orderedCodeList;
	
	public TreeCodeManager(){
	}
	
	public List<TreeCode> getChildCodeList(String code){
		
		logger.debug("getChildCodeList call !!");
		
		if (orderedCodeList == null) init();
		
		if (code == null || "".equals(code.trim())) code = TOP_PCODE;
		
		if (TOP_PCODE.equals(code)) return rootCodeList;
		
		for (TreeCode treeCode : orderedCodeList){
			if (code.equals(treeCode.getCode())){
				return treeCode.getChildTree();
			}
		}
		
		return new ArrayList<TreeCode>();
	}
	
	public List<TreeCode> getRootCodeList(){
		if (orderedCodeList == null) init();
		return rootCodeList;
	}
	
	public int updateCode(Code2VO code) throws Exception{
		
		int reValue = commonDAO.update(code, "commmonDAO.updateCode2");
		init();
		
		return reValue;
	}
	
	public int deleteCode(Code2VO code) throws Exception{
		
		TreeCode chkCode = getTreeCode(code.getCode());
		
		if (!chkCode.getChildTree().isEmpty()) return -1;
		
		int reValue = commonDAO.delete(chkCode, "commmonDAO.deleteCode2");
		init();
		
		return reValue;
	}
	
	private TreeCode getTreeCode(String code) {
		
		for (TreeCode treeCode : orderedCodeList){
			if (treeCode.getCode().equals(code)) return treeCode;
		}
		
		return null;
	}

	public int insertCode(Code2VO code) throws Exception{
		if (orderedCodeList == null) init();
		
		if (code.getP_code() == null) code.setP_code(TOP_PCODE);
		if (code.getCode_type() == null) code.setCode_type(DEFAULT_CODE_TYPE);
		if (code.getUse_yn() == null) code.setUse_yn("Y");
		
		List<TreeCode> childList = null;
		if (TOP_PCODE.equals(code.getP_code())){
			childList = getRootCodeList();
		}else{
			
			// 최상위가 아니면서 P_code가 code에등록되어 있지 않으면 등록불가
			if (!hasCode(code.getP_code())) return -1;
			
			childList = getChildCodeList(code.getP_code());
		}
		
		int maxCode = -1;
		int maxOrd = -1;
		int chkNum = -1;
		for (TreeCode obj : childList){
			if (TOP_PCODE.equals(code.getP_code())){
				chkNum = Integer.valueOf(obj.getCode().replaceAll(code.getCode_type(), ""));
			}else{
				chkNum = Integer.valueOf(obj.getCode().replaceAll(code.getP_code(), ""));
			}
			
			if (chkNum > maxCode) maxCode = chkNum;
			if (obj.getOrd_no() > maxOrd) maxOrd = obj.getOrd_no();
		}
		
		maxCode++;
		maxOrd++;
		code.setOrd_no(maxOrd);
		
		String newCode = String.format("%02d", maxCode);
		
		if (TOP_PCODE.equals(code.getP_code())){
			newCode = code.getCode_type() + newCode;
		}else{
			newCode = code.getP_code() + newCode;
		}
		
		code.setCode(newCode);
		
		int reValue = -1;
		reValue = commonDAO.insert(code, "commmonDAO.insertCode2");
		
		init();
		
		return reValue;
	}
	
	private boolean hasCode(String pCode) {
		for (TreeCode obj: orderedCodeList){
			if (pCode.equals(obj.getCode())) return true;
		}
		return false;
	}

	@SuppressWarnings("unchecked")
	private synchronized void init(){
		
		logger.debug("init call !!");
		
		try{
			Code2VO param = new Code2VO();
			List<Code2VO> dataList = (List<Code2VO>) commonDAO.list(param, "commmonDAO.selectCode2");
			
			rootCodeList = new ArrayList<TreeCode>();
			int ordNo = 0;
			for (Code2VO data : dataList){
				if (TOP_PCODE.equals(data.getP_code())){
					TreeCode treeCode = new TreeCode(data, 0, "",ordNo);
					treeCode.setData(dataList);
					rootCodeList.add(treeCode);
					if (ordNo > -1) ordNo++;
				}
			}
			
			orderedCodeList = new ArrayList<TreeCode>();
			for (TreeCode data : rootCodeList){
				orderedCodeList.add(data);
				data.setOrderList(orderedCodeList);
			}
			
			for (TreeCode data : orderedCodeList){
				logger.debug(">>>>> menuid["+data.getCode()+"] level[" + data.getLevel() + "] ordNo["+data.getOrd_no()+"] naviname : " + data.getNaviName());
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
//		try{doMig();}catch(Exception e){e.printStackTrace();}
	}
	
	private void doMig() throws Exception{
		
		// System.out.println("doMig call !!");
		
		// 공지번호 순으로 다시 따내기
		List<Map<String,String>> noticeNumList = (List<Map<String, String>>) commonDAO.list(null, "commmonDAO.getNoticeNum");
		
		
		HashMap<String,String> paramMap = null;
		for (Map<String,String> map : noticeNumList){
			
			// System.out.println("map.get('NOTICE_NUM')" + map.get("NOTICE_NUM"));
			paramMap = new HashMap<String, String>();
			
			paramMap.put("notice_num", map.get("NOTICE_NUM"));
			commonDAO.update(paramMap, "commmonDAO.setSeqByNoticeNum");
		}
		
		// 패스워드 암호화 하여 저장하기
//		List<Map<String,String>> passList = (List<Map<String, String>>) commonDAO.list(null, "commmonDAO.getUserPass");
//		
//		
//		paramMap = null;
//		for (Map<String,String> map : passList){
//			
//			// System.out.println("map.get('PASS_BACK')" + map.get("PASS_BACK"));
//			paramMap = new HashMap<String, String>();
//			
//			paramMap.put("seq", map.get("SEQ"));
//			paramMap.put("pass", SsStringUtil.encryptSHA256(map.get("PASS_BACK")));
//			commonDAO.update(paramMap, "commmonDAO.setUserPass");
//		}
	}

	public boolean orderUpdate(List<Code2VO> voList, String emp_no) throws Exception {
		Code2VO tmpVo = null;
		for (Code2VO code : voList){
			tmpVo = new Code2VO();
			tmpVo.setP_code(code.getP_code());
			tmpVo.setCode(code.getCode());
			tmpVo.setOrd_no(code.getOrd_no());
			tmpVo.setUp_id(emp_no);
			commonDAO.update(code, "commmonDAO.updateCode2");
		}
		
		init();
		
		return true;
	}
}