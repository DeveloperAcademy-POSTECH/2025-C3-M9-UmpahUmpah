#!/bin/bash

set -e

echo "🔧 Husky 커밋 메시지 검사 환경 자동 설정 시작..."

# ✅ 0. npm 명령어 유무 확인
if ! command -v npm >/dev/null 2>&1; then
  echo "❌ npm이 설치되어 있지 않습니다. 먼저 Node.js를 설치해주세요."
  echo "   👉 macOS: brew install node"
  echo "   👉 Windows: https://nodejs.org"
  exit 1
fi

# 1. package.json 존재 여부 확인
if [ ! -f package.json ]; then
  echo "⚠️ package.json이 없습니다. 먼저 Node 프로젝트를 초기화해주세요: npm init -y"
  exit 1
fi

# 2. Husky 설치
echo "📦 husky 설치 중..."
npm install husky --save-dev

# 3. prepare 스크립트 추가 (기존에 없을 경우만)
if ! grep -q '"prepare": "husky install"' package.json; then
  echo "📄 package.json에 prepare 스크립트 추가..."
  npm pkg set scripts.prepare="husky install"
fi

# 4. husky 초기화
echo "🚀 husky install 실행 중..."
npx husky install

# 5. scripts 디렉토리 및 커밋 검사 스크립트 존재 확인
HOOK_SCRIPT="scripts/validate-commit-msg.sh"
if [ ! -f "$HOOK_SCRIPT" ]; then
  echo "❌ $HOOK_SCRIPT 가 없습니다. 먼저 커밋 메시지 검사 스크립트를 작성해주세요."
  exit 1
fi

# 6. .husky/commit-msg 파일 생성
echo "🔗 .husky/commit-msg 설정 중..."
mkdir -p .husky
cat <<EOF > .husky/commit-msg
#!/bin/sh
bash $HOOK_SCRIPT "\$1"
EOF
chmod +x .husky/commit-msg

# 7. 실행 권한 확인
chmod +x "$HOOK_SCRIPT"

# 8. 최종 확인
echo "✅ setup 완료! 이제 커밋 메시지 검사 훅이 적용됩니다."
echo "   테스트: git commit --allow-empty -m '잘못된 메시지'"