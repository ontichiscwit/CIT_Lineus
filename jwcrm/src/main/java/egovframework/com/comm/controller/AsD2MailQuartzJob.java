package egovframework.com.comm.controller;

import java.util.List;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;

import egovframework.com.comm.ApplicationContextProvider;
import egovframework.com.comm.JwConstants;
import egovframework.com.comm.dao.impl.CommonDaoImpl;
import egovframework.com.comm.service.CommonSmsService;
import egovframework.com.comm.util.SendMailForm;
import egovframework.com.comm.util.SsStringUtil;
import egovframework.com.model.AsVO;

/**
 * AS 처리예정일 D-2 담당자 메일 알림 배치
 * - 기존 SimpleQuartzJob 패턴을 따름
 * - 매일 1회 (예: 오전 08:00) 실행
 */
@SuppressWarnings("unused")
public class AsD2MailQuartzJob extends QuartzJobBean {

	@Autowired CommonDaoImpl commonDAO;
	@Autowired CommonSmsService commonSmsService;

	public AsD2MailQuartzJob() {
		commonDAO = ApplicationContextProvider.getBean(CommonDaoImpl.class);
		commonSmsService = (CommonSmsService) ApplicationContextProvider.getBean(CommonSmsService.class);
	}

	private static final Logger logger = LoggerFactory.getLogger(AsD2MailQuartzJob.class);

	@SuppressWarnings("unchecked")
	public void executeInternal(JobExecutionContext ex) throws JobExecutionException {

		logger.info("===== [AS D-2 메일 배치] 시작 =====");

		int successCnt = 0;
		int failCnt = 0;

		try {
			// 1. 처리예정일이 오늘+2일이고 미완료 상태인 AS 목록 조회 (담당자 이메일 포함)
			AsVO dump = new AsVO();
			List<AsVO> targetList = (List<AsVO>) commonDAO.list(dump, "asDAO.selectD2AsList");

			if (targetList == null || targetList.size() == 0) {
				logger.info("[AS D-2 메일 배치] 발송 대상 없음");
				return;
			}

			logger.info("[AS D-2 메일 배치] 대상 건수: {}", targetList.size());

			// 2. 건별 메일 발송 (한 건 실패해도 나머지 계속)
			for (AsVO asVo : targetList) {

				try {
					// 담당자 퇴사자 여부 체크 (기존 패턴과 동일)
					AsVO retirevo = (AsVO) commonDAO.selectOne(asVo, "asDAO.getAsEmpRetireYn");
					if (retirevo != null && !"N".equals(SsStringUtil.normalizeNull(retirevo.getRetire_yn()))) {
						logger.info("[AS D-2 메일 배치] 퇴사자 스킵 - AS_NO: {}", asVo.getAs_no());
						continue;
					}

					// 담당자 이메일 없으면 스킵
					String mgrEmail = SsStringUtil.normalizeNull(asVo.getSender_email());
					if ("".equals(mgrEmail)) {
						logger.warn("[AS D-2 메일 배치] 담당자 메일 없음 - AS_NO: {}", asVo.getAs_no());
						failCnt++;
						continue;
					}

					String title = "ONTIC LineUs에서 A/S 처리예정일 임박(D-2) 안내 메일을 보내드립니다. [" + asVo.getAs_no() + "]";

					// 3. 메일 발송
					// sendMail(senderId, receiverId, subject, body, attach_file, file_ori_name)
					// - senderId는 내부에서 미사용(발신자는 JwConstants.MAIL_SEND_ADDR 고정)
					// - 리턴: 성공 1, 실패 -100
					int sendEmailResult = commonSmsService.sendMail(
							JwConstants.MAIL_SEND_ADDR,
							mgrEmail,
							title,
							SendMailForm.makeAsD2Mail(asVo),
							"", "");

					// 4. 발송 성공 시 AS 이력 남기기 (기존 패턴과 동일)
					if (sendEmailResult == 1) {
						successCnt++;
						asVo.setAction_content("AS 처리예정일 D-2 안내 EMAIL이 처리담당자에게 " + mgrEmail + " 주소로 발송되었습니다.");
						asVo.setSeq(String.valueOf(commonDAO.selectOneInt(asVo, "asDAO.getAsHistMaxSeq")));
						commonDAO.insert(asVo, "asDAO.insertAsInfoHist");
					} else {
						failCnt++;
						logger.error("[AS D-2 메일 배치] 발송 실패 - AS_NO: {}, 수신자: {}", asVo.getAs_no(), mgrEmail);
					}

				} catch (Exception e) {
					failCnt++;
					logger.error("[AS D-2 메일 배치] 건 처리 오류 - AS_NO: " + asVo.getAs_no(), e);
				}
			}

		} catch (Exception e) {
			logger.error("[AS D-2 메일 배치] 배치 전체 오류", e);
		}

		logger.info("===== [AS D-2 메일 배치] 종료 - 성공: {}, 실패: {} =====", successCnt, failCnt);
	}

}
