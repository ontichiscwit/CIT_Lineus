package egovframework.com.model;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("stat2HeaderVO")
public class Stat2HeaderVO implements Serializable {

	private static final long serialVersionUID = 1408851094140590961L;
	
	private String label;
	private String fieldName;
	private String dType;
	private String ref;
	
	public Stat2HeaderVO(){}
	
	
	public Stat2HeaderVO(String label, String fieldName, String dType, String ref) {
		super();
		this.label = label;
		this.fieldName = fieldName;
		this.dType = dType;
		this.ref = ref;
	}


	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getFieldName() {
		return fieldName;
	}
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	public String getdType() {
		return dType;
	}

	public void setdType(String dType) {
		this.dType = dType;
	}

	public String getRef() {
		return ref;
	}

	public void setRef(String ref) {
		this.ref = ref;
	}

	@Override
	public String toString() {
		return "Stat2HeaderVO [label=" + label + ", fieldName=" + fieldName + ", dType=" + dType + ", ref=" + ref + "]";
	}
	
	
	
}
