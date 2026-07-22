package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("serviceVO")
public class ServiceVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	/*서버관리*/
	private String seq   ="";         
	private String server_seq ="";    
	private String service_name  ="";
	private String service_type  ="";
	private String service_ip    ="";
	private String service_route ="";
	private String service_id    ="";
	private String service_pass  ="";
	private String account_etc   ="";
	private String str_dt        ="";
	private String end_dt        ="";
	private String service_etc   ="";
	private String service_type_nm ="";
	private String del_service_seq ="";
	
	
	
	
	public String getDel_service_seq() {
		return del_service_seq;
	}
	public void setDel_service_seq(String del_service_seq) {
		this.del_service_seq = del_service_seq;
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
	public String getService_name() {
		return service_name;
	}
	public void setService_name(String service_name) {
		this.service_name = service_name;
	}
	public String getService_type() {
		return service_type;
	}
	public void setService_type(String service_type) {
		this.service_type = service_type;
	}
	public String getService_ip() {
		return service_ip;
	}
	public void setService_ip(String service_ip) {
		this.service_ip = service_ip;
	}
	public String getService_route() {
		return service_route;
	}
	public void setService_route(String service_route) {
		this.service_route = service_route;
	}
	public String getService_id() {
		return service_id;
	}
	public void setService_id(String service_id) {
		this.service_id = service_id;
	}
	public String getService_pass() {
		return service_pass;
	}
	public void setService_pass(String service_pass) {
		this.service_pass = service_pass;
	}
	public String getAccount_etc() {
		return account_etc;
	}
	public void setAccount_etc(String account_etc) {
		this.account_etc = account_etc;
	}
	public String getStr_dt() {
		return str_dt;
	}
	public void setStr_dt(String str_dt) {
		this.str_dt = str_dt;
	}
	public String getEnd_dt() {
		return end_dt;
	}
	public void setEnd_dt(String end_dt) {
		this.end_dt = end_dt;
	}
	public String getService_etc() {
		return service_etc;
	}
	public void setService_etc(String service_etc) {
		this.service_etc = service_etc;
	}
	public String getService_type_nm() {
		return service_type_nm;
	}
	public void setService_type_nm(String service_type_nm) {
		this.service_type_nm = service_type_nm;
	}
	
	
	
	
	
	
}
