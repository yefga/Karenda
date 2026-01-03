// The MIT License (MIT)
//
// Copyright (c) 2026 Yefga (https://www.yefga.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

// MARK: - Enums

/// Scroll direction options for the Karenda calendar picker.
public enum KarendaDirection {
    /// Vertical scrolling - shows all months stacked vertically, scroll up/down
    case vertical
    /// Horizontal scrolling - shows 1 month per page, swipe left/right
    case horizontal
}

/// Starting day of the week for the calendar.
public enum KarendaStartDay: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    /// Short weekday labels starting from this day
    var weekdayLabels: [String] {
        let allDays = ["S", "M", "T", "W", "T", "F", "S"]
        let startIndex = rawValue - 1
        return Array(allDays[startIndex...]) + Array(allDays[..<startIndex])
    }
    
    /// Full weekday names starting from this day
    var weekdayNames: [String] {
        let allDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let startIndex = rawValue - 1
        return Array(allDays[startIndex...]) + Array(allDays[..<startIndex])
    }
}

// MARK: - Configuration

/// Configuration for the Karenda calendar picker.
public struct KarendaConfig {
    
    // MARK: - Date Range
    
    /// The start date of the calendar range (format: dd/MM/yyyy)
    public let startDate: String
    
    /// The end date of the calendar range (format: dd/MM/yyyy)
    public let endDate: String
    
    // MARK: - Features
    
    /// List of public holidays with date and name
    public let holidays: [KarendaHoliday]
    
    /// Whether multi-date selection is enabled.
    /// When `true`, users can select a date range (start and end).
    /// When `false`, users can only select a single date.
    public let isMultiSelectEnabled: Bool
    
    // MARK: - Layout
    
    /// Scroll direction for the calendar.
    /// - `.vertical`: All months stacked, scroll up/down
    /// - `.horizontal`: One month per page, swipe left/right
    public let direction: KarendaDirection
    
    /// The first day of the week. Defaults to `.sunday`
    public let startDayOfWeek: KarendaStartDay
    
    // MARK: - Appearance
    
    /// Background color for selected dates (start/end of range)
    public let selectedBackgroundColor: UIColor
    
    /// Corner radius for selected date circles. Defaults to 0 (square).
    /// Set to a high value (e.g., 100) for circular selection.
    public let selectionCornerRadius: CGFloat
    
    /// Background color for dates in the selected range (between start and end)
    public let rangeBackgroundColor: UIColor
    
    /// Tint color for text (optional). When set, applies to day text.
    public let textTintColor: UIColor?
    
    /// Text color for selected dates
    public let selectedTextColor: UIColor
    
    /// Text color for today's date
    public let todayTextColor: UIColor
    
    /// Text color for public holidays
    public let holidayTextColor: UIColor
    
    /// Color for the holiday indicator dot. Defaults to same as holidayTextColor.
    public let holidayIndicatorColor: UIColor
    
    /// Text color for weekend days (Saturday and Sunday)
    public let weekendTextColor: UIColor
    
    /// Text color for days outside the valid range
    public let disabledTextColor: UIColor
    
    /// Text color for month/year headers
    public let headerTextColor: UIColor
    
    /// Text color for weekday labels (S, M, T, W, T, F, S)
    public let weekdayLabelColor: UIColor
    
    /// Background color for the calendar
    public let backgroundColor: UIColor
    
    // MARK: - Typography
    
    /// Font for day numbers (optional). When nil, uses system font.
    public let dayFont: UIFont?
    
    /// Font for month/year headers (optional). When nil, uses system font.
    public let headerFont: UIFont?
    
    /// Font for weekday labels (optional). When nil, uses system font.
    public let weekdayFont: UIFont?
    
    /// Font for footer holiday labels (optional). When nil, uses system font.
    public let footerFont: UIFont?
    
    // MARK: - Initialization
    
    /// Creates a new Karenda configuration.
    /// - Parameters:
    ///   - startDate: The start date of the calendar range (format: dd/MM/yyyy)
    ///   - endDate: The end date of the calendar range (format: dd/MM/yyyy)
    ///   - holidays: List of holidays with date and name. Defaults to empty.
    ///   - isMultiSelectEnabled: Whether multi-date selection is enabled. Defaults to `true`.
    ///   - direction: Scroll direction (`.vertical` or `.horizontal`). Defaults to `.vertical`.
    ///   - startDayOfWeek: First day of the week. Defaults to `.sunday`.
    ///   - selectedBackgroundColor: Background color for selected dates. Defaults to system blue.
    ///   - selectionCornerRadius: Corner radius for selection. Defaults to 0 (square).
    ///   - rangeBackgroundColor: Background color for range dates. Defaults to light blue.
    ///   - textTintColor: Optional tint color for day text. Defaults to nil.
    ///   - selectedTextColor: Text color for selected dates. Defaults to white.
    ///   - todayTextColor: Text color for today. Defaults to system blue.
    ///   - holidayTextColor: Text color for holidays. Defaults to system red.
    ///   - holidayIndicatorColor: Color for holiday dot. Defaults to holidayTextColor.
    ///   - weekendTextColor: Text color for weekends. Defaults to secondary label.
    ///   - disabledTextColor: Text color for disabled days. Defaults to tertiary label.
    ///   - headerTextColor: Text color for headers. Defaults to label color.
    ///   - weekdayLabelColor: Text color for weekday labels. Defaults to secondary label.
    ///   - backgroundColor: Background color. Defaults to system background.
    ///   - dayFont: Optional font for day numbers.
    ///   - headerFont: Optional font for headers.
    ///   - weekdayFont: Optional font for weekday labels.
    ///   - footerFont: Optional font for footer holiday labels.
    public init(
        startDate: String,
        endDate: String,
        holidays: [KarendaHoliday] = [],
        isMultiSelectEnabled: Bool = true,
        direction: KarendaDirection = .vertical,
        startDayOfWeek: KarendaStartDay = .sunday,
        selectedBackgroundColor: UIColor = .systemBlue,
        selectionCornerRadius: CGFloat = 0,
        rangeBackgroundColor: UIColor? = nil,
        textTintColor: UIColor? = nil,
        selectedTextColor: UIColor = .white,
        todayTextColor: UIColor = .systemBlue,
        holidayTextColor: UIColor = .systemRed,
        holidayIndicatorColor: UIColor? = nil,
        weekendTextColor: UIColor = .secondaryLabel,
        disabledTextColor: UIColor = .tertiaryLabel,
        headerTextColor: UIColor = .label,
        weekdayLabelColor: UIColor = .secondaryLabel,
        backgroundColor: UIColor = .systemBackground,
        dayFont: UIFont? = nil,
        headerFont: UIFont? = nil,
        weekdayFont: UIFont? = nil,
        footerFont: UIFont? = nil
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.holidays = holidays
        self.isMultiSelectEnabled = isMultiSelectEnabled
        self.direction = direction
        self.startDayOfWeek = startDayOfWeek
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectionCornerRadius = selectionCornerRadius
        self.rangeBackgroundColor = rangeBackgroundColor ?? selectedBackgroundColor.withAlphaComponent(0.15)
        self.textTintColor = textTintColor
        self.selectedTextColor = selectedTextColor
        self.todayTextColor = todayTextColor
        self.holidayTextColor = holidayTextColor
        self.holidayIndicatorColor = holidayIndicatorColor ?? holidayTextColor
        self.weekendTextColor = weekendTextColor
        self.disabledTextColor = disabledTextColor
        self.headerTextColor = headerTextColor
        self.weekdayLabelColor = weekdayLabelColor
        self.backgroundColor = backgroundColor
        self.dayFont = dayFont
        self.headerFont = headerFont
        self.weekdayFont = weekdayFont
        self.footerFont = footerFont
    }
    
    // MARK: - Resolved Fonts
    
    /// Resolved font for day numbers
    var resolvedDayFont: UIFont {
        dayFont ?? .systemFont(ofSize: 16)
    }
    
    /// Resolved font for headers
    var resolvedHeaderFont: UIFont {
        headerFont ?? .systemFont(ofSize: 17, weight: .medium)
    }
    
    /// Resolved font for weekday labels
    var resolvedWeekdayFont: UIFont {
        weekdayFont ?? .systemFont(ofSize: 13)
    }
    
    /// Resolved font for footer
    var resolvedFooterFont: UIFont {
        footerFont ?? .systemFont(ofSize: 12)
    }
    
    /// Resolved text color for regular days
    var resolvedDayTextColor: UIColor {
        textTintColor ?? .label
    }
}

// MARK: - Date Parsing Helpers

extension KarendaConfig {
    
    /// Date formatter for parsing dd/MM/yyyy format
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// Parses a date string in dd/MM/yyyy format
    public static func parseDate(_ dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
    /// Formats a Date to dd/MM/yyyy string
    public static func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    /// The parsed start date
    public var parsedStartDate: Date? {
        return KarendaConfig.parseDate(startDate)
    }
    
    /// The parsed end date
    public var parsedEndDate: Date? {
        return KarendaConfig.parseDate(endDate)
    }
    
    /// The parsed public holiday dates (for checking if a date is a holiday)
    public var parsedHolidayDates: Set<Date> {
        let calendar = Calendar.current
        var holidayDates = Set<Date>()
        for holiday in holidays {
            if let date = holiday.parsedDate {
                let normalized = calendar.startOfDay(for: date)
                holidayDates.insert(normalized)
            }
        }
        return holidayDates
    }
    
    /// Returns holidays for a specific month and year
    public func holidays(forMonth month: Int, year: Int) -> [KarendaHoliday] {
        let calendar = Calendar.current
        return holidays.filter { holiday in
            guard let date = holiday.parsedDate else { return false }
            let components = calendar.dateComponents([.month, .year], from: date)
            return components.month == month && components.year == year
        }
    }
}
