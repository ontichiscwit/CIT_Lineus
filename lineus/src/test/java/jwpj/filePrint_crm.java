package jwpj;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class filePrint_crm {

	private Calendar check;
	private String targetFolder;
	public filePrint_crm(String compareTime, String targetFolder){
		check = Calendar.getInstance();
		check.set(Integer.parseInt(compareTime.substring(0, 4)), 
				Integer.parseInt(compareTime.substring(4, 6)) - 1,
				Integer.parseInt(compareTime.substring(6, 8)),
				Integer.parseInt(compareTime.substring(8, 10)),
				Integer.parseInt(compareTime.substring(10, 12)),
				Integer.parseInt(compareTime.substring(12, 14))
				);
		this.targetFolder = targetFolder;
		File file = new File(targetFolder);
		file.mkdirs();
	}
	public void print(File file){
		File[] files = file.listFiles();
		for (int i = 0; i < files.length; i++) {
			if(files[i].isDirectory()){
				print(files[i]);
			} else {
				String path = files[i].getAbsolutePath();
				if(path.indexOf("\\SVN\\") != -1){
					continue;
				}
				if(path.indexOf("\\Entries\\") != -1){
					continue;
				}
				
				
				path = replace(path, "E:\\cwit\\crm\\jwcrm", ""); //현재 프로젝트 경로
				//path = replace(path, "C:\\Users\\pjh\\Desktop\\eGovFrameDev-3.6.0-64bit\\workspace\\jwpj\\src\\main\\webapp\\WEB-INF\\classes", "");
				
				path = replace(path, "\\", "/");
				java.util.Date date = new java.util.Date(files[i].lastModified());
				Calendar fileCal = Calendar.getInstance();
				fileCal.setTime(date);
				if(fileCal.after(check)){
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					try{
						
						String targetFile = targetFolder + "\\webapp" + path;
						
						targetFile = replace(targetFile, "/", "\\");
						copy(files[i], new File(targetFile));
					} catch(Exception e){
						e.printStackTrace();
					}
					
					// System.out.println(path);
				}
			}
		}
	}
	
	public void copy(File fOrg, File fTarget) {
		try{
			FileInputStream io = new FileInputStream(fOrg);
			if(!fTarget.isFile()){
				File fParent = new File(fTarget.getParent());
				 if(!fParent.exists()){
					fParent.mkdirs();
				}
				fTarget.createNewFile();
			}
			
			FileOutputStream out = new FileOutputStream(fTarget);
			byte[] bBuffer = new byte[1024*8];
			
			int nRead;
			
			while((nRead = io.read(bBuffer)) != -1){
				out.write(bBuffer, 0, nRead);
			}
			io.close();
			out.close();
			
			fTarget.setLastModified(fOrg.lastModified());
		} catch (FileNotFoundException e) {
			// System.out.println("Copy ���� : " + fOrg.getAbsolutePath());
		} catch (IOException e) {
			// System.out.println("���ϻ���� : " + fTarget.getAbsolutePath());
		}
	}	
	

	/**
	 * <pre>
	 * ��� String ���� Ư�� String�� ã�Ƽ� �ٸ� String���� ��ü�Ͽ� return
	 * </pre>
	 * @param str		��� String
	 * @param from		from ã�� String
	 * @param to		to ġȯ�� String
	 * @return String
	 * @throws Exception
	 */
	public static String replace(String str, String from, String to) 
	{
		String sResult = "";
		try
		{
			if (str == null
				|| str.length() == 0
				|| from == null
				|| from.length() == 0
				|| to == null)
				return str;

			StringBuffer sb = null;			
			
			sb = new StringBuffer(str.length() * 2);
			String poFilePrinttring = str.toLowerCase();
			String cmpString = from.toLowerCase();
			int i = 0;
			boolean done = false;
			while (i < str.length() && !done)
			{
				int start = poFilePrinttring.indexOf(cmpString, i);
				if (start == -1)
				{
					done = true;
				}
				else
				{
					sb.append(str.substring(i, start) + to);
					i = start + from.length();
				}
			}
			if (i < str.length())
			{
				sb.append(str.substring(i));
			}

			sResult = sb.toString();
		}
		catch(Exception e) {
			sResult  = str;
		}
		finally
		{
			
		}

		return sResult;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String now="09-17-20";
		//String now="31-16-49";		 
		filePrint_crm fp = new filePrint_crm("201711"+now.replaceAll("-", "")+"00", "E:\\cwit\\FilePrintws\\jwcrm\\2017-11-"+now);	//yyyyMMddHHmmFilePrint
		//class파일 카피되는 경로
		
		
		// System.out.println("\n\n\n\n----------------------jwpj--------------------------");
		//fp.print(new File("C:\\Users\\pjh\\Desktop\\eGovFrameDev-3.6.0-64bit\\workspace\\jwpj\\src\\main\\resources\\layout"));
		//fp.print(new File("C:\\Users\\pjh\\Desktop\\eGovFrameDev-3.6.0-64bit\\workspace\\jwpj\\src\\main\\resources\\query"));
		fp.print(new File("E:\\cwit\\crm\\jwcrm\\src\\main\\webapp")); //현재 프로젝트 파일 경로
		fp.print(new File("E:\\cwit\\crm\\jwcrm\\target")); //현재 프로젝트 파일 경로

	}
}

