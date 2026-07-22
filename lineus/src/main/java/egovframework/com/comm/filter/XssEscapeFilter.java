package egovframework.com.comm.filter;

import org.apache.commons.lang3.StringUtils;

public final class XssEscapeFilter {
	
	private static XssEscapeFilter xssEscapeFilter ; 
	private static XssEscapeFilterConfig config ; 
	
	static{
		try{
			xssEscapeFilter = new XssEscapeFilter() ; 
		}catch(Exception e){
			throw new ExceptionInInitializerError(e) ; 
		}
	}
	
	private XssEscapeFilter(){
		config = new XssEscapeFilterConfig() ; 
	}
	
	public static XssEscapeFilter getInstance() {
		return xssEscapeFilter;
	}
	
	public String doFilter(String url, String paramName, String value) {
		if (StringUtils.isBlank(value)) {
			return value;
		}

		XssEscapeFilterRule urlRule = config.getUrlParamRule(url, paramName);
		if (urlRule == null) {
			// Default defender 적용
			return config.getDefaultDefender().doFilter(value);
		} 

		if (!urlRule.isUseDefender()) {
			return value;
		}

		return urlRule.getDefender().doFilter(value);
	}


}
