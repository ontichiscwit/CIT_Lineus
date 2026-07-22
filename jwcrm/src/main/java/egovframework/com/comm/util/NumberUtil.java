package egovframework.com.comm.util;

public class NumberUtil implements java.io.Serializable {
	
	public static int parseInt(String src){
		return parseInt(src, -1);
	}
	
	
	public static int parseInt(String src, int dft){
		int result = dft;
		
		try{
			result = Integer.parseInt(src);
		}catch(Exception e){
			result = dft;
		}
		
		return result;
	}
	
	
	public static long parseLong(String src){
		return parseLong(src, -1l);
	}
	
	
	public static long parseLong(String src, long dft){
		long result = dft;
		
		try{
			result = Long.parseLong(src);
		}catch(Exception e){
			result = dft;
		}
		
		return result;
	}
	
	
	public static double parseDouble(String src){
		return parseDouble(src, -1l);
	}
	
	
	public static double parseDouble(String src, double dft){
		double result = dft;
		
		try{
			result = Double.parseDouble(src);
		}catch(Exception e){
			result = dft;
		}
		
		return result;
	}
	
	public static int round(float a){
		return Math.round(a);
	}

	public static long round(double a){
		return Math.round(a);
	}
	
	public static int max(int a, int b){
		return Math.max(a,b);
	}
	public static long max(long a, long b){
		return Math.max(a,b);
	}
	
	public static float max(float a,float b){
		return Math.max(a,b);
	}
	
	public static double max(double a,double b){
		return Math.max(a,b);
	}

	public static int min(int a, int b){
		return Math.max(a,b);
	}
	public static long min(long a, long b){
		return Math.max(a,b);
	}
	
	public static float min(float a,float b){
		return Math.max(a,b);
	}
	
	public static double min(double a,double b){
		return Math.max(a,b);
	}

}
