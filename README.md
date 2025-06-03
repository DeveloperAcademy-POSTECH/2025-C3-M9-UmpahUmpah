# 🏊 음파음파

![배너 이미지 또는 로고](링크)

> 수영을 하면서 "내가 잘하고 있는지?" 확신이 부족한 사용자를 위해, 과거 자신의 수영 데이터와 비교하여 실시간 피드백과 응원을 제공함으로써 지속가능한 수영 습관을 만들어주는 iOS 솔루션입니다.

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)]()
[![Xcode](https://img.shields.io/badge/Xcode-15.0-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()

---

## 🗂 목차

- [🏊 음파음파](#-음파음파)
  - [🗂 목차](#-목차)
  - [📱 소개](#-소개)
  - [📆 프로젝트 기간](#-프로젝트-기간)
  - [🛠 기술 스택](#-기술-스택)
  - [🌟 주요 기능](#-주요-기능)
  - [🧱 폴더 구조](#-폴더-구조)
  - [🧑‍💻 팀 소개](#-팀-소개)
  - [🔖 브랜치 전략](#-브랜치-전략)
  - [📚 커밋 컨벤션 가이드](#-커밋-컨벤션-가이드)
  - [✅ 테스트 방법](#-테스트-방법)
  - [📝 License](#-license)

---

## 📱 소개

> 사용자가 수영하는 상황에서, 잘하고 있는지 확신할 수 없는 문제를 겪는데, 과거의 사용자 수영 데이터와 비교하는 방법으로, 사용자를 격려하고 응원하여 지속가능한 수영을 돕는 솔루션입니다.
> 
> - 자신의 수영 기록에 대한 과거와 현재 데이터 비교 및 피드백

<!-- [🔗 앱스토어/웹 링크](https://example.com) -->


## 📆 프로젝트 기간

- 전체 기간: `2025.05.08 - 2025.06.13`
- 개발 기간: `2025.05.30 - 2025.06.10`


## 🛠 기술 스택

- Swift 5.9 / SwiftUI / UIKit
- Xcode 15.0
- 아키텍처: MVVM (일부 Clean Architecture 적용 가능성)
- 테스트: XCTest
- 기타 도구: Figma, Notion, GitHub Projects
- CI/CD: <!-- GitHub Actions 등 사용 시 명시 -->
- 배포: <!-- TestFlight, App Store 등 사용 시 명시 -->


## 🌟 주요 기능

- ✅ HealthKit 기반 수영 데이터 연동 및 기록
- ✅ 과거 기록과 실시간 비교, 피드백 제공
- <!-- 추가 기능은 개발 진행에 따라 업데이트 -->

<!-- > 필요시 이미지, GIF, 혹은 링크 삽입 -->


<!-- ## 🖼 화면 구성 및 시연

| 기능 | 설명 | 이미지 |
|------|------|--------|
| 예시1 | 수영 데이터 대시보드 | ![gif](링크) |
| 예시2 | 데이터 비교 및 피드백 | ![gif](링크) | -->


## 🧱 폴더 구조

```text
📦UmpahUmpah
┣ 📂Core
┃ ┣ 📂Models
┃ ┣ 📂Protocols
┃ ┗ 📂UseCases
┣ 📂Data
┃ ┣ 📂DataSources
┃ ┗ 📂Repositories
┣ 📂Presentation
┃ ┣ 📂Coordinators
┃ ┣ 📂ViewModels
┃ ┗ 📂Views
┣ 📂Resources
┣ 📂Supporting
┣ 📂Test
┣ 📂Feature
┃ ┣ 📂SceneA
┃ ┗ 📂SceneB
┗ 기타 파일들
```


## 🧑‍💻 팀 소개

| [GUS (윤창현)](https://github.com/salgilbarana) | [Simi (장수민)](https://github.com/simi-sumin) | [Kirby (양서린)](https://github.com/bisor0627) | [Steve (이은수)](https://github.com/ieunsoo) | [Henry (김현목)](https://github.com/NOP-YA) | [Hidy (이윤서)](https://github.com/yunsly) |
|:---:|:---:|:---:|:---:|:---:|:---:|
| <img src="https://github.com/salgilbarana.png" width="100" height="100" style="border-radius:50%"/> | <img src="https://github.com/simi-sumin.png" width="100" height="100" style="border-radius:50%"/> | <img src="https://github.com/bisor0627.png" width="100" height="100" style="border-radius:50%"/> | <img src="https://github.com/ieunsoo.png" width="100" height="100" style="border-radius:50%"/> | <img src="https://github.com/NOP-YA.png" width="100" height="100" style="border-radius:50%"/> | <img src="https://github.com/yunsly.png" width="100" height="100" style="border-radius:50%"/> |

<!-- [🔗 팀 블로그 / 미디엄 링크](https://medium.com/example) -->

## 🔖 브랜치 전략

→ [docs/branch-guide.md](docs/branch-guide.md) 문서를 참고해주세요.


## 📚 커밋 컨벤션 가이드

→ [docs/commit-guide.md](docs/commit-guide.md) 문서를 참고해주세요.


## ✅ 테스트 방법

1. 이 저장소를 클론합니다.

    ```bash
    git clone https://github.com/DeveloperAcademy-POSTECH/2025-C3-M9-UmpahUmpah.git
    ```

2. `Xcode`로 `.xcodeproj` 또는 `.xcworkspace` 열기
3. 시뮬레이터 환경 설정: iPhone 15 / iOS 17
4. `Cmd + R`로 실행 / `Cmd + U`로 테스트 실행


<!-- ## 📎 프로젝트 문서

- [기획 히스토리](링크) 
- [디자인 히스토리](링크) 
- [기술 문서 (아키텍처 등)](링크) 
 -->

## 📝 License

This project is licensed under the [LICENSE](./LICENSE)
