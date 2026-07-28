# =====================================================================
# [AX Lab] PC 별 로컬 설정 샘플 (2026-07-28)
# 사용법:
#   1) 이 파일을 같은 폴더에 setup-local.config.ps1 이름으로 복사한다.
#        Copy-Item .\setup-local.config.sample.ps1 .\setup-local.config.ps1
#   2) 아래 값을 이 PC/망에 맞게 채운다. (특히 DB 접속정보)
#   3) setup-local.ps1 실행 시 자동으로 이 값이 기본값으로 적용된다.
#
# 주의:
#   - setup-local.config.ps1 은 비밀번호를 포함하므로 .gitignore 대상이다(절대 커밋 금지).
#   - 이 샘플 파일(setup-local.config.sample.ps1)만 git 에 커밋해 다른 PC 가 참고하게 한다.
#   - 우선순위: 명령행 인자 > setup-local.config.ps1 > setup-local.ps1 param 기본값.
# =====================================================================
$LocalConfig = @{
    OraHost    = "192.168.20.56"   # Oracle DB 호스트/IP (PC/망마다 다를 수 있음)
    OraPort    = "1521"            # Oracle 리스너 포트
    # 접속 식별자는 SID 또는 SERVICE_NAME 중 하나를 쓴다.
    #  - SID 방식:          OraSid 를 채우고 OraService 는 비워둔다      → url: @host:port:SID
    #  - SERVICE_NAME 방식: OraService 를 채우면 SID 보다 우선 적용된다  → url: @//host:port/SERVICE
    OraSid     = "orcl"            # Oracle SID (SERVICE_NAME 을 쓰면 무시됨)
    OraService = ""                # Oracle SERVICE_NAME (예: "NEWCIT"). 값이 있으면 이게 우선.
    OraUser    = "hislineus"       # DB 계정
    OraPass    = ""                # DB 비밀번호 (비워두면 실행 시 입력받음)
    TomcatPort = 8080              # 로컬 tomcat 포트
    # Jdk8Dir  = "$env:USERPROFILE\jdk8-temurin"  # (선택) portable JDK8 설치/탐색 위치
}
