package egovframework.com.comm.util;

import java.net.URLEncoder;

import egovframework.com.comm.JwConstants;
import egovframework.com.comm.model.UserVO;
import egovframework.com.model.AsVO;

public class SendMailForm {
		
	/**	회원 메일	*/
	public static String makeMemberMail(UserVO vo) {
		StringBuffer sb = new StringBuffer() ; 
		
		if(vo != null) {
			sb.append("<!DOCTYPE html>");
			sb.append("<html lang=\"en\">");
			sb.append("<head>");
			sb.append("    <meta charset=\"UTF-8\">");
			sb.append("    <title>Document</title>");
			sb.append("</head>");
			sb.append("<body>");
			sb.append("    <div style=\"max-width: 750px; margin: 0 auto; padding-top: 30px; font-size: 12px;\">");
			sb.append("        <div style=\"text-align: center;\">");
			sb.append("            <img src=\""+JwConstants.SITE_ADDR+"/images/front/logo.png\" alt=\"\">");
			
			/**	가입 승인 불가	*/
			if("wrong".equals(SsStringUtil.normalizeNull(vo.getPageType()))) {
				sb.append("            <h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">가입신청 불가</h1>");
				sb.append("            <p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				sb.append("            본 메일은 중외정보기술에서 제공하는 ONTIC LineUs에서<br>고객님께서 신청하신 계정 가입 신청에 대한 미승인 완료 안내 메일입니다.");
				sb.append("            </p>");
				sb.append("            <p style=\"margin-bottom: 20px; color: red; font-weight: bold;\">신청해주신 아래의 정보를 관리자가 확인한 결과,<br>정확한 정보 입력이 되지 않은 사유로 인하여 가입 미승인 처리 되었음을 알려드립니다.<br>확인 후 다시 가입신청을 해 주시면 감사드리겠습니다.</p>");
			/**	탈퇴	*/	
			}else if("finish".equals(SsStringUtil.normalizeNull(vo.getPageType()))) {
				 sb.append("           <h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">계정탈퇴 완료 안내</h1>");
				 sb.append("            <p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				 sb.append("            본 메일은 중외정보기술에서 제공하는 ONTIC LineUs에서<br>고객님께서 신청하신 계정 탈퇴 완료 안내 메일입니다.");
				 sb.append("            </p>");
				 sb.append("            <p style=\"margin-bottom: 20px; color: red; font-weight: bold;\">아래의 정보로 계정 탈퇴 신청 해 주신 결과, 탈퇴 처리가 완료되었습니다.<br>ONTIC LineUs 서비스를 이용해주셔서 감사합니다.</p>");
			/**	승인	*/	
			}else if("confirm".equals(SsStringUtil.normalizeNull(vo.getPageType()))) {
				sb.append("<h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">가입승인 완료</h1>");
				sb.append("<p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				sb.append("본 메일은 중외정보기술에서 제공하는  ONTIC LineUs에서<br>고객님께서 신청하신 계정 가입 승인 완료 안내 메일입니다.");
				sb.append("</p>");
				sb.append("<a href=\""+JwConstants.SITE_ADDR+"\" style=\"text-decoration: none; color: #fff; padding: 10px 20px; background: blue; display: inline-block; border: 1px solid #0075a2; background-color: #0090c8; font-weight: bold;\">서비스 이용하기</a>");
				sb.append("<p style=\"margin-bottom: 20px; color: red; font-weight: bold;\">아래의 정보로 가입 신청 해 주신 결과, 정상적인 가입 승인 처리가 되었습니다.<br> ONTIC LineUs 서비스를 이용해보세요.<br>감사합니다.</p>");
			/**	가입 신청	*/	
			}else if("join".equals(SsStringUtil.normalizeNull(vo.getPageType()))) {
				sb.append("<h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">가입신청 완료</h1>");
				sb.append("<p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				sb.append("본 메일은 중외정보기술에서 제공하는 ONTIC LineUs에서<br>고객님께서 신청하신 계정 가입 신청 완료 안내 메일입니다.");
				sb.append("</p>");
				sb.append("<p style=\"margin-bottom: 20px; color: red; font-weight: bold;\">신청해주신 아래의 정보를 관리자가 확인 및 승인 후<br>별도의 안내 메일을 받으시면 정상적으로 로그인 및 서비스 이용을 하실 수 있습니다.</p>");
			}
			
			
			sb.append("        </div>");
			sb.append("        <table class=\"sType\" style=\"width: 100%; border-top: 2px solid #494949;\">");
			sb.append("            <colgroup>");
			sb.append("                <col style=\"width: 140px;\">");
			sb.append("                <col style=\"width: auto;\">");
			sb.append("            </colgroup>");
			sb.append("            <thead>");
			sb.append("                <th colspan=\"2\" style=\"text-align: center; height: 40px; padding-left: 18px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">가입 신청 정보</th>");
			sb.append("            </thead>");
			sb.append("            <tbody>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">가입신청 일시</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">"+SsStringUtil.normalizeNull(vo.getReg_date())+"</td>");
			sb.append("                </tr>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">회원유형/ID</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>회원유형 : "+("C001".equals(SsStringUtil.normalizeNull(vo.getEmp_grade())) ? "고객사 대표" : "고객사 일반")+"</li>");
			sb.append("                            <li>ID : "+SsStringUtil.normalizeNull(vo.getEmp_id())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">사용자 정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>이름 : "+SsStringUtil.normalizeNull(vo.getEmp_name())+"</li>");
			sb.append("                            <li>근무부서 : "+SsStringUtil.normalizeNull(vo.getDept1_nm())+"</li>");
			sb.append("                            <li>직책 : "+SsStringUtil.normalizeNull(vo.getDept_grade_nm())+"</li>");
			sb.append("                            <li>이메일 : "+SsStringUtil.normalizeNull(vo.getEmail())+"</li>");
			sb.append("                            <li>연락처 : "+SsStringUtil.normalizeNull(vo.getTel_no())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("            </tbody>");
			sb.append("        </table>");
			sb.append("        <h3 style=\"text-align: center; margin: 20px 0; padding: 0; line-height: 1.5em;\">중외정보기술은 고객 만족을 위한<br>빠르고 편리한 서비스를 제공하기 위하여 항상 최선을 다하겠습니다.<br>감사합니다.<br>※본 메일 발신전용 메일입니다.</h3>");
			sb.append("        <hr style=\"margin: 0 0 20px;\" />");
			sb.append("        <p style=\"margin: 0; padding: 0; line-height: 1.5em;\">상위에 기재한 모든 정보는 당시의 ONTIC LineUs에 등록된 사실에 근거하며 고객정보는 중외정보기술 개인정보취급방침에 의거해 서비스 제공용으로 사용할 수 있습니다.</p>");
			sb.append("        <h4 style=\"margin: 20px 0 5px; padding: 0; line-height: 1.5em;\">[개인정보취급방침]</h4>");
			sb.append("        <ul style=\"margin-top: 0; padding-left: 15px;\">");
			sb.append("            <li>위의 정보는 중외정보기술의 <a href=\"#\">개인정보취급방침</a>에 따라 취급되며 마케팅 목적으로 사용되지는 않습니다.</li>");
			sb.append("            <li>ONTIC LineUs는 개인정보취급방침을 수시로 업데이트 할 수 있습니다.</li>");
			sb.append("            <li>본사가 방침에 대해 중요한 변경을 하는 경우, 본사의 ONTIC LineUs 웹사이트에 업데이트된 개인정보취급방침과 함께 게시할 것입니다.</li>");
			sb.append("        </ul>");
			sb.append("    </div>");
			sb.append("</body>");
			sb.append("</html>");
		}
		return sb.toString() ; 
	}
	
	
	/**	회원 메일	*/
	public static String makeAsMail(AsVO vo) {
		StringBuffer sb = new StringBuffer() ; 
		
		if(vo != null) {
			sb.append("<!DOCTYPE html>");
			sb.append("<html lang=\"en\">");
			sb.append("<head>");
			sb.append("    <meta charset=\"UTF-8\">");
			sb.append("    <title>Document</title>");
			sb.append("</head>");
			sb.append("<body>");
			sb.append("    <div style=\"max-width: 750px; margin: 0 auto; padding-top: 30px; font-size: 12px;\">");
			sb.append("        <div style=\"text-align: center;\">");
			sb.append("            <img src=\""+JwConstants.SITE_ADDR+"/images/front/logo.png\" alt=\"\">");
			
			if ("C009".equals(SsStringUtil.normalizeNull(vo.getProc_status())) || "C011".equals(SsStringUtil.normalizeNull(vo.getProc_status()))){
				/**	C009 반려, C011 팀장반려	*/
				sb.append("            <h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">A/S 반려되었습니다.</h1>");
				sb.append("            <p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				sb.append("            본 메일은 중외정보기술에서 제공하는 ONTIC LineUs에서<br>고객님께서 접수하신 A/S에 대한 반려 안내 메일입니다."); 
				sb.append("            </p>");
				sb.append("            <p style=\"margin-bottom: 20px; color: red; font-weight: bold;\">접수해주신 아래의 정보를 관리자가 확인한 결과,<br>A/S 반려 되었음을 알려드립니다.<br>ONTIC LineUs 서비스를 이용해주셔서 감사합니다.</p>");				
			} else {
				/**	C005 처리완료	*/
				sb.append("            <h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">A/S처리완료</h1>");
				sb.append("            <p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				sb.append("            본 메일은 중외정보기술에서 제공하는 ONTIC LineUs에서<br>고객님께서 접수하신 A/S에 대한 처리 완료 안내 메일입니다.");
				sb.append("            </p>");
				sb.append("            <p style=\"margin-bottom: 10px; color: red; font-weight: bold;\">접수해주신 아래의 정보를 관리자가 확인한 결과,<br>A/S 처리 되었음을 알려드립니다.<br>ONTIC LineUs 서비스를 이용해주셔서 감사합니다.</p><br>");
				
				/** 2021.11.수정 . 배포 전 사용자(현업)의 확인이 필요 -처리완료 매일 내 사용자테스트확인완료 버튼 추가
				 *  조건1 : 처리상태가 처리완료(C005)
				 *  조건2 : 거래처가 JW그룹 (C001)
				 *  조건3
				 *  -기존 : 문의유형이 프로그램 신규개발(C001) 또는 프로그램 개선(C017)
				 *  -변경 : 조치유형이 프로그램신규개발(C001) 또는 프로그램수정(C002)인 배포가 필요한 AS건*/ //2023.08.21. 배포 조건 변경(문의유형-->조치유형)
				if("C001".equals(SsStringUtil.normalizeNull(vo.getCust_gubun())) && ( "C001".equals(SsStringUtil.normalizeNull(vo.getAction_type())) || "C002".equals(SsStringUtil.normalizeNull(vo.getAction_type()))) ){
					sb.append("				<p style=\"margin-bottom: 10px; font-weight: bold; font-size:15px;\">테스트를 확인하신 후 아래 버튼을 클릭해 주시길 바랍니다.<br><span style=\"color:red; font-size:12px !important;\">*버튼 미 클릭시 배포 및 수정사항 반영이 되지 않으므로 주의 바랍니다.</span></p>");
					
					/*개발*/
					sb.append("				<a href=\"http://localhost:8081/cm/confirm/view.do?as_no="+SsStringUtil.normalizeNull(vo.getAs_no())+"&apply_id="+SsStringUtil.normalizeNull(vo.getApply_id())+"\"><button type=\"button\" style=\"margin-bottom: 20px;\" >사용자 테스트 확인</button>	</a>		");
					
					/*운영*/
					//sb.append("				<a href=\"http://cplineus.cwit.co.kr/cm/confirm/view.do?as_no="+SsStringUtil.normalizeNull(vo.getAs_no())+"&apply_id="+SsStringUtil.normalizeNull(vo.getApply_id())+"\"><button type=\"button\" style=\"margin-bottom: 20px;\" >사용자 테스트 확인</button></a>		");
				}
				
			}
			
			sb.append("        </div>");
			sb.append("        <table class=\"sType\" style=\"width: 100%; border-top: 2px solid #494949;\">");
			sb.append("            <colgroup>");
			sb.append("                <col style=\"width: 140px;\">");
			sb.append("                <col style=\"width: auto;\">");
			sb.append("            </colgroup>");
			sb.append("            <thead>");
			sb.append("                <th colspan=\"2\" style=\"text-align: center; height: 40px; padding-left: 18px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S 접수 정보</th>");
			sb.append("            </thead>");
			sb.append("            <tbody>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">접수 일자</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">"+SsStringUtil.normalizeNull(vo.getAccept_dt())+" "+ SsStringUtil.normalizeNull(vo.getAccept_time()) +"</td>");
			sb.append("                </tr>");
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S번호</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">"+SsStringUtil.normalizeNull(vo.getAs_no())+"</td>");
			sb.append("                </tr>");
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">회원정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>기관명 :   "+SsStringUtil.normalizeNull(vo.getCust_kor_name())+"</li>");
			sb.append("                            <li>성명/ID : "+SsStringUtil.normalizeNull(vo.getApply_nm())+" "+SsStringUtil.normalizeNull(vo.getApply_id())+"</li>");
			sb.append("                            <li>연락처 : "+SsStringUtil.normalizeNull(vo.getApply_tel())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">문의 정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>시스템 유형 : "+SsStringUtil.normalizeNull(vo.getSystem_type_nm())+"</li>");
			sb.append("                            <li>시스템 명 : "+SsStringUtil.normalizeNull(vo.getSystem_nm())+"</li>");
			sb.append("                            <li>업무 유형 : "+SsStringUtil.normalizeNull(vo.getInquiry_type_nm())+"</li>");
			sb.append("                            <li>문의 유형 : "+SsStringUtil.normalizeNull(vo.getRequest_type_nm())+"</li>");
			
			sb.append("                            <li>요청 내용 : "+SsStringUtil.normalizeNull(vo.getCall_content())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("            </tbody>");
			sb.append("        </table>");
			
			sb.append("        <table class=\"sType\" style=\"width: 100%; border-top: 2px solid #494949;\">");
			sb.append("            <colgroup>");
			sb.append("                <col style=\"width: 140px;\">");
			sb.append("                <col style=\"width: auto;\">");
			sb.append("            </colgroup>");
			sb.append("            <thead>");
			sb.append("                <th colspan=\"2\" style=\"text-align: center; height: 40px; padding-left: 18px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S 처리 정보</th>");
			sb.append("            </thead>");
			sb.append("            <tbody>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S담당자 정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>이름 : "+ SsStringUtil.normalizeNull(vo.getEmp_nm())+"</li>");
			sb.append("                            <li>근무부서 : "+SsStringUtil.normalizeNull(vo.getDept1_nm())+" "+SsStringUtil.normalizeNull(vo.getDept2_nm())+"</li>");
			sb.append("                            <li>직책 : "+SsStringUtil.normalizeNull(vo.getDept_grade_nm())+"</li>");
			sb.append("                            <li>이메일 : "+SsStringUtil.normalizeNull(vo.getSender_email())+"</li>");
			sb.append("                            <li>연락처 : "+SsStringUtil.normalizeNull(vo.getCompany_no())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">처리 완료 일자</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">"+SsStringUtil.normalizeNull(vo.getComplete_dt())+"</td>");
			sb.append("                </tr>");
			
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">처리 정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>원인유형 : "+SsStringUtil.normalizeNull(vo.getCause_type_nm())+"</li>");
			sb.append("                            <li>조치유형: "+SsStringUtil.normalizeNull(vo.getAction_type_nm())+"</li>");
			sb.append("                            <li>조치 및 처리 의견: "+SsStringUtil.normalizeNull(vo.getAction_content())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("            </tbody>");
			sb.append("        </table>");

			
			
			sb.append("        <h3 style=\"text-align: center; margin: 20px 0; padding: 0; line-height: 1.5em;\">중외정보기술은 고객 만족을 위한<br>빠르고 편리한 서비스를 제공하기 위하여 항상 최선을 다하겠습니다.<br>감사합니다.<br>※본 메일 발신전용 메일입니다.</h3>");
			sb.append("        <hr style=\"margin: 0 0 20px;\" />");
			sb.append("        <p style=\"margin: 0; padding: 0; line-height: 1.5em;\">상위에 기재한 모든 정보는 당시의 ONTIC LineUs에 등록된 사실에 근거하며 고객정보는 중외정보기술 이용약관에 의거해 서비스 제공용으로 사용할 수 있습니다.</p>");
			sb.append("        <h4 style=\"margin: 20px 0 5px; padding: 0; line-height: 1.5em;\">[개인정보취급방침]</h4>");
			sb.append("        <ul style=\"margin-top: 0; padding-left: 15px;\">");
			sb.append("            <li>위의 정보는 중외정보기술의 <a href=\"#\">개인정보취급방침</a>에 따라 취급되며 마케팅 목적으로 사용되지는 않습니다.</li>");
			sb.append("            <li>ONTIC LineUs는 개인정보취급방침을 수시로 업데이트 할 수 있습니다.</li>");
			sb.append("            <li>본사가 방침에 대해 중요한 변경을 하는 경우, 본사의 ONTIC LineUs 웹사이트에 업데이트된 개인정보취급방침과 함께 게시할 것입니다.</li>");
			sb.append("        </ul>");
			sb.append("    </div>");
			sb.append("</body>");
			sb.append("</html>");
		}
		return sb.toString() ; 
	}
	
	
	
	
	/**	유지보수 담당자에게 이메일발송 (처리상태 C010 팀장승인, C012 배포승인) */
	public static String makeAsEmpMail(AsVO vo) {
		StringBuffer sb = new StringBuffer() ; 
		
		if(vo != null) {
			sb.append("<!DOCTYPE html>");
			sb.append("<html lang=\"en\">");
			sb.append("<head>");
			sb.append("    <meta charset=\"UTF-8\">");
			sb.append("    <title>Document</title>");
			sb.append("</head>");
			sb.append("<body>");
			sb.append("    <div style=\"max-width: 750px; margin: 0 auto; padding-top: 30px; font-size: 12px;\">");
			sb.append("        <div style=\"text-align: center;\">");
			sb.append("            <img src=\""+JwConstants.SITE_ADDR+"/images/front/logo.png\" alt=\"\">");
			
			if ("C010".equals(SsStringUtil.normalizeNull(vo.getProc_status()))){
				sb.append("            <h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">A/S접수되었습니다.</h1>");
				sb.append("            <p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				sb.append("            본 메일은 중외정보기술에서 제공하는 ONTIC LineUs에서<br>고객님께서 접수하신 A/S에 대한 유지보수 담당자에게 접수 안내 메일입니다.");
				sb.append("            </p>");
				sb.append("            <p style=\"margin-bottom: 20px; color: red; font-weight: bold;\">접수해주신 아래의 정보를 관리자가 확인한 결과,<br>A/S 접수 되었음을 알려드립니다.<br>ONTIC LineUs 서비스를 이용해주셔서 감사합니다.</p>");
			}else if("C012".equals(SsStringUtil.normalizeNull(vo.getProc_status()))){
				sb.append("            <h1 style=\"margin-bottom: 20px; line-height: 1em; margin-top: 30px;\">A/S배포승인되었습니다.</h1>");
				sb.append("            <p style=\"margin-top: 0; padding: 0; line-height: 1.5em;\">안녕하세요.<br>");
				sb.append("            본 메일은 중외정보기술에서 제공하는 ONTIC LineUs에서<br>고객님께서 접수하신 A/S에 대한 유지보수 담당자에게 배포승인 안내 메일입니다.");
				sb.append("            </p>");
				sb.append("            <p style=\"margin-bottom: 20px; color: red; font-weight: bold;\">접수해주신 아래의 정보를 관리자가 확인한 결과,<br>A/S 배포승인 되었음을 알려드립니다.<br>ONTIC LineUs 서비스를 이용해주셔서 감사합니다.</p>");
			}
			
			sb.append("        </div>");
			sb.append("        <table class=\"sType\" style=\"width: 100%; border-top: 2px solid #494949;\">");
			sb.append("            <colgroup>");
			sb.append("                <col style=\"width: 140px;\">");
			sb.append("                <col style=\"width: auto;\">");
			sb.append("            </colgroup>");
			sb.append("            <thead>");
			sb.append("                <th colspan=\"2\" style=\"text-align: center; height: 40px; padding-left: 18px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S 접수 정보</th>");
			sb.append("            </thead>");
			sb.append("            <tbody>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">접수 일자</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">"+SsStringUtil.normalizeNull(vo.getAccept_dt())+" "+ SsStringUtil.normalizeNull(vo.getAccept_time()) +"</td>");
			sb.append("                </tr>");
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S번호</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">"+SsStringUtil.normalizeNull(vo.getAs_no())+"</td>");
			sb.append("                </tr>");
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">회원정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>기관명 :   "+SsStringUtil.normalizeNull(vo.getCust_kor_name())+"</li>");
			sb.append("                            <li>성명/ID : "+SsStringUtil.normalizeNull(vo.getApply_nm())+" "+SsStringUtil.normalizeNull(vo.getApply_id())+"</li>");
			sb.append("                            <li>연락처 : "+SsStringUtil.normalizeNull(vo.getApply_tel())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">문의 정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>시스템 유형 : "+SsStringUtil.normalizeNull(vo.getSystem_type_nm())+"</li>");
			sb.append("                            <li>시스템 명 : "+SsStringUtil.normalizeNull(vo.getSystem_nm())+"</li>");
			sb.append("                            <li>업무 유형 : "+SsStringUtil.normalizeNull(vo.getInquiry_type_nm())+"</li>");
			sb.append("                            <li>문의 유형 : "+SsStringUtil.normalizeNull(vo.getRequest_type_nm())+"</li>");
			sb.append("                            <li>처리요청일자 : "+SsStringUtil.normalizeNull(vo.getInquiry_dt())+"</li>"); 			
			sb.append("                            <li>요청 내용 : "+SsStringUtil.normalizeNull(vo.getCall_content())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("            </tbody>");
			sb.append("        </table>");
			
			sb.append("        <table class=\"sType\" style=\"width: 100%; border-top: 2px solid #494949;\">");
			sb.append("            <colgroup>");
			sb.append("                <col style=\"width: 140px;\">");
			sb.append("                <col style=\"width: auto;\">");
			sb.append("            </colgroup>");
			sb.append("            <thead>");
			sb.append("                <th colspan=\"2\" style=\"text-align: center; height: 40px; padding-left: 18px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S 처리 정보</th>");
			sb.append("            </thead>");
			sb.append("            <tbody>");
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">A/S담당자 정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");
			sb.append("                            <li>이름 : "+ SsStringUtil.normalizeNull(vo.getEmp_nm())+"</li>");
			sb.append("                            <li>근무부서 : "+SsStringUtil.normalizeNull(vo.getDept1_nm())+" "+SsStringUtil.normalizeNull(vo.getDept2_nm())+"</li>");
			sb.append("                            <li>직책 : "+SsStringUtil.normalizeNull(vo.getDept_grade_nm())+"</li>");
			sb.append("                            <li>이메일 : "+SsStringUtil.normalizeNull(vo.getSender_email())+"</li>");
			sb.append("                            <li>연락처 : "+SsStringUtil.normalizeNull(vo.getCompany_no())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">처리 완료 일자</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">"+SsStringUtil.normalizeNull(vo.getComplete_dt())+"</td>");
			sb.append("                </tr>"); 
			
			
			sb.append("                <tr>");
			sb.append("                    <th style=\"height: 40px; font-weight: 700; border-bottom: 1px solid #dadada; background-color: #f7f7f7;\">처리 정보</th>");
			sb.append("                    <td style=\"height: 30px; padding: 5px 20px; border-bottom: 1px solid #dadada;\">");
			sb.append("                        <ul style=\"padding-left: 15px;\">");  		
			sb.append("                            <li>처리예정일자 : "+ SsStringUtil.normalizeNull(vo.getProc_dt())+"</li>");					
			sb.append("                            <li>배정담당자 : "+ SsStringUtil.normalizeNull(vo.getEmp_nm())+"</li>");			
			sb.append("                            <li>처리상태 : "+SsStringUtil.normalizeNull(vo.getProc_status_nm())+"</li>");			
			sb.append("                            <li>원인유형 : "+SsStringUtil.normalizeNull(vo.getCause_type_nm())+"</li>");
			sb.append("                            <li>조치유형 : "+SsStringUtil.normalizeNull(vo.getAction_type_nm())+"</li>");
			sb.append("                            <li>조치 및 처리 의견: "+SsStringUtil.normalizeNull(vo.getAction_content())+"</li>");
			sb.append("                        </ul>");
			sb.append("                    </td>");
			sb.append("                </tr>");
			sb.append("            </tbody>");
			sb.append("        </table>");
			
			
			
			sb.append("        <h3 style=\"text-align: center; margin: 20px 0; padding: 0; line-height: 1.5em;\">중외정보기술은 고객 만족을 위한<br>빠르고 편리한 서비스를 제공하기 위하여 항상 최선을 다하겠습니다.<br>감사합니다.<br>※본 메일 발신전용 메일입니다.</h3>");
			sb.append("        <hr style=\"margin: 0 0 20px;\" />");
			sb.append("        <p style=\"margin: 0; padding: 0; line-height: 1.5em;\">상위에 기재한 모든 정보는 당시의 ONTIC LineUs에 등록된 사실에 근거하며 고객정보는 중외정보기술 이용약관에 의거해 서비스 제공용으로 사용할 수 있습니다.</p>");
			sb.append("        <h4 style=\"margin: 20px 0 5px; padding: 0; line-height: 1.5em;\">[개인정보취급방침]</h4>");
			sb.append("        <ul style=\"margin-top: 0; padding-left: 15px;\">");
			sb.append("            <li>위의 정보는 중외정보기술의 <a href=\"#\">개인정보취급방침</a>에 따라 취급되며 마케팅 목적으로 사용되지는 않습니다.</li>");
			sb.append("            <li>ONTIC LineUs는 개인정보취급방침을 수시로 업데이트 할 수 있습니다.</li>");
			sb.append("            <li>본사가 방침에 대해 중요한 변경을 하는 경우, 본사의 ONTIC LineUs 웹사이트에 업데이트된 개인정보취급방침과 함께 게시할 것입니다.</li>");
			sb.append("        </ul>");
			sb.append("    </div>");
			sb.append("</body>");
			sb.append("</html>");
		}
		return sb.toString() ; 
	}
	
	
}



                                                                                              