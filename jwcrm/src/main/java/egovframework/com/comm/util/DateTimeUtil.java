package egovframework.com.comm.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

/**
 * <B>DateTimeUtil.java<B><br>
 * 
 * @author  정철구
 * @version V1.0    2012.02.01	정철구 최초 작성 
 */
public class DateTimeUtil {
	
	/**
	 * YYYYMM 
	 */
	public static String getMonth(){
		String month;

 		Calendar cal = Calendar.getInstance(Locale.getDefault());

 		StringBuffer buf = new StringBuffer();

 		buf.append(Integer.toString(cal.get(Calendar.YEAR)));
 		month = Integer.toString(cal.get(Calendar.MONTH)+1);
 		if(month.length() == 1) month = "0" + month;
 		
 		buf.append(month);
 		
		return buf.toString();
	}
	
	/**
	 * YYYYMMDD   
	 */
	public static String getDate(){
		String month, day;

 		Calendar cal = Calendar.getInstance(Locale.getDefault());

 		StringBuffer buf = new StringBuffer();

 		buf.append(Integer.toString(cal.get(Calendar.YEAR)));
 		month = Integer.toString(cal.get(Calendar.MONTH)+1);
 		if(month.length() == 1) month = "0" + month;
 		day = Integer.toString(cal.get(Calendar.DATE));
 		if(day.length() == 1) day = "0" + day;

 		buf.append(month);
 		buf.append(day);

		return buf.toString();
	}

	/**
	 * HH:MI:SS 
	 */
	public static String getTimeText(String szTime)
	{
		if(szTime == null || szTime.length() < 6) return "";
		String hour = StringUtil.substring(szTime,0, 2);
		String minute = StringUtil.substring(szTime, 2, 4);
		String second = StringUtil.substring(szTime,4, 6);
		
		return hour + ":" + minute + ":" + second;
	}

	/**
	 * HHMISS 
	 */
	public static String getTime(){
		String hour, min, sec;

 		Calendar cal = Calendar.getInstance(Locale.getDefault());

 		StringBuffer buf = new StringBuffer();

 		hour = Integer.toString(cal.get(Calendar.HOUR_OF_DAY));
 		if(hour.length() == 1) hour = "0" + hour;

 		min = Integer.toString(cal.get(Calendar.MINUTE));
 		if(min.length() == 1) min = "0" + min;

 		sec = Integer.toString(cal.get(Calendar.SECOND));
 		if(sec.length() == 1) sec = "0" + sec;

 		buf.append(hour);
 		buf.append(min);
 		buf.append(sec);

		return buf.toString();
	}

	/**
	 * YYYY/MM/DD 
	 */
	public static String getDateText(String szdate)
	{
		String reDate = "";
		if(szdate != null && szdate.length() >= 8){			
			String year = szdate.substring(0, 4);
			String month = szdate.substring(4, 6);
			String day = szdate.substring(6, 8);
		
			reDate = year + "/" + month + "/" + day;
		}	
		return reDate;
	}

	/**
	 *  YYYY/MM/DD HH:MI:SS
	 * @param dateTime :  YYYYMMDD HHMISS
	 */
	public static String getDateTimeText(String dateTime)
	{
		if (dateTime == null || dateTime.length() < 14) {
			return "";
		}
		
		return getDateText(StringUtil.substring(dateTime, 0, 8)) + " " + getTimeText(StringUtil.substring(dateTime, 8, 14));
	}

	/**
	 * YYYY/MM/DD 
	 */
	public static String getDateText(){
		String month, day;

 		Calendar cal = Calendar.getInstance(Locale.getDefault());
 	
 		StringBuffer buf = new StringBuffer();

 		buf.append(Integer.toString(cal.get(Calendar.YEAR)));
 		month = Integer.toString(cal.get(Calendar.MONTH)+1);
 		if(month.length() == 1) month = "0" + month;

 		day = Integer.toString(cal.get(Calendar.DATE));
 		if(day.length() == 1) day = "0" + day;

 		buf.append("/");
 		buf.append(month);
 		buf.append("/");
 		buf.append(day);
		return buf.toString();
	}
	
	/**
	 * 
	 * @param param     
	 * @param format    (".","/","-")	 	 	 	 	 	 	 
	 * @return   
	 */			
	public static String getDateFormatText(String param,String format){
		String reDate = "";
		if(param != null && param.length() >= 8){			
			String year = param.substring(0, 4);
			String month = param.substring(4, 6);
			String day = param.substring(6, 8);
		
			reDate = year + format + month + format + day;
		} else if(param != null && param.length() >= 4){			
			String year = param.substring(0, 4);
			String month = param.substring(4, 6);
		
			reDate = year + format + month;
		}		
		return reDate;
	}
	
	/**
	 * HH:MI:SS 
	 */
	public static String getTimeText(){
		String hour, min, sec;

 		Calendar cal = Calendar.getInstance(Locale.getDefault());

 		StringBuffer buf = new StringBuffer();

 		hour = Integer.toString(cal.get(Calendar.HOUR_OF_DAY));
 		if(hour.length() == 1) hour = "0" + hour;
 		hour += ":";

 		min = Integer.toString(cal.get(Calendar.MINUTE));
 		if(min.length() == 1) min = "0" + min;
 		min += ":";

 		sec = Integer.toString(cal.get(Calendar.SECOND));
 		if(sec.length() == 1) sec = "0" + sec;

 		buf.append(hour);
 		buf.append(min);
 		buf.append(sec);

		return buf.toString();
	}


	/**
	 * YYYYMMDDHHMISS  
	 */
	public static String getDateTime(){
		return getDate() + getTime();
	}	
	public static String getDateTimeText(){
		return getDateText() + getTimeText();
	}	

	/**
	 * 
	 * @param DateTime 			YYMMDDHHMMSS
	 * @param plusDay 			 	 	 	 	 	 	 	 
	 * @return   
	 */		
	public static String getAddTime(String DateTime, int plusDay){
		if(DateTime == null || DateTime.length() < 8)
			return DateTime;

		if (DateTime.equals("99991231235959")){
			return "99991231235959";
		}
		int y = Integer.parseInt(DateTime.substring(0,4));
		int m = Integer.parseInt(DateTime.substring(4,6));
		int d = Integer.parseInt(DateTime.substring(6,8));

      	java.util.GregorianCalendar sToday = new java.util.GregorianCalendar ();
		sToday.set(y,m-1,d);       
       	sToday.add(GregorianCalendar.DAY_OF_MONTH, plusDay);
       
        int day = sToday.get(GregorianCalendar.DAY_OF_MONTH);
       	int month = sToday.get(GregorianCalendar.MONTH)+1;
       	int year = sToday.get(GregorianCalendar.YEAR);
       
       String sNowyear =  String.valueOf(year);
       String sNowmonth = "";
       String sNowday = "";
       
       if (month < 10)  
         sNowmonth =  "0" + String.valueOf(month);
       else    
         sNowmonth = String.valueOf(month);
        
	     if (day < 10) 
	       sNowday = "0" +  String.valueOf(day);
	     else
	       sNowday = String.valueOf(day);  
      
        return sNowyear+sNowmonth+sNowday+DateTime.substring(8);

	}
	
	/**
	 * 포멧 적용한 날짜
	 * @param DateTime 			YYMMDDHHMMSS
	 * @param plusDay 			증가할 날짜 	 	 	 	 	 	 	 
	 * @return 2012-02-17
	 */		
	public static String getAddTime(String DateTime, int plusDay, String fm){
		if(DateTime == null || DateTime.length() < 8)
			return DateTime;
		
		if (DateTime.equals("99991231235959")){
			return "99991231235959";
		}
		int y = Integer.parseInt(DateTime.substring(0,4));
		int m = Integer.parseInt(DateTime.substring(4,6));
		int d = Integer.parseInt(DateTime.substring(6,8));
		
		java.util.GregorianCalendar sToday = new java.util.GregorianCalendar ();
		sToday.set(y,m-1,d);       
		sToday.add(GregorianCalendar.DAY_OF_MONTH, plusDay);
		
		int day = sToday.get(GregorianCalendar.DAY_OF_MONTH);
		int month = sToday.get(GregorianCalendar.MONTH)+1;
		int year = sToday.get(GregorianCalendar.YEAR);
		
		String sNowyear =  String.valueOf(year);
		String sNowmonth = "";
		String sNowday = "";
		
		if (month < 10)  
			sNowmonth =  "0" + String.valueOf(month);
		else    
			sNowmonth = String.valueOf(month);
		
		if (day < 10) 
			sNowday = "0" +  String.valueOf(day);
		else
			sNowday = String.valueOf(day);  
		
		return sNowyear+fm+sNowmonth+fm+sNowday+DateTime.substring(8);
		
	}

	/**
	 * 
	 * @param DateTime 			YYMMDDHHMMSS
	 * @param plusDay 			 	 	 	 	 	 	 	 
	 * @return   
	 */		
	public static String getAddDay(String DateTime, int plusDay){

		if (DateTime == null)
			return "";
		
		if (DateTime.length() == 8 )	
			DateTime += "000000";
			
		if (DateTime.equals("99991231")){
			return "99991231000000";
		}	
		
		if (DateTime.equals("99991231235959")){
			return "99991231235959";
		}	
		
		int y = Integer.parseInt(DateTime.substring(0,4));
		int m = Integer.parseInt(DateTime.substring(4,6));
		int d = Integer.parseInt(DateTime.substring(6,8));

      	java.util.GregorianCalendar sToday = new java.util.GregorianCalendar ();
		sToday.set(y,m-1,d);       
       	sToday.add(GregorianCalendar.DAY_OF_MONTH, plusDay);
       
        int day = sToday.get(GregorianCalendar.DAY_OF_MONTH);
       	int month = sToday.get(GregorianCalendar.MONTH)+1;
       	int year = sToday.get(GregorianCalendar.YEAR);
       
       String sNowyear =  String.valueOf(year);
       String sNowmonth = "";
       String sNowday = "";
       
       if (month < 10)  
         sNowmonth =  "0" + String.valueOf(month);
       else    
         sNowmonth = String.valueOf(month);
        
	     if (day < 10) 
	       sNowday = "0" +  String.valueOf(day);
	     else
	       sNowday = String.valueOf(day);  
      
       return sNowyear+sNowmonth+sNowday+DateTime.substring(8,14);

	}

	/**
	 * 
	 * @param DateTime 			YYMMDDHHMMSS
	 * @param plusMonth 			 	 	 	 	 	 	 	 
	 * @return   
	 */		
	public static String getAddMonth(String DateTime, int plusMonth){

		if (DateTime == null)
			return "";
		
		if (DateTime.length() == 8 )	
			DateTime += "000000";
			
		if (DateTime.equals("99991231")){
			return "99991231000000";
		}	
		
		if (DateTime.equals("99991231235959")){
			return "99991231235959";
		}	
		
		int y = Integer.parseInt(DateTime.substring(0,4));
		int m = Integer.parseInt(DateTime.substring(4,6));
		int d = Integer.parseInt(DateTime.substring(6,8));

		java.util.GregorianCalendar sToday = new java.util.GregorianCalendar ();
		sToday.set(y,m-1,d);       
		sToday.add(GregorianCalendar.MONTH , plusMonth);
       
		int day = sToday.get(GregorianCalendar.DAY_OF_MONTH);
		int month = sToday.get(GregorianCalendar.MONTH)+1;
		int year = sToday.get(GregorianCalendar.YEAR);
       
	   String sNowyear =  String.valueOf(year);
	   String sNowmonth = "";
	   String sNowday = "";
       
	   if (month < 10)  
		 sNowmonth =  "0" + String.valueOf(month);
	   else    
		 sNowmonth = String.valueOf(month);
        
		 if (day < 10) 
		   sNowday = "0" +  String.valueOf(day);
		 else
		   sNowday = String.valueOf(day);  
      
	   return sNowyear+sNowmonth+sNowday+DateTime.substring(8,14);

	}
	
	/**
	 * 
	 * @param sType			YY, MM, DD, HH, MI, SS
	 * @param iGap 			
	 * @return 
	 */
	public static String getGapDateTime(String sType, int iGap){
		String year, month, day, hour, min, sec;

 		Calendar calendar = Calendar.getInstance(Locale.getDefault());
 		StringBuffer buf = new StringBuffer();

		if(sType.equals("SS"))
			calendar.add(Calendar.SECOND, iGap);
 		sec = Integer.toString(calendar.get(Calendar.SECOND));
 		if(sec.length() == 1) sec = "0" + sec;

		if(sType.equals("MI"))
			calendar.add(Calendar.MINUTE, iGap);
 		min = Integer.toString(calendar.get(Calendar.MINUTE));
 		if(min.length() == 1) min = "0" + min;

		if(sType.equals("HH"))
			calendar.add(Calendar.HOUR_OF_DAY, iGap);
 		hour = Integer.toString(calendar.get(Calendar.HOUR_OF_DAY));
 		if(hour.length() == 1) hour = "0" + hour;

		if(sType.equals("DD"))
			calendar.add(Calendar.DATE, iGap);
 		day = Integer.toString(calendar.get(Calendar.DATE));
 		if(day.length() == 1) day = "0" + day;

		if(sType.equals("MM"))
			calendar.add(Calendar.MONTH, iGap);
 		month = Integer.toString(calendar.get(Calendar.MONTH)+1);
 		if(month.length() == 1) month = "0" + month;

		if(sType.equals("YY"))
			calendar.add(Calendar.YEAR, iGap);
 		year = Integer.toString(calendar.get(Calendar.YEAR));

		buf.append(year);
 		buf.append(month);
 		buf.append(day);
 		buf.append(hour);
 		buf.append(min);
 		buf.append(sec);
 		
 		return buf.toString();
	}

	/**
	 * YYYYMMDD 
	 */
	public static String getYesterday(){
      	java.util.GregorianCalendar sToday = new java.util.GregorianCalendar ();
		sToday.add(GregorianCalendar.DAY_OF_MONTH, -1);
       
        int day = sToday.get(GregorianCalendar.DAY_OF_MONTH);
       	int month = sToday.get(GregorianCalendar.MONTH)+1;
       	int year = sToday.get(GregorianCalendar.YEAR);
       
       String sNowyear =  String.valueOf(year);
       String sNowmonth = "";
       String sNowday = "";
       
       if (month < 10)  
         sNowmonth =  "0" + String.valueOf(month);
       else    
         sNowmonth = String.valueOf(month);
        
	     if (day < 10) 
	       sNowday = "0" +  String.valueOf(day);
	     else
	       sNowday = String.valueOf(day);  

      	return sNowyear + sNowmonth + sNowday;
	}
	
	/**
	 * YYYYMMDD 
	 */
	public static String getTomorrow(){
      	java.util.GregorianCalendar sToday = new java.util.GregorianCalendar ();
		sToday.add(GregorianCalendar.DAY_OF_MONTH, 1);
       
        int day = sToday.get(GregorianCalendar.DAY_OF_MONTH);
       	int month = sToday.get(GregorianCalendar.MONTH)+1;
       	int year = sToday.get(GregorianCalendar.YEAR);
       
       String sNowyear =  String.valueOf(year);
       String sNowmonth = "";
       String sNowday = "";
       
       if (month < 10)  
         sNowmonth =  "0" + String.valueOf(month);
       else    
         sNowmonth = String.valueOf(month);
        
	     if (day < 10) 
	       sNowday = "0" +  String.valueOf(day);
	     else
	       sNowday = String.valueOf(day);  

      	return sNowyear + sNowmonth + sNowday;
	}
	

	/**
	 * YYYYMMDD
	 * @param cal -  
	 */
	public static String getDate(Calendar cal ){
		String month, day;

 		StringBuffer buf = new StringBuffer();

 		buf.append(Integer.toString(cal.get(Calendar.YEAR)));
 		month = Integer.toString(cal.get(Calendar.MONTH)+1);
 		if(month.length() == 1) month = "0" + month;
 		day = Integer.toString(cal.get(Calendar.DATE));
 		if(day.length() == 1) day = "0" + day;

 		buf.append(month);
 		buf.append(day);

		return buf.toString();
	}

	/**
	 *	1900 - 9999, 01 - 12, 01 - 31, 00 - 23, 00 - 59, 00 - 59
	 *
	 *	@param param		
	 *
	 *	@return 
	 */
	public static boolean isDateTime(String param){
		if(param == null || param.length() != 14)
			return false;
			
		if(isDate(param.substring(0,8)) && isTime(param.substring(8,14)))
			return true;
		else
			return false;
	}

	/**
	 *	1900 - 9999, 01 - 12, 01 - 31, 00 - 23, 00 - 59, 00 - 59
	 *
	 *	@param param		
	 *
	 *	@return 
	 */
	public static boolean isDate(String param){
		if(param == null || param.length() != 8)
			return false;
		
		try{
			int year = Integer.parseInt(param.substring(0,4));
			int month = Integer.parseInt(param.substring(4,6));
			int day = Integer.parseInt(param.substring(6,8));
			
			if(year < 1900 || year > 9999) return false;
			if(month < 1 || month > 12) return false;
			if(day < 1 || day > 31) return false;
			
			return true;
		}catch(Exception e){
			return false;
		}
	}

	/**
	 *	1900 - 9999, 01 - 12, 01 - 31, 00 - 23, 00 - 59, 00 - 59
	 *
	 *	@param param		
	 *
	 *	@return 
	 */
	public static boolean isTime(String param){
		if(param == null || param.length() != 6)
			return false;
		
		try{
			int hour = Integer.parseInt(param.substring(0,2));
			int min = Integer.parseInt(param.substring(2,4));
			int sec = Integer.parseInt(param.substring(4,6));
			
			if(hour < 0 || hour > 23) return false;
			if(min < 0 || min > 59) return false;
			if(sec < 0 || sec > 59) return false;
			
			return true;
		}catch(Exception e){
			return false;
		}
	}
	public static Timestamp getTimestamp(String szDate){
		if(StringUtil.isNull(szDate)) return null;
		
		String pattern = "";

		if(szDate.length() == 14 && szDate.indexOf("/") < 0 && szDate.indexOf(":") < 0 && szDate.indexOf("-") < 0){
			pattern = "yyyyMMddHHmmss";
		}else{
			pattern = "yyyy-MM-dd HH:mm:ss"; //2005-11-28 11:58:31.0
		}

		if(szDate.indexOf(".") > 0) szDate = szDate.substring(0,szDate.indexOf("."));
		
		return new Timestamp(DateTimeUtil.getDate(szDate,pattern).getTime());
	}
	/**
	 * 
	 * @param szDate
	 * @return Date
	 */
	public static Date getDate(String szDate)
	{
		return getDate(szDate,"yyyyMMddHHmmss");
	}

	/**
	 * 
	 * 
	 * Time Format Syntax:
	 *  		Symbol   Meaning                 Presentation        Example
			 ------   -------                 ------------        -------
			 G        era designator          (Text)              AD
			 y        year                    (Number)            1996
			 M        month in year           (Text & Number)     July & 07
			 d        day in month            (Number)            10
			 h        hour in am/pm (1~12)    (Number)            12
			 H        hour in day (0~23)      (Number)            0
			 m        minute in hour          (Number)            30
			 s        second in minute        (Number)            55
			 S        millisecond             (Number)            978
			 E        day in week             (Text)              Tuesday
			 D        day in year             (Number)            189
			 F        day of week in month    (Number)            2 (2nd Wed in July)
			 w        week in year            (Number)            27
			 W        week in month           (Number)            2
			 a        am/pm marker            (Text)              PM
			 k        hour in day (1~24)      (Number)            24
			 K        hour in am/pm (0~11)    (Number)            0
			 z        time zone               (Text)              Pacific Standard Time
			 '        escape for text         (Delimiter)
			 ''       single quote            (Literal)           '
	 * @param szDate
	 * @param dateFormat
	 * @return Date
	 */
	public static Date getDate(String szDate, String dateFormat)
	{
		Date d = null;
		try
		{
			SimpleDateFormat df = new SimpleDateFormat(dateFormat);
			d = df.parse(szDate);
			
		} catch(Exception e)
		{
			// ignore;
		}
		return d;
	}	

	public static int getCurrentYear()
	{
		Calendar cal = Calendar.getInstance(Locale.getDefault());
		return cal.get(Calendar.YEAR);
	}


	public static String getDateText(Date szDate){
		return getDateText(szDate, "yyyy/MM/dd");
	}

	public static String getDateTimeText(Date szDate){
		return getDateText(szDate, "yyyy/MM/dd HH:mm:ss");
	}
	
	public static String getDateText(Date szDate, String dateFormat)
	{
		String d = "";
		try
		{
			SimpleDateFormat df = new SimpleDateFormat(dateFormat);
			d = df.format(szDate);
			
		} catch(Exception e)
		{
			// ignore;
		}
		return d;
	}
	
	/**
	 *	
	 *
	 *	@return sta_day
	 */
	public static String getLastDay()
	{
		GregorianCalendar today = new GregorianCalendar();
		int maxday = today.getActualMaximum((today.DAY_OF_MONTH));
		return Integer.toString(maxday);

	}
	
	/**
	 *	
	 *
	 *	@param day		
	 *  ex) getLastDay(200801)
	 *	@return 
	 */
	public static String getLastDay(String day)
	{
		Calendar cal = Calendar.getInstance();
        int yyyy = Integer.parseInt(day.substring(0, 4));
        int mm = Integer.parseInt(day.substring(4)) - 1;

        cal.set(yyyy, mm, 1);
        return Integer.toString(cal.getActualMaximum(Calendar.DAY_OF_MONTH));


	}

	/**
	 *	String 
	 *
	 *	@param begin 
	 *         end   
	 *  ex) diffOfDate(20090717,20070817)
	 *  
	 *	@return diff
	 */	
	
	public static long diffOfDate(String begin, String end) throws Exception
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	
		Date beginDate = formatter.parse(begin);

		Date endDate = formatter.parse(end);

		long diff = endDate.getTime() - beginDate.getTime();
		
		long diffDays = diff / (24 * 60 * 60 * 1000);
	
		return diffDays;
	}
	
	public static long diffOfTune(String begin, String end) throws Exception
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		
		Date beginDate = formatter.parse(begin);
		
		Date endDate = formatter.parse(end);
		
		
		
		long mills = endDate.getTime() - beginDate.getTime();
		
		long diffTime = mills / 60000 ;
		
		return diffTime / 60;
	}	
	
	public static Date check(String s, String format) throws java.text.ParseException {
		if ( s == null )
			throw new java.text.ParseException("date string to check is null", 0);
		if ( format == null )
			throw new java.text.ParseException("format string to check date is null", 0);

		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat (format, Locale.KOREA);
		Date date = null;
		try {
			date = formatter.parse(s);
		}
		catch(java.text.ParseException e) {
            throw new java.text.ParseException(" wrong date:\"" + s +
            "\" with format \"" + format + "\"", 0);
		}

		if ( ! formatter.format(date).equals(s) )
			throw new java.text.ParseException(
				"Out of bound date:\"" + s + "\" with format \"" + format + "\"",
				0
			);
        return date;
	}
	
	/**
	 *  날짜 검색 관련 공통 
	 */
	
	public static String addMonths(String s, int addMonth, String format) throws Exception {
 		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat (format, Locale.KOREA);
		Date date = check(s, format);

 		java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat("yyyy", Locale.KOREA);
 		java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MM", Locale.KOREA);
 		java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("dd", Locale.KOREA);
        int year = Integer.parseInt(yearFormat.format(date));
        int month = Integer.parseInt(monthFormat.format(date));
        int day = Integer.parseInt(dayFormat.format(date));

        month += addMonth;
        if (addMonth > 0) {
            while (month > 12) {
                month -= 12;
                year += 1;
            }
        } else {
            while (month <= 0) {
                month += 12;
                year -= 1;
            }
        }
 		java.text.DecimalFormat fourDf = new java.text.DecimalFormat("0000");
 		java.text.DecimalFormat twoDf = new java.text.DecimalFormat("00");
        String tempDate = String.valueOf(fourDf.format(year))
                         + String.valueOf(twoDf.format(month))
                         + String.valueOf(twoDf.format(day));
        Date targetDate = null;

        try {
            targetDate = check(tempDate, "yyyyMMdd");
        } catch(java.text.ParseException pe) {
            day = lastDay(year, month);
            tempDate = String.valueOf(fourDf.format(year))
                         + String.valueOf(twoDf.format(month))
                         + String.valueOf(twoDf.format(day));
            targetDate = check(tempDate, "yyyyMMdd");
        }

        return formatter.format(targetDate);
    }
	
    private static int lastDay(int year, int month) throws java.text.ParseException {
        int day = 0;
        switch(month)
        {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12: day = 31;
                     break;
            case 2: if ((year % 4) == 0) {
                        if ((year % 100) == 0 && (year % 400) != 0) { day = 28; }
                        else { day = 29; }
                    } else { day = 28; }
                    break;
            default: day = 30;
        }
        return day;
    }
    
    public static String toDate(String cal,String format){
        String strDate="";
        String year = "0";
        String month = "0";
        String date = "0";
        String hour = "0";
        String min = "0";
        String sec = "0";

        try{
        	cal = SsStringUtil.normalizeNull(cal);
        	if(!cal.trim().equals("")){
	            strDate = cal.replaceAll("[^0-9]", "");
	            if(strDate.length() >= 4) year = strDate.substring(0,4);
	            if(strDate.length() >= 6) month = strDate.substring(4,6);
	            if(strDate.length() >= 8) date = strDate.substring(6,8);
	            if(strDate.length() >=10) hour = strDate.substring(8,10);
	            if(strDate.length() >=12) min= strDate.substring(10,12);
	            if(strDate.length() >=14) sec = strDate.substring(12,14);
	            strDate = toDate(Integer.parseInt(year),Integer.parseInt(month)-1,Integer.parseInt(date),Integer.parseInt(hour),Integer.parseInt(min),Integer.parseInt(sec),format);

        	}else{
            	strDate = "";
            }
        }catch(Exception e){
            strDate="";
        }

        return strDate;
    }
    
    public static String toDate(Calendar cal,String format){
		String strDate="";
		try{
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			strDate = sdf.format(cal.getTime());
		}catch(Exception e){
			strDate="";
		}
		return strDate;
	}
    
    public static String toDate(int year,int month,int date,int hour,int min,int sec,String format){
        String strDate="";
        try{
        Calendar cal= Calendar.getInstance();
        cal.set(year,month,date,hour,min,sec);
        strDate=toDate(cal,format);
        }catch(Exception e){
            strDate="";
        }
        return strDate;
    }
    
    public static String toDate(String format){
		String strDate="";
		try{
		Calendar c = Calendar.getInstance();
		strDate = toDate(c,format);
		}catch(Exception e){
			strDate="";
		}
		return strDate;
	}
    
    public static String toFirstDate(){
    	String strDate="";
    	String format = "yyyy-MM" ; 
		try{
		Calendar c = Calendar.getInstance();
		strDate = toDate(c,format);
		strDate = strDate + "-01" ; 
		}catch(Exception e){
			strDate="";
		}
		return strDate;
    }
    
    public static String rssDateChange(String pubdate){
    	
    	String returnStr = "" ; 
    	
    	try{
    	
    		// Wed, 09 Oct 2013 22:22:11 +0900
    		
		 Date time = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss", Locale.ENGLISH).parse(pubdate);
		 
		 String todate = getDateTime() ; 
		 
		 String timedate = new SimpleDateFormat("yyyyMMddHHmmss").format(time);
		 
		 long diffOfDate = diffOfDate(timedate , todate) ;
		 
		 long diffOfTime = diffOfTune(timedate, todate) ; 
		 
		 if(diffOfDate == 0) returnStr =  diffOfTime + "시간 전" ; 
		 else returnStr = diffOfDate + "일 전" ; 
		 
		 String rssFormat = new SimpleDateFormat("yyyy년 MM월 dd일").format(time);
		 
		 returnStr = rssFormat +" " + returnStr ; 
		 
    	}catch(Exception e){
    	}
    	
    	return returnStr ; 
    }
    
    public static int calcMonth(String start_date , String end_date){
    	int between = 0 ; 
    	
    	try{
    		if("".equals(SsStringUtil.normalizeNull(start_date))) return -1 ; 
        	if("".equals(SsStringUtil.normalizeNull(end_date))) return -1 ;
        	
        	start_date = start_date.replaceAll("/" , "") ; 
        	end_date = end_date.replaceAll("/" , "") ; 

        	SimpleDateFormat format = new SimpleDateFormat("yyyyMM") ; 

        	Date date1 = format.parse(start_date) ;
        	Date date2 = format.parse(end_date) ; 
        	
        	long interval = date2.getTime() - date1.getTime() ;
        	long day = 1000 * 60 * 60 * 24 ; 
        	long month = day * 30 ; 
        	
        	between = (int)(interval / month) ; 
        	
    	}catch(Exception e){
    		e.printStackTrace();
    		return - 1 ; 
    	}
    	
    	return between ; 
    }
    
    public static String addMon(String start_date , int num){
    	String returnStr = "" ; 
    	
    	try{
    		if("".equals(SsStringUtil.normalizeNull(start_date))) return "" ; 
        	
        	start_date = start_date.replaceAll("/" , "") ; 

        	int y = Integer.parseInt(start_date.substring(0,4));
    		int m = Integer.parseInt(start_date.substring(4,6));
        	
    		java.util.GregorianCalendar sToday = new java.util.GregorianCalendar ();
    		
    		sToday.set(y, m - 1, 1);
    		sToday.add(GregorianCalendar.MONTH, num);
    		
    		int month = sToday.get(GregorianCalendar.MONTH) + 1 ; 
    		int year = sToday.get(GregorianCalendar.YEAR) ; 
    		
    		returnStr = String.valueOf(year) + "/" + (month < 10 ? "0" + month : String.valueOf(month)) ;  
        	
    	}catch(Exception e){
    		e.printStackTrace();
    		return "" ; 
    	}
    	
    	return returnStr ; 
    }
    
}

