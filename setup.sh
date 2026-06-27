#!/bin/bash

set -e

echo ""
echo "====================================="
echo " Moteus Mac 환경 설치 시작"
echo "====================================="
echo ""

if ! xcode-select -p >/dev/null 2>&1; then
  echo "❌ Xcode Command Line Tools가 설치되어 있지 않습니다."
  echo "xcode-select --install 실행 후 다시 시도하세요."
  exit 1
fi

echo "✅ Xcode Command Line Tools 확인"

if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew 확인"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  grep -qxF 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
  grep -qxF 'eval "$(/usr/local/bin/brew shellenv)"' ~/.zprofile || echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
fi

echo "🐍 Python 설치 중..."
brew install python || true

echo "🧹 기존 moteus-venv 삭제..."
rm -rf ~/moteus-venv

echo "📦 Python 가상환경 생성..."
python3 -m venv ~/moteus-venv
source ~/moteus-venv/bin/activate

echo "⬆️ pip 업데이트..."
python3 -m pip install --upgrade pip

echo "⚙️ moteus 설치 중..."
python3 -m pip install --upgrade moteus

echo "🖥️ tview 설치 중..."
python3 -m pip install --upgrade moteus-gui

echo ""
echo "====================================="
echo " 설치 확인"
echo "====================================="
python3 --version
python3 -m moteus.moteus_tool --version || true

echo ""
echo "tview 위치:"
which tview || echo "⚠️ tview 명령어는 없을 수 있습니다. 대신 python3 -m moteus_gui.tview 로 실행하세요."

echo ""
echo "====================================="
echo " Moteus Python 환경 설치 완료!"
echo "====================================="
echo "source ~/moteus-venv/bin/activate"
echo ""
