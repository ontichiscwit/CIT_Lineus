package egovframework.com.comm.util;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.StringTokenizer;
/**
 * <B>StringUtil.java<B><br>
 * 
 * @author  정규창
 * @version V1.0    2012.02.01    정규창    신규작성 
 */
public class StringUtil implements java.io.Serializable{
	/**
	 *	스트링배열을 (,)로 구분된 하나의 스트링으로 변환시킴
	 *
	 *	@param	s	변환할 스트링배열
	 *	@return String		(,)구분자를 가지는 문자열
	 *
	 */
	public static String arrayToString(String[] s) {
		String str = new String();

		if (s != null) {
			for (int i=0; i < s.length; i++) {
				if (i != s.length - 1 )
					str += s[i] + ",";
				else
					str += s[i];
			}
		}
		return str;
	}

	/**
	 *	스트링배열을 'deli' 로 구분된 하나의 스트링으로 변환시킴
	 *
	 *	@param	s	변환할 스트링배열
	 **	@param	deli	구분자
	 *	@return String		구분자를 가지는 문자열
	 *
	 */
	public static String arrayToString(String[] s, String deli) {
		String str = new String();

		if (s != null) {
			for (int i=0; i < s.length; i++) {
				if (i != s.length - 1 )
					str += s[i] + deli;
				else
					str += s[i];
			}
		}
		return str;
	}

	public static String arrayToStringWithAmp(String[] s) {
		String str = new String();

		if (s != null) {
			for (int i=0; i < s.length; i++) {
				if (i != s.length - 1 )
					str += "'"+s[i] + "',";
				else
					str += "'"+s[i]+"'";
			}
		}
		return str;
	}

	public static String arrayListToStringWithAmp(ArrayList a) {
		String[] s = new String[a.size()];
		if (a != null) {
			for( int i = 0; i < a.size(); i++) {
				s[i] = (String) a.get(i);
			}
		}

		String str = new String();

		if (s != null) {
			for (int i=0; i < s.length; i++) {
				if (i != s.length - 1 )
					str += "'"+s[i] + "',";
				else
					str += "'"+s[i]+"'";
			}
		}
		return str;
	}


	public static String arrayListToString(ArrayList a) {
		String[] s = new String[a.size()];
		if (a != null) {
			for( int i = 0; i < a.size(); i++) {
				s[i] = (String) a.get(i);
			}
		}

		String str = new String();

		if (s != null) {
			for (int i=0; i < s.length; i++) {
				if (i != s.length - 1 )
					str += s[i] + ",";
				else
					str += s[i];
			}
		}
		return str;
	}

	/**
	 *	토큰으로 연결된 스트링을 스트링 배열로 변환
	 *
	 *	@param	s	변환할 스트링
	 *	@param	t	토큰
	 *	@return String[]	배열
	 *
	 */
	public static String[] stringToArray(String s, String t){
		if(isNull(s)) return null;

		StringTokenizer st = new StringTokenizer(s, t);
		int size = st.countTokens() ;
		if(size <= 0) return null;

		String[] result = new String[size];
		for(int i=0; i<size && st.hasMoreTokens(); i++){
			result[i] = st.nextToken();
		}
		return result;
	}

	/**
	 *	토큰으로 연결된 스트링을 스트링으로 변환
	 *
	 *	@param	s	변환할 스트링
	 *	@param	t	토큰
	 *	@return String  	배열
	 *
	 */
	public static String   stringToString(String s, String t){
		if(isNull(s)) return null;

		StringTokenizer st = new StringTokenizer(s, t);
		int size = st.countTokens() ;
		if(size <= 0) return null;

		String result = "";
		for(int i=0; i<size && st.hasMoreTokens(); i++){
			result += st.nextToken();
		}
		return result;
	}

	public static int ArrayLength(String[][] a){
		if(a == null) return 0;

		int aLen = a.length;

		if(aLen <= 0) aLen=0;

		return aLen;
	}

	public static String nullTo(String source, String replace)
	{
		if(source != null)
		{
			return source;
		}
		else
		{
			return replace;
		}
	}

	/**
	 * String.substring(int start, int end) 대체
	 * NullPointException 방지
	 */
	public static String substring(String src, int start, int end){
		if(src == null || "".equals(src) || start > src.length() || start > end || start < 0) return "";
		if(end > src.length()) end = src.length();

		return src.substring(start, end);
	}
	/**
	 * oracle lpad함수 구현
	 */
	 public static String lpad(String source, int n, String pad){
		if(source == null)
		{
			return null;
		}
		if(source.length() >= n){
			return source;
		}
		return pad.substring(0, n - source.length()) + source;
	}

     
    /**
     * <p>The maximum size to which the padding constant(s) can expand.</p>
     */
    private static final int PAD_LIMIT = 8192;

    /**
     * <p>An array of <code>String</code>s used for padding.</p>
     *
     * <p>Used for efficient space padding. The length of each String expands as needed.</p>
     */
    private static final String[] PADDING = new String[Character.MAX_VALUE + 1];
    static {
        // space padding is most common, start with 64 chars
        PADDING[32] = "                                                                ";
    }

    /**
     * <p>Returns padding using the specified delimiter repeated
     * to a given length.</p>
     *
     * <pre>
     * StringUtils.padding(0, 'e')  = ""
     * StringUtils.padding(3, 'e')  = "eee"
     * StringUtils.padding(-2, 'e') = IndexOutOfBoundsException
     * </pre>
     *
     * @param repeat  number of times to repeat delim
     * @param padChar  character to repeat
     * @return String with repeated character
     * @throws IndexOutOfBoundsException if <code>repeat &lt; 0</code>
     */
    private static String padding(int repeat, char padChar) {
        // be careful of synchronization in this method
        // we are assuming that get and set from an array index is atomic
        String pad = PADDING[padChar];
        if (pad == null) {
            pad = String.valueOf(padChar);
        }
        while (pad.length() < repeat) {
            pad = pad.concat(pad);
        }
        PADDING[padChar] = pad;
        return pad.substring(0, repeat);
    }

    /**
     * <p>Right pad a String with a specified character.</p>
     *
     * <p>The String is padded to the size of <code>size</code>.</p>
     *
     * <pre>
     * StringUtils.rightPad(null, *, *)     = null
     * StringUtils.rightPad("", 3, 'z')     = "zzz"
     * StringUtils.rightPad("bat", 3, 'z')  = "bat"
     * StringUtils.rightPad("bat", 5, 'z')  = "batzz"
     * StringUtils.rightPad("bat", 1, 'z')  = "bat"
     * StringUtils.rightPad("bat", -1, 'z') = "bat"
     * </pre>
     *
     * @param str  the String to pad out, may be null
     * @param size  the size to pad to
     * @param padChar  the character to pad with
     * @return right padded String or original String if no padding is necessary,
     *  <code>null</code> if null String input
     */
    public static String rightPad(String str, int size, char padChar) {
        if (str == null) {
            return null;
        }
        int pads = size - str.length();
        if (pads <= 0) {
            return str; // returns original String when possible
        }
        if (pads > PAD_LIMIT) {
            return rightPad(str, size, String.valueOf(padChar));
        }
        return str.concat(padding(pads, padChar));
    }

    /**
     * <p>Right pad a String with a specified String.</p>
     *
     * <p>The String is padded to the size of <code>size</code>.</p>
     *
     * <pre>
     * StringUtils.rightPad(null, *, *)      = null
     * StringUtils.rightPad("", 3, "z")      = "zzz"
     * StringUtils.rightPad("bat", 3, "yz")  = "bat"
     * StringUtils.rightPad("bat", 5, "yz")  = "batyz"
     * StringUtils.rightPad("bat", 8, "yz")  = "batyzyzy"
     * StringUtils.rightPad("bat", 1, "yz")  = "bat"
     * StringUtils.rightPad("bat", -1, "yz") = "bat"
     * StringUtils.rightPad("bat", 5, null)  = "bat  "
     * StringUtils.rightPad("bat", 5, "")    = "bat  "
     * </pre>
     *
     * @param str  the String to pad out, may be null
     * @param size  the size to pad to
     * @param padStr  the String to pad with, null or empty treated as single space
     * @return right padded String or original String if no padding is necessary,
     *  <code>null</code> if null String input
     */
    public static String rightPad(String str, int size, String padStr) {
        if (str == null) {
            return null;
        }
        if ( padStr==null || "".equals(padStr) ) {
            padStr = " ";
        }
        int padLen = padStr.length();
        int strLen = str.length();
        int pads = size - strLen;
        if (pads <= 0) {
            return str; // returns original String when possible
        }
        if (padLen == 1 && pads <= PAD_LIMIT) {
            return rightPad(str, size, padStr.charAt(0));
        }
        if (pads == padLen) {
            return str.concat(padStr);
        } else if (pads < padLen) {
            return str.concat(padStr.substring(0, pads));
        } else {
            char[] padding = new char[pads];
            char[] padChars = padStr.toCharArray();
            for (int i = 0; i < pads; i++) {
                padding[i] = padChars[i % padLen];
            }
            return str.concat(new String(padding));
        }
    }



	/**
	 * money format convert.
	 */
	public static String getPriceFormat(String source) {
		return getPriceFormat(NumberUtil.parseInt(source));
	}

	/**
	 * money format convert.
	 */
	public static String getPriceFormat(int source) {
		String sPattern = "###,###,###,##0";
		DecimalFormat decimalformat = new DecimalFormat(sPattern);
		return decimalformat.format(source);
	}
	
	public static String getPriceFormat(long source)
	{
		String sPattern = "###,###,###,##0";
		DecimalFormat decimalformat = new DecimalFormat(sPattern);
		return decimalformat.format(source);
	}

	/**
	 *	"." 이후 문자열 리턴 ("." 포함
	 *
	 */
	public static String getExt(String szTemp)
	{
		if(szTemp == null) return "";

		String fname = "";
		if (szTemp.indexOf(".") != -1) {
			fname = szTemp.substring(szTemp.lastIndexOf("."));
			return fname;
		} else {
			return "";
		}
	}

	/**
	 *	주어진 파일명을 이용, 확장자가 .gif, .jpg, .png, .bmp 인 경우 true 리턴
	 *
	 */
	public static boolean isImageFile(String fileName)
	{
		String ext = getExt(fileName);

		if(ext.equals(".gif") || ext.equals(".jpg") || ext.equals(".png") || ext.equals(".bmp"))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/**
	 * 데이타를 구분자로 나누어 배열로 리턴
	 *
	 *
	 */
	public static String[] getSplit(String str, String delimiter){
		int	cnt	= 0;
		String[] arrayData = null;

		if (str == null){
			return null;
		}

		if ( str != null && !str.equals("")){
			StringTokenizer	token =	new	StringTokenizer(str,delimiter);
			arrayData = new	String[token.countTokens()];
			while(token.hasMoreTokens())
			{
				arrayData[cnt++] = token.nextToken();
			}
		}
		return arrayData ;
	}



	/**
	 *	파라미터 스트링이 null 이 아니고, "" 이 아니면 true, 아니면 false
	 *
	 *	@param param		검사 문자열
	 *
	 *	@return 검사결과
	 */
	public static boolean isNotNull(String param){
		if(param != null && "".equals(param) == false) return true;
		else return false;
	}
	
	/**
	 *	파라미터 스트링이 null 이 아니고, "" 이 아니면 true, 아니면 false
	 *
	 *	@param param		검사 문자열
	 *
	 *	@return 검사결과
	 */
	public static String isNullReplace(String param,String dst){
		if(param != null && "".equals(param) == false)
		{
			return param;
		}
		else 
		{
			return dst;
		}
	}


	/**
	 *	파라미터 스트링이 null or "" 이면 true, 아니면 false
	 *
	 *	@param param		검사 문자열
	 *
	 *	@return 검사결과
	 */
	public static boolean isNull(String param){
		if(param == null || "".equals(param) || "".equals(param.trim())) return true;
		else return false;
	}

	/**
	 *	파라미터 String 배열이 null or length = 0 or isNull(elementAt(i))
	 *
	 *	@param param		검사 문자열 배열
	 *
	 *	@return 검사결과
	 */
	public static boolean isNull(String[] param){
		if(param == null || param.length == 0) return true;
		for(int i=0; i < param.length; i++){
			if(isNotNull(param[i])) return false;
		}
		return true;
	}


	public static boolean isNotNull(String[] param){
		return !isNull(param);
	}

	public static boolean isNull(Object[] param){
		if(param == null || param.length == 0) return true;
		for(int i=0; i < param.length; i ++){
			if(param[i] != null) return false;
		}

		return true;
	}

	public static boolean isNotNull(Object[] param){
		return !isNull(param);
	}

        public static String checkNullStr(String str){
          if(isNull(str)){
              str = "";
          }
          return str;
        }
        
	/*
		고정길이 len = 3
		현재 값  str = 1 일 경우 001을 반환해 준다.
	 */
	public static String zeroPutStr(int len, String str){
	  for(int i = 0; i < len; i++)
		if(i >= str.length()) str = "0" + str;

	  return str;
	}


	/**
	 *	자바스크립트의 alert('') 함수에서 출력할 문자열에 포함되어 있는 "\n", """ 문자 제거
	 *
	 */
	public static String getAlertMsg(String src){
		src = ReplaceAll(src, "\n", "\\n");
		src = ReplaceAll(src, "\r", "");
		src = ReplaceAll(src, "\"", "'");
		
		return src;
	}

	/**
	 *	스트링 치환 함수
	 *	
	 *	주어진 문자열(buffer)에서 특정문자열('src')를 찾아 특정문자열('dst')로 치환
	 *
	 */
	public static String ReplaceAll(String buffer, String src, String dst){
		if(buffer == null) return null;
		if(buffer.indexOf(src) < 0) return buffer;
		
		int bufLen = buffer.length();
		int srcLen = src.length();
		StringBuffer result = new StringBuffer();

		int i = 0; 
		int j = 0;
		for(; i < bufLen; ){
			j = buffer.indexOf(src, j);
			if(j >= 0) {
				result.append(buffer.substring(i, j));
				result.append(dst);
				
				j += srcLen;
				i = j;
			}else break;
		}
		result.append(buffer.substring(i));
		return result.toString();
	}

    /**
     *  스트링 치환 함수
     *  
     *  주어진 문자열(buffer)에서 특정문자열('src')를 찾아 특정문자열('dst')로 치환
     *
     */
    public static String ReplaceLogSqlMapping(String buffer, String src, String dst){
        if(buffer == null) return null;
        if(buffer.indexOf(src) < 0) return buffer;
        
        int bufLen = buffer.length();
        int srcLen = src.length();
        StringBuffer result = new StringBuffer();

        int i = 0; 
        int j = 0;
        for(; i < bufLen; ){
            j = buffer.indexOf(src, j);
            if(j >= 0) {
                result.append(buffer.substring(i, j));
                result.append(dst);
                
                j += srcLen;
                i = j;
                break;
            }else break;
        }
        result.append(buffer.substring(i));
        return result.toString();
    }
    
	/**
	 String의 & 비트 연산을 한다.
	 00000001 & 00001001 => 00000001로 출력이 된다.
	 **/
	public static String calcStrBit(String root, String comp){
	  String retVal = "";
	  char first = '0';
      
	  for(int i =0;i < 8;i++){
		 if((first = root.charAt(i)) == '1'){
			if(first == comp.charAt(i)) retVal += "1";
			else retVal += "0";          
		 }else{
			retVal += "0";
		 }     
	  }
      
	  return retVal;	
	}	
	
	public static String encode(String str){
		if((str != null) && (str.equals(""))) str = ""; 
		else str = URLEncoder.encode(str);
		
		return str;
	}
	
	public static String decode(String str){
		if((str != null) && (str.equals(""))) str = ""; 
		else str = URLDecoder.decode(str);
		
		return str;
	}
	
	public static String encrypt(String str){
		return str;
	}
	
	public static boolean equalsIgnoreCase(String src, String dst){
		if(src == null && dst != null) return false;
		return src.equalsIgnoreCase(dst);
	}
	
	public static String stringToDate(String str,String format)
	{
		StringBuffer result = new StringBuffer();

		int maxlen = str.length();
		if(maxlen < 8)
			return str;
		
		result.append(str.substring(0, 4)+format);
		result.append(str.substring(4, 6)+format);
		result.append(str.substring(6, 8));
		
		return result.toString();
	}

    /**
        현재 날짜(년월일) 반환
     **/
    public static String  currStringToYmd()  throws Exception
    {
       java.text.SimpleDateFormat  f = new java.text.SimpleDateFormat("yyyyMMdd") ;
       f.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Seoul")) ;
       return  f.format(new java.util.Date()) ;
    }

    /**
        현재 날짜(년월일시분초) 반환
     **/
    public static String  currStringToDate()  throws Exception
    {
       java.text.SimpleDateFormat  f = new java.text.SimpleDateFormat("yyyyMMddHHmmss") ;
       f.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Seoul")) ;
       return  f.format(new java.util.Date()) ;
    }
    
	/**
 	현재 날짜(년) 반환
	 **/
	public static String  currStringToYear()  throws Exception
	{
	   java.text.SimpleDateFormat  f = new java.text.SimpleDateFormat("yyyy") ;
	   f.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Seoul")) ;
	   return  f.format(new java.util.Date()) ;
	}
	/**
	 * 다음해 년도 반환
	 **/
	public static String nextStringToYear() throws Exception
	{
        Calendar cal = Calendar.getInstance();
        int    iYear    = cal.get(Calendar.YEAR)+1;
		return  String.valueOf(iYear) ;
	}
	/**
 	현재 날짜(월) 반환
	 **/
	public static String  currStringToMonth()  throws Exception
	{
	   java.text.SimpleDateFormat  f = new java.text.SimpleDateFormat("MM") ;
	   f.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Seoul")) ;
	   return  f.format(new java.util.Date()) ;
	}
	
	/**
 	현재 날짜(일) 반환
	 **/
	public static String  currStringToDay()  throws Exception
	{
	   java.text.SimpleDateFormat  f = new java.text.SimpleDateFormat("dd") ;
	   f.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Seoul")) ;
	   return  f.format(new java.util.Date()) ;
	}
	
	/**
     * 일정 길이보다 길 경우 글자수 자르기
     * @param arg1 - 비교하는 값
     * @param arg2 - 비교하는 크기
     * @return String
     */
    public static String strLength(String arg1, int arg2) {
        String src = null;

        if (arg1.getBytes().length > arg2) {
            src = arg1.substring(0, arg2)+"...";
        } else {
            src = arg1;
        }

        return src;
    }
    
    /**
     * 전화번호를 길이별로 쪼개 준다..
     * @param tel
     * @return String[]
     */
    public static String[] parseTelNum(String tel) {
        String[] tels = new String[3];
        if ( tel.length()>=2 ) {
            if ( tel.substring(0, 2).equals("02") ) {
                if ( tel.length()>=10 ) {
                    tels[0] = tel.substring(0, 2);
                    tels[1] = tel.substring(2, 6);
                    tels[2] = tel.substring(6, 10);
                } else if ( tel.length()==9 ) {
                    tels[0] = tel.substring(0, 2);
                    tels[1] = tel.substring(2, 5);
                    tels[2] = tel.substring(5, 9);
                } else if ( tel.length()>5 && tel.length()<9 ) {
                    tels[0] = tel.substring(0, 2);
                    tels[1] = tel.substring(2, 5);
                    tels[2] = tel.substring(5);
                } else if ( tel.length()<=5 ) {
                    tels[0] = tel.substring(0, 2);
                    tels[1] = tel.substring(2);
                }
            } else {
                if ( tel.length()>=11 ) {
                    tels[0] = tel.substring(0, 3);
                    tels[1] = tel.substring(3, 7);
                    tels[2] = tel.substring(7, 11);
                } else if ( tel.length()==10 ) {
                    tels[0] = tel.substring(0, 3);
                    tels[1] = tel.substring(3, 6);
                    tels[2] = tel.substring(6, 10);
                } else if ( tel.length()>6 && tel.length()<10 ) {
                    tels[0] = tel.substring(0, 3);
                    tels[1] = tel.substring(3, 6);
                    tels[2] = tel.substring(6);
                } else if ( tel.length()>3 && tel.length()<=6 ) {
                    tels[0] = tel.substring(0, 3);
                    tels[1] = tel.substring(3);
                } else if ( tel.length()<=3 ) {
                    tels[0] = tel;
                }
            }
        } else {
            tels[0] = tel;
        }
        return tels;
    }
    
    /**
     * 해당일에 대한 몇일 전/후 날짜를 구한다. 
     * @param lm_sDateString
     * @param pm_iChangeDate
     * @return String
     */
    public static String addDay(String lm_sDateString, int pm_iChangeDate) {

        int lm_iYear    = Integer.parseInt(lm_sDateString.substring(0,4)); 
        int lm_iMonth   = Integer.parseInt(lm_sDateString.substring(4,6))-1; 
        int lm_iDate    = Integer.parseInt(lm_sDateString.substring(6,8)); 
        
        Calendar lm_oCal = Calendar.getInstance();
        lm_oCal.set(lm_iYear,lm_iMonth,lm_iDate); 
        lm_oCal.add(Calendar.DATE, pm_iChangeDate); 
        
        SimpleDateFormat lm_oFormat = new SimpleDateFormat("yyyyMMdd");
        lm_oFormat.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Seoul")) ;
        return lm_oFormat.format(lm_oCal.getTime());
    }

    /**
     * <p>메소드명 : addMonth</p>
     * <p>설명 : 주어진 날짜 DATE 의 달수를 addCount 만큼 증가 또는 감소 시킴</p>
     * <p>메소드인수1 : String dateString - 8자리 또는 6자리의 날짜 데이터</p>
     * <p>메소드인수2 : int addCount - 더할 달의 수 (증가시 +, 감소시 -)</p>
     * <p>메소드리턴값 : String dateString - 8자리 또는 6자리의 날짜 데이터</p>
     */
    public static String addMonth(String dateString, int addMonth) {
        try {
            if (dateString == null) {
                return null;
            }
            int year = 0;
            int month = 2;
            int day = 1;
            String format = "yyyyMMdd";

            GregorianCalendar cal = new GregorianCalendar();
            if (dateString.length() == 8) {
                year = Integer.parseInt(dateString.substring(0, 4));
                month = Integer.parseInt(dateString.substring(4, 6));
                day = Integer.parseInt(dateString.substring(6));
            } else if (dateString.length() == 6) {
                year = Integer.parseInt(dateString.substring(0, 4));
                month = Integer.parseInt(dateString.substring(4));

                format = "yyyyMM";
            } else {
                return null;
            }
            //MONTH 는 0 ~ 11 이므로 실제 데이터의 마이너스 1
            cal.set(year, month - 1, day);
            cal.add(GregorianCalendar.MONTH, addMonth);

            SimpleDateFormat formatter = new SimpleDateFormat(format);
            return formatter.format(cal.getTime());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 다음 회차 시작일을 구한다.
     * @return String
     * @throws NumberFormatException
     * @throws Exception
     */
    public static String nextPeriodSDay() throws NumberFormatException, Exception {
        String curYearMonth = currStringToYear() + currStringToMonth();
        int curDay = Integer.parseInt(currStringToDay());
        String day = "";
        if ( curDay>15 ) {
            curYearMonth = addMonth(curYearMonth, 1);
            day = "01";
        } else {
            day = "16";
        }
        return curYearMonth + day;
    }
    
    /**
     * 다음 회차 시작일을 구한다.
     * @return String
     * @throws NumberFormatException
     * @throws Exception
     */
    public static String nextPeriodEDay() throws NumberFormatException, Exception {
        String curYearMonth = currStringToYear() + currStringToMonth();
        int curDay = Integer.parseInt(currStringToDay());
        String day = "";
        if ( curDay>15 ) {
            curYearMonth = addMonth(curYearMonth, 1);
            day = "15";
        } else {
            day = new Integer(lastDay(curYearMonth)).toString();
        }
        return curYearMonth + day;
    }

    /**
     * 현재일 기준 회차 시작일을 구한다.
     * @return String
     * @throws NumberFormatException
     * @throws Exception
     */
    public static String currPeriodSDay() throws NumberFormatException, Exception {
        String curYearMonth = currStringToYear() + currStringToMonth();
        int curDay = Integer.parseInt(currStringToDay());
        String day = "";
        if ( curDay>15 ) {
            day = "16";
        } else {
            day = "01";
        }
        return curYearMonth + day;
    }
    
    /**
     * 현재일 기준 회차 시작일을 구한다.
     * @return String
     * @throws NumberFormatException
     * @throws Exception
     */
    public static String currPeriodEDay() throws NumberFormatException, Exception {
        String curYearMonth = currStringToYear() + currStringToMonth();
        int curDay = Integer.parseInt(currStringToDay());
        String day = "";
        if ( curDay>15 ) {
            day = "" + lastDay(curYearMonth);
        } else {
            day = "15";
        }
        return curYearMonth + day;
    }

    /**
     * 주어진 년 월의 마지막 일자(월말) 구하기
     * @param dateString
     * @return int - 월말일
     * @throws ParseException
     */
    public static int lastDay(String dateString) throws ParseException {
        int year = Integer.parseInt(dateString.substring(0, 4));
        int month = Integer.parseInt(dateString.substring(4, 6));
        int day = 0;
        switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day = 31;
            break;
        case 2:
            if ((year % 4) == 0) {
                if ((year % 100) == 0 && (year % 400) != 0) {
                    day = 28;
                } else {
                    day = 29;
                }
            } else {
                day = 28;
            }
            break;
        default:
            day = 30;
        }
        return day;
    }

    /**
     * <p>메소드명      : getNumOfTheWeek</p>
     * <p>설명        : 입력된 날짜의 요일 수를 반환하는 함수</p>
     * <p>메소드인수1    : String dayStr  - '20040101' 날짜 스트링</p>
     * <p>메소드리턴값    : String         - 요일 스트링</p>
     */
    public static int getNumOfTheWeek(String dayStr) {
        return getNumOfTheWeek(dayStr, "yyyyMMdd");
    }

    /**
     * <p>메소드명      : getNumOfTheWeek</p>
     * <p>설명        : 입력된 날짜의 요일 수를 반환하는 함수</p>
     * <p>메소드인수1    : String dayStr  - '20040101' 날짜 스트링</p>
     * <p>메소드인수2    : String format  - 'yyyyMMdd' 포맷 스트링</p>
     * <p>메소드리턴값    : String         - 요일 스트링</p>
     */
    public static int getNumOfTheWeek(String dayStr, String format) {
        DateFormat df1 = new SimpleDateFormat(format);
        DateFormat df2 = new SimpleDateFormat("EEE");

        return df1.parse(dayStr, new ParsePosition(0)).getDay();
    }
    
    /**
     * 해당 일자가 속한 주의 시작일(Mon)과 종료일(Sun)을 구한다.
     * @param dayStr
     * @return String[]
     */
    public static String[] getFirstLastOfTheWeek(String dayStr) {
        String[] rtns = new String[2];
        String curr = addDay(dayStr, -1);
        int yoil = getNumOfTheWeek(curr, "yyyyMMdd");
        rtns[0] = addDay(curr, 1-yoil);
        rtns[1] = addDay(curr, 7-yoil);
        return rtns;
    }
    
    /**
     * 스트링끝에 NewLine추가
     * @param str
     * @return String - \n이 추가된 스트링
     */
    public static String addLN(String str)
    {
    	return str + "\n";
    }
    
	public static int getCalTime(String type) {
		
		Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
		int returnTime = 0;
		
		if ("HH".equals(type)) returnTime = oCalendar.get(Calendar.HOUR_OF_DAY);
		if ("MM".equals(type)) returnTime = oCalendar.get(Calendar.MINUTE);
		if ("SS".equals(type)) returnTime = oCalendar.get(Calendar.SECOND);

		return returnTime;
	}
	
	public static String getCalDate(String type) {
		
		SimpleDateFormat sdf = new SimpleDateFormat(type);
	    Calendar c1 = Calendar.getInstance();
	    String strToday = sdf.format(c1.getTime());

		return strToday;
	}

}
