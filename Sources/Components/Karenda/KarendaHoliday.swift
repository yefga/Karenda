//
//  KarendaHoliday.swift
//  Karenda
//
//  Created on 2026-01-03.
//

import Foundation

/// Represents a public holiday with date and name.
public struct KarendaHoliday {
    
    /// The holiday date (format: dd/MM/yyyy)
    public let date: String
    
    /// The name/description of the holiday
    public let name: String
    
    /// Creates a new holiday.
    /// - Parameters:
    ///   - date: The holiday date (format: dd/MM/yyyy)
    ///   - name: The name of the holiday
    public init(date: String, name: String) {
        self.date = date
        self.name = name
    }
    
    /// The parsed date
    public var parsedDate: Date? {
        KarendaConfig.parseDate(date)
    }
}

// MARK: - Equatable & Hashable

extension KarendaHoliday: Equatable, Hashable {
    public static func == (lhs: KarendaHoliday, rhs: KarendaHoliday) -> Bool {
        lhs.date == rhs.date
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}
