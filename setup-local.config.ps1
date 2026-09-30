# =====================================================================
# [AX Lab] PC 별 로컬 설정 (이 파일은 .gitignore 대상, 커밋 금지)
#   - setup-local.ps1 실행 시 자동으로 이 값이 기본값으로 적용된다.
#   - 우선순위: 명령행 인자 > 이 파일 > setup-local.ps1 param 기본값.
# =====================================================================
$LocalConfig = @{
    OraHost    = "192.168.16.212"  # 새 DB (CIT_192.168.16.212_newcit)
    OraPort    = "1521"
    OraSid     = ""                # SERVICE_NAME 사용하므로 SID 는 비움
    OraService = "NEWCIT"          # SERVICE_NAME (우선 적용) → url: @//192.168.16.212:1521/NEWCIT
    OraUser    = "lineus"
    OraPass    = "oralineus"
    TomcatPort = 8080
}
