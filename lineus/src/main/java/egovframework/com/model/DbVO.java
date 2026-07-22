package egovframework.com.model;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import egovframework.com.comm.model.PagingVO;

@Alias("dbVO")
public class DbVO extends PagingVO implements Serializable {
	private static final long serialVersionUID = 5383192200927382485L;
	/*DB관리*/
	private String seq               ="";
	private String server_seq        ="";
	private String db_name           ="";
	private String dbms_type         ="";
	private String dbms_version      ="";
	private String db_host           ="";
	private String db_port           ="";
	private String db_sid            ="";
	private String service_name      ="";
	private String db_user_name      ="";
	private String db_user_pass      ="";
	private String db_link           ="";
	private String archive_mode      ="";
	private String backup            ="";
	private String backup_dt         ="";
	private String db_etc            ="";
	private String reg_id            ="";
	private String reg_date	         ="";
	private String	upd_id              = "";
	private String	upd_date            = "";
	private String	dbms_type_nm ="";
	private String	dbms_version_nm ="";
	private String	archive_mode_nm ="";
	private String  del_db_seq ="";
	
	
	
	
	
	
	public String getDel_db_seq() {
		return del_db_seq;
	}
	public void setDel_db_seq(String del_db_seq) {
		this.del_db_seq = del_db_seq;
	}
	public String getDbms_type_nm() {
		return dbms_type_nm;
	}
	public void setDbms_type_nm(String dbms_type_nm) {
		this.dbms_type_nm = dbms_type_nm;
	}
	public String getDbms_version_nm() {
		return dbms_version_nm;
	}
	public void setDbms_version_nm(String dbms_version_nm) {
		this.dbms_version_nm = dbms_version_nm;
	}
	public String getArchive_mode_nm() {
		return archive_mode_nm;
	}
	public void setArchive_mode_nm(String archive_mode_nm) {
		this.archive_mode_nm = archive_mode_nm;
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
	public String getDb_name() {
		return db_name;
	}
	public void setDb_name(String db_name) {
		this.db_name = db_name;
	}
	public String getDbms_type() {
		return dbms_type;
	}
	public void setDbms_type(String dbms_type) {
		this.dbms_type = dbms_type;
	}
	public String getDbms_version() {
		return dbms_version;
	}
	public void setDbms_version(String dbms_version) {
		this.dbms_version = dbms_version;
	}
	public String getDb_host() {
		return db_host;
	}
	public void setDb_host(String db_host) {
		this.db_host = db_host;
	}
	public String getDb_port() {
		return db_port;
	}
	public void setDb_port(String db_port) {
		this.db_port = db_port;
	}
	public String getDb_sid() {
		return db_sid;
	}
	public void setDb_sid(String db_sid) {
		this.db_sid = db_sid;
	}
	public String getService_name() {
		return service_name;
	}
	public void setService_name(String service_name) {
		this.service_name = service_name;
	}
	public String getDb_user_name() {
		return db_user_name;
	}
	public void setDb_user_name(String db_user_name) {
		this.db_user_name = db_user_name;
	}
	public String getDb_user_pass() {
		return db_user_pass;
	}
	public void setDb_user_pass(String db_user_pass) {
		this.db_user_pass = db_user_pass;
	}
	public String getDb_link() {
		return db_link;
	}
	public void setDb_link(String db_link) {
		this.db_link = db_link;
	}
	public String getArchive_mode() {
		return archive_mode;
	}
	public void setArchive_mode(String archive_mode) {
		this.archive_mode = archive_mode;
	}
	public String getBackup() {
		return backup;
	}
	public void setBackup(String backup) {
		this.backup = backup;
	}
	public String getBackup_dt() {
		return backup_dt;
	}
	public void setBackup_dt(String backup_dt) {
		this.backup_dt = backup_dt;
	}
	public String getDb_etc() {
		return db_etc;
	}
	public void setDb_etc(String db_etc) {
		this.db_etc = db_etc;
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
