#!/bin/bash

set -e

echo ""
echo "====================================="
echo " Moteus Mac 환경 설치 시작"
echo "====================================="
echo ""

# 1. Xcode Command Line Tools 확인
if ! xcode-select -p >/dev/null 2>&1; then
  echo "❌ Xcode Command Line Tools가 설치되어 있지 않습니다."
  echo ""
  echo "아래 명령어를 실행하여 설치한 후, setup.sh를 다시 실행하세요."
  echo ""
  echo "xcode-select --install"
  exit 1
fi

echo "✅ Xcode Command Line Tools 확인"

# 2. Homebrew 확인 및 설치
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew 확인"
fi

# Homebrew PATH 설정
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  grep -qxF 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile || \
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
  grep -qxF 'eval "$(/usr/local/bin/brew shellenv)"' ~/.zprofile || \
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
fi

# 3. Python 설치
echo "🐍 Python 설치 중..."
brew install python || true

# 4. 기존 환경 삭제
echo "🧹 기존 moteus-venv 삭제..."
rm -rf ~/moteus-venv

# 5. 새 가상환경 생성
echo "📦 Python 가상환경 생성..."
python3 -m venv ~/moteus-venv
source ~/moteus-venv/bin/activate

# 6. pip 업데이트
echo "⬆️ pip 업데이트..."
python3 -m pip install --upgrade pip

# 7. moteus 설치
echo "⚙️ moteus 설치 중..."
python3 -m pip install --upgrade moteus

# 8. 설치 확인
echo ""
echo "====================================="
echo " 설치 확인"
echo "====================================="
echo ""

python3 --version
python3 -m pip --version
python3 -m moteus.moteus_tool --version || true

echo ""
echo "tview 위치:"
which tview || echo "⚠️ tview를 찾을 수 없습니다."

echo ""
echo "====================================="
echo " Moteus Python 환경 설치 완료!"
echo "====================================="
echo ""
echo "앞으로 작업을 시작할 때는 아래 명령어만 실행하세요."
echo ""
echo "source ~/moteus-venv/bin/activate"
echo ""
echo "이후에는 펌웨어 업데이트 → conf 적용 → 캘리브레이션을 진행하면 됩니다."
echo ""