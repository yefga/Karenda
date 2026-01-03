//
//  KarendaMonthData.swift
//  Karenda
//
//  Created by Yefga on 2026-01-03.
//

import Foundation

/// Represents a single day in the calendar
struct KarendaDayItem {
    /// The date for this day, or nil for empty cells
    let date: Date?
    
    /// The day number (1-31)
    let dayNumber: Int
    
    /// Whether this day is in the current month
    let isCurrentMonth: Bool
    
    /// Whether this day is today
    let isToday: Bool
    
    /// Whether this day is a weekend (based on calendar, not visual position)
    let isWeekend: Bool
    
    /// Whether this day is a public holiday
    let isHoliday: Bool
    
    /// Whether this day is within the valid date range
    let isEnabled: Bool
    
    /// Creates an empty day item (for padding)
    static let empty = KarendaDayItem(
        date: nil,
        dayNumber: 0,
        isCurrentMonth: false,
        isToday: false,
        isWeekend: false,
        isHoliday: false,
        isEnabled: false
    )
}

/// Represents a month section in the calendar
struct KarendaMonthData {
    /// The month number (1-12)
    let month: Int
    
    /// The year
    let year: Int
    
    /// The days in this month (including padding for the first week)
    let days: [KarendaDayItem]
    
    /// The formatted title for this month (e.g., "November 2017")
    var title: String {
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        guard let date = Calendar.current.date(from: dateComponents) else {
            return "\(month)/\(year)"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

/// Generator for calendar month data
final class KarendaDataGenerator {
    
    private let calendar: Calendar
    private let holidays: Set<Date>
    private let rangeStart: Date
    private let rangeEnd: Date
    private let startDayOfWeek: KarendaStartDay
    
    init(config: KarendaConfig) {
        var calendar = Calendar.current
        calendar.firstWeekday = config.startDayOfWeek.rawValue
        self.calendar = calendar
        self.startDayOfWeek = config.startDayOfWeek
        
        self.holidays = config.parsedPublicHolidays
        self.rangeStart = config.parsedStartDate ?? Date()
        self.rangeEnd = config.parsedEndDate ?? Date()
    }
    
    /// Generates all months between the start and end dates
    func generateMonths() -> [KarendaMonthData] {
        var months: [KarendaMonthData] = []
        
        let startComponents = calendar.dateComponents([.year, .month], from: rangeStart)
        let endComponents = calendar.dateComponents([.year, .month], from: rangeEnd)
        
        guard let startYear = startComponents.year,
              let startMonth = startComponents.month,
              let endYear = endComponents.year,
              let endMonth = endComponents.month else {
            return months
        }
        
        var currentYear = startYear
        var currentMonth = startMonth
        
        while currentYear < endYear || (currentYear == endYear && currentMonth <= endMonth) {
            let monthData = generateMonth(month: currentMonth, year: currentYear)
            months.append(monthData)
            
            currentMonth += 1
            if currentMonth > 12 {
                currentMonth = 1
                currentYear += 1
            }
        }
        
        return months
    }
    
    /// Generates data for a single month
    private func generateMonth(month: Int, year: Int) -> KarendaMonthData {
        var days: [KarendaDayItem] = []
        
        // Get the first day of the month
        guard let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            return KarendaMonthData(month: month, year: year, days: [])
        }
        
        // Get the weekday of the first day
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        // Calculate empty cells needed before the first day
        // Based on the configured start day of week
        var emptyDays = firstWeekday - startDayOfWeek.rawValue
        if emptyDays < 0 {
            emptyDays += 7
        }
        
        // Add empty cells for days before the first of the month
        for _ in 0..<emptyDays {
            days.append(.empty)
        }
        
        // Get the number of days in the month
        guard let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
            return KarendaMonthData(month: month, year: year, days: [])
        }
        
        let today = calendar.startOfDay(for: Date())
        
        // Add days of the month
        for dayNumber in range {
            guard let date = calendar.date(from: DateComponents(year: year, month: month, day: dayNumber)) else {
                continue
            }
            
            let normalizedDate = calendar.startOfDay(for: date)
            let weekday = calendar.component(.weekday, from: date)
            // Weekend is always Saturday (7) and Sunday (1) regardless of start day
            let isWeekend = weekday == 1 || weekday == 7
            let isToday = normalizedDate == today
            let isHoliday = holidays.contains(normalizedDate)
            let isEnabled = normalizedDate >= calendar.startOfDay(for: rangeStart) &&
                           normalizedDate <= calendar.startOfDay(for: rangeEnd)
            
            let dayItem = KarendaDayItem(
                date: normalizedDate,
                dayNumber: dayNumber,
                isCurrentMonth: true,
                isToday: isToday,
                isWeekend: isWeekend,
                isHoliday: isHoliday,
                isEnabled: isEnabled
            )
            days.append(dayItem)
        }
        
        return KarendaMonthData(month: month, year: year, days: days)
    }
}
