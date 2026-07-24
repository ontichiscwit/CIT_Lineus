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
# =====================================================================
[CmdletBinding()]
param(
    [string]$OraHost   = "192.168.20.56",
    [string]$OraPort   = "1521",
    [string]$OraSid    = "orcl",
    [string]$OraUser   = "hislineus",
    [string]$OraPass   = "",
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
        Write-Ok "감지된 ojdbc 버전: $ojdbcVer  -> orai18n $orai18nVer 다운로드 시도"
    } else {
        Write-Warn2 "ojdbc 버전 자동감지 실패 -> 기본 orai18n $orai18nVer 로 시도"
    }
    $orai18nUrl = "https://repo1.maven.org/maven2/com/oracle/database/nls/orai18n/$orai18nVer/orai18n-$orai18nVer.jar"
    try {
        $old = $ProgressPreference; $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $orai18nUrl -OutFile $Orai18nPath -UseBasicParsing
        $ProgressPreference = $old
        Write-Ok "orai18n.jar 다운로드 완료: $Orai18nPath ($orai18nVer)"
    } catch {
        Write-Warn2 "orai18n.jar 자동 다운로드 실패: $($_.Exception.Message)"
        Write-Warn2 "  아래 위치에 orai18n.jar(ojdbc 와 동일 버전)을 수동으로 넣어주세요:"
        Write-Warn2 "  $Orai18nPath"
        Write-Warn2 "  다운로드 예시 URL: $orai18nUrl"
        throw "orai18n.jar 미존재 및 자동 다운로드 실패로 중단"
    }
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
        $sec = Read-Host -Prompt "Oracle 비밀번호 입력 ($OraUser@$OraHost`:$OraPort`:$OraSid)" -AsSecureString
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
              url="jdbc:oracle:thin:@${OraHost}:${OraPort}:${OraSid}"
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
    Write-Ok "생성: $contextPath  (Oracle: $OraUser@$OraHost`:$OraPort`:$OraSid)"
}

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
    $env:JAVA_HOME = $Java8Home
    $env:Path = "$Java8Home\bin;$env:Path"
    Push-Location $Jwcrm
    try {
        & $MvnCmd -s $settingsPath "-Dojdbc.jar=$OjdbcJar" tomcat7:run
    } finally {
        Pop-Location
    }
}
