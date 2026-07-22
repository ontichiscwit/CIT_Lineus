package egovframework.com.comm.filter.defender;


public interface Defender {
	public abstract void init(String[] values) ; 
	public abstract String doFilter(String value) ; 
}
