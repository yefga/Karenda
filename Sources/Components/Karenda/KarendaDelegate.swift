//
//  KarendaDelegate.swift
//  Karenda
//
//  Created by Yefga on 2026-01-03.
//

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
