# Karenda

A modern UIKit-based calendar date picker framework for iOS.

![iOS 13+](https://img.shields.io/badge/iOS-13%2B-blue)
![Swift 5](https://img.shields.io/badge/Swift-5.0-orange)
![UIKit](https://img.shields.io/badge/UIKit-100%25-green)

## Features

- 📆 **Calendar Date Picker** - Beautiful vertical or horizontal scrolling calendar
- 📅 **Date Range Selection** - Select single dates or date ranges
- 🎨 **Fully Customizable** - Colors, fonts, and appearance
- 🏖️ **Holiday Support** - Highlight public holidays
- 📱 **iOS 13+** - Built with modern UICollectionViewCompositionalLayout
- 🧩 **Easy Integration** - Simple configuration API

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 14.0+

## Installation

### Swift Package Manager

Add Karenda to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/example/Karenda.git", from: "1.0.0")
]
```

### CocoaPods

Add Karenda to your `Podfile`:

```ruby
pod 'Karenda', '~> 1.0'
```

### Tuist

Add as a project dependency:

```swift
.project(target: "Karenda", path: "../Karenda")
```

## Usage

### Basic Usage

```swift
import Karenda

class MyViewController: UIViewController, KarendaDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create configuration
        let config = KarendaConfig(
            startDate: "01/01/2024",
            endDate: "31/12/2024",
            publicHolidays: ["25/12/2024", "01/01/2024"],
            isMultiSelectEnabled: true,
            selectedColorBackground: .systemBlue
        )
        
        // Create calendar view
        let calendarPicker = KarendaView(config: config)
        calendarPicker.delegate = self
        view.addSubview(calendarPicker)
        
        // Add constraints
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
        print("Selected range: \(startDate) to \(endDate)")
    }
}
```

### Configuration Options

```swift
let config = KarendaConfig(
    // Date range (format: dd/MM/yyyy)
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    
    // Features
    publicHolidays: ["25/12/2024"],  // Holiday dates
    isMultiSelectEnabled: true,       // true = range, false = single
    
    // Colors
    selectedColorBackground: .systemBlue,
    selectedTextColor: .white,
    rangeColorBackground: UIColor.systemBlue.withAlphaComponent(0.15),
    todayTextColor: .systemBlue,
    holidayTextColor: .systemRed,
    weekendTextColor: .secondaryLabel,
    dayTextColor: .label,
    disabledTextColor: .tertiaryLabel,
    headerTextColor: .label,
    weekdayLabelColor: .secondaryLabel,
    backgroundColor: .systemBackground,
    
    // Layout
    scrollDirection: .vertical,  // or .horizontal for paging
    
    // Typography
    dayFont: .systemFont(ofSize: 16),
    headerFont: .systemFont(ofSize: 17, weight: .medium),
    weekdayFont: .systemFont(ofSize: 13)
)
```

### Scroll Directions

**Vertical Scrolling** (default) - All months stacked vertically:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    scrollDirection: .vertical
)
```

**Horizontal Scrolling** - Swipe per month/page:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    scrollDirection: .horizontal
)
```

### Selection Modes

**Multi-Select (Date Range)**:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    isMultiSelectEnabled: true  // First tap = start, second tap = end
)
```

**Single Select**:

```swift
let config = KarendaConfig(
    startDate: "01/01/2024",
    endDate: "31/12/2024",
    isMultiSelectEnabled: false  // Each tap selects a single date
)
```

### Delegate Protocol

```swift
protocol KarendaDelegate {
    // Called when date range is selected
    func didSelectCalendar(startDate: String, endDate: String)
    
    // Called when selection is cleared
    func didClearSelection()
    
    // Called on each date tap
    func didTapDate(_ date: String)
    
    // Called when scrolling to a new month
    func didScrollToMonth(_ month: Int, year: Int)
}
```

### Programmatic Control

```swift
// Clear current selection
calendarPicker.clearSelection()

// Scroll to today
calendarPicker.scrollToToday(animated: true)

// Scroll to specific date
calendarPicker.scrollToDate(someDate, animated: true)

// Pre-select dates
calendarPicker.selectDates(startDate: "15/06/2024", endDate: "20/06/2024")
```

## Example Project

An example project is included in the `Example` directory. To run it:

```bash
cd Example
tuist generate
open KarendaExample.xcworkspace
```

The example demonstrates:
- Vertical scrolling calendar with date range selection
- Horizontal paging calendar
- Single date selection mode

## Architecture

```
Karenda/
├── Sources/
│   ├── Karenda.swift                # Framework entry point
│   ├── Core/
│   │   ├── BaseView.swift           # Base UIView class
│   │   └── Theme.swift              # Theming system
│   ├── Components/
│   │   └── Karenda/
│   │       ├── KarendaView.swift    # Main calendar component
│   │       ├── KarendaConfig.swift  # Configuration
│   │       ├── KarendaDelegate.swift
│   │       ├── KarendaMonthData.swift
│   │       └── Cells/
│   │           ├── KarendaDayCell.swift
│   │           └── KarendaMonthHeaderView.swift
│   ├── Extensions/
│   │   └── UIView+Karenda.swift
│   └── Resources/
├── Tests/
├── Example/                          # Example app (Tuist)
├── Package.swift                     # SPM
├── Karenda.podspec                  # CocoaPods
└── Project.swift                    # Tuist
```

## Library Evolution

This framework is built with library evolution support (`BUILD_LIBRARY_FOR_DISTRIBUTION = YES`), ensuring binary compatibility across Swift versions.

## License

Karenda is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
