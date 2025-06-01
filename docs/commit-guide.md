
# 🔒 Husky 기반 커밋 메시지 검사 가이드

## 📌 개요

이 프로젝트는 **일관된 커밋 메시지 작성 규칙**을 강제하기 위해 [Husky](https://typicode.github.io/husky/)를 사용합니다.

커밋 메시지가 정해진 형식에 맞지 않으면, **커밋이 차단되고 에러 메시지가 출력**됩니다.

## 🛠 사전 준비사항

| 항목         | 설명                                                                                  |
| ---------- | ----------------------------------------------------------------------------------- |
| Node.js    | 설치 필요. macOS는 `brew install node`, Windows는 [Node.js 공식 페이지](https://nodejs.org) 참고 |
| Git 초기화 상태 | `.git/` 폴더가 있어야 합니다                                                                 |

## 🚀 설치 방법 (최초 1회)

```bash
bash setup.sh
```

이 명령은 다음을 자동으로 수행합니다:

1. Husky 설치 및 초기화
2. `package.json`에 `prepare` 스크립트 삽입
3. `.husky/commit-msg` 생성 및 커밋 메시지 검사 스크립트 연결
4. 실행 권한 설정 및 검증

## 📋 커밋 메시지 컨벤션 요약

| 구분    | 규칙                                                                  |
| ----- | ------------------------------------------------------------------- |
| 제목    | `<Type>. 요약 설명` or `📝 <Type>. 요약 설명`</br>Type은 대문자로 시작. 마침표 뒤 공백 필수 |
| 요약 길이 | 한국어 기준 30자 이내 권장 (권장사항)                                             |
| 본문    | `Why:` 변경 이유 / `How:` 변경 방법                                         |

## ✅ 커밋 메시지 예시

```text
🖍 Docs. 컴포넌트 구조 개선

Why:
- View 네이밍 통일

How:
- CycleView → CycleProgressView로 변경
```

```text
Fix. 로그인 실패 시 예외처리 추가

Why:
- 빈 토큰에서 앱이 크래시 발생

How:
- if 조건문 보호 및 로그 출력 추가
```

## ❌ 잘못된 메시지 예시

```text
readme 업데이트
```

```text
fix: 로그인 고침
```

이런 커밋을 시도하면 아래와 같은 메시지가 출력됩니다:

```text
❌ 제목 형식 오류:
🔹 제목은 'Type. 요약 설명' 또는 '🖍 Type. 요약 설명' 형식이어야 합니다.
```

## 🧪 테스트 방법

```bash
git commit --allow-empty -m "README 업데이트"      # ❌ 실패 (형식 위반)

git commit --allow-empty -m "Docs. 리드미 정리 완료

Why:
- 오래된 구조를 반영하고 있음

How:
- 섹션 순서 변경, UI 설명 추가
"                                # ✅ 성공
```

## 🗑 비활성화/제거 방법 (로컬 전용)

```bash
rm .husky/commit-msg
```

> 팀원 간 규칙은 유지되므로 제거는 권장되지 않음

## 📁 관련 파일 구조

```
project-root/
├── .husky/
│   └── commit-msg             # 실행 진입점
├── scripts/
│   └── validate-commit-msg.sh # 검사 스크립트 본문
├── setup.sh                   # 자동 설치 스크립트
├── package.json
├── package-lock.json
├── .gitignore
```

## 🧑‍💻 추가 자료

* [Husky 공식 문서](https://typicode.github.io/husky/)
* [Conventional Commits](https://www.conventionalcommits.org/ko/v1.0.0/)
* [Gitmoji](https://gitmoji.dev)
