//
//  BaseView.swift
//  Karenda
//
//  Created by Yefga on 2026-01-03.
//

import UIKit

/// A base UIView class that provides common setup hooks and convenience methods.
///
/// `BaseView` serves as the foundation for all custom views in the Karenda framework.
/// It provides a structured initialization pattern with dedicated setup methods that
/// subclasses can override.
///
/// ## Subclassing
/// Override the following methods to customize your view:
/// - `setupView()`: Configure view properties
/// - `setupHierarchy()`: Add subviews
/// - `setupConstraints()`: Set up Auto Layout constraints
/// - `setupBindings()`: Configure data bindings or observers
///
/// ## Example
/// ```swift
/// class CustomButton: BaseView {
///     private let titleLabel = UILabel()
///
///     override func setupHierarchy() {
///         addSubview(titleLabel)
///     }
///
///     override func setupConstraints() {
///         titleLabel.translatesAutoresizingMaskIntoConstraints = false
///         NSLayoutConstraint.activate([
///             titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
///             titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
///         ])
///     }
/// }
/// ```
///
open class BaseView: UIView {
    
    // MARK: - Initialization
    
    /// Creates a new base view with the specified frame.
    /// - Parameter frame: The frame rectangle for the view.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// Creates a new base view from a storyboard or nib.
    /// - Parameter coder: The decoder to use for initialization.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    /// Convenience initializer that creates a view with zero frame.
    public convenience init() {
        self.init(frame: .zero)
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        setupView()
        setupHierarchy()
        setupConstraints()
        setupBindings()
    }
    
    // MARK: - Setup Hooks
    
    /// Called during initialization to configure the view's properties.
    ///
    /// Override this method to set properties like background color,
    /// corner radius, or other view attributes.
    ///
    /// The default implementation does nothing.
    open func setupView() {
        // Subclasses should override this method
    }
    
    /// Called during initialization to add subviews to the view hierarchy.
    ///
    /// Override this method to add child views using `addSubview(_:)`.
    ///
    /// The default implementation does nothing.
    open func setupHierarchy() {
        // Subclasses should override this method
    }
    
    /// Called during initialization to set up Auto Layout constraints.
    ///
    /// Override this method to configure constraints for subviews.
    /// Remember to set `translatesAutoresizingMaskIntoConstraints = false`
    /// on views that will use Auto Layout.
    ///
    /// The default implementation does nothing.
    open func setupConstraints() {
        // Subclasses should override this method
    }
    
    /// Called during initialization to set up data bindings or observers.
    ///
    /// Override this method to configure KVO observers, notification
    /// observers, or other reactive bindings.
    ///
    /// The default implementation does nothing.
    open func setupBindings() {
        // Subclasses should override this method
    }
}

// MARK: - Convenience Methods

extension BaseView {
    
    /// Adds multiple subviews to the view.
    /// - Parameter subviews: The views to add as subviews.
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    /// Adds multiple subviews to the view from an array.
    /// - Parameter subviews: An array of views to add as subviews.
    public func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /// Prepares a view for Auto Layout by setting
    /// `translatesAutoresizingMaskIntoConstraints` to `false`.
    /// - Parameter view: The view to prepare.
    public func prepareForAutoLayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Prepares multiple views for Auto Layout.
    /// - Parameter views: The views to prepare.
    public func prepareForAutoLayout(_ views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
