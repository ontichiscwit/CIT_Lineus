# =====================================================================
# [AX Lab] NEWCIT 데이터 최신화 스크립트 (운영 CIT → 복제본 NEWCIT)  작성: 2026-10-07 AX Lab
# =====================================================================
# 목적 : NEWCIT(복제본)은 2026-07-30 시점 스냅샷이라 그 이후 운영(CIT) 데이터가 없다.
#        운영 CIT 의 LINEUS 스키마를 Data Pump 로 서버 내부 export 한 뒤 NEWCIT 에 반영한다.
#
# 구성 : 운영 CIT 와 NEWCIT 은 같은 서버(192.168.16.212:1521)의 다른 인스턴스이고,
#        양쪽 모두 DIRECTORY 객체 EXPDP_BACKUP (= D:\backup\EXPDP\CIT, lineus READ/WRITE) 을 갖고 있어
#        CIT 가 쓴 덤프 파일을 NEWCIT 이 그대로 읽을 수 있다. (전체 덤프 ≈ 1.1 GB)
#
# 방식 : 로컬 PC 의 expdp/impdp 는 19c 클라이언트라 11.2.0.4 서버와 호환되지 않으므로(UDE-00018),
#        sqlplus 에서 DBMS_DATAPUMP(PL/SQL) 를 호출해 "서버 안에서" export/import 를 수행한다.
#        → PC 에는 sqlplus 만 있으면 된다. 덤프 파일은 PC 를 거치지 않는다.
#
# 반영 방식 두 가지:
#   (1) Merge  [권장] : 변경된 테이블만 NEWCIT 안에 스테이징(X_테이블명)으로 import 한 뒤
#                       PK 기준 MERGE(없으면 INSERT, 있으면 UPDATE) → 키 없는 테이블(로그/재등록형)은 DELETE+INSERT 로 통째 교체
#                       → 시퀀스를 CIT 현재값으로 보정 → 스테이징 삭제.
#                       (키 없는 테이블에 MINUS 로 "없는 행만" 넣으면 운영에서 수정/재등록된 행의 옛 버전이 남아 중복됨 — 실측 확인)
#                       기존 테이블을 DROP 하지 않으므로 뷰/프로시저가 깨지지 않고, 실패해도 기존 데이터는 그대로다.
#                       충돌 규칙은 "운영(CIT) 우선": 같은 행이 양쪽에서 바뀌면 CIT 값으로 덮는다.
#                       운영에서 물리 삭제된 행은 반영되지 않는다(이 앱은 DEL_YN 소프트삭제라 실질 영향 적음).
#   (2) Import [교체]  : 모든 테이블을 DROP 후 덤프로 재생성(TABLE_EXISTS_ACTION=REPLACE). 완전 동일본이 필요할 때.
#
# 사용법 (PowerShell, 프로젝트 루트에서):
#   .\sql\NEWCIT_data_refresh_from_CIT.ps1 -Step Check         # 양쪽 건수/최신일자만 비교 (변경 없음)
#   .\sql\NEWCIT_data_refresh_from_CIT.ps1 -Step Export        # CIT 에서 덤프 생성 (운영 DB 는 읽기만 함)
#   .\sql\NEWCIT_data_refresh_from_CIT.ps1 -Step Merge  -DumpName AXLAB_LINEUS_20261007_1630.dmp   # (1)
#   .\sql\NEWCIT_data_refresh_from_CIT.ps1 -Step ExportMerge -DeleteDump   # Export → Merge → Check 한 번에, 끝나면 덤프 삭제 [권장]
#   .\sql\NEWCIT_data_refresh_from_CIT.ps1 -Step Import -DumpName AXLAB_LINEUS_20261007_1630.dmp  # (2)
#   .\sql\NEWCIT_data_refresh_from_CIT.ps1 -Step All           # Export → Import(교체) → Check
#   .\sql\NEWCIT_data_refresh_from_CIT.ps1 -Step Merge -DumpName ... -WhatIf   # 실제 반영 없이 대상/SQL 만 출력
#
# 접속정보 : setup-local.config.ps1 의 OraUser/OraPass 를 사용한다 (CIT/NEWCIT 둘 다 같은 lineus 계정).
#
# ★ 주의 ★
#   - 스크립트는 접속한 DB 의 DB_NAME 이 'NEWCIT' 가 아니면 Merge/Import 를 거부한다 (운영 오염 방지).
#   - Import(교체) 는 NEWCIT 의 LINEUS 테이블을 전부 DROP 후 재생성한다. 7/30 이후 NEWCIT 에 넣은 데이터는 사라진다.
#   - Merge 의 변경 감지는 "건수 + DATE 컬럼 MAX" 지문 비교다. DATE 컬럼이 없고 건수도 같은 테이블에서
#     값만 바뀐 경우는 감지하지 못한다(코드성 소형 테이블 일부). 필요하면 -ForceTables 로 지정한다.
#   - Merge 로 새로 생성되는(NEWCIT 에 없던) 테이블은 인덱스/제약조건 없이 데이터만 들어온다(운영 백업본 테이블용).
#   - PLAN_TABLE / TOAD_PLAN_TABLE 은 LONG 컬럼이라 MERGE 불가 → 항상 제외(툴 작업용 테이블).
#   - KYERP 스키마(ERP 복제본)도 약 1~2% 차이가 있으나 이 스크립트 범위 밖이다(필요 시 별도 진행).
# =====================================================================
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateSet('Check', 'Export', 'Merge', 'ExportMerge', 'Import', 'All')]
    [string]$Step = 'Check',
    [string]$DumpName = '',                                  # Merge/Import 시 사용할 덤프 파일명 (Export 가 출력한 이름)
    [string[]]$ForceTables = @(),                            # Merge 시 지문이 같아도 강제로 포함할 테이블
    [switch]$DeleteDump,                                     # Merge 성공 후 서버의 덤프/로그 파일 삭제 (UTL_FILE.FREMOVE)
    [string]$DbHost   = '192.168.16.212',
    [string]$DbPort   = '1521',
    [string]$SrcService = 'CIT',                             # 원본(운영) — 읽기만
    [string]$DstService = 'NEWCIT',                          # 대상(복제본)
    [string]$Directory  = 'EXPDP_BACKUP',                    # 양쪽 DB 에 동일 경로로 존재하는 DIRECTORY 객체
    [string]$OraUser = '',
    [string]$OraPass = '',
    [string]$SqlPlus = 'C:\Oracle19C____\bin\sqlplus.exe'
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$OutputEncoding = New-Object System.Text.UTF8Encoding $false   # sqlplus 표준입력 SQL 의 한글(컬럼명 등) 보존, BOM 없이(BOM 이 붙으면 SP2-0734)
$env:NLS_LANG = 'KOREAN_KOREA.AL32UTF8'

$StagePrefix   = 'X_'                                        # 스테이징 테이블 접두사 (NEWCIT 안)
$ExcludeTables = @('PLAN_TABLE', 'TOAD_PLAN_TABLE')          # LONG 컬럼 → MERGE 불가, 툴 작업용

# ---------------------------------------------------------------- 접속정보
$root = Split-Path -Parent $PSScriptRoot
$cfgPath = Join-Path $root 'setup-local.config.ps1'
if ((-not $OraUser -or -not $OraPass) -and (Test-Path $cfgPath)) {
    . $cfgPath
    if (-not $OraUser) { $OraUser = $LocalConfig.OraUser }
    if (-not $OraPass) { $OraPass = $LocalConfig.OraPass }
}
if (-not $OraUser) { $OraUser = Read-Host 'DB 계정 (lineus)' }
if (-not $OraPass) { $sec = Read-Host "DB 비밀번호 ($OraUser)" -AsSecureString; $OraPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)) }

if (-not (Test-Path $SqlPlus)) { $cmd = Get-Command sqlplus -ErrorAction SilentlyContinue; if ($cmd) { $SqlPlus = $cmd.Source } else { throw "sqlplus.exe 를 찾지 못했습니다: $SqlPlus" } }
# 이 PC 의 시스템 ORACLE_HOME(instantclient 등)은 sqlplus 메시지 파일이 없어 "Error 6 initializing SQL*Plus" 가 나므로
# 이 프로세스 안에서만 실제 sqlplus 가 들어있는 홈으로 맞춘다.
$env:ORACLE_HOME = Split-Path -Parent (Split-Path -Parent $SqlPlus)

$SrcConn = "$OraUser/$OraPass@//$DbHost`:$DbPort/$SrcService"
$DstConn = "$OraUser/$OraPass@//$DbHost`:$DbPort/$DstService"

# ---------------------------------------------------------------- sqlplus 실행 헬퍼
# -Quiet : 메타데이터 조회처럼 결과를 화면에 쏟지 않고 배열로만 돌려받을 때
function Invoke-SqlPlus([string]$Conn, [string]$Script, [string]$Label, [switch]$Quiet) {
    $full = "SET PAGESIZE 0 LINESIZE 300 FEEDBACK OFF HEADING OFF TRIMSPOOL ON SERVEROUTPUT ON SIZE UNLIMITED`nWHENEVER SQLERROR EXIT FAILURE`n$Script`nEXIT`n"
    $prevEap = $ErrorActionPreference; $ErrorActionPreference = 'Continue'   # sqlplus 의 stderr 를 예외로 승격시키지 않음
    $out = @($full | & $SqlPlus -S $Conn 2>&1 | ForEach-Object { "$_" })
    $rc = $LASTEXITCODE
    $ErrorActionPreference = $prevEap
    if (-not $Quiet) { $out | ForEach-Object { if ($_.Trim()) { Write-Host "  $_" } } }
    # 로그인/접속 실패는 exit code 가 0 일 수 있어 앞머리 몇 줄의 ORA-/SP2- 도 본다 (Data Pump 로그 안의 ORA-31684 같은 경고는 제외)
    $head = @($out | Select-Object -First 5)
    if ($rc -ne 0 -or ($head -match '^(ORA-01017|ORA-125\d\d|ORA-1215\d|SP2-\d+|Error \d+ initializing)')) {
        if ($Quiet) { $out | ForEach-Object { if ($_.Trim()) { Write-Host "  $_" } } }
        throw "[$Label] sqlplus 실행 실패 (exit=$rc)"
    }
    return @($out | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

# ---------------------------------------------------------------- DBMS_DATAPUMP 공통 모니터링 블록
# $Setup 자리에 OPEN/ADD_FILE/필터 등을 넣는다. 작업이 끝날 때까지 로그를 출력하며 대기한다.
function New-DataPumpBlock([string]$Setup) {
@"
DECLARE
  h   NUMBER;
  st  VARCHAR2(30);
  sts ku`$_Status;
  le  ku`$_LogEntry;
BEGIN
$Setup
  DBMS_DATAPUMP.START_JOB(h);
  LOOP
    DBMS_DATAPUMP.GET_STATUS(h,
        DBMS_DATAPUMP.KU`$_STATUS_JOB_STATUS + DBMS_DATAPUMP.KU`$_STATUS_WIP + DBMS_DATAPUMP.KU`$_STATUS_JOB_ERROR,
        -1, st, sts);
    le := NULL;
    IF    BITAND(sts.mask, DBMS_DATAPUMP.KU`$_STATUS_WIP)       <> 0 THEN le := sts.wip;
    ELSIF BITAND(sts.mask, DBMS_DATAPUMP.KU`$_STATUS_JOB_ERROR) <> 0 THEN le := sts.error;
    END IF;
    IF le IS NOT NULL THEN
      FOR i IN le.FIRST .. le.LAST LOOP
        IF le(i).LogText IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE(le(i).LogText); END IF;
      END LOOP;
    END IF;
    EXIT WHEN st IN ('COMPLETED', 'STOPPED');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('DATAPUMP JOB STATE: ' || st);
  DBMS_DATAPUMP.DETACH(h);
  IF st <> 'COMPLETED' THEN RAISE_APPLICATION_ERROR(-20001, 'Data Pump 작업이 정상 완료되지 않았습니다: ' || st); END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    BEGIN DBMS_DATAPUMP.STOP_JOB(h, 1, 0, 0); EXCEPTION WHEN OTHERS THEN NULL; END;
    RAISE;
END;
/
"@
}

function Q([string]$Name) { return '"' + $Name.Replace('"', '""') + '"' }      # 식별자 인용 (한글 컬럼명 등 대비)
function SqlList([string[]]$Names) { return ($Names | ForEach-Object { "'" + $_.Replace("'", "''") + "'" }) -join ',' }

# ---------------------------------------------------------------- Step: Check
$CheckSql = @"
SELECT 'DB='||SYS_CONTEXT('USERENV','DB_NAME')||'  USER='||USER||'  NOW='||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM DUAL;
SELECT 'CRM_AS_MGT         rows='||COUNT(*)||'  max ACCEPT_DT='||MAX(ACCEPT_DT)||'  max REG_DATE='||TO_CHAR(MAX(REG_DATE),'YYYY-MM-DD HH24:MI') FROM CRM_AS_MGT;
SELECT 'CRM_AS_MGT_ANSWER  rows='||COUNT(*) FROM CRM_AS_MGT_ANSWER;
SELECT 'CRM_AS_MGT_HIST    rows='||COUNT(*) FROM CRM_AS_MGT_HIST;
SELECT 'CRM_ATTACH_MGT     rows='||COUNT(*) FROM CRM_ATTACH_MGT;
SELECT 'CRM_CUST_MGT       rows='||COUNT(*) FROM CRM_CUST_MGT;
SELECT 'CRM_EMP_MGT        rows='||COUNT(*) FROM CRM_EMP_MGT;
SELECT 'CRM_CODE_DETAIL    rows='||COUNT(*) FROM CRM_CODE_DETAIL;
SELECT 'TABLES='||(SELECT COUNT(*) FROM USER_TABLES)||'  INVALID OBJECTS='||(SELECT COUNT(*) FROM USER_OBJECTS WHERE STATUS='INVALID')||'  STAGING(X_)='||(SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME LIKE 'X\_%' ESCAPE '\') FROM DUAL;
SELECT 'SEQ MAX_AS_HIST_NO='||LAST_NUMBER FROM USER_SEQUENCES WHERE SEQUENCE_NAME='MAX_AS_HIST_NO';
"@

function Do-Check {
    Write-Host "`n===== [원본] $SrcService =====" -ForegroundColor Cyan
    Invoke-SqlPlus $SrcConn $CheckSql 'Check-CIT' | Out-Null
    Write-Host "`n===== [대상] $DstService =====" -ForegroundColor Cyan
    Invoke-SqlPlus $DstConn $CheckSql 'Check-NEWCIT' | Out-Null
}

# ---------------------------------------------------------------- Step: Export (CIT 에서 덤프 생성, 읽기 전용)
function Do-Export {
    $ts = Get-Date -Format 'yyyyMMdd_HHmm'
    $script:DumpName = "AXLAB_LINEUS_$ts.dmp"
    $log = "AXLAB_LINEUS_${ts}_exp.log"
    Write-Host "`n===== Export: $SrcService → $Directory\$($script:DumpName) =====" -ForegroundColor Cyan
    $setup = @"
  -- 운영 CIT 에서만 export (DB_NAME 검사)
  IF UPPER(SYS_CONTEXT('USERENV','DB_NAME')) <> UPPER('$SrcService') THEN
    RAISE_APPLICATION_ERROR(-20002, '원본 DB 가 아닙니다: ' || SYS_CONTEXT('USERENV','DB_NAME'));
  END IF;
  h := DBMS_DATAPUMP.OPEN(operation => 'EXPORT', job_mode => 'SCHEMA', job_name => 'AXLAB_EXP_$ts');
  DBMS_DATAPUMP.ADD_FILE(h, '$($script:DumpName)', '$Directory', filetype => DBMS_DATAPUMP.KU`$_FILE_TYPE_DUMP_FILE, reusefile => 1);
  DBMS_DATAPUMP.ADD_FILE(h, '$log', '$Directory', filetype => DBMS_DATAPUMP.KU`$_FILE_TYPE_LOG_FILE);
  DBMS_DATAPUMP.METADATA_FILTER(h, 'SCHEMA_EXPR', 'IN (''LINEUS'')');
  -- 일관된 시점(현재 SCN)으로 export → 운영 중 변경되는 데이터와 무관하게 정합성 유지
  -- (DBMS_FLASHBACK 은 lineus 에 실행권한이 없어 SQL 함수 TIMESTAMP_TO_SCN 으로 현재 SCN 을 구한다)
  DECLARE scn NUMBER; BEGIN
    SELECT TIMESTAMP_TO_SCN(SYSTIMESTAMP) INTO scn FROM DUAL;
    DBMS_DATAPUMP.SET_PARAMETER(h, 'FLASHBACK_SCN', scn);
    DBMS_OUTPUT.PUT_LINE('FLASHBACK_SCN = ' || scn);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('FLASHBACK_SCN 미적용: ' || SQLERRM); END;
"@
    Invoke-SqlPlus $SrcConn (New-DataPumpBlock $setup) 'Export' | Out-Null
    Write-Host "`n>> 덤프 생성 완료: $Directory\$($script:DumpName)  (서버 D:\backup\EXPDP\CIT)" -ForegroundColor Green
}

# ---------------------------------------------------------------- Step: Merge (변경분만 스테이징 → MERGE)
function Get-TableMeta([string]$Conn, [string]$Label) {
    # 테이블 / 컬럼(순서,타입) / PK(없으면 UNIQUE 제약) / 시퀀스 현재값 을 한 번에 읽어 온다
    $sql = @"
SELECT 'T|'||TABLE_NAME FROM USER_TABLES ORDER BY TABLE_NAME;
SELECT 'C|'||C.TABLE_NAME||'|'||C.COLUMN_NAME||'|'||C.DATA_TYPE FROM USER_TAB_COLUMNS C JOIN USER_TABLES T ON T.TABLE_NAME=C.TABLE_NAME ORDER BY C.TABLE_NAME, C.COLUMN_ID;
SELECT 'K|'||X.TABLE_NAME||'|'||X.COLUMN_NAME FROM (
  SELECT C.TABLE_NAME, CC.COLUMN_NAME, CC.POSITION,
         ROW_NUMBER() OVER (PARTITION BY C.TABLE_NAME ORDER BY DECODE(C.CONSTRAINT_TYPE,'P',0,1), C.CONSTRAINT_NAME) RN0,
         DENSE_RANK() OVER (PARTITION BY C.TABLE_NAME ORDER BY DECODE(C.CONSTRAINT_TYPE,'P',0,1), C.CONSTRAINT_NAME) RN
    FROM USER_CONSTRAINTS C JOIN USER_CONS_COLUMNS CC ON C.CONSTRAINT_NAME=CC.CONSTRAINT_NAME
   WHERE C.CONSTRAINT_TYPE IN ('P','U') AND C.STATUS='ENABLED') X
 WHERE X.RN = 1 ORDER BY X.TABLE_NAME, X.POSITION;
SELECT 'S|'||SEQUENCE_NAME||'|'||LAST_NUMBER FROM USER_SEQUENCES ORDER BY SEQUENCE_NAME;
"@
    $lines = @(Invoke-SqlPlus $Conn $sql "Meta-$Label" -Quiet)
    $meta = @{ Tables = New-Object System.Collections.ArrayList; Cols = @{}; PK = @{}; Seqs = @{} }
    foreach ($l in $lines) {
        $p = $l.Split('|')
        switch ($p[0]) {
            'T' { [void]$meta.Tables.Add($p[1]) }
            'C' { if (-not $meta.Cols.ContainsKey($p[1])) { $meta.Cols[$p[1]] = New-Object System.Collections.ArrayList }; [void]$meta.Cols[$p[1]].Add(@{ Name = $p[2]; Type = $p[3] }) }
            'K' { if (-not $meta.PK.ContainsKey($p[1])) { $meta.PK[$p[1]] = New-Object System.Collections.ArrayList }; [void]$meta.PK[$p[1]].Add($p[2]) }
            'S' { $meta.Seqs[$p[1]] = [long]$p[2] }
        }
    }
    return $meta
}

function Get-Fingerprints([string]$Conn, [string]$Label, $Meta, [string[]]$Tables) {
    # 테이블별 지문 = 건수 + 모든 DATE/TIMESTAMP 컬럼의 MAX  (어느 한쪽이라도 다르면 "변경됨")
    $sb = New-Object System.Text.StringBuilder
    foreach ($t in $Tables) {
        $dateCols = @($Meta.Cols[$t] | Where-Object { $_.Type -eq 'DATE' -or $_.Type -like 'TIMESTAMP*' } | ForEach-Object { "||'|'||NVL(TO_CHAR(MAX($(Q $_.Name)),'YYYYMMDDHH24MISS'),'-')" })
        [void]$sb.AppendLine("SELECT '$t|'||COUNT(*)$($dateCols -join '') FROM $(Q $t);")
    }
    $fp = @{}
    if ($sb.Length -gt 0) { foreach ($l in (Invoke-SqlPlus $Conn $sb.ToString() "Fingerprint-$Label" -Quiet)) { $i = $l.IndexOf('|'); if ($i -gt 0) { $fp[$l.Substring(0, $i)] = $l.Substring($i + 1) } } }
    return $fp
}

function Get-StageName([string]$Table, [int]$Idx) {
    # Oracle 11g 식별자 30자 제한: 접두사 포함 30자 넘으면 앞 23자 + 일련번호
    $n = $StagePrefix + $Table
    if ($n.Length -le 30) { return $n }
    return $StagePrefix + $Table.Substring(0, 23) + '_' + $Idx.ToString('000')
}

function Do-Merge {
    if (-not $script:DumpName) { throw 'Merge 하려면 -DumpName 을 지정하세요 (Export 가 출력한 파일명).' }
    $ts = Get-Date -Format 'yyyyMMdd_HHmm'
    Write-Host "`n===== Merge: $Directory\$($script:DumpName) → $DstService (변경분만) =====" -ForegroundColor Cyan

    # (0) 대상 DB 안전장치
    $dbn = @(Invoke-SqlPlus $DstConn "SELECT SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL;" 'Merge-Guard' -Quiet)[0]
    if ($dbn.ToUpper() -ne $DstService.ToUpper()) { throw "대상 DB 가 아닙니다. 중단: $dbn" }

    # (1) 메타데이터 수집 + 지문 비교로 대상 테이블 선정
    Write-Host "-- (1/5) 메타데이터 수집 및 변경 테이블 탐지" -ForegroundColor Yellow
    $src = Get-TableMeta $SrcConn 'CIT'
    $dst = Get-TableMeta $DstConn 'NEWCIT'
    $srcTables = @($src.Tables | Where-Object { $ExcludeTables -notcontains $_ -and $_ -notlike "$StagePrefix*" })
    $common    = @($srcTables | Where-Object { $dst.Tables -contains $_ })
    $newTables = @($srcTables | Where-Object { $dst.Tables -notcontains $_ })

    # 스키마 드리프트 검사: CIT 에 있는 컬럼이 NEWCIT 에 없으면 MERGE 가 깨지므로 먼저 알린다
    $drift = @()
    foreach ($t in $common) {
        $dstNames = @($dst.Cols[$t] | ForEach-Object { $_.Name })
        foreach ($c in $src.Cols[$t]) { if ($dstNames -notcontains $c.Name) { $drift += "$t.$($c.Name) ($($c.Type))" } }
    }
    if ($drift.Count -gt 0) { throw "NEWCIT 에 없는 컬럼이 있습니다. 먼저 스키마를 맞추세요(sql/NEWCIT_schema_sync_from_CIT.sql 참고):`n  " + ($drift -join "`n  ") }

    $fpSrc = Get-Fingerprints $SrcConn 'CIT'    $src $common
    $fpDst = Get-Fingerprints $DstConn 'NEWCIT' $src $common
    $changed = @($common | Where-Object { $fpSrc[$_] -ne $fpDst[$_] -or $ForceTables -contains $_ })

    Write-Host ("   공통 테이블 {0}개 중 변경 {1}개, NEWCIT 에 없는 테이블 {2}개" -f $common.Count, $changed.Count, $newTables.Count)
    $mergeTables = @(); $minusTables = @(); $skipTables = @()
    foreach ($t in $changed) {
        $hasLob = @($src.Cols[$t] | Where-Object { $_.Type -in @('CLOB', 'BLOB', 'NCLOB', 'LONG', 'LONG RAW') }).Count -gt 0
        if ($src.PK.ContainsKey($t)) { $mergeTables += $t }
        elseif (-not $hasLob)          { $minusTables += $t }
        else                           { $skipTables  += $t }
    }
    foreach ($t in $mergeTables) { Write-Host ("   MERGE  {0,-32} key=({1})  CIT[{2}]  NEWCIT[{3}]" -f $t, ($src.PK[$t] -join ','), $fpSrc[$t], $fpDst[$t]) }
    foreach ($t in $minusTables) { Write-Host ("   REPLACE {0,-31} (키 없음→전체 교체)  CIT[{1}]  NEWCIT[{2}]" -f $t, $fpSrc[$t], $fpDst[$t]) }
    foreach ($t in $newTables)   { Write-Host ("   CREATE {0,-32} (NEWCIT 에 없음 → 그대로 생성)" -f $t) }
    foreach ($t in $skipTables)  { Write-Host ("   SKIP   {0,-32} (키 없음 + LOB 컬럼 → 수동 처리 필요)" -f $t) -ForegroundColor DarkYellow }
    if ($mergeTables.Count + $minusTables.Count + $newTables.Count -eq 0) { Write-Host ">> 변경된 테이블이 없습니다. 종료." -ForegroundColor Green; return }

    # 스테이징 이름 매핑
    $stage = @{}; $i = 0
    foreach ($t in ($mergeTables + $minusTables)) { $i++; $stage[$t] = Get-StageName $t $i }

    # (2) 스테이징 import (TABLE 모드, 인덱스/제약/통계 제외, 이름 리맵)
    Write-Host "-- (2/5) Data Pump 스테이징 import ($($stage.Count + $newTables.Count)개 테이블)" -ForegroundColor Yellow
    $log = [IO.Path]::GetFileNameWithoutExtension($script:DumpName) + "_stg_$ts.log"
    $remaps = ($stage.Keys | ForEach-Object { "  DBMS_DATAPUMP.METADATA_REMAP(h, 'REMAP_TABLE', '$_', '$($stage[$_])');" }) -join "`n"
    $setup = @"
  h := DBMS_DATAPUMP.OPEN(operation => 'IMPORT', job_mode => 'TABLE', job_name => 'AXLAB_STG_$ts');
  DBMS_DATAPUMP.ADD_FILE(h, '$($script:DumpName)', '$Directory', filetype => DBMS_DATAPUMP.KU`$_FILE_TYPE_DUMP_FILE);
  DBMS_DATAPUMP.ADD_FILE(h, '$log', '$Directory', filetype => DBMS_DATAPUMP.KU`$_FILE_TYPE_LOG_FILE);
  DBMS_DATAPUMP.METADATA_FILTER(h, 'SCHEMA_EXPR', 'IN (''LINEUS'')');
  DBMS_DATAPUMP.METADATA_FILTER(h, 'NAME_EXPR', 'IN ($((SqlList (@($stage.Keys) + @($newTables))).Replace("'", "''")))');
  DBMS_DATAPUMP.METADATA_FILTER(h, 'EXCLUDE_PATH_EXPR', 'IN (''INDEX'',''CONSTRAINT'',''REF_CONSTRAINT'',''TRIGGER'',''GRANT'',''STATISTICS'',''COMMENT'')');
$remaps
  DBMS_DATAPUMP.SET_PARAMETER(h, 'TABLE_EXISTS_ACTION', 'REPLACE');   -- 이전 실패로 남은 X_ 스테이징이 있으면 덮어씀
"@
    if ($WhatIfPreference) { Write-Host "[WhatIf] import PL/SQL:`n$(New-DataPumpBlock $setup)"; } 
    else { Invoke-SqlPlus $DstConn (New-DataPumpBlock $setup) 'Merge-Stage' | Out-Null }

    # (3) MERGE / INSERT SQL 생성 및 실행 (테이블마다 COMMIT, 건수 출력)
    Write-Host "-- (3/5) MERGE / INSERT 실행" -ForegroundColor Yellow
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("SET FEEDBACK ON SQLBLANKLINES ON")
    foreach ($t in $mergeTables) {
        $keys = @($src.PK[$t]); $cols = @($src.Cols[$t]); $nonKey = @($cols | Where-Object { $keys -notcontains $_.Name })
        $on   = ($keys | ForEach-Object { "d.$(Q $_) = s.$(Q $_)" }) -join ' AND '
        $ins  = ($cols | ForEach-Object { Q $_.Name }) -join ",`n    "
        $vals = ($cols | ForEach-Object { "s.$(Q $_.Name)" }) -join ",`n    "
        [void]$sb.AppendLine("PROMPT ### MERGE $t")
        [void]$sb.AppendLine("MERGE INTO $(Q $t) d USING $(Q $stage[$t]) s ON ($on)")
        if ($nonKey.Count -gt 0) {
            $set  = ($nonKey | ForEach-Object { "d.$(Q $_.Name) = s.$(Q $_.Name)" }) -join ",`n    "
            # "운영 우선" 이되, 실제로 값이 다른 행만 UPDATE (DECODE 는 NULL=NULL 을 같다고 봄, LOB 은 길이로 비교)
            $diff = ($nonKey | ForEach-Object {
                if ($_.Type -in @('CLOB', 'BLOB', 'NCLOB')) { "DECODE(DBMS_LOB.GETLENGTH(d.$(Q $_.Name)), DBMS_LOB.GETLENGTH(s.$(Q $_.Name)), 0, 1) = 1" }
                else { "DECODE(d.$(Q $_.Name), s.$(Q $_.Name), 0, 1) = 1" } }) -join "`n     OR "
            [void]$sb.AppendLine("WHEN MATCHED THEN UPDATE SET`n    $set`n  WHERE $diff")
        }
        [void]$sb.AppendLine("WHEN NOT MATCHED THEN INSERT (`n    $ins)`n  VALUES (`n    $vals);")
        [void]$sb.AppendLine("COMMIT;")
    }
    foreach ($t in $minusTables) {
        # 키가 없으면 "어느 행이 같은 행인지" 알 수 없어 MINUS 로 없는 행만 넣으면 운영에서 수정/재등록된 행의
        # 옛 버전이 남아 중복이 생긴다(실측: CRM_AS_VOICE_HIST, CRM_CUST_OPERATE_MTAC). → 운영 내용으로 통째 교체.
        # DELETE+INSERT 를 한 트랜잭션으로 묶어 중간 실패 시 원상태로 롤백되게 한다(TRUNCATE 는 DDL 이라 롤백 불가).
        $cl = (@($src.Cols[$t]) | ForEach-Object { Q $_.Name }) -join ",`n    "
        [void]$sb.AppendLine("PROMPT ### REPLACE(키 없음, DELETE+INSERT) $t")
        [void]$sb.AppendLine("DELETE FROM $(Q $t);")
        [void]$sb.AppendLine("INSERT INTO $(Q $t) (`n    $cl)`nSELECT `n    $cl`n  FROM $(Q $stage[$t]);")
        [void]$sb.AppendLine("COMMIT;")
    }
    if ($WhatIfPreference) { Write-Host "[WhatIf] merge SQL:`n$($sb.ToString())" }
    elseif ($sb.Length -gt 0) { Invoke-SqlPlus $DstConn $sb.ToString() 'Merge-Apply' | Out-Null }

    # (4) 시퀀스 보정: NEWCIT 값이 CIT 보다 작으면 CIT 현재값까지 올린다 (키 중복 방지)
    Write-Host "-- (4/5) 시퀀스 보정" -ForegroundColor Yellow
    $seqSql = New-Object System.Text.StringBuilder
    [void]$seqSql.AppendLine("DECLARE v NUMBER; cur NUMBER; BEGIN")
    foreach ($s in $src.Seqs.Keys) {
        if (-not $dst.Seqs.ContainsKey($s)) { Write-Host "   시퀀스 $s 가 NEWCIT 에 없음 → 건너뜀" -ForegroundColor DarkYellow; continue }
        [void]$seqSql.AppendLine(@"
  SELECT LAST_NUMBER INTO cur FROM USER_SEQUENCES WHERE SEQUENCE_NAME = '$s';
  IF cur < $($src.Seqs[$s]) THEN
    EXECUTE IMMEDIATE 'ALTER SEQUENCE $(Q $s) INCREMENT BY ' || ($($src.Seqs[$s]) - cur);
    EXECUTE IMMEDIATE 'SELECT $(Q $s).NEXTVAL FROM DUAL' INTO v;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE $(Q $s) INCREMENT BY 1';
    DBMS_OUTPUT.PUT_LINE('$s : ' || cur || ' -> ' || v);
  END IF;
"@)
    }
    [void]$seqSql.AppendLine("END;`n/")
    if ($WhatIfPreference) { Write-Host "[WhatIf] sequence PL/SQL:`n$($seqSql.ToString())" }
    else { Invoke-SqlPlus $DstConn $seqSql.ToString() 'Merge-Seq' | Out-Null }

    # (5) 스테이징 삭제 (+ 옵션: 서버의 덤프/로그 파일 삭제 — 1 GB 씩 쌓이는 것 방지)
    Write-Host "-- (5/5) 스테이징 테이블 삭제" -ForegroundColor Yellow
    $drop = ($stage.Values | ForEach-Object { "DROP TABLE $(Q $_) PURGE;" }) -join "`n"
    if ($DeleteDump) {
        $base = [IO.Path]::GetFileNameWithoutExtension($script:DumpName)
        $drop += @"

BEGIN
  FOR f IN (SELECT COLUMN_VALUE fn FROM TABLE(SYS.ODCIVARCHAR2LIST('$($script:DumpName)', '${base}_exp.log', '$log'))) LOOP
    BEGIN UTL_FILE.FREMOVE('$Directory', f.fn); DBMS_OUTPUT.PUT_LINE('삭제: ' || f.fn);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('삭제 실패(무시): ' || f.fn || ' - ' || SQLERRM); END;
  END LOOP;
END;
/
"@
    }
    if ($WhatIfPreference) { Write-Host "[WhatIf] $drop" }
    elseif ($drop) { Invoke-SqlPlus $DstConn $drop 'Merge-Cleanup' | Out-Null }
    Write-Host "`n>> Merge 완료." -ForegroundColor Green
    if (-not $DeleteDump) { Write-Host "   덤프/로그는 서버 $Directory 에 남아 있습니다 (다음엔 -DeleteDump 로 자동 삭제 가능): $($script:DumpName), $log" }
}

# ---------------------------------------------------------------- Step: Import (NEWCIT 테이블 전체 교체)
function Do-Import {
    if (-not $script:DumpName) { throw 'Import 하려면 -DumpName 을 지정하세요 (Export 가 출력한 파일명).' }
    $ts = Get-Date -Format 'yyyyMMdd_HHmm'
    $log = [IO.Path]::GetFileNameWithoutExtension($script:DumpName) + "_imp_$ts.log"
    Write-Host "`n===== Import(교체): $Directory\$($script:DumpName) → $DstService =====" -ForegroundColor Cyan

    # 1) 대상 DB 확인 + 시퀀스 DROP (impdp 가 '이미 존재' 로 건너뛰므로 CIT 현재값으로 다시 만들기 위함)
    Write-Host "-- (1/3) 대상 DB 검증 및 시퀀스 삭제" -ForegroundColor Yellow
    $pre = @"
DECLARE n NUMBER := 0; BEGIN
  IF UPPER(SYS_CONTEXT('USERENV','DB_NAME')) <> UPPER('$DstService') THEN
    RAISE_APPLICATION_ERROR(-20003, '대상 DB 가 아닙니다. 중단: ' || SYS_CONTEXT('USERENV','DB_NAME'));
  END IF;
  FOR s IN (SELECT SEQUENCE_NAME FROM USER_SEQUENCES) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE "' || s.SEQUENCE_NAME || '"'; n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('DB=' || SYS_CONTEXT('USERENV','DB_NAME') || ' / 시퀀스 ' || n || '개 삭제 (import 로 재생성됨)');
END;
/
"@
    Invoke-SqlPlus $DstConn $pre 'Import-Pre' | Out-Null

    # 2) Data Pump import (테이블 전부 REPLACE, 그 외 기존 객체는 skip)
    Write-Host "-- (2/3) Data Pump import 실행 (수 분 소요)" -ForegroundColor Yellow
    $setup = @"
  h := DBMS_DATAPUMP.OPEN(operation => 'IMPORT', job_mode => 'SCHEMA', job_name => 'AXLAB_IMP_$ts');
  DBMS_DATAPUMP.ADD_FILE(h, '$($script:DumpName)', '$Directory', filetype => DBMS_DATAPUMP.KU`$_FILE_TYPE_DUMP_FILE);
  DBMS_DATAPUMP.ADD_FILE(h, '$log', '$Directory', filetype => DBMS_DATAPUMP.KU`$_FILE_TYPE_LOG_FILE);
  DBMS_DATAPUMP.METADATA_FILTER(h, 'SCHEMA_EXPR', 'IN (''LINEUS'')');
  DBMS_DATAPUMP.SET_PARAMETER(h, 'TABLE_EXISTS_ACTION', 'REPLACE');
"@
    Invoke-SqlPlus $DstConn (New-DataPumpBlock $setup) 'Import' | Out-Null

    # 3) 재컴파일 + 요약
    Write-Host "-- (3/3) 스키마 재컴파일" -ForegroundColor Yellow
    $post = @"
BEGIN DBMS_UTILITY.COMPILE_SCHEMA(schema => USER, compile_all => FALSE); END;
/
SELECT 'INVALID OBJECTS='||COUNT(*) FROM USER_OBJECTS WHERE STATUS='INVALID';
SELECT 'SEQUENCES='||COUNT(*) FROM USER_SEQUENCES;
"@
    Invoke-SqlPlus $DstConn $post 'Import-Post' | Out-Null
    Write-Host "`n>> Import 완료. 로그: $Directory\$log" -ForegroundColor Green
}

# ---------------------------------------------------------------- 실행
$script:DumpName = $DumpName
switch ($Step) {
    'Check'       { Do-Check }
    'Export'      { Do-Export }
    'Merge'       { Do-Merge; if (-not $WhatIfPreference) { Do-Check } }
    'ExportMerge' { Do-Check; Do-Export; Do-Merge; Do-Check }
    'Import'      { Do-Import; Do-Check }
    'All'         { Do-Check; Do-Export; Do-Import; Do-Check }
}
