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

/// Supplementary view for month footers showing holidays in that month
final class KarendaMonthFooterView: UICollectionReusableView {
    
    static let reuseIdentifier = "KarendaMonthFooterView"
    
    // MARK: - UI Elements
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Remove all holiday labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Configuration
    
    func configure(with holidays: [KarendaHoliday], config: KarendaConfig) {
        // Clear existing labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add a label for each holiday
        for holiday in holidays {
            let holidayView = createHolidayLabel(holiday: holiday, config: config)
            stackView.addArrangedSubview(holidayView)
        }
    }
    
    private func createHolidayLabel(holiday: KarendaHoliday, config: KarendaConfig) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Dot indicator
        let dotView = UIView()
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.backgroundColor = config.holidayIndicatorColor
        dotView.layer.cornerRadius = 3
        
        // Holiday text label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = config.resolvedFooterFont
        label.textColor = config.holidayTextColor
        label.numberOfLines = 0
        
        // Format: "25 Dec - Christmas Day"
        if let date = holiday.parsedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            let dateStr = formatter.string(from: date)
            label.text = "\(dateStr) - \(holiday.name)"
        } else {
            label.text = "\(holiday.date) - \(holiday.name)"
        }
        
        container.addSubview(dotView)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            dotView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dotView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            dotView.widthAnchor.constraint(equalToConstant: 6),
            dotView.heightAnchor.constraint(equalToConstant: 6),
            
            label.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
}
