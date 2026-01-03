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

// MARK: - Auto Layout Extensions

extension UIView {
    
    /// Pins the view's edges to its superview's edges with optional insets.
    /// - Parameter insets: The edge insets to apply. Defaults to zero.
    /// - Returns: An array of the activated constraints.
    @discardableResult
    public func pinToSuperview(insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure("View must have a superview before pinning")
            return []
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    /// Pins the view's edges to its superview's safe area with optional insets.
    /// - Parameter insets: The edge insets to apply. Defaults to zero.
    /// - Returns: An array of the activated constraints.
    @discardableResult
    public func pinToSuperviewSafeArea(insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure("View must have a superview before pinning")
            return []
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    /// Centers the view within its superview.
    /// - Returns: An array of the activated constraints.
    @discardableResult
    public func centerInSuperview() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure("View must have a superview before centering")
            return []
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    /// Sets a fixed size for the view.
    /// - Parameters:
    ///   - width: The fixed width.
    ///   - height: The fixed height.
    /// - Returns: An array of the activated constraints.
    @discardableResult
    public func setSize(width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    /// Sets a fixed size for the view using a CGSize.
    /// - Parameter size: The size to apply.
    /// - Returns: An array of the activated constraints.
    @discardableResult
    public func setSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return setSize(width: size.width, height: size.height)
    }
}

// MARK: - Corner Radius Extensions

extension UIView {
    
    /// Applies a corner radius to the view.
    /// - Parameter radius: The corner radius to apply.
    public func roundCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// Applies corner radius to specific corners.
    /// - Parameters:
    ///   - corners: The corners to round.
    ///   - radius: The corner radius to apply.
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners.toCACornerMask()
        layer.masksToBounds = true
    }
    
    /// Makes the view circular by setting corner radius to half its bounds.
    public func makeCircular() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
}

// MARK: - Shadow Extensions

extension UIView {
    
    /// Applies a shadow to the view.
    /// - Parameters:
    ///   - color: The shadow color. Defaults to black.
    ///   - opacity: The shadow opacity. Defaults to 0.1.
    ///   - offset: The shadow offset. Defaults to (0, 2).
    ///   - radius: The shadow blur radius. Defaults to 4.
    public func applyShadow(
        color: UIColor = .black,
        opacity: Float = 0.1,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 4
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    /// Removes the shadow from the view.
    public func removeShadow() {
        layer.shadowOpacity = 0
    }
}

// MARK: - Border Extensions

extension UIView {
    
    /// Applies a border to the view.
    /// - Parameters:
    ///   - color: The border color.
    ///   - width: The border width. Defaults to 1.
    public func applyBorder(color: UIColor, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Removes the border from the view.
    public func removeBorder() {
        layer.borderWidth = 0
    }
}

// MARK: - Helper Extensions

extension UIRectCorner {
    
    /// Converts UIRectCorner to CACornerMask.
    func toCACornerMask() -> CACornerMask {
        var cornerMask: CACornerMask = []
        
        if contains(.topLeft) {
            cornerMask.insert(.layerMinXMinYCorner)
        }
        if contains(.topRight) {
            cornerMask.insert(.layerMaxXMinYCorner)
        }
        if contains(.bottomLeft) {
            cornerMask.insert(.layerMinXMaxYCorner)
        }
        if contains(.bottomRight) {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }
        
        return cornerMask
    }
}
