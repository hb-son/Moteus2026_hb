$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "====================================="
Write-Host " Moteus Windows 환경 설치 시작"
Write-Host "====================================="
Write-Host ""

function Test-Python {
    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) {
        try {
            py -3 --version
            return $true
        } catch {
            return $false
        }
    }
    return $false
}

if (-not (Test-Python)) {
    Write-Host "Python이 없습니다. python.org 설치파일로 자동 설치합니다."

    $installer = "$env:TEMP\python-3.12.10-amd64.exe"
    $url = "https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe"

    Write-Host "Python 설치파일 다운로드 중..."
    Invoke-WebRequest -Uri $url -OutFile $installer

    Write-Host "Python 설치 중..."
    Start-Process -FilePath $installer -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1 Include_launcher=1 Include_pip=1" -Wait

    Remove-Item $installer -Force -ErrorAction SilentlyContinue

    $env:Path += ";$env:LOCALAPPDATA\Programs\Python\Python312"
    $env:Path += ";$env:LOCALAPPDATA\Programs\Python\Python312\Scripts"
}

Write-Host ""
Write-Host "Python 확인:"
py -3 --version

Write-Host "기존 moteus-venv 삭제..."
Remove-Item -Recurse -Force "$HOME\moteus-venv" -ErrorAction SilentlyContinue

Write-Host "Python 가상환경 생성..."
py -3 -m venv "$HOME\moteus-venv"

$venvPython = "$HOME\moteus-venv\Scripts\python.exe"
$venvTview = "$HOME\moteus-venv\Scripts\tview.exe"

if (-not (Test-Path $venvPython)) {
    Write-Host "가상환경 생성 실패: python.exe를 찾을 수 없습니다."
    exit 1
}

Write-Host "pip 업데이트..."
& $venvPython -m pip install --upgrade pip

Write-Host "moteus 설치 중..."
& $venvPython -m pip install --upgrade moteus

Write-Host "tview 설치 중..."
& $venvPython -m pip install --upgrade moteus-gui

Write-Host ""
Write-Host "====================================="
Write-Host " 설치 확인"
Write-Host "====================================="
& $venvPython --version
& $venvPython -m moteus.moteus_tool --version

Write-Host ""
Write-Host "tview 위치:"
if (Test-Path $venvTview) {
    Write-Host $venvTview
} else {
    Write-Host "tview.exe를 찾을 수 없습니다."
}

Write-Host ""
Write-Host "====================================="
Write-Host " Moteus Windows 환경 설치 완료!"
Write-Host "====================================="
Write-Host ""
Write-Host "앞으로 작업 전에는 아래 명령어를 실행하세요:"
Write-Host ""
Write-Host "& `$HOME\moteus-venv\Scripts\Activate.ps1"
Write-Host ""
Write-Host "만약 보안 오류가 뜨면 tview는 아래처럼 실행하세요:"
Write-Host ""
Write-Host "& `$HOME\moteus-venv\Scripts\tview.exe"
Write-Host ""
