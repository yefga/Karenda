//
//  KarendaMonthFooterView.swift
//  Karenda
//
//  Created on 2026-01-03.
//

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
