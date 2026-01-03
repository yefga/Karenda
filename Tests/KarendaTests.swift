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

import XCTest
@testable import Karenda

final class KarendaTests: XCTestCase {
    
    // MARK: - Framework Tests
    
    func testFrameworkVersion() {
        XCTAssertEqual(KarendaFramework.version, "1.0.0")
    }
    
    func testBundleIdentifier() {
        XCTAssertEqual(KarendaFramework.bundleIdentifier, "com.example.karenda")
    }
    
    // MARK: - Config Tests
    
    func testConfigDateParsing() {
        let dateString = "25/12/2024"
        let date = KarendaConfig.parseDate(dateString)
        
        XCTAssertNotNil(date)
        
        let formatted = KarendaConfig.formatDate(date!)
        XCTAssertEqual(formatted, dateString)
    }
    
    func testConfigDefaults() {
        let config = KarendaConfig(
            startDate: "01/01/2024",
            endDate: "31/12/2024"
        )
        
        XCTAssertEqual(config.direction, .vertical)
        XCTAssertEqual(config.startDayOfWeek, .sunday)
        XCTAssertEqual(config.selectionCornerRadius, 0)
        XCTAssertTrue(config.isMultiSelectEnabled)
    }
    
    func testStartDayOfWeekLabels() {
        let sunday = KarendaStartDay.sunday
        XCTAssertEqual(sunday.weekdayLabels, ["S", "M", "T", "W", "T", "F", "S"])
        
        let monday = KarendaStartDay.monday
        XCTAssertEqual(monday.weekdayLabels, ["M", "T", "W", "T", "F", "S", "S"])
    }
    
    func testHolidayStruct() {
        let holiday = KarendaHoliday(date: "25/12/2024", name: "Christmas Day")
        
        XCTAssertEqual(holiday.date, "25/12/2024")
        XCTAssertEqual(holiday.name, "Christmas Day")
        XCTAssertNotNil(holiday.parsedDate)
    }
    
    func testHolidaysForMonth() {
        let holidays = [
            KarendaHoliday(date: "01/01/2024", name: "New Year"),
            KarendaHoliday(date: "25/12/2024", name: "Christmas")
        ]
        
        let config = KarendaConfig(
            startDate: "01/01/2024",
            endDate: "31/12/2024",
            holidays: holidays
        )
        
        let januaryHolidays = config.holidays(forMonth: 1, year: 2024)
        XCTAssertEqual(januaryHolidays.count, 1)
        XCTAssertEqual(januaryHolidays.first?.name, "New Year")
        
        let decemberHolidays = config.holidays(forMonth: 12, year: 2024)
        XCTAssertEqual(decemberHolidays.count, 1)
        XCTAssertEqual(decemberHolidays.first?.name, "Christmas")
        
        let juneHolidays = config.holidays(forMonth: 6, year: 2024)
        XCTAssertTrue(juneHolidays.isEmpty)
    }
    
    // MARK: - Theme Tests
    
    func testDefaultTheme() {
        let theme = Theme.default
        
        XCTAssertNotNil(theme.colors)
        XCTAssertNotNil(theme.fonts)
        XCTAssertNotNil(theme.spacing)
        XCTAssertNotNil(theme.cornerRadius)
    }
    
    func testThemeColors() {
        let colors = Theme.Colors.default
        
        XCTAssertEqual(colors.primary, .systemBlue)
        XCTAssertEqual(colors.secondary, .systemIndigo)
        XCTAssertEqual(colors.accent, .systemOrange)
    }
    
    func testThemeSpacing() {
        let spacing = Theme.Spacing.default
        
        XCTAssertEqual(spacing.xs, 4)
        XCTAssertEqual(spacing.sm, 8)
        XCTAssertEqual(spacing.md, 16)
        XCTAssertEqual(spacing.lg, 24)
        XCTAssertEqual(spacing.xl, 32)
        XCTAssertEqual(spacing.xxl, 48)
    }
    
    func testThemeCornerRadius() {
        let cornerRadius = Theme.CornerRadius.default
        
        XCTAssertEqual(cornerRadius.none, 0)
        XCTAssertEqual(cornerRadius.sm, 4)
        XCTAssertEqual(cornerRadius.md, 8)
        XCTAssertEqual(cornerRadius.lg, 12)
        XCTAssertEqual(cornerRadius.xl, 16)
    }
    
    func testThemeManager() {
        let manager = ThemeManager.shared
        let customTheme = Theme(
            colors: Theme.Colors(primary: .red)
        )
        
        manager.current = customTheme
        
        XCTAssertEqual(manager.current.colors.primary, .red)
    }
    
    // MARK: - BaseView Tests
    
    func testBaseViewInitialization() {
        let view = BaseView()
        
        XCTAssertNotNil(view)
        XCTAssertEqual(view.frame, .zero)
    }
    
    func testBaseViewInitializationWithFrame() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = BaseView(frame: frame)
        
        XCTAssertEqual(view.frame, frame)
    }
}
