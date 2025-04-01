# 📚 HarryPotterLibrary

해리포터 시리즈 정보를 한눈에 확인할 수 있는 iOS 도서 정보 앱입니다.  
시리즈별 책 정보를 요약, 챕터, 저자 등 다양한 정보와 함께 확인할 수 있습니다.

---

## 🗓 프로젝트 일정

- **시작일:** 2025년 3월 24일
- **종료일:** 2025년 4월 4일

---

## 📂 폴더 구조
```
HarryPotterLibrary
├── Model                           // 데이터 모델과 서비스
│   ├── Response.swift              // API 응답 모델
│   ├── Error.swift                 // 커스텀 에러 타입 정의
│   ├── Constants.swift             // 문자열 상수 및 설정
│   └── DataService.swift           // JSON 데이터 로딩 서비스
│
├── View                            // UI 관련 뷰 클래스
│   ├── CustomView                  // 공통 커스텀 UI 컴포넌트
│   │   ├── SeriesButton.swift
│   │   ├── CustomHStackView.swift
│   │   ├── CustomUILabel.swift
│   │   └── CustomVStackView.swift
│   └── ViewController
│       └── ViewController.swift    // 주요 화면 로직 담당
│
├── Extension                       // 공통 유틸리티 확장 기능
│   ├── Extension+String.swift
│   ├── Extension+UIView.swift
│   ├── Extension+UIStackView.swift
│   └── Extension+UIButton.swift
│
├── UserDefaultManager.swift        // 사용자 기본값 관리
├── AppDelegate.swift
├── SceneDelegate.swift
└── data.json                       // 시리즈별 도서 정보
```

---

## 🛠 사용 기술

- **Swift 5**
- **UIKit**
- **SnapKit** (제약 조건 설정을 위한 라이브러리)
- **MVC 패턴 적용**
- **UserDefaults** (간단한 사용자 상태 저장)
- **Custom View 구성**
- **Extension 기반 유틸리티 메서드**

---

## 🌟 주요 기능

- 시리즈 버튼을 선택하여 각 해리포터 책 정보 조회
- 책 표지, 제목, 저자, 출간일, 페이지 수 표시
- 헌정사 및 요약 표시 (요약은 ‘더보기/접기’ 기능 제공)
- 챕터 목록 표시
- `UserDefaults`를 이용해 마지막 선택 도서와 더보기/접기 상태 기억
- 화면 구성은 `SnapKit`을 활용하여 오토레이아웃 구성

---

## 🧩 Trouble Shooting

### 1. ✅ 시리즈 버튼 선택 상태가 저장되지 않음

- **문제**: 앱을 재실행하면 마지막으로 선택했던 시리즈 버튼 상태가 초기화됨
- **원인**: 버튼 상태를 `UserDefaults`에 저장하고 있었지만, 앱 시작 시 해당 상태를 불러오지 않았음
- **해결**:
  - `UserDefaultsManager`를 통해 `currentSeriesButtonIndex`를 저장
  - `viewDidLoad()` 내 `configureUserDefaults()` 및 `setPageInfo()` 호출로 복원 처리

---

### 2. ✅ 요약문이 길 때 UI 깨짐

- **문제**: 요약문이 450자 이상일 때 UI가 비정상적으로 동작하거나 버튼 위치가 꼬임
- **원인**: `더보기` 버튼 위치 설정이 챕터 뷰 제약보다 뒤에 위치함
- **해결**:
  - 요약문 길이 체크 후 `layoutMoreButton()`으로 더보기 버튼 레이아웃 재정의
  - `setConstraints()`에서 챕터 뷰 제약을 상황에 따라 다르게 설정

---

### 3. ✅ 버튼 스타일 중복 우려 로직 

- **문제**: 시리즈 버튼의 스타일 설정(`applySelectedStyle`, `applyUnselectedStyle`)을 ViewController에서 메서드로 정의하여 관리함 
- **해결**: UIButton의 Extension 파일을 통해 스타일 관련 메서드를 확장자로 분리

---

## 📸 화면 미리보기

(스크린샷 또는 시연 GIF가 있다면 여기에 추가)

---
