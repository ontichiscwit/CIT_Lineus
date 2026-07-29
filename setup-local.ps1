# =====================================================================
# [AX Lab] 로컬 실행 자동 셋업 스크립트 (2026-07-24 작성)
# 목적: 새 PC 에서 git clone 후 이 스크립트 1회 실행으로 로컬 실행환경 구성.
#   1) JDK 8 확인 (없거나 손상 시 portable Temurin 8 자동 다운로드)
#   2) Maven 확인 (없으면 portable Maven 3.8.8 자동 다운로드)
#   2-1) Oracle JDBC 드라이버 확인 (WEB-INF/lib 의 ojdbc8.jar 또는 ojdbc7.jar 자동 감지)
#        + orai18n.jar(확장 문자집합 KO16MSWIN949 지원) 확인/자동 다운로드
#   3) settings-local.xml 생성 (http->https 미러, git 에 안 올라가는 파일)
#   4) jwcrm/local-run/tomcat-context.xml 생성 (DB 접속정보, git 에 안 올라가는 파일)
#   5) (옵션) mvn tomcat7:run 실행
#
# 사용 예:
#   powershell -ExecutionPolicy Bypass -File .\setup-local.ps1                # 대화형(비번 입력) 후 환경만 구성
#   powershell -ExecutionPolicy Bypass -File .\setup-local.ps1 -Run           # 구성 후 바로 실행
#   .\setup-local.ps1 -OraPass 'xxxx' -Run                                    # 비번 인자로 전달
#   .\setup-local.ps1 -OraHost 10.0.0.5 -OraSid orcl -OraUser hislineus -Run  # DB 정보 변경
#
# 주의:
#   - 이 스크립트에는 비밀번호를 하드코딩하지 않는다(=git 안전). 비번은 실행 시 입력받거나 -OraPass 로 전달.
#   - pom.xml 변경분/이 스크립트/.gitignore/_origin_backup 은 git 으로 커밋해야 새 PC 에 반영됨.
#   - Oracle 드라이버(ojdbc8.jar/ojdbc7.jar)는 .gitignore(*.jar) 대상이라 git 으로 전파되지 않는다.
#     각 PC 의 jwcrm/src/main/webapp/WEB-INF/lib 에 ojdbc8.jar 또는 ojdbc7.jar 중 하나를 수동 배치할 것.
#     (스크립트가 있는 파일을 감지해 pom 의 ${ojdbc.jar} 로 전달; ojdbc8 우선.)
#
# 새 PC 이식 3단계:
#   1) git clone 후, jwcrm/src/main/webapp/WEB-INF/lib 에 ojdbc7.jar 또는 ojdbc8.jar 수동 배치(유일한 수동 단계).
#   2) setup-local.config.sample.ps1 을 setup-local.config.ps1 로 복사해 DB 접속정보(IP/SID/USER/PASS) 입력.
#   3) powershell -ExecutionPolicy Bypass -File .\setup-local.ps1 -Run  실행 → 사전점검(Doctor) 통과 후 자동 기동.
#
# 트러블슈팅(자주 나오는 증상 → 원인):
#   - 화면이 비거나 안 바뀜        → (a) 8080 을 옛 tomcat 이 점유 → -Run 이 자동 종료함.
#                                     (b) 브라우저 캐시/세션 → Ctrl+Shift+R(강력 새로고침).
#   - 로그인 시 한글 깨짐/실패      → orai18n.jar 누락(KO16MSWIN949). -Run 이 자동 다운로드 시도.
#   - 로그인/조회 실패(빈 데이터)   → DB 미도달. 사전점검의 "DB 도달(TCP)" FAIL 확인 → 망/방화벽/OraHost.
#   - 빌드 시 http repo 차단        → settings-local.xml(자동 생성)의 https 미러 사용 여부 확인.
# =====================================================================
[CmdletBinding()]
param(
    [string]$OraHost    = "192.168.20.56",
    [string]$OraPort    = "1521",
    [string]$OraSid     = "orcl",
    [string]$OraService = "",   # [AX Lab] Oracle SERVICE_NAME (값이 있으면 SID 대신 서비스명 URL 사용)
    [string]$OraUser    = "hislineus",
    [string]$OraPass    = "",
    [int]   $TomcatPort = 8080,
    [string]$Jdk8Dir   = "$env:USERPROFILE\jdk8-temurin",
    [switch]$Force,     # 이미 있는 settings/context 파일도 덮어쓰기
    [switch]$Run        # 구성 후 mvn tomcat7:run 실행
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Jwcrm    = Join-Path $RepoRoot "jwcrm"

function Write-Step($msg) { Write-Host "`n==== $msg ====" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "  [OK] $msg"   -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "  [!!] $msg"   -ForegroundColor Yellow }

# BOM 없는 UTF-8 로 파일 기록. (Windows PowerShell 5.x 의 Set-Content -Encoding UTF8 은 BOM(EF BB BF)을
# 추가하는데, tomcat7-maven-plugin 의 XML 파서가 BOM 을 처리하지 못해 context.xml 파싱이 실패하므로 BOM 을 제거한다.)
function Write-Utf8NoBom($path, $content) {
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $content, $enc)
}

# ---------------------------------------------------------------------
# [AX Lab] 수정 시작 (2026-07-28): PC 별 로컬 설정 파일 분리.
#   - DB 접속정보(IP/SID/USER/PASS 등)를 스크립트에 하드코딩하면 PC/망마다 다른 값이
#     git 에 그대로 올라가고, 새 PC 에선 매번 인자로 덮어써야 해서 "이식 시 오설정" 이 잦다.
#   - 따라서 저장소 루트의 setup-local.config.ps1 (gitignore 대상) 에서 값을 읽는다.
#     이 파일이 $LocalConfig 해시테이블을 정의하면 그 값을 기본으로 사용한다.
#   - 우선순위: 명령행 인자 > setup-local.config.ps1 > 스크립트 param 기본값.
#   - 샘플: setup-local.config.sample.ps1 을 복사해 setup-local.config.ps1 로 만들어 값만 채운다.
# ---------------------------------------------------------------------
$cfgFile = Join-Path $RepoRoot "setup-local.config.ps1"
if (Test-Path $cfgFile) {
    try {
        $LocalConfig = $null
        . $cfgFile
        if ($LocalConfig -is [hashtable]) {
            foreach ($k in @('OraHost','OraPort','OraSid','OraService','OraUser','OraPass','TomcatPort','Jdk8Dir')) {
                # 명령행에서 명시적으로 준 값은 건드리지 않는다(최우선).
                if (-not $PSBoundParameters.ContainsKey($k) -and $LocalConfig.ContainsKey($k) `
                    -and $null -ne $LocalConfig[$k] -and "$($LocalConfig[$k])" -ne "") {
                    Set-Variable -Name $k -Value $LocalConfig[$k]
                }
            }
            Write-Ok "로컬 설정 적용: $cfgFile"
        } else {
            Write-Warn2 "$cfgFile 에 `$LocalConfig 해시테이블이 없습니다. 건너뜁니다."
        }
    } catch {
        Write-Warn2 "로컬 설정 파일 로드 실패($cfgFile): $($_.Exception.Message)"
    }
} else {
    Write-Warn2 "로컬 설정 파일 없음: $cfgFile  (없어도 됨: 인자/기본값/대화형 입력 사용. setup-local.config.sample.ps1 참고)"
}

# Oracle JDBC URL 조립: SERVICE_NAME 이 지정되면 서비스명 형식(@//host:port/service), 아니면 SID 형식(@host:port:sid).
if (-not [string]::IsNullOrWhiteSpace($OraService)) {
    $OraJdbcUrl = "jdbc:oracle:thin:@//${OraHost}:${OraPort}/${OraService}"
    $OraDbDesc  = "$OraUser@$OraHost`:$OraPort/$OraService (SERVICE_NAME)"
} else {
    $OraJdbcUrl = "jdbc:oracle:thin:@${OraHost}:${OraPort}:${OraSid}"
    $OraDbDesc  = "$OraUser@$OraHost`:$OraPort`:$OraSid (SID)"
}
# [AX Lab] 수정 끝

# ---------------------------------------------------------------------
# 1) 유효한 JDK 8 확보 (javac 가 실제로 동작하는지 검증: 손상된 tools.jar 걸러냄)
# ---------------------------------------------------------------------
function Test-Jdk8($JdkHome) {
    # 유효한 JDK 8 인지 검사: javac.exe + tools.jar 존재 + release=1.8 + tools.jar 무손상(zip 안에 컴파일러 클래스 존재)
    # (javac -version 실행 캡처는 환경에 따라 불안정하여 파일 기반으로 검증)
    if ([string]::IsNullOrWhiteSpace($JdkHome)) { return $false }
    if (-not (Test-Path (Join-Path $JdkHome "bin\javac.exe"))) { return $false }
    $toolsJar = Join-Path $JdkHome "lib\tools.jar"
    if (-not (Test-Path $toolsJar)) { return $false }
    $release = Join-Path $JdkHome "release"
    if (-not (Test-Path $release)) { return $false }
    if (-not (Select-String -Path $release -Pattern 'JAVA_VERSION="1\.8' -Quiet)) { return $false }
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $z = [System.IO.Compression.ZipFile]::OpenRead($toolsJar)
        $hasCompiler = $null -ne ($z.Entries | Where-Object { $_.FullName -eq 'com/sun/tools/javac/Main.class' } | Select-Object -First 1)
        $z.Dispose()
        return $hasCompiler
    } catch {
        return $false   # tools.jar 가 손상되어 zip 으로 열리지 않는 경우
    }
}

function Find-Jdk8 {
    # 후보 경로들을 순서대로 검사
    $cands = @()
    if ($env:JAVA_HOME) { $cands += $env:JAVA_HOME }
    if (Test-Path $Jdk8Dir) {
        $cands += (Get-ChildItem $Jdk8Dir -Directory -ErrorAction SilentlyContinue |
                   Where-Object { $_.Name -like "jdk8*" -or $_.Name -like "*1.8*" } |
                   ForEach-Object { $_.FullName })
    }
    foreach ($base in @("C:\Program Files\Java","C:\Program Files\Eclipse Adoptium","C:\Program Files\Zulu","C:\Program Files\Amazon Corretto")) {
        if (Test-Path $base) {
            $cands += (Get-ChildItem $base -Directory -ErrorAction SilentlyContinue |
                       Where-Object { $_.Name -like "*1.8*" -or $_.Name -like "jdk8*" -or $_.Name -like "jdk-8*" } |
                       ForEach-Object { $_.FullName })
        }
    }
    foreach ($c in $cands) { if (Test-Jdk8 $c) { return $c } }
    return $null
}

function Install-PortableJdk8 {
    Write-Warn2 "유효한 JDK 8 이 없어 portable Temurin 8 을 다운로드합니다..."
    New-Item -ItemType Directory -Force -Path $Jdk8Dir | Out-Null
    $zip = Join-Path $env:TEMP "temurin8.zip"
    $url = "https://api.adoptium.net/v3/binary/latest/8/ga/windows/x64/jdk/hotspot/normal/eclipse?project=jdk"
    $old = $ProgressPreference; $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    $ProgressPreference = $old
    Expand-Archive -Path $zip -DestinationPath $Jdk8Dir -Force
    Remove-Item $zip -ErrorAction SilentlyContinue
    $home8 = (Get-ChildItem $Jdk8Dir -Directory | Where-Object { $_.Name -like "jdk8*" } | Select-Object -First 1).FullName
    if (-not (Test-Jdk8 $home8)) { throw "portable JDK 8 설치 후에도 javac 검증 실패: $home8" }
    return $home8
}

Write-Step "1. JDK 8 확인"
$Java8Home = Find-Jdk8
if ($Java8Home) {
    Write-Ok "사용할 JDK 8: $Java8Home"
} else {
    $Java8Home = Install-PortableJdk8
    Write-Ok "portable JDK 8 설치 완료: $Java8Home"
}

# ---------------------------------------------------------------------
# 2) Maven 확인
# ---------------------------------------------------------------------
function Install-PortableMaven {
    $mvnDir = Join-Path $env:USERPROFILE "apache-maven"
    $cmd = Join-Path $mvnDir "apache-maven-3.8.8\bin\mvn.cmd"
    # 이미 설치돼 있으면 재다운로드/재압축해제하지 않고 재사용 (반복 실행 시 잠긴 DLL 덮어쓰기 오류 방지)
    if (Test-Path $cmd) {
        Write-Ok "기존 portable Maven 재사용: $cmd"
        return $cmd
    }
    Write-Warn2 "Maven 이 없어 portable Apache Maven 3.8.8 을 다운로드합니다..."
    New-Item -ItemType Directory -Force -Path $mvnDir | Out-Null
    $zip = Join-Path $env:TEMP "maven388.zip"
    $url = "https://archive.apache.org/dist/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.zip"
    $old = $ProgressPreference; $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    $ProgressPreference = $old
    Expand-Archive -Path $zip -DestinationPath $mvnDir -Force
    Remove-Item $zip -ErrorAction SilentlyContinue
    $cmd = Join-Path $mvnDir "apache-maven-3.8.8\bin\mvn.cmd"
    if (-not (Test-Path $cmd)) { throw "Maven 설치 실패: $cmd 없음" }
    return $cmd
}

Write-Step "2. Maven 확인"
$mvn = Get-Command mvn -ErrorAction SilentlyContinue
if ($mvn) {
    $MvnCmd = $mvn.Source
    Write-Ok "Maven: $MvnCmd"
} else {
    $MvnCmd = Install-PortableMaven
    Write-Ok "portable Maven 설치 완료: $MvnCmd"
}

# ---------------------------------------------------------------------
# 2-1) Oracle JDBC 드라이버(ojdbc) 확인
#   - WEB-INF/lib 의 ojdbc*.jar 은 .gitignore(*.jar) 대상이라 git clone 으로는 받아지지 않는다.
#     (Oracle 라이선스상 Maven Central 에도 없어 각 PC 에 수동 배치가 필요.)
#   - PC 마다 ojdbc8.jar 또는 ojdbc7.jar 중 하나만 있어도 되도록, 있는 파일을 감지해 pom 의
#     ${ojdbc.jar} 프로퍼티로 전달한다(ojdbc8 우선). 둘 다 없으면 명확히 안내하고 중단.
# ---------------------------------------------------------------------
Write-Step "2-1. Oracle JDBC 드라이버(ojdbc) 확인"
$LibDir = Join-Path $Jwcrm "src\main\webapp\WEB-INF\lib"
$OjdbcJar = $null
foreach ($cand in @("ojdbc8.jar", "ojdbc7.jar")) {
    if (Test-Path (Join-Path $LibDir $cand)) { $OjdbcJar = $cand; break }
}
if ($OjdbcJar) {
    Write-Ok "사용할 Oracle 드라이버: $OjdbcJar  ($LibDir)"
} else {
    Write-Warn2 "Oracle 드라이버가 없습니다. 아래 위치에 ojdbc8.jar 또는 ojdbc7.jar 를 넣어주세요:"
    Write-Warn2 "  $LibDir"
    Write-Warn2 "  (git 에 올라가지 않는 파일입니다. 기존 PC 의 같은 경로에서 복사하거나 Oracle 에서 내려받으세요.)"
    throw "ojdbc 드라이버(jar) 미존재로 중단"
}

# ---------------------------------------------------------------------
# [AX Lab] 수정 시작 (2026-07-24): orai18n.jar(Oracle NLS 확장 문자집합) 확인/자동 배치.
#   ojdbc 만으로는 KO16MSWIN949 등 확장 charset 변환 클래스가 없어, 로그인 프로시저
#   PROC_EMP_LOGIN_INFO 가 한글 결과를 반환할 때 아래 SQLException 이 발생한다:
#     "지원되지 않는 문자 집합(클래스 경로에 orai18n.jar 추가): KO16MSWIN949"
#   따라서 ojdbc 와 동일 릴리스의 orai18n.jar 을 WEB-INF/lib 에 둔다. 없으면 ojdbc 매니페스트
#   버전을 읽어 Maven Central 에서 같은 버전을 자동 다운로드한다(오프라인/미존재 시 수동 안내).
# ---------------------------------------------------------------------
function Get-JarImplVersion($jarPath) {
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $zf = [System.IO.Compression.ZipFile]::OpenRead($jarPath)
        $mf = $zf.Entries | Where-Object { $_.FullName -eq 'META-INF/MANIFEST.MF' } | Select-Object -First 1
        if (-not $mf) { $zf.Dispose(); return $null }
        $sr = New-Object System.IO.StreamReader($mf.Open())
        $txt = $sr.ReadToEnd(); $sr.Close(); $zf.Dispose()
        $m = [regex]::Match($txt, 'Implementation-Version:\s*([0-9][0-9.]+)')
        if ($m.Success) { return $m.Groups[1].Value.Trim() }
        return $null
    } catch { return $null }
}

$Orai18nPath = Join-Path $LibDir "orai18n.jar"
if (Test-Path $Orai18nPath) {
    Write-Ok "orai18n.jar 존재: $Orai18nPath"
} else {
    Write-Warn2 "orai18n.jar 이 없습니다. ojdbc 버전에 맞춰 Maven Central 에서 자동 다운로드를 시도합니다..."
    # ojdbc 매니페스트에서 정확한 버전(예:19.23.0.0.0)을 읽어 orai18n 좌표 버전(예:19.23.0.0)으로 변환
    $ojdbcVer   = Get-JarImplVersion (Join-Path $LibDir $OjdbcJar)
    $orai18nVer = "19.23.0.0"   # 기본값(현재 표준 ojdbc8 = 19.23.0.0.0)
    if ($ojdbcVer) {
        $segs = $ojdbcVer.Split('.')
        if ($segs.Count -ge 4) { $orai18nVer = ($segs[0..3] -join '.') }
        Write-Ok "감지된 ojdbc 버전: $ojdbcVer  -> orai18n $orai18nVer 우선 시도"
    } else {
        Write-Warn2 "ojdbc 버전 자동감지 실패 -> 기본 orai18n $orai18nVer 로 시도"
    }

    # [AX Lab] 수정 시작 (2026-07-28): ojdbc7(12.1.0.2 등) 처럼 동일 버전 orai18n 이
    #   Maven Central 에 없어 404 로 중단되던 문제 근본 수정.
    #   - orai18n 은 한글 charset(KO16MSWIN949) 클래스 제공 목적이라 major 가 같은 최신 릴리스로도 호환됨.
    #   - "정확 버전 -> 동일 major 의 Central 존재 버전 -> 안전 기본값" 순으로 후보를 만들어
    #     첫 성공까지 순차 시도(폴백)한다. 후보 맵은 maven-metadata.xml 기준 실제 존재 버전으로 구성.
    #   (Maven Central 존재 버전 예: 11.2.0.4 / 12.2.0.1 / 18.3.0.0 / 19.x / 21.x / 23.x, 12.1.0.2 는 없음)
    $orai18nFallbackByMajor = @{
        "11" = "11.2.0.4"
        "12" = "12.2.0.1"
        "18" = "18.3.0.0"
        "19" = "19.23.0.0"
        "21" = "21.11.0.0"
        "23" = "23.6.0.24.10"
    }
    $orai18nCandidates = New-Object System.Collections.Generic.List[string]
    $orai18nCandidates.Add($orai18nVer)                 # 1) ojdbc 와 정확히 동일한 버전 우선
    $major = $orai18nVer.Split('.')[0]
    if ($orai18nFallbackByMajor.ContainsKey($major)) {  # 2) 동일 major 의 Central 존재 버전
        $orai18nCandidates.Add($orai18nFallbackByMajor[$major])
    }
    $orai18nCandidates.Add("19.23.0.0")                 # 3) 최종 안전 기본값(JDK8 호환)
    # 중복 제거(순서 유지)
    $orai18nCandidates = $orai18nCandidates | Select-Object -Unique

    $downloaded = $false
    $lastErr = $null
    foreach ($ver in $orai18nCandidates) {
        $orai18nUrl = "https://repo1.maven.org/maven2/com/oracle/database/nls/orai18n/$ver/orai18n-$ver.jar"
        try {
            $old = $ProgressPreference; $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $orai18nUrl -OutFile $Orai18nPath -UseBasicParsing
            $ProgressPreference = $old
            if ($ver -ne $orai18nVer) {
                Write-Warn2 "동일 버전($orai18nVer) 없음 -> 호환 버전 $ver 로 대체 다운로드"
            }
            Write-Ok "orai18n.jar 다운로드 완료: $Orai18nPath ($ver)"
            $downloaded = $true
            break
        } catch {
            $lastErr = $_.Exception.Message
            Write-Warn2 "orai18n $ver 다운로드 실패: $lastErr"
        }
    }
    if (-not $downloaded) {
        Write-Warn2 "orai18n.jar 자동 다운로드 실패(모든 후보 소진): $lastErr"
        Write-Warn2 "  아래 위치에 orai18n.jar(ojdbc 와 호환되는 버전)을 수동으로 넣어주세요:"
        Write-Warn2 "  $Orai18nPath"
        Write-Warn2 "  다운로드 예시 URL: https://repo1.maven.org/maven2/com/oracle/database/nls/orai18n/19.23.0.0/orai18n-19.23.0.0.jar"
        throw "orai18n.jar 미존재 및 자동 다운로드 실패로 중단"
    }
    # [AX Lab] 수정 끝
}
# [AX Lab] 수정 끝

# ---------------------------------------------------------------------
# 3) settings-local.xml 생성 (http -> https 미러)
# ---------------------------------------------------------------------
Write-Step "3. settings-local.xml 생성"
$settingsPath = Join-Path $RepoRoot "settings-local.xml"
if ((Test-Path $settingsPath) -and (-not $Force)) {
    Write-Ok "이미 존재 (건너뜀): $settingsPath  (덮어쓰려면 -Force)"
} else {
    $settingsXml = @'
<?xml version="1.0" encoding="UTF-8"?>
<!-- [AX Lab] 로컬 빌드 전용 Maven 설정: pom.xml 의 http 저장소를 https 미러로 우회 (Maven 3.8+ http 차단 대응) -->
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>egovframe-secure</id>
      <name>eGovFrame Maven (HTTPS)</name>
      <url>https://maven.egovframe.go.kr/maven/</url>
      <mirrorOf>egovframe</mirrorOf>
    </mirror>
    <mirror>
      <id>terracotta-secure</id>
      <name>Terracotta Maven (HTTPS)</name>
      <url>https://repo.terracotta.org/maven2/</url>
      <mirrorOf>terracotta-repository,terracotta-snapshots</mirrorOf>
    </mirror>
    <mirror>
      <id>http-to-central-secure</id>
      <name>All external HTTP repos -> Maven Central (HTTPS)</name>
      <url>https://repo1.maven.org/maven2/</url>
      <mirrorOf>external:http:*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
'@
    Write-Utf8NoBom $settingsPath $settingsXml
    Write-Ok "생성: $settingsPath"
}

# ---------------------------------------------------------------------
# 4) jwcrm/local-run/tomcat-context.xml 생성 (DB 접속정보)
# ---------------------------------------------------------------------
Write-Step "4. tomcat-context.xml (JNDI 데이터소스) 생성"
$localRunDir  = Join-Path $Jwcrm "local-run"
$contextPath  = Join-Path $localRunDir "tomcat-context.xml"
if ((Test-Path $contextPath) -and (-not $Force)) {
    Write-Ok "이미 존재 (건너뜀): $contextPath  (덮어쓰려면 -Force)"
} else {
    if ([string]::IsNullOrWhiteSpace($OraPass)) {
        $sec = Read-Host -Prompt "Oracle 비밀번호 입력 ($OraDbDesc)" -AsSecureString
        $OraPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                     [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
    }
    New-Item -ItemType Directory -Force -Path $localRunDir | Out-Null
    $ctx = @"
<?xml version="1.0" encoding="UTF-8"?>
<!--
  [AX Lab] 로컬 실행 전용 Tomcat Context (setup-local.ps1 생성)
  - mvn tomcat7:run 기동 시 JNDI 데이터소스 제공. WAR 미포함, 운영과 무관. 절대 커밋 금지.
-->
<Context>
    <Resource name="jdbc/lineUsDs" auth="Container" type="javax.sql.DataSource"
              factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
              driverClassName="oracle.jdbc.OracleDriver"
              url="${OraJdbcUrl}"
              username="${OraUser}" password="${OraPass}"
              initialSize="1" maxActive="20" maxIdle="5" minIdle="1" maxWait="10000"
              validationQuery="select 1 from dual" testOnBorrow="true" testWhileIdle="true"
              timeBetweenEvictionRunsMillis="600000" />

    <!-- MS-SQL: AS 화면과 무관. 기동 시 조회만 필요하므로 더미(initialSize=0). 실제 사용 시 값 교체 -->
    <Resource name="jdbc/ciCrmDs" auth="Container" type="javax.sql.DataSource"
              factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
              driverClassName="net.sourceforge.jtds.jdbc.Driver"
              url="jdbc:jtds:sqlserver://127.0.0.1:1433/CICRM"
              username="sa" password="dummy"
              initialSize="0" maxActive="5" maxIdle="1" minIdle="0" maxWait="5000"
              testOnBorrow="false" testWhileIdle="false" />
</Context>
"@
    Write-Utf8NoBom $contextPath $ctx
    Write-Ok "생성: $contextPath  (Oracle: $OraDbDesc)"
}

# ---------------------------------------------------------------------
# [AX Lab] 수정 시작 (2026-07-28): 사전점검(Doctor) 요약.
#   - 기동 전에 필수 조건을 한 번에 PASS/FAIL 로 보여줘, 새 PC 에서 "왜 안 되는지" 를
#     로그를 뒤지지 않고 즉시 파악하게 한다. (특히 DB 네트워크 도달 여부)
#   - 치명 항목(JDK/Maven/ojdbc/orai18n)은 위 단계에서 이미 throw 되므로 여기선 상태 표기 위주.
#   - DB 미도달은 경고로만 표기(DB 가 나중에 열리는 경우도 있어 강제 중단하지 않음). 기동 후 헬스체크로 재확인.
# ---------------------------------------------------------------------
function Test-TcpPort($h, $p, $timeoutMs = 3000) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $iar = $client.BeginConnect($h, [int]$p, $null, $null)
        $ok = $iar.AsyncWaitHandle.WaitOne($timeoutMs, $false)
        if ($ok -and $client.Connected) { $client.EndConnect($iar); $client.Close(); return $true }
        $client.Close(); return $false
    } catch { return $false }
}
function PassFail($b) { if ($b) { return "PASS" } else { return "FAIL" } }

Write-Step "환경 사전점검 (Doctor)"
$jdkOk   = [bool]$Java8Home
$mvnOk   = ($MvnCmd -and (Test-Path $MvnCmd))
$ojdbcOk = ($OjdbcJar -and (Test-Path (Join-Path $LibDir $OjdbcJar)))
$oraiOk  = (Test-Path $Orai18nPath)
$dbOk    = Test-TcpPort $OraHost $OraPort
$portOwnersPre = Get-NetTCPConnection -LocalPort $TomcatPort -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
if ($portOwnersPre) {
    $portResult = "USED"
    $portDetail = ":$TomcatPort 점유 PID $($portOwnersPre -join ',') (-Run 시 자동 정리)"
} else {
    $portResult = "FREE"
    $portDetail = ":$TomcatPort 사용 가능"
}
$checks = @()
$checks += [pscustomobject]@{ 항목="JDK 8";       결과=(PassFail $jdkOk);   상세="$Java8Home" }
$checks += [pscustomobject]@{ 항목="Maven";        결과=(PassFail $mvnOk);   상세="$MvnCmd" }
$checks += [pscustomobject]@{ 항목="ojdbc";        결과=(PassFail $ojdbcOk); 상세="$OjdbcJar" }
$checks += [pscustomobject]@{ 항목="orai18n";      결과=(PassFail $oraiOk);  상세="orai18n.jar (KO16MSWIN949)" }
$checks += [pscustomobject]@{ 항목="DB 도달(TCP)"; 결과=(PassFail $dbOk);    상세="$OraDbDesc" }
$checks += [pscustomobject]@{ 항목="Tomcat 포트";  결과=$portResult;         상세=$portDetail }
$checks | Format-Table -AutoSize | Out-String | Write-Host
if (-not $dbOk) {
    Write-Warn2 "DB($OraHost`:$OraPort) 에 TCP 로 접속되지 않습니다. 방화벽/VPN/사내망/DB 기동 여부를 확인하세요."
    Write-Warn2 "  (DB 가 안 열리면 서버는 떠도 로그인/조회가 실패합니다. setup-local.config.ps1 의 OraHost/OraPort 확인.)"
}
# [AX Lab] 수정 끝

# ---------------------------------------------------------------------
# 5) 완료 안내 / 실행
# ---------------------------------------------------------------------
Write-Step "셋업 완료"
Write-Host "  JAVA_HOME  = $Java8Home"
Write-Host "  settings   = $settingsPath"
Write-Host "  context    = $contextPath"
Write-Host "  ojdbc      = $OjdbcJar"
Write-Host "  orai18n    = orai18n.jar (KO16MSWIN949 지원)"
Write-Host "  Tomcat 포트 = (pom.xml 의 tomcat7-plugin 설정 사용)"
Write-Host ""
Write-Host "  [수동 실행 명령]" -ForegroundColor Cyan
Write-Host "    `$env:JAVA_HOME='$Java8Home'"
Write-Host "    cd '$Jwcrm'"
Write-Host "    & '$MvnCmd' -s '$settingsPath' `"-Dojdbc.jar=$OjdbcJar`" tomcat7:run"
Write-Host ""
Write-Host "  접속: http://localhost:$TomcatPort/   (AS 통합화면: /ad/as/list.do)" -ForegroundColor Green

if ($Run) {
    Write-Step "mvn tomcat7:run 실행"

    # [AX Lab] 수정 시작 (2026-07-28): 기동 전 기존 tomcat 인스턴스(포트 점유) 정리.
    #   - 재실행할 때 이전 mvn tomcat7:run 프로세스가 살아 8080 을 계속 점유하면,
    #     새로 띄운 서버는 포트 바인딩에 실패하고 브라우저는 "옛 인스턴스"에 붙어
    #     방금 고친 코드/의존성이 반영 안 된 것처럼 보이는(빈 화면 등) 혼선이 발생한다.
    #   - 따라서 $TomcatPort 를 LISTEN 중인 프로세스를 찾아 종료한 뒤 새로 기동한다.
    $portOwners = @()
    try {
        $portOwners = Get-NetTCPConnection -LocalPort $TomcatPort -State Listen -ErrorAction SilentlyContinue |
                      Select-Object -ExpandProperty OwningProcess -Unique
    } catch { $portOwners = @() }
    if ($portOwners -and $portOwners.Count -gt 0) {
        Write-Warn2 "포트 $TomcatPort 을(를) 이미 사용 중인 프로세스가 있습니다 (PID: $($portOwners -join ', ')). 기존 인스턴스를 종료합니다."
        foreach ($opid in $portOwners) {
            try {
                Stop-Process -Id $opid -Force -ErrorAction Stop
                Write-Ok "기존 프로세스 종료: PID $opid"
            } catch {
                Write-Warn2 "PID $opid 종료 실패: $($_.Exception.Message) (관리자 권한이 필요할 수 있습니다)"
            }
        }
        # 포트가 실제로 해제될 때까지 잠시 대기
        for ($i = 0; $i -lt 10; $i++) {
            Start-Sleep -Milliseconds 500
            $still = Get-NetTCPConnection -LocalPort $TomcatPort -State Listen -ErrorAction SilentlyContinue
            if (-not $still) { break }
        }
        $still = Get-NetTCPConnection -LocalPort $TomcatPort -State Listen -ErrorAction SilentlyContinue
        if ($still) {
            throw "포트 $TomcatPort 이(가) 여전히 사용 중입니다. 기존 프로세스를 수동으로 종료 후 다시 실행하세요."
        }
        Write-Ok "포트 $TomcatPort 정리 완료"
    } else {
        Write-Ok "포트 $TomcatPort 사용 가능 (기존 인스턴스 없음)"
    }
    # [AX Lab] 수정 끝

    $env:JAVA_HOME = $Java8Home
    $env:Path = "$Java8Home\bin;$env:Path"
    Push-Location $Jwcrm
    try {
        # [AX Lab] 수정 시작 (2026-07-28): 기동 후 자동 헬스체크.
        #   - mvn 을 자식 프로세스로 띄우고(로그는 그대로 콘솔에 스트리밍), 로그인 페이지가 200 을
        #     돌려줄 때까지 폴링한다. 성공하면 "이 인스턴스가 :$TomcatPort 에서 서비스 중" 을 명시해,
        #     이번처럼 옛 인스턴스/캐시로 인한 혼선을 원천 차단한다.
        $mvnArgs = @('-s', $settingsPath, "-Dojdbc.jar=$OjdbcJar", 'tomcat7:run')
        Write-Ok "mvn 기동: $MvnCmd $($mvnArgs -join ' ')"
        $proc = Start-Process -FilePath $MvnCmd -ArgumentList $mvnArgs -WorkingDirectory $Jwcrm -NoNewWindow -PassThru

        $healthUrl = "http://localhost:$TomcatPort/ad/login/form.do"
        $health = $false
        for ($i = 0; $i -lt 60; $i++) {   # 최대 약 120초(2초 * 60) 대기
            Start-Sleep -Seconds 2
            if ($proc.HasExited) { break }
            try {
                $resp = Invoke-WebRequest -Uri $healthUrl -UseBasicParsing -TimeoutSec 3
                if ($resp.StatusCode -eq 200) { $health = $true; break }
            } catch { }
        }
        Write-Host ""
        if ($health) {
            Write-Ok "헬스체크 성공: $healthUrl → 200 (이 인스턴스가 :$TomcatPort 에서 정상 서비스 중)"
            Write-Host "  접속: http://localhost:$TomcatPort/   (AS 통합화면: /ad/as/list.do)" -ForegroundColor Green
            Write-Host "  * 화면이 그대로면 브라우저에서 Ctrl+Shift+R(강력 새로고침) 하세요(옛 캐시/세션 제거)." -ForegroundColor Green
        } elseif ($proc.HasExited) {
            Write-Warn2 "서버가 조기 종료되었습니다 (exit=$($proc.ExitCode)). 위 로그의 오류를 확인하세요."
        } else {
            Write-Warn2 "헬스체크 시간초과: $healthUrl 응답 없음. 위 로그/DB 접속($OraHost`:$OraPort)을 확인하세요."
        }
        if (-not $proc.HasExited) { Wait-Process -Id $proc.Id }   # 서버 종료까지 콘솔 유지(기존 foreground 동작 유지)
        # [AX Lab] 수정 끝
    } finally {
        Pop-Location
    }
}
