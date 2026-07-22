package egovframework.com.comm;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;

import egovframework.com.comm.model.Code2VO;

public class TreeCode extends Code2VO{
	
	private static final long serialVersionUID = 948806025451802507L;
	
	private int level;
	private String naviName;
	private List<TreeCode> childTree;
	private boolean reOrder = true;
	
	protected TreeCode(Code2VO menu, int level, String pName, int ordNo){
		
		if (ordNo < 0) reOrder = false;
		else reOrder = true;
		
		try {
			BeanUtils.copyProperties(this, menu);
			this.level = level;
			if (reOrder) setOrd_no(ordNo);
			this.naviName = "".equals(pName) ? this.getCode_nm() : pName + ">" + this.getCode_nm();
			
			childTree = new ArrayList<TreeCode>();
			
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public void setData(List<Code2VO> dataList){
		int ordNo = 0;
		for (Code2VO obj: dataList){
			if (obj.getP_code().equals(this.getCode())){
				TreeCode treeMenu = new TreeCode(obj, this.level+1, naviName, reOrder ? ordNo : -1);
				treeMenu.setData(dataList);
				this.childTree.add(treeMenu);
				
				ordNo++;
			}
		}
	}
	
	public void setOrderList(ArrayList<TreeCode> list){
		for (TreeCode data : childTree){
			list.add(data);
			data.setOrderList(list);
		}
	}
	
	public List<TreeCode> getChildTree(){
		return this.childTree;
	}
	
	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public String getNaviName() {
		return naviName;
	}

	public void setNaviName(String naviName) {
		this.naviName = naviName;
	}
}
