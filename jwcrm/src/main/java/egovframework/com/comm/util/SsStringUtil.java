package egovframework.com.comm.util;

import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Random;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

public class SsStringUtil {


	public static final int FILTER_WORD_MAX_LENGTH = 100000;
	public static final int FILTER_WORD_MIN_LENGTH = 2;
	public static final String DELIMITERS = " ,;/'\"\n\r.~!@#$%^&*()+|-=`[]";
	
	public static String checkFilterWord4HashMap(HashMap _filterWordList, String _contents) {

		String content = null;
		HashMap<String,String> hash = new HashMap<String,String>();

		if(_contents == null) return null;

		content = _contents.toLowerCase();

		StringTokenizer st = new StringTokenizer(content, DELIMITERS, false);

		// 단어를 추출한다.
		while(st.hasMoreElements()) {
			String str = st.nextToken();
			int length = str.length();
			String substr;
			String tmpstr = hash.get(str);
			if(tmpstr != null) continue;
			for(int k = 0; k < length - FILTER_WORD_MIN_LENGTH + 1; k++) {
				for(int i = FILTER_WORD_MIN_LENGTH + k ; i <= length && i < FILTER_WORD_MAX_LENGTH; i++) {
					substr = str.substring(k, i);
					if(_filterWordList.get(substr) != null)
						return substr;
				}
			}
			hash.put(str, str);
		}
		return null;
	}	
	
    /**
     * 실명인증 요청 랜덤 번호 생성
     * @return reqNum YYYYMMDD + @@@@@@ (6자리 랜덤 함수) 
     * @throws Exception
     */
	public static String GetRandom(int numLength){
        //날짜 생성
        Calendar today = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String day = sdf.format(today.getTime());

        SecureRandom srn = null;
        
        //랜덤 문자 길이
        String randomStr = "";
        
        try {
        	
        	// System.out.println("try SecureRandom !!");
			srn = SecureRandom.getInstance("SHA1PRNG");
	        for (int i = 0; i < numLength; i++) {
	            //0 ~ 9 랜덤 숫자 생성
	            randomStr += srn.nextInt(10);
	        }
	        
		} catch (Exception e) {
			
			e.printStackTrace();
			
			java.util.Random ran = new Random();
			ran.setSeed(new Date().getTime());
	        for (int i = 0; i < numLength; i++) {
	            //0 ~ 9 랜덤 숫자 생성
	            randomStr += ran.nextInt(10);
	        }
		}

        String reqNum = day + randomStr;		

        return reqNum;
	}

	public static String convertHtmlchars(String htmlstr)
	{
		String convert = new String();
		convert = replace(htmlstr, "<script", "<xxscrit");
		convert = replace(convert, "javascript", "xxjavascript");
		convert = replace(convert, "alert(", "alert(!!");
		convert = replace(convert, "<", "&lt;");
		convert = replace(convert, ">", "&gt;");
		convert = replace(convert, "\"", "&quot;");
		convert = replace(convert, "&nbsp;", "&amp;nbsp;");
		convert = replace(convert, "&lt;script", "&lt;XXscript");
		return convert;
	}
	
	public static String convertCharshtml(String htmlstr)
	{
		String convert = new String();
		convert = replace(htmlstr, "&lt;", "<");
		convert = replace(convert, "&gt;", ">");
		convert = replace(convert, "&quot;", "\"");
		convert = replace(convert, "&amp;nbsp;", "&nbsp;");
		
		return convert;
	}
	
	/**
	* '\n' 문자를 '<br>'로 대치한다.
	*/
	public static String ReplaceBR(String pStrIn) {
		String str = "";
		int i;

		if (pStrIn == null) return "";

		for (i = 0; i < pStrIn.length(); i++) {
			if (pStrIn.charAt(i) == '\n') {
				str += "<br>";
			}
			else {
				str += pStrIn.charAt(i);
			}
		}
		return str;
	}

	public static String encode(String s) {
        return encode(s, "8859_1");
    }

	public static String encode(String s, String enc) {
        try {
            return new String(s.getBytes("KSC5601"), enc);
        } catch(Exception exception) {
            return null;
        }
    }

	public static String[] encode(String as[]) {
        if(as == null)
            return null;
        for(int i = 0; i < as.length; i++)
            as[i] = encode(as[i]);
        return as;
    }

    public static String decode(String s) {
        return decode(s, "KSC5601");
    }

    public static String decode(String s, String enc) {
        try {
            return new String(s.getBytes("8859_1"), "KSC5601");
        } catch(Exception exception) {
            return null;
        }
    }

    public static String[] decode(String as[]) {
        if(as == null)
            return null;
        for(int i = 0; i < as.length; i++)
            as[i] = decode(as[i]);
        return as;
    }
    
    public static String trim(String s) { 
    	if (!isDefined(s))
    		return s;
    	return s.trim();
    }

	public static String replace(String sSrc, String sOld, String sNew) {
        if(sSrc == null || sOld == null || sNew == null)
            return sSrc;
        StringBuffer stringbuffer = new StringBuffer();
        int i = sOld.length();
        int j = 0;
        for(int k = 0; (k = sSrc.indexOf(sOld, j)) != -1;) {
            stringbuffer.append(sSrc.substring(j, k)).append(sNew);
            j = k + i;
        }
        stringbuffer.append(sSrc.substring(j));
        return stringbuffer.toString();
    }
    
    public static String remove(String s, String s1) {
        if(s == null || s1 == null)
            return s;
        StringTokenizer stringtokenizer = new StringTokenizer(s, s1);
        StringBuffer stringbuffer = new StringBuffer();
        for(; stringtokenizer.hasMoreElements(); stringbuffer.append(stringtokenizer.nextToken()));
        return stringbuffer.toString();
    }
    
    public static String fillSpace(String s, int len) { 
    	if (s.length() > len)
    		return s;
    	StringBuffer sb = new StringBuffer();
    	sb.append(s);
    	for (int i=s.length(); i<len; i++)
    		sb.append(" ");
    	return sb.toString();
    }
	
    public static int length(String s) { 
    	if (s == null)
    		return 0;
    	return s.length();
    }
    
    public static String cutAndAdd(String s, int i) { 
    	if (s == null)
    		return s;
    	else if (length(s) > i)
    		return cut(s, i) + "...";
    	return s;
    }
    
    public static String cut(String s, int i) {
        if(s == null)
            return s;
        else
            return s.substring(0, Math.min(s.length(), i));
    }

    public static String substring(String s, int i) { 
    	if (i < 0)
    		return s;
    	return s.substring(i, s.length());
    }

    public static String substring(String s, int i, int i2) { 
    	if (s == null)
    		return s;
    	if (s.length() > i2)
    		return s;
    	return s.substring(i, i2);
    }

    public static String getNameByte(String s, int start, int end) throws Exception { 
    	int bytelen = getByte(s);
    	if (start == 0 && end > bytelen)
    		return s;
    	if (start < bytelen && (end < bytelen || end == bytelen)) {
    		return s.substring(start/2, end/2);
    	}
    	return "";
    }
    
    public static int getByte(String s) {
        int i = 1;
        if(s != null)
        {
            for(int j = 0; j < s.length(); j++)
            {
                char c = s.charAt(j);
                if(isHalf(c))
                    i++;
                else
                    i += 2;
            }

        }
        return i;
    }

    public static int getNameWidth(String s) {
        int i = 1;
        if(s != null)
        {
            for(int j = 0; j < s.length(); j++)
            {
                char c = s.charAt(j);
                if(isHalf(c))
                    i++;
                else
                    i += 2;
            }

        }
        return i / 2;
    }

    public static int getNameLength(String s, int i) {
        if(s == null)
            return 0;
        int j = 1;
        for(int k = 0; k < s.length(); k++)
        {
            if(j >= i * 2)
                return k;
            char c = s.charAt(k);
            if(isHalf(c))
                j++;
            else
                j += 2;
        }

        return s.length();
    }

    private static boolean isHalf(char c) {
        return ' ' <= c && c < '\177';
    }

    public static String normalizeNull(String s) {
	    if(s == null)
	        return "";
	    if (equals(s, "null"))
	    	return "";
	    if (equals(s, "undefined"))
	    	return "";
	    return s;
	}

    public static String normalizeNull(Object o) {
	    if(o == null)
	        return "";
	    String s = o.toString();
	    if (equals(s, "null"))
	    	return "";
	    if (equals(s, "undefined"))
	    	return "";
	    return s;
	}

    public static String normalizeNullArray(String[] array) {
	    if(array == null)
	        return "";
	    String s = "not null";
	    
	    if (equals(array[0], "null"))
	    	return "";
	    if (equals(array[0], "undefined"))
	    	return "";
	    if (equals(array[0], ""))
	    	return "";
	    
	    return s;
	}
    
    public static String normalize(String s, String replace) {
		if (!isDefined(s))
			return normalizeNull(replace);
		return s;
	}
	
    public static String normalize(Object o, String replace) {
		if (!isDefined(o))
			return normalizeNull(replace);
		return SsStringUtil.toString(o);
	}

    public static String normalize(String s) {
        if(s == null)
            return "";
        
        int i;
        for(int j = -1; (i = s.substring(j + 1).indexOf('&')) != -1; j = i) {
            i += j + 1;
            s = new String((new StringBuffer(s)).replace(i, i + 1, "&amp;"));
        }

        return normalizeLtGtQuot(s);
    }

	public static String normalizeLtGtAmpQuot(String s) { 
		String s1 = replace(s, "&", "&amp;");
		s1 = replace(s1, "<", "&lt;");
		s1 = replace(s1, ">", "&gt;");
		s1 = replace(s1, "\"", "&quot;");
		s1 = replace(s1, "'", "&#039;");
		return s1;
	}
	
	public static String normalizeLtGtQuot(String s) {
        if(s == null)
            return "";
        for(int i = -1; (i = s.indexOf('"')) != -1;)
            s = new String((new StringBuffer(s)).replace(i, i + 1, "&quot;"));

        int j;
        while((j = s.indexOf('<')) != -1) 
            s = new String((new StringBuffer(s)).replace(j, j + 1, "&lt;"));
        while((j = s.indexOf('>')) != -1) 
            s = new String((new StringBuffer(s)).replace(j, j + 1, "&gt;"));
        while((j = s.indexOf('&')) != -1) 
            s = new String((new StringBuffer(s)).replace(j, j + 1, "&amp;"));
        while((j = s.indexOf('\'')) != -1) 
            s = new String((new StringBuffer(s)).replace(j, j + 1, "&#039;"));
        return s;
    }

    public static String normalizeSql(int i) {
        return normalizeSql(toString(i));
    }

    public static String normalizeSql(String s) {
        if (!isDefined(s))
        	return "";
    	s = s.replaceAll("/", "//");
        s = s.replaceAll("%", "/%");
        s = s.replaceAll("_", "/_");
        return s;
    }

    public static boolean toBoolean(String s) {
		if(isDefined(s) && ( equalsIgnoreCase("1", s) || equalsIgnoreCase("y", s) || equalsIgnoreCase("true", s))) {
			return true;
		}else {
			return false;
		}
	}
    
    public static String toBooleanString(boolean b) { 
        if (b)
            return "1";
        return "0";
    }

	public static int toInteger(String s) {
		return Integer.parseInt(s);
	}

	public static Date toDate(String s, String pattern) { 
		SimpleDateFormat format = new SimpleDateFormat(pattern);
		Date d = null;
		try { 
			d = format.parse(s);
		} catch (Exception e) {
			d = null ; 
		}
		
		return d;
	}
	
    public static String normalize(Object obj) {
        return normalize((String)obj);
    }
	
    public static int parseInt(String s) {
        return parseInt(s, 0);
    }

    public static int parseInt(String s, int i) {
        try
        {
            return Integer.parseInt(s);
        }
        catch(NumberFormatException numberformatexception)
        {
            return i;
        }
    }

    public static long parseLong(String s) {
        return parseLong(s, 0L);
    }

    public static long parseLong(String s, long l) {
        try
        {
            return Long.parseLong(s);
        }
        catch(NumberFormatException numberformatexception)
        {
            return l;
        }
    }

    public static float parseFloat(String s) {
    	return parseFloat(s, 00.00F);
    }

	public static float parseFloat(String s, float f) {
		try
		{
			return Float.parseFloat(s); 
		}
		catch(NumberFormatException numberformatexception)
		{
			return f;
		}
	}

    public static boolean equals(String s, String s1) {
        if(s == null && s1 == null)
            return true;
        if(s == null || s1 == null)
            return false;
        else
            return s.equals(s1);
    }

    public static boolean equalsIgnoreCase(String s, String s1) {
        if(s == null && s1 == null)
            return true;
        if(s == null || s1 == null)
            return false;
        else
            return s.equalsIgnoreCase(s1);
    }
    public static String add(String s, String s1) {
        if(s == null)
            return s1;
        if(s1 == null)
            return s;
        else
            return s + s1;
    }

    public static String addNumeric(String s, String s1) {
        if(!isDefined(s))
            return s1;
        if(!isDefined(s1))
            return s;
        else
            return String.valueOf(Integer.parseInt(s) + Integer.parseInt(s1));
    }
    
	public static String divide(String s1, String s2) {
		if (equals(s1,"0") || equals(s2,"0")) 
			return "0";
		double d  = (toDouble(s1) / toDouble(s2)) * 100 ;
		return cut(toString(d), 4);	
		
	}
    
	public static String divide1(String s1, String s2, int num) {
		if (!isDefined(s1) || !isDefined(s2) || equals(s1,"0") || equals(s2,"0")) 
			return "0";
		double d  = (toDouble(s1) / toDouble(s2)) ;	
		
		return toString(Math.round(d*Math.pow(10, num))/Math.pow(10, num));	
		
	}
	
	public static String addDouble(String s, String s1) {
		if (!isDefined(s) || !isDefined(s1) || equals(s,"0") || equals(s1,"0")) 
			return "0";
		double d  = (toDouble(s) + toDouble(s1)) ;
		return toString(d);
    }
	

	public static double toDouble(String s) {
		Double d = new Double(s);
		return d.doubleValue();	
	}

	public static float toFloat(String s) {
		if (!isDefined(s))
			return toFloat("0.0");
		return Float.parseFloat(s);
	}

	public static long toLong(String s) {
		return Long.parseLong(s);
	}

	public static String toString(Collection c) {
		return toString(c, ",");
	}
	
	public static String toString(Collection c, String separator) {
		if (c == null)
			return "";
		StringBuffer sb = new StringBuffer();
		for (Iterator i = c.iterator(); i.hasNext(); ) {
			sb.append(i.next());
			if (i.hasNext()) sb.append(separator);
		}
		return sb.toString();
	}
	
	public static String toString(int c) {
        String s = "";
        try { 
            s = String.valueOf(c);
        } catch (Exception e) { 
            s = "" ; 
        }
    	return s;
	}
	
	public static String toString(int[] c) {
		if (c == null)
			return "";
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < c.length; i++) {
			sb.append(c[i]);
			if (i < c.length - 1) sb.append(", ");
		}
		return sb.toString();
	}
    
	public static String toString(boolean b) {
		return b ? "1" : "0";
	}

	public static String toString(Object o) {
		if (o == null)
			return "";
		return o.toString();
	}

	public static String toString(String s) {
		return (s == null) ? "" : s.toString();
	}

	public static boolean isDefined(String s) {
        return s != null && s.length() != 0;
    }

    public static boolean isDefined(Object o) {
        return o != null && isDefined(o.toString());
    }

    public static boolean isDefined(String as[]) {
        return as != null && as.length != 0;
    }

    public static boolean isTrue(String s) {
        if(s == null)
            return false;
        else
            return s.equals("t");
    }
    
    public static boolean isAlphabet(char c) {
        return 'a' <= c && c <= 'z' || 'A' <= c && c <= 'Z';
    }
    
	public static String toString(double d) {
		return Double.toString(d);
	}

    public static String toString(String[] as) {
        return toString(as, ",");
    }

    public static String toString(String[] as, String delim) {
        if(as == null)
            return "";
        StringBuffer stringbuffer = new StringBuffer();
        for(int i = 0; i < as.length; i++)
        {
            stringbuffer.append(trim(as[i]));
            if(i < as.length - 1)
                stringbuffer.append(delim);
        }

        return stringbuffer.toString();
    }

    public static String toString(List list, List list1) {
        if(list == null || list1 == null)
            return "";
        int i = list.size();
        int j = list1.size();
        if(i != j)
            return "";
        StringBuffer stringbuffer = new StringBuffer();
        for(int k = 0; k < i; k++)
        {
            stringbuffer.append(list.get(k)).append("=").append(list1.get(k));
            if(k < i - 1)
                stringbuffer.append(", ");
        }

        return stringbuffer.toString();
    }

    public static ArrayList reverse(List list) {
        ArrayList arraylist = new ArrayList();
        for(ListIterator listiterator = list.listIterator(); listiterator.hasNext(); arraylist.add(0, listiterator.next()));
        return arraylist;
    }

    public static String[] tokenize(String s, String s1) {
        if(s == null || s1 == null)
            return null;
        else
            return tokenize(new StringTokenizer(s, s1));
    }

    public static String[] tokenize(StringTokenizer stringtokenizer) {
        return tokenize(stringtokenizer, stringtokenizer.countTokens());
    }

    public static String[] tokenize(StringTokenizer stringtokenizer, int i) {
        String as[] = new String[i];
        for(int j = 0; j < i; j++)
            as[j] = stringtokenizer.hasMoreElements() ? stringtokenizer.nextToken().trim() : null;

        return as;
    }
    
    public static boolean exist(String[] in, String s) { 
    	for (int i=0; i<in.length; i++) { 
    		if (equals(in[i], s))
    			return true;
    	}
    	return false;
    }
    
    public static String getExtension(String s)
    {
    	return getExtension(s, ".");
    }

    public static String getExtension(String s, String delim)
    {
        if(s == null)
            return null;
        int i = s.lastIndexOf(delim);
        if(i < 0)
            return "txt";
        else
            return s.substring(i + 1);
    }

	public static String getLast(String s, String delim) {
		if (!isDefined(s)) 
			return "null";
		if (!contains(s, delim))
			return s;
		StringTokenizer st = new StringTokenizer(s, delim);
		String last  = null;
		while (st.hasMoreTokens()) {
			last = st.nextToken();
		}
		return last;
	}

	public static boolean contains(String s, String in) {
		if (!isDefined(s))
				return false;
		return s.indexOf(in) > -1 ? true : false;
	}

	public static boolean contains(String s, String[] in) {
		boolean flag = false;
		if (!isDefined(in))
			return false;
		for (int i=0; i<in.length; i++) {
			if (equals(s, in[i])) {
				flag = true;
				break;
			}
		}
		return flag;
	}
	
	public static String toUpperCase(String s) {
		if (!isDefined(s))
			return s;
		return s.toUpperCase();
	}
	
	public static String toLowerCase(String s) {
		if (!isDefined(s))
			return s;
		return s.toLowerCase();
	}
	
	public static String normalizeXml(int i) { 
		return normalizeXml(toString(i));
	}
	
	public static String normalizeXml(String s) { 
		if (!isDefined(s))
			return "";
		String s1 = replace(s, "&", "&amp;");
		s1 = s1.replaceAll("\'", "&#039;");
		s1 = s1.replaceAll("\"", "&#34;");
		s1 = s1.replaceAll("<", "&lt;");
		s1 = s1.replaceAll(">", "&gt;");
		return s1;
	}

	public static boolean ssnCheck(String str){
		int checkNum[] = new int[13];
		int sum = 0;
		
		if(str.length()==13){
			for(int i=0; i < 13; i++){
				checkNum[i] = str.charAt(i)-48;
			}
			
			if(checkNum[6] > 6){ //성별 체크 1 2 3 4 5 6
				return false;
			}
			
			sum = (checkNum[0]*2) + (checkNum[1]*3) + (checkNum[2]*4) + (checkNum[3]*5) + (checkNum[4]*6) + (checkNum[5]*7) + (checkNum[6]*8) 
					+ (checkNum[7]*9) + (checkNum[8]*2) + (checkNum[9]*3) + (checkNum[10]*4) + (checkNum[11]*5);
			sum = 11-(sum%11);
			if(sum == 11) sum = 1;
			else if(sum == 10) sum = 0;
			
			if(checkNum[12] == sum){
				return true;
			}else{
				return false;
			}
		}
		return false;
	}
	
	public static String clobToString(java.sql.Clob clob){
		StringBuffer str1 = new StringBuffer();
		if(clob != null){
			java.io.Reader br = null ; 
			char[] buf = new char[1024] ; 
			int readcnt ; 
			try{
				br = clob.getCharacterStream() ; 
				while((readcnt = br.read(buf , 0 , 1024)) != -1){
					str1.append(buf , 0 , readcnt) ; 
				}
			}catch(Exception e){
				// System.out.println("CLOB!!!!!!!! error");
			}finally{
				if(br != null){
					try{
						br.close() ; 
					}catch(IOException e){
						// System.out.println("CLOB!!!!!! error > br close");
					}
				}
			}
		}
		
		return str1.toString() ; 
	}
	
	/**
	 * 문자열 뒤자리 * 처리
	 * @param value
	 * @return
	 */
	public static String astaStr(String value, int len) {
		String asta = "*";
		StringBuffer sb = new StringBuffer();
		if(len > 0){
			for(int i = 0; i < len; i++){
				sb.append(asta);
			}
		}
		
		if(value.length() > 0){
			value = value.substring(0, (value.length()-len)) + sb.toString();
		}
		
		return value;
	}
	
	/**
	 * 문자열 앞자리 * 처리
	 * @param value
	 * @return
	 */
	public static String astaStrPre(String value, int len) {
		String asta = "*";
		StringBuffer sb = new StringBuffer();
		
		if(len > 0){
			for(int i = 0; i < len; i++){
				sb.append(asta);
			}
		}
		
		if(value.length() > 0){
			value = sb.toString() + value.substring(len, value.length());
		}
		
		return value;
	}
	
	public static String nextUpCategory(String str){
		String returnValue = "" ;
		
		if("".equals(normalizeNull(str))) return "" ; 
		
		for(int i = 0 ; i < str.length() ; i++){
			char bb = str.charAt(i) ; 
			returnValue += ((char)(bb + 1)) ; 
		}
		
		return returnValue ; 
	}

	public static String getParamLinkUrl(HttpServletRequest request){
		String returnValue = "";
		Enumeration str = request.getParameterNames();
		String name = ""; 

		int no_cnt = 0;
		while(str.hasMoreElements()) { 
		    name = (String) str.nextElement();
		    if("seq".equals(name) || "board_type".equals(name) || "p_menu_code".equals(name) || "urlInfo".equals(name) || "urlinfo".equals(name)){
			    String value[] = request.getParameterValues(name); 
			    int tmp = value.length; 
			    
			    if(no_cnt == 0) returnValue += "?"; else returnValue += "&";
			    if(tmp == 1){ 
			    	for(int i=0; i<tmp; i++) { 
			    		returnValue += name + "=" + value[i]; 
			    				
			    	}
			    } else if(tmp > 1) { 
			    	returnValue += name + "=" + value; 
			    }
			    no_cnt++;
			    if("urlInfo".equals(name) || "urlinfo".equals(name)){
				    if(tmp == 1){ 
				    	for(int i=0; i<tmp; i++) { 
				    		returnValue = value[i]; 
				    		break;
				    	}
				    } else if(tmp > 1) { 
				    	returnValue = "" + value; 
			    		break;
				    }
			    }
		    }
		}
		
		return returnValue;
	}
	
	public static String link_url(String url , String board_type , String seq , String p_menu_code){
		String returnValue = "";
		
		if("".equals(board_type)){
			return "" ;
		}
		if("".equals(seq)){
			return "" ;
		}
		
		if("".equals(p_menu_code)){
			return "" ;
		}
		
		if(!"".equals(url)){
			returnValue = url.replaceAll("_list", "_view") + "?p_menu_code=" + p_menu_code + "&board_type=" + board_type + "&seq=" + seq ;
		}
		
		return returnValue ; 
	}
	
	
	public static String toMoney(String str,int spr){
	    String result = "";
		 try{
			if(str==null){
				result="-";
			}else{
				if(str.indexOf(".") ==-1){
				 spr=0;
				}
				StringBuffer sb = new StringBuffer();
				sb.append("#,###,###,###,###,##");
				if(spr == 0){
					sb.append("#");
				}else{
					sb.append("0.");
					for(int i = 0;i<spr;i++){
						sb.append("0");
					}
				}

				if(str != null ){
					if(checkStr(str)==true){
					 DecimalFormat df = new DecimalFormat(sb.toString());
					 result = df.format(new BigDecimal(str));
				    }
				}else{
					result ="-";
				}
			}
	    	}catch(Exception e){
	    		result = "-";
	    	}
		return result;
	}
 
	public static boolean checkStr(String str){
			boolean bool = false;
			Pattern p = Pattern.compile("[-]*[0-9.]+||[.]*");
			Matcher m = p.matcher(str);
			bool = m.matches();
			return bool;
		}
	 
	public static String toDouble(String str,int spr){
		return toMoney(str);
	}
	
	public static String toMoney(String str){
		return toMoney(str,2);
	}
	
	public static String StringInNumber(String str){
		String patternStr = "\\d" ;
		Pattern pattern = Pattern.compile(patternStr) ; 
		Matcher matcher = pattern.matcher(str) ; 
		
		String returnValue = "" ;
		
		while(matcher.find()){
			returnValue  += matcher.group(0) ; 
		}
		
		return returnValue ; 
	}
	
	/**
	 * yyyyMMdd를 yyyy-MM-dd로 변환
	 * @param dateStr 예)20090129 [8자리형태]
	 * @return String yyyy-MM-dd포맷
	 */
	public static String formatDate(String dateStr){
		if(dateStr == null){
			return "";
		}else if(dateStr.length() != 8){
			return dateStr;
		}
		return dateStr.substring(0, 4) + "-" + dateStr.substring(4, 6) + "-" + dateStr.substring(6, 8);
	}
	
	 public static String encryptSHA256(String planText) {
        try{
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(planText.getBytes());
            byte byteData[] = md.digest();

            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }

            StringBuffer hexString = new StringBuffer();
            for (int i=0;i<byteData.length;i++) {
                String hex=Integer.toHexString(0xff & byteData[i]);
                if(hex.length()==1){
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();
        }catch(Exception e){
            throw new RuntimeException();
        }
    }
	 
	 public static String ajaxDecoder(String text){
		 
		 String returnStr = "" ; 
		 
		 try{
			 
			 if(!normalize(text, "").equals("")){
				 returnStr = URLDecoder.decode(text, "UTF-8") ; 
			 }
			 
		 }catch(Exception e){ returnStr = "" ;}
		 
		 
		 return returnStr ; 
	 }
	 
	 public static String maxSeqCreate(String max){
		 String returnStr = "" ; 
		 int num_len = 7 ; 
		 try{
			 
			 if("".equals(normalizeNull(max))) returnStr = "M0000001" ;
			 else{
				 max = max.replaceAll("M", "") ;
				 int seq = Integer.parseInt(max) + 1 ; 
				 num_len = num_len - (String.valueOf(seq).length()) ;
				 
				 for(int i = 0 ; i < num_len; i++){
					 returnStr += "0" ;
				 }
				 
				 returnStr = "M" + returnStr + String.valueOf(seq) ; 
			 }
			 
		 }catch(Exception e){returnStr = "" ; }
		 
		 return returnStr ; 
	 }
	 
	 public static String getExt(String szTemp){
		 
		 String returnStr = "" ; 
		 
		 if("".equals(SsStringUtil.normalizeNull(szTemp).trim())){
			 returnStr = "" ; 
		 }else{
			 if(szTemp.indexOf(".") != -1){
				 returnStr = szTemp.substring(szTemp.lastIndexOf(".")) ;
			 }
		 }
		 
		 return returnStr ; 
	 }
	 
	 public static boolean isImageFile(String fileName){
		 boolean isFlag = false ; 
		 
		 String ext = getExt(fileName) ; 
		 
		 if(
				 ext.equals(".gif") ||
				 ext.equals(".jpg") ||
				 ext.equals(".png") ||
				 ext.equals(".bmp") ||
				 ext.equals(".jpeg") 
		){
			 isFlag = true ; 
		 }
		 
		 return isFlag; 
	 }
	 //vo -> map 변환
	public static Map ConverObjectToMap(Object obj) {
		Map resultMap = new HashMap();
		try {
			Field[] fields = obj.getClass().getDeclaredFields();
			for (int i = 0; i <= fields.length - 1; i++) {
				fields[i].setAccessible(true);
				resultMap.put(fields[i].getName(), fields[i].get(obj));
			}
			
		} catch (Exception e) {
			resultMap.clear();
		}
		return resultMap;
	}
	// map -> vo 변환
	public static Object convertMapToObject(Map map, Object objClass) throws Exception {
		String keyAttribute = null;
		String setMethodString = "set";
		String methodString = null;
		Iterator itr = map.keySet().iterator();
		while (itr.hasNext()) {
			keyAttribute = (String) itr.next();
			methodString = setMethodString + keyAttribute.substring(0, 1).toUpperCase() + keyAttribute.substring(1);
			Method[] methods = objClass.getClass().getDeclaredMethods();
			for (int i = 0; i <= methods.length - 1; i++) {
				if (methodString.equals(methods[i].getName())) {
					// System.out.println("invoke : " + methodString);
					methods[i].invoke(objClass, map.get(keyAttribute));
				}
			}
		}
		return objClass;
	}

	public static String maxTestCaseCode(String gbn , String max){
		 String returnStr = "" ; 
		 
		 try{
			 
			 if("TS".equals(gbn)){
				 if("".equals(normalizeNull(max))) returnStr = "CTS_1" ;
				 else {
					 max = max.replaceAll("CTS_", "") ; 
					 int maxNum = Integer.parseInt(max) + 1 ; 
					 
					 returnStr = "CTS_" + maxNum ;
				 }
			 }else if("TC".equals(gbn)){
				 if("".equals(normalizeNull(max))) returnStr = "CTC_1" ;
				 else {
					 max = max.replaceAll("CTC_", "") ; 
					 int maxNum = Integer.parseInt(max) + 1 ; 
					 
					 returnStr = "CTC_" + maxNum ;
				 } 
			 }
			 
		 }catch(Exception e){ returnStr = "" ; }
		 
		 return returnStr ; 
	 }

	
}
