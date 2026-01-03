//
//  Theme.swift
//  Karenda
//
//  Created on 2026-01-03.
//

import UIKit

/// A theme configuration that defines the visual appearance of UI components.
///
/// `Theme` provides a centralized way to manage colors, fonts, spacing,
/// and other visual properties across your application.
///
/// ## Usage
/// ```swift
/// // Use the default theme
/// let theme = Theme.default
/// view.backgroundColor = theme.colors.background
/// label.font = theme.fonts.body
///
/// // Create a custom theme
/// let customTheme = Theme(
///     colors: Theme.Colors(primary: .systemBlue),
///     fonts: Theme.Fonts(bodySize: 16)
/// )
/// ```
///
public struct Theme {
    
    // MARK: - Properties
    
    /// The color palette for this theme.
    public let colors: Colors
    
    /// The typography settings for this theme.
    public let fonts: Fonts
    
    /// The spacing values for this theme.
    public let spacing: Spacing
    
    /// The corner radius values for this theme.
    public let cornerRadius: CornerRadius
    
    // MARK: - Initialization
    
    /// Creates a new theme with the specified configuration.
    /// - Parameters:
    ///   - colors: The color palette. Defaults to `.default`.
    ///   - fonts: The typography settings. Defaults to `.default`.
    ///   - spacing: The spacing values. Defaults to `.default`.
    ///   - cornerRadius: The corner radius values. Defaults to `.default`.
    public init(
        colors: Colors = .default,
        fonts: Fonts = .default,
        spacing: Spacing = .default,
        cornerRadius: CornerRadius = .default
    ) {
        self.colors = colors
        self.fonts = fonts
        self.spacing = spacing
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Default Theme
    
    /// The default theme configuration.
    public static let `default` = Theme()
}

// MARK: - Colors

extension Theme {
    
    /// A color palette for the theme.
    public struct Colors {
        
        /// The primary brand color.
        public let primary: UIColor
        
        /// The secondary brand color.
        public let secondary: UIColor
        
        /// The accent color for highlights and calls-to-action.
        public let accent: UIColor
        
        /// The main background color.
        public let background: UIColor
        
        /// The secondary background color for cards, sections, etc.
        public let secondaryBackground: UIColor
        
        /// The primary text color.
        public let text: UIColor
        
        /// The secondary text color for subtitles, captions, etc.
        public let secondaryText: UIColor
        
        /// The color for borders and separators.
        public let separator: UIColor
        
        /// The color indicating success states.
        public let success: UIColor
        
        /// The color indicating warning states.
        public let warning: UIColor
        
        /// The color indicating error states.
        public let error: UIColor
        
        /// Creates a new color palette.
        public init(
            primary: UIColor = .systemBlue,
            secondary: UIColor = .systemIndigo,
            accent: UIColor = .systemOrange,
            background: UIColor = .systemBackground,
            secondaryBackground: UIColor = .secondarySystemBackground,
            text: UIColor = .label,
            secondaryText: UIColor = .secondaryLabel,
            separator: UIColor = .separator,
            success: UIColor = .systemGreen,
            warning: UIColor = .systemYellow,
            error: UIColor = .systemRed
        ) {
            self.primary = primary
            self.secondary = secondary
            self.accent = accent
            self.background = background
            self.secondaryBackground = secondaryBackground
            self.text = text
            self.secondaryText = secondaryText
            self.separator = separator
            self.success = success
            self.warning = warning
            self.error = error
        }
        
        /// The default color palette.
        public static let `default` = Colors()
    }
}

// MARK: - Fonts

extension Theme {
    
    /// Typography settings for the theme.
    public struct Fonts {
        
        /// The font for large titles.
        public let largeTitle: UIFont
        
        /// The font for primary titles.
        public let title: UIFont
        
        /// The font for secondary titles.
        public let title2: UIFont
        
        /// The font for tertiary titles.
        public let title3: UIFont
        
        /// The font for headlines.
        public let headline: UIFont
        
        /// The font for body text.
        public let body: UIFont
        
        /// The font for callouts.
        public let callout: UIFont
        
        /// The font for subheadlines.
        public let subheadline: UIFont
        
        /// The font for footnotes.
        public let footnote: UIFont
        
        /// The font for captions.
        public let caption: UIFont
        
        /// Creates a new font configuration.
        public init(
            largeTitle: UIFont = .preferredFont(forTextStyle: .largeTitle),
            title: UIFont = .preferredFont(forTextStyle: .title1),
            title2: UIFont = .preferredFont(forTextStyle: .title2),
            title3: UIFont = .preferredFont(forTextStyle: .title3),
            headline: UIFont = .preferredFont(forTextStyle: .headline),
            body: UIFont = .preferredFont(forTextStyle: .body),
            callout: UIFont = .preferredFont(forTextStyle: .callout),
            subheadline: UIFont = .preferredFont(forTextStyle: .subheadline),
            footnote: UIFont = .preferredFont(forTextStyle: .footnote),
            caption: UIFont = .preferredFont(forTextStyle: .caption1)
        ) {
            self.largeTitle = largeTitle
            self.title = title
            self.title2 = title2
            self.title3 = title3
            self.headline = headline
            self.body = body
            self.callout = callout
            self.subheadline = subheadline
            self.footnote = footnote
            self.caption = caption
        }
        
        /// Creates a font configuration with a custom base size.
        /// - Parameter bodySize: The base body font size.
        public init(bodySize: CGFloat) {
            self.init(
                largeTitle: .systemFont(ofSize: bodySize * 2.125, weight: .bold),
                title: .systemFont(ofSize: bodySize * 1.75, weight: .bold),
                title2: .systemFont(ofSize: bodySize * 1.375, weight: .bold),
                title3: .systemFont(ofSize: bodySize * 1.25, weight: .semibold),
                headline: .systemFont(ofSize: bodySize * 1.0625, weight: .semibold),
                body: .systemFont(ofSize: bodySize, weight: .regular),
                callout: .systemFont(ofSize: bodySize, weight: .regular),
                subheadline: .systemFont(ofSize: bodySize * 0.9375, weight: .regular),
                footnote: .systemFont(ofSize: bodySize * 0.8125, weight: .regular),
                caption: .systemFont(ofSize: bodySize * 0.75, weight: .regular)
            )
        }
        
        /// The default font configuration using system fonts.
        public static let `default` = Fonts()
    }
}

// MARK: - Spacing

extension Theme {
    
    /// Spacing values for the theme.
    public struct Spacing {
        
        /// Extra small spacing (4pt).
        public let xs: CGFloat
        
        /// Small spacing (8pt).
        public let sm: CGFloat
        
        /// Medium spacing (16pt).
        public let md: CGFloat
        
        /// Large spacing (24pt).
        public let lg: CGFloat
        
        /// Extra large spacing (32pt).
        public let xl: CGFloat
        
        /// Extra extra large spacing (48pt).
        public let xxl: CGFloat
        
        /// Creates a new spacing configuration.
        public init(
            xs: CGFloat = 4,
            sm: CGFloat = 8,
            md: CGFloat = 16,
            lg: CGFloat = 24,
            xl: CGFloat = 32,
            xxl: CGFloat = 48
        ) {
            self.xs = xs
            self.sm = sm
            self.md = md
            self.lg = lg
            self.xl = xl
            self.xxl = xxl
        }
        
        /// The default spacing configuration.
        public static let `default` = Spacing()
    }
}

// MARK: - Corner Radius

extension Theme {
    
    /// Corner radius values for the theme.
    public struct CornerRadius {
        
        /// No corner radius (0pt).
        public let none: CGFloat
        
        /// Small corner radius (4pt).
        public let sm: CGFloat
        
        /// Medium corner radius (8pt).
        public let md: CGFloat
        
        /// Large corner radius (12pt).
        public let lg: CGFloat
        
        /// Extra large corner radius (16pt).
        public let xl: CGFloat
        
        /// Full corner radius for pills/circles.
        public let full: CGFloat
        
        /// Creates a new corner radius configuration.
        public init(
            none: CGFloat = 0,
            sm: CGFloat = 4,
            md: CGFloat = 8,
            lg: CGFloat = 12,
            xl: CGFloat = 16,
            full: CGFloat = 9999
        ) {
            self.none = none
            self.sm = sm
            self.md = md
            self.lg = lg
            self.xl = xl
            self.full = full
        }
        
        /// The default corner radius configuration.
        public static let `default` = CornerRadius()
    }
}

// MARK: - Theme Provider

/// A protocol for objects that provide a theme.
public protocol ThemeProvider {
    /// The current theme.
    var theme: Theme { get }
}

/// A singleton that manages the current app theme.
public final class ThemeManager {
    
    /// The shared theme manager instance.
    public static let shared = ThemeManager()
    
    /// The current theme.
    public var current: Theme = .default {
        didSet {
            notifyThemeChanged()
        }
    }
    
    /// Notification name posted when the theme changes.
    public static let themeDidChangeNotification = Notification.Name("KarendaThemeDidChange")
    
    private init() {}
    
    private func notifyThemeChanged() {
        NotificationCenter.default.post(
            name: ThemeManager.themeDidChangeNotification,
            object: self
        )
    }
}
