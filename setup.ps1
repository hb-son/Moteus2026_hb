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

    $installer = "$env:TEMP\python-3.12.8-amd64.exe"
    $url = "https://www.python.org/ftp/python/3.12.8/python-3.12.8-amd64.exe"

    Write-Host "Python 설치파일 다운로드 중..."
    Invoke-WebRequest -Uri $url -OutFile $installer

    Write-Host "Python 설치 중..."
    Start-Process -FilePath $installer -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1 Include_launcher=1 Include_pip=1" -Wait

    Remove-Item $installer -Force -ErrorAction SilentlyContinue

    Write-Host "Python 설치 완료."
    Write-Host "현재 PowerShell에 PATH를 반영합니다."

    $env:Path += ";$env:LOCALAPPDATA\Programs\Python\Python312"
    $env:Path += ";$env:LOCALAPPDATA\Programs\Python\Python312\Scripts"
    $env:Path += ";$env:LOCALAPPDATA\Programs\Python\Launcher"
}

Write-Host ""
Write-Host "Python 확인:"
py -3 --version

Write-Host "기존 moteus-venv 삭제..."
Remove-Item -Recurse -Force "$HOME\moteus-venv" -ErrorAction SilentlyContinue

Write-Host "Python 가상환경 생성..."
py -3 -m venv "$HOME\moteus-venv"

$activate = "$HOME\moteus-venv\Scripts\Activate.ps1"

if (-not (Test-Path $activate)) {
    Write-Host "가상환경 생성 실패: Activate.ps1을 찾을 수 없습니다."
    exit 1
}

& $activate

Write-Host "pip 업데이트..."
python -m pip install --upgrade pip

Write-Host "moteus 설치 중..."
python -m pip install --upgrade moteus

Write-Host "tview 설치 중..."
python -m pip install --upgrade moteus-gui

Write-Host ""
Write-Host "====================================="
Write-Host " 설치 확인"
Write-Host "====================================="
python --version
python -m moteus.moteus_tool --version

Write-Host ""
Write-Host "tview 위치:"
Get-Command tview -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "====================================="
Write-Host " Moteus Windows 환경 설치 완료!"
Write-Host "====================================="
Write-Host ""
Write-Host "작업 전 실행:"
Write-Host "& `$HOME\moteus-venv\Scripts\Activate.ps1"
Write-Host ""
Write-Host "tview 실행:"
Write-Host "tview"
Write-Host ""
