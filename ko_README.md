# Karenda (캘린더)

**[English](README.md)** | **[日本語](ja_README.md)** | **한국어**

iOS를 위한 모던한 UIKit 기반 달력 날짜 선택 프레임워크입니다.

![iOS 13+](https://img.shields.io/badge/iOS-13%2B-blue)
![Swift 5](https://img.shields.io/badge/Swift-5.0-orange)
![UIKit](https://img.shields.io/badge/UIKit-100%25-green)

## 기능 (Features)

- 📆 **달력 날짜 선택기** - 아름다운 수직 또는 수평 스크롤 달력
- 📅 **날짜 범위 선택** - 단일 날짜 또는 날짜 범위 선택 가능
- 🎨 **완벽한 커스터마이징** - 색상, 폰트, 외관 설정 가능
- 🏖️ **공휴일 지원** - 점 표시와 이름으로 공휴일 강조
- 📱 **iOS 13+** - 모던한 UICollectionViewCompositionalLayout으로 제작
- 🧩 **쉬운 연동** - 간편한 설정 API

<details>
<summary>📸 스크린샷 (Screenshots)</summary>

| 수직 (Vertical) | 수평 (Horizontal) | 단일 선택 (Single Select) |
|:--------:|:----------:|:-------------:|
| ![Vertical](Screenshots/vertical.png) | ![Horizontal](Screenshots/horizontal.png) | ![Single Select](Screenshots/single_select.png) |

</details>

## 요구 사항 (Requirements)

- iOS 13.0+
- Swift 5.0+
- Xcode 14.0+

## 설치 (Installation)

### Swift Package Manager

Swift Package Manager를 사용하여 프로젝트에 Karenda를 추가하세요:

```swift
dependencies: [
    .package(url: "https://github.com/yefga/Karenda.git", from: "1.0.0")
]
```

### CocoaPods

`Podfile`에 Karenda를 추가하세요:

```ruby
pod 'Karenda', '~> 1.0'
```

### Tuist

프로젝트 의존성으로 추가하세요:

```swift
.project(target: "Karenda", path: "../Karenda")
```

## 사용법 (Usage)

### 기본 사용법 (Basic Usage)

```swift
import Karenda

class MyViewController: UIViewController, KarendaDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 공휴일 이름과 함께 정의
        let holidays: [KarendaHoliday] = [
            KarendaHoliday(date: "01/01/2024", name: "New Year's Day"),
            KarendaHoliday(date: "25/12/2024", name: "Christmas Day")
        ]
        
        // 설정 생성
        let config = KarendaConfig(
            startDate: "01/01/2024",
            endDate: "31/12/2024",
            holidays: holidays,
            isMultiSelectEnabled: true,
            direction: .vertical
        )
        
        // 달력 뷰 생성
        let calendarPicker = KarendaView(config: config)
        calendarPicker.delegate = self
        view.addSubview(calendarPicker)
        
        // 제약 조건 추가
        calendarPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - KarendaDelegate
    
    func didSelectCalendar(startDate: String, endDate: String) {
        print("선택된 범위: \(startDate) 부터 \(endDate)")
    }
```

### SwiftUI 사용법 (SwiftUI Usage)

`KarendaRepresentable`을 사용하여 달력을 SwiftUI 뷰 내에 임베드하세요:

```swift
import SwiftUI
import Karenda

struct ContentView: View {
    @State private var selectedStartDate: String?
    @State private var selectedEndDate: String?
    
    var body: some View {
        VStack {
            Text("선택됨: \(selectedStartDate ?? "없음") ~ \(selectedEndDate ?? "없음")")
                .padding()
            
            KarendaRepresentable(
                config: KarendaConfig(
                    startDate: "01/01/2024",
                    endDate: "31/12/2024",
                    holidays: [
                        KarendaHoliday(date: "25/12/2024", name: "Christmas")
                    ],
                    direction: .vertical
                ),
                selectedStartDate: $selectedStartDate,
                selectedEndDate: $selectedEndDate
            )
            .onDateTapped { date in
                print("탭한 날짜: \(date)")
            }
            .onMonthChanged { month, year in
                print("보고 있는 달: \(month)/\(year)")
            }
        }
    }
}
```

**단일 날짜 선택 (SwiftUI)**:

```swift
KarendaRepresentable(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    selectedDate: $selectedDate  // 단일 선택 모드를 위한 단일 바인딩
)
```

```swift
let holiday = KarendaHoliday(
    date: "25/12/2024",    // 형식: dd/MM/yyyy
    name: "Christmas Day"   // 푸터에 표시될 공휴일 이름
)
```

### 스크롤 방향 (Scroll Directions)

**수직 스크롤 (Vertical Scrolling)** (기본값) - 모든 달이 수직으로 쌓입니다:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    direction: .vertical
)
```

**수평 스크롤 (Horizontal Scrolling)** - 페이지당 한 달씩 보이며, 스와이프로 이동합니다:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    direction: .horizontal
)
```

### 선택 모드 (Selection Modes)

**다중 선택 (날짜 범위)**:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    isMultiSelectEnabled: true  // 첫 번째 탭 = 시작, 두 번째 탭 = 끝
)
```

**단일 선택 (Single Select)**:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    isMultiSelectEnabled: false  // 탭할 때마다 단일 날짜 선택
)
```

### 델리게이트 프로토콜 (Delegate Protocol)

```swift
protocol KarendaDelegate {
    // 날짜 범위가 선택되었을 때 호출됨
    func didSelectCalendar(startDate: String, endDate: String)
    
    // 선택이 해제되었을 때 호출됨
    func didClearSelection()
    
    // 날짜를 탭할 때마다 호출됨
    func didTapDate(_ date: String)
    
    // 새로운 달로 스크롤되었을 때 호출됨
    func didScrollToMonth(_ month: Int, year: Int)
}
```

### 프로그래밍 제어 (Programmatic Control)

```swift
// 현재 선택 해제
calendarPicker.clearSelection()

// 오늘 날짜로 스크롤
calendarPicker.scrollToToday(animated: true)

// 특정 날짜로 스크롤
calendarPicker.scrollToDate(someDate, animated: true)

// 날짜 미리 선택
calendarPicker.selectDates(startDate: "15/06/2024", endDate: "20/06/2024")

// 달 이동 (수평 모드)
calendarPicker.goToNextMonth()
calendarPicker.goToPreviousMonth()

// 현재 보이는 달 가져오기
if let (month, year) = calendarPicker.currentVisibleMonth() {
    print("보고 있는 달: \(month)/\(year)")
}
```

## 설정 옵션 (Configuration Options)

`KarendaConfig`의 모든 설정 옵션:

| 속성 | 타입 | 기본값 | 설명 |
|----------|------|---------|-------------|
| `startDate` | `String` | - | 달력 범위 시작 날짜 (dd/MM/yyyy) |
| `endDate` | `String` | - | 달력 범위 종료 날짜 (dd/MM/yyyy) |
| `holidays` | `[KarendaHoliday]` | `[]` | 날짜와 이름을 포함한 공휴일 목록 |
| `isMultiSelectEnabled` | `Bool` | `true` | `true` = 날짜 범위, `false` = 단일 날짜 |
| `direction` | `KarendaDirection` | `.vertical` | `.vertical` 또는 `.horizontal` |
| `startDayOfWeek` | `KarendaStartDay` | `.sunday` | 주의 시작 요일 (`.sunday`, `.monday` 등) |
| `selectedBackgroundColor` | `UIColor` | `.systemBlue` | 선택된 날짜의 배경색 |
| `selectionCornerRadius` | `CGFloat` | `0` | 선택 영역의 코너 반경 (0 = 사각형, 높을수록 원형) |
| `rangeBackgroundColor` | `UIColor` | Blue 15% | 범위 내 날짜의 배경색 |
| `textTintColor` | `UIColor?` | `nil` | 날짜 텍스트의 선택적 틴트 색상 |
| `selectedTextColor` | `UIColor` | `.white` | 선택된 날짜의 텍스트 색상 |
| `todayTextColor` | `UIColor` | `.systemBlue` | 오늘 날짜의 텍스트 색상 |
| `holidayTextColor` | `UIColor` | `.systemRed` | 공휴일 날짜의 텍스트 색상 |
| `holidayIndicatorColor` | `UIColor` | 공휴일 색상과 동일 | 공휴일 점 표시 색상 |
| `weekendTextColor` | `UIColor` | `.secondaryLabel` | 주말 날짜 텍스트 색상 |
| `disabledTextColor` | `UIColor` | `.tertiaryLabel` | 비활성화된 날짜 텍스트 색상 |
| `headerTextColor` | `UIColor` | `.label` | 월 헤더 텍스트 색상 |
| `weekdayLabelColor` | `UIColor` | `.secondaryLabel` | 요일 라벨 텍스트 색상 |
| `backgroundColor` | `UIColor` | `.systemBackground` | 달력 배경색 |
| `dayFont` | `UIFont?` | System 16 | 날짜 숫자 폰트 |
| `headerFont` | `UIFont?` | System 17 medium | 월 헤더 폰트 |
| `weekdayFont` | `UIFont?` | System 13 | 요일 라벨 폰트 |
| `footerFont` | `UIFont?` | System 12 | 하단 공휴일 이름 폰트 |

## 라이브러리 진화 (Library Evolution)

이 프레임워크는 라이브러리 진화 지원(`BUILD_LIBRARY_FOR_DISTRIBUTION = YES`)으로 빌드되어, Swift 버전 간 바이너리 호환성을 보장합니다.

## 라이선스 (License)

Karenda는 MIT 라이선스 하에 사용 가능합니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.
