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
