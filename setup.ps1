Write-Host ""
Write-Host "====================================="
Write-Host " Moteus Windows 환경 설치 시작"
Write-Host "====================================="
Write-Host ""

$ErrorActionPreference = "Stop"

# 1. Python 확인
$py = Get-Command py -ErrorAction SilentlyContinue

if (-not $py) {
    Write-Host "Python Launcher(py)가 없습니다. winget으로 Python 설치를 시도합니다."

    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Host "winget이 없습니다. Microsoft Store 또는 python.org에서 Python 3.12 이상을 먼저 설치하세요."
        exit 1
    }

    winget install -e --id Python.Python.3.12

    Write-Host ""
    Write-Host "Python 설치가 끝났습니다."
    Write-Host "PowerShell을 완전히 닫았다가 다시 열고, 설치 명령을 한 번 더 실행하세요."
    exit 0
}

# 2. 기존 가상환경 삭제
Write-Host "기존 moteus-venv 삭제..."
Remove-Item -Recurse -Force "$HOME\moteus-venv" -ErrorAction SilentlyContinue

# 3. 가상환경 생성
Write-Host "Python 가상환경 생성..."
py -3 -m venv "$HOME\moteus-venv"

$activate = "$HOME\moteus-venv\Scripts\Activate.ps1"

if (-not (Test-Path $activate)) {
    Write-Host "가상환경 생성 실패: Activate.ps1을 찾을 수 없습니다."
    Write-Host "Python 설치 상태를 확인하세요: py -3 --version"
    exit 1
}

# 4. 가상환경 활성화
& $activate

# 5. pip 업데이트
Write-Host "pip 업데이트..."
python -m pip install --upgrade pip

# 6. moteus 설치
Write-Host "moteus 설치 중..."
python -m pip install --upgrade moteus

# 7. tview 설치
Write-Host "tview 설치 중..."
python -m pip install --upgrade moteus-gui

# 8. 설치 확인
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
Write-Host "앞으로 작업 전에는 PowerShell에서 아래 명령어를 실행하세요."
Write-Host ""
Write-Host "& `$HOME\moteus-venv\Scripts\Activate.ps1"
Write-Host ""
Write-Host "그 다음 tview 실행:"
Write-Host ""
Write-Host "tview"
Write-Host ""
