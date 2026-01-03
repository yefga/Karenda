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

/// Delegate protocol for receiving calendar selection events from Karenda.
public protocol KarendaDelegate: AnyObject {
    
    /// Called when the user selects a date or date range.
    ///
    /// In multi-select mode, this is called when both start and end dates are selected.
    /// In single-select mode, this is called immediately when a date is tapped,
    /// with `startDate` and `endDate` having the same value.
    ///
    /// - Parameters:
    ///   - startDate: The start date in dd/MM/yyyy format
    ///   - endDate: The end date in dd/MM/yyyy format
    func didSelectCalendar(startDate: String, endDate: String)
    
    /// Called when the selection is cleared.
    ///
    /// This occurs when the user taps a selected date to deselect it,
    /// or when `clearSelection()` is called programmatically.
    func didClearSelection()
    
    /// Called when a single date is tapped.
    ///
    /// This method is called for every tap, allowing you to respond to
    /// individual date selections before the range is complete.
    ///
    /// - Parameter date: The tapped date in dd/MM/yyyy format
    func didTapDate(_ date: String)
    
    /// Called when the visible month changes during scrolling.
    ///
    /// - Parameters:
    ///   - month: The month number (1-12)
    ///   - year: The year
    func didScrollToMonth(_ month: Int, year: Int)
}

// MARK: - Default Implementations

public extension KarendaDelegate {
    
    func didClearSelection() {
        // Default empty implementation
    }
    
    func didTapDate(_ date: String) {
        // Default empty implementation
    }
    
    func didScrollToMonth(_ month: Int, year: Int) {
        // Default empty implementation
    }
}
