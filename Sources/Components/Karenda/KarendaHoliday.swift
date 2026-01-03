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
