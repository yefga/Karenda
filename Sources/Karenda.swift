//
//  Karenda.swift
//  Karenda
//
//  Created on 2026-01-03.
//

import UIKit

/// Karenda - A modern UIKit-based calendar date picker framework for iOS.
///
/// Karenda provides a customizable calendar view with:
/// - Vertical or horizontal scrolling
/// - Single date or date range selection
/// - Public holiday highlighting
/// - Customizable appearance
///
/// ## Getting Started
/// ```swift
/// import Karenda
///
/// let config = KarendaConfig(
///     startDate: "01/01/2024",
///     endDate: "31/12/2024",
///     direction: .vertical,
///     selectedBackgroundColor: .systemBlue
/// )
///
/// let calendarView = KarendaView(config: config)
/// calendarView.delegate = self
/// view.addSubview(calendarView)
/// ```
///

/// Framework information and utilities.
public enum KarendaFramework {
    
    /// The current version of the Karenda framework.
    public static let version = "1.0.0"
    
    /// Framework bundle identifier.
    public static let bundleIdentifier = "com.example.karenda"
    
    /// Returns the framework's bundle.
    public static var bundle: Bundle {
        Bundle(for: BundleToken.self)
    }
}

// MARK: - Bundle Token

/// Internal class used to locate the framework bundle.
private final class BundleToken {}
