# Karenda (カレンダー)

[English](README.md) | **日本語**

iOS用のモダンなUIKitベースのカレンダー日付選択フレームワーク。

![iOS 13+](https://img.shields.io/badge/iOS-13%2B-blue)
![Swift 5](https://img.shields.io/badge/Swift-5.0-orange)
![UIKit](https://img.shields.io/badge/UIKit-100%25-green)

## 特徴

- 📆 **カレンダー日付ピッカー** - 美しい縦スクロールまたは横スクロールのカレンダー
- 📅 **日付範囲選択** - 単一日付または期間の選択が可能
- 🎨 **完全なカスタマイズ性** - 色、フォント、外観をカスタマイズ可能
- 🏖️ **祝日サポート** - ドットインジケーターと名前で祝日を強調表示
- 📱 **iOS 13+** - 最新の UICollectionViewCompositionalLayout で構築
- 🧩 **簡単な統合** - シンプルな設定 API

<details>
<summary>📸 スクリーンショット</summary>

| 縦スクロール | 横スクロール | 単一選択 |
|:--------:|:----------:|:-------------:|
| ![Vertical](Screenshots/vertical.png) | ![Horizontal](Screenshots/horizontal.png) | ![Single Select](Screenshots/single_select.png) |

</details>

## 要件

- iOS 13.0+
- Swift 5.0+
- Xcode 14.0+

## インストール

### Swift Package Manager

Swift Package Manager を使用してプロジェクトに Karenda を追加します：

```swift
dependencies: [
    .package(url: "https://github.com/yefga/Karenda.git", from: "1.0.0")
]
```

### CocoaPods

`Podfile` に Karenda を追加します：

```ruby
pod 'Karenda', '~> 1.0'
```

### Tuist

プロジェクトの依存関係として追加します：

```swift
.project(target: "Karenda", path: "../Karenda")
```

## 使用方法

### 基本的な使用方法

```swift
import Karenda

class MyViewController: UIViewController, KarendaDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 祝日の定義（名前付き）
        let holidays: [KarendaHoliday] = [
            KarendaHoliday(date: "01/01/2024", name: "元日"),
            KarendaHoliday(date: "25/12/2024", name: "クリスマス")
        ]
        
        // 設定の作成
        let config = KarendaConfig(
            startDate: "01/01/2024",
            endDate: "31/12/2024",
            holidays: holidays,
            isMultiSelectEnabled: true,
            direction: .vertical
        )
        
        // カレンダービューの作成
        let calendarPicker = KarendaView(config: config)
        calendarPicker.delegate = self
        view.addSubview(calendarPicker)
        
        // 制約の追加
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
        print("選択範囲: \(startDate) から \(endDate)")
    }
}
```

### SwiftUI での使用

`KarendaRepresentable` を使用して、SwiftUI ビューにカレンダーを埋め込みます：

```swift
import SwiftUI
import Karenda

struct ContentView: View {
    @State private var selectedStartDate: String?
    @State private var selectedEndDate: String?
    
    var body: some View {
        VStack {
            Text("選択中: \(selectedStartDate ?? "なし") 〜 \(selectedEndDate ?? "なし")")
                .padding()
            
            KarendaRepresentable(
                config: KarendaConfig(
                    startDate: "01/01/2024",
                    endDate: "31/12/2024",
                    holidays: [
                        KarendaHoliday(date: "25/12/2024", name: "クリスマス")
                    ],
                    direction: .vertical
                ),
                selectedStartDate: $selectedStartDate,
                selectedEndDate: $selectedEndDate
            )
            .onDateTapped { date in
                print("タップされました: \(date)")
            }
            .onMonthChanged { month, year in
                print("表示中: \(year)年\(month)月")
            }
        }
    }
}
```

**単一日付選択 (SwiftUI)**:

```swift
KarendaRepresentable(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    selectedDate: $selectedDate  // 単一選択モード用の単一バインディング
)
```

```swift
let holiday = KarendaHoliday(
    date: "25/12/2024",    // 形式: dd/MM/yyyy
    name: "クリスマス"      // フッターに表示される祝日名
)
```

### スクロール方向

**縦スクロール** (デフォルト) - 全ての月を縦に積み重ねて表示：

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    direction: .vertical
)
```

**横スクロール** - 1ページに1ヶ月表示し、スワイプで切り替え：

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    direction: .horizontal
)
```

### 選択モード

**複数選択 (日付範囲)**:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    isMultiSelectEnabled: true  // 1回目のタップ=開始、2回目のタップ=終了
)
```

**単一選択**:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    isMultiSelectEnabled: false  // タップごとに単一の日付を選択
)
```

### デリゲートプロトコル

```swift
protocol KarendaDelegate {
    // 日付範囲が選択された時に呼ばれる
    func didSelectCalendar(startDate: String, endDate: String)
    
    // 選択がクリアされた時に呼ばれる
    func didClearSelection()
    
    // 日付がタップされるたびに呼ばれる
    func didTapDate(_ date: String)
    
    // 新しい月にスクロールした時に呼ばれる
    func didScrollToMonth(_ month: Int, year: Int)
}
```

### プログラム制御

```swift
// 現在の選択をクリア
calendarPicker.clearSelection()

// 今日へスクロール
calendarPicker.scrollToToday(animated: true)

// 特定の日付へスクロール
calendarPicker.scrollToDate(someDate, animated: true)

// 日付を事前選択
calendarPicker.selectDates(startDate: "15/06/2024", endDate: "20/06/2024")

// 月の移動（横スクロールモード用）
calendarPicker.goToNextMonth()
calendarPicker.goToPreviousMonth()

// 現在表示中の月を取得
if let (month, year) = calendarPicker.currentVisibleMonth() {
    print("表示中: \(year)年\(month)月")
}
```

## 設定オプション

`KarendaConfig` のすべての設定オプション：

| プロパティ | 型 | デフォルト | 説明 |
|----------|------|---------|-------------|
| `startDate` | `String` | - | カレンダー範囲の開始日 (dd/MM/yyyy) |
| `endDate` | `String` | - | カレンダー範囲の終了日 (dd/MM/yyyy) |
| `holidays` | `[KarendaHoliday]` | `[]` | 日付と名前を含む祝日リスト |
| `isMultiSelectEnabled` | `Bool` | `true` | `true` = 期間選択, `false` = 単一選択 |
| `direction` | `KarendaDirection` | `.vertical` | `.vertical` または `.horizontal` |
| `startDayOfWeek` | `KarendaStartDay` | `.sunday` | 週の開始日 (`.sunday`, `.monday` 等) |
| `selectedBackgroundColor` | `UIColor` | `.systemBlue` | 選択された日付の背景色 |
| `selectionCornerRadius` | `CGFloat` | `0` | 選択の角丸半径 (0 = 四角, 大きな値 = 丸) |
| `rangeBackgroundColor` | `UIColor` | Blue 15% | 範囲内の日付の背景色 |
| `textTintColor` | `UIColor?` | `nil` | 日付テキストのオプションの色合い |
| `selectedTextColor` | `UIColor` | `.white` | 選択された日付のテキスト色 |
| `todayTextColor` | `UIColor` | `.systemBlue` | 今日の日付のテキスト色 |
| `holidayTextColor` | `UIColor` | `.systemRed` | 祝日の日付のテキスト色 |
| `holidayIndicatorColor` | `UIColor` | 祝日色と同じ | 祝日ドットインジケーターの色 |
| `weekendTextColor` | `UIColor` | `.secondaryLabel` | 週末のテキスト色 |
| `disabledTextColor` | `UIColor` | `.tertiaryLabel` | 無効な日付のテキスト色 |
| `headerTextColor` | `UIColor` | `.label` | 月ヘッダーのテキスト色 |
| `weekdayLabelColor` | `UIColor` | `.secondaryLabel` | 曜日ラベルのテキスト色 |
| `backgroundColor` | `UIColor` | `.systemBackground` | カレンダーの背景色 |
| `dayFont` | `UIFont?` | System 16 | 日付番号のフォント |
| `headerFont` | `UIFont?` | System 17 medium | 月ヘッダーのフォント |
| `weekdayFont` | `UIFont?` | System 13 | 曜日ラベルのフォント |
| `footerFont` | `UIFont?` | System 12 | フッターの祝日名のフォント |

## ライブラリの進化

このフレームワークは、ライブラリ進化サポート（`BUILD_LIBRARY_FOR_DISTRIBUTION = YES`）で構築されており、Swift バージョン間のバイナリ互換性を保証します。

## ライセンス

Karenda は MIT ライセンスの下で利用可能です。詳細は [LICENSE](LICENSE) ファイルをご覧ください。
