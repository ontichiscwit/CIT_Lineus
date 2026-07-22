package egovframework.com.comm.filter;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public final class XssEscapeServletFilterWrapper extends HttpServletRequestWrapper {
	private XssEscapeFilter xssEscapeFilter;
	private String path = null;
	
	public XssEscapeServletFilterWrapper(ServletRequest request, XssEscapeFilter xssEscapeFilter) {
		super((HttpServletRequest)request);
		this.xssEscapeFilter = xssEscapeFilter;
		this.path = ((HttpServletRequest)request).getRequestURI();
	}
	
	@Override
	public String getParameter(String paramName) {
		String value = super.getParameter(paramName);
		
		return doFilter(paramName, value);
	}
	
	@Override
	public String[] getParameterValues(String paramName) {
		String values[] = super.getParameterValues(paramName);
		if (values == null) {
			return values;
		}
		for (int index = 0; index < values.length; index++) {
			values[index] = doFilter(paramName, values[index]);
		}
		return values;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getParameterMap() {
		Map<String, Object> paramMap = super.getParameterMap();
		Map<String, Object> newFilteredParamMap = new HashMap<String, Object>();

		Set<Map.Entry<String, Object>> entries = paramMap.entrySet();
		for (Map.Entry<String, Object> entry : entries) {
			String paramName = entry.getKey();
			Object[] valueObj = (Object[])entry.getValue();
			String[] filteredValue = new String[valueObj.length];
			for (int index = 0; index < valueObj.length; index++) {
				filteredValue[index] = doFilter(paramName, String.valueOf(valueObj[index]));
			}
			
			newFilteredParamMap.put(entry.getKey(), filteredValue);
		}

		return newFilteredParamMap;
	}
	
	private String doFilter(String paramName, String value) {
		
		/**	editor 사용 할 경우 parameter 이름을 content를 포함 시키면 필터링 되지 않게 설정. 	*/
		/**	비밀번호도 필터 사용 안함 	*/
		
		boolean isPass = false ; 
		
		if(paramName.indexOf("content") !=  -1) isPass  = true ;
		if(paramName.indexOf("pass") !=  -1) isPass  = true ;
		if(paramName.indexOf("matr_name") !=  -1) isPass  = true ;
		if(paramName.indexOf("mdl_name") !=  -1) isPass  = true ;
		
		if(isPass) return value ;
		else return xssEscapeFilter.doFilter(path, paramName, value);
	}


}
