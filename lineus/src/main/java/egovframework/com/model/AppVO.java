package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("appVO")
public class AppVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	/*app관리*/
	private String  seq               ="";
	private String  server_seq        ="";
	private String  app_name          ="";
	private String  app_type          ="";
	private String  lan_type          ="";
	private String  development_tool  ="";
	private String  management_tool   ="";
	private String  management_addr   ="";
	private String  site_addr         ="";
	private String  site_id           ="";
	private String  site_pass         ="";
	private String  app_etc    		  ="";
	private String  reg_id     		  ="";
	private String  reg_date	      ="";
	private String	upd_id              = "";
	private String	upd_date            = "";
	private String  del_app_seq			="";
	private String  app_type_nm          ="";
	private String  lan_type_nm          ="";
	
	
	public String getApp_type_nm() {
		return app_type_nm;
	}
	public void setApp_type_nm(String app_type_nm) {
		this.app_type_nm = app_type_nm;
	}
	public String getLan_type_nm() {
		return lan_type_nm;
	}
	public void setLan_type_nm(String lan_type_nm) {
		this.lan_type_nm = lan_type_nm;
	}
	public String getDel_app_seq() {
		return del_app_seq;
	}
	public void setDel_app_seq(String del_app_seq) {
		this.del_app_seq = del_app_seq;
	}
	public String getUpd_id() {
		return upd_id;
	}
	public void setUpd_id(String upd_id) {
		this.upd_id = upd_id;
	}
	public String getUpd_date() {
		return upd_date;
	}
	public void setUpd_date(String upd_date) {
		this.upd_date = upd_date;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	
	public String getServer_seq() {
		return server_seq;
	}
	public void setServer_seq(String server_seq) {
		this.server_seq = server_seq;
	}
	public String getApp_name() {
		return app_name;
	}
	public void setApp_name(String app_name) {
		this.app_name = app_name;
	}
	public String getApp_type() {
		return app_type;
	}
	public void setApp_type(String app_type) {
		this.app_type = app_type;
	}
	public String getLan_type() {
		return lan_type;
	}
	public void setLan_type(String lan_type) {
		this.lan_type = lan_type;
	}
	public String getDevelopment_tool() {
		return development_tool;
	}
	public void setDevelopment_tool(String development_tool) {
		this.development_tool = development_tool;
	}
	public String getManagement_tool() {
		return management_tool;
	}
	public void setManagement_tool(String management_tool) {
		this.management_tool = management_tool;
	}
	public String getManagement_addr() {
		return management_addr;
	}
	public void setManagement_addr(String management_addr) {
		this.management_addr = management_addr;
	}
	public String getSite_addr() {
		return site_addr;
	}
	public void setSite_addr(String site_addr) {
		this.site_addr = site_addr;
	}
	public String getSite_id() {
		return site_id;
	}
	public void setSite_id(String site_id) {
		this.site_id = site_id;
	}
	public String getSite_pass() {
		return site_pass;
	}
	public void setSite_pass(String site_pass) {
		this.site_pass = site_pass;
	}
	public String getApp_etc() {
		return app_etc;
	}
	public void setApp_etc(String app_etc) {
		this.app_etc = app_etc;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	
	
	
	
}
