//
//  KarendaTests.swift
//  Karenda
//
//  Created on 2026-01-03.
//

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
