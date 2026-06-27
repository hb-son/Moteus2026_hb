Write-Host ""
Write-Host "====================================="
Write-Host " Moteus Windows 환경 설치 시작"
Write-Host "====================================="
Write-Host ""

$ErrorActionPreference = "Stop"

$py = Get-Command py -ErrorAction SilentlyContinue

if (-not $py) {
    Write-Host "Python Launcher(py)가 없습니다. winget으로 Python 설치를 시도합니다."

    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Host "winget이 없습니다. python.org에서 Python 3.12 이상을 설치하세요."
        exit 1
    }

    winget install -e --id Python.Python.3.12
    Write-Host "Python 설치 완료. PowerShell을 닫고 다시 열어 같은 명령을 다시 실행하세요."
    exit 0
}

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
