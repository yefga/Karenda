//
//  KarendaMonthHeaderView.swift
//  Karenda
//
//  Created on 2026-01-03.
//

import UIKit

/// Supplementary view for month headers in the calendar
final class KarendaMonthHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "KarendaMonthHeaderView"
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weekdayStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var weekdayLabels: [UILabel] = []
    
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
        addSubview(titleLabel)
        addSubview(weekdayStackView)
        
        // Create 7 weekday labels (will be configured later)
        for _ in 0..<7 {
            let label = UILabel()
            label.textAlignment = .center
            weekdayStackView.addArrangedSubview(label)
            weekdayLabels.append(label)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            weekdayStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            weekdayStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdayStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdayStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Configuration
    
    func configure(with title: String, config: KarendaConfig) {
        titleLabel.text = title
        titleLabel.font = config.resolvedHeaderFont
        titleLabel.textColor = config.headerTextColor
        
        // Get weekday labels based on start day of week
        let weekdays = config.startDayOfWeek.weekdayLabels
        
        // Determine which visual positions are weekends
        // Weekend days are always Saturday and Sunday in the Gregorian calendar
        // We need to figure out which visual positions they occupy based on startDayOfWeek
        let saturdayPosition = (7 - config.startDayOfWeek.rawValue + 1) % 7
        let sundayPosition = (1 - config.startDayOfWeek.rawValue + 7) % 7
        
        for (index, label) in weekdayLabels.enumerated() {
            label.text = weekdays[index]
            label.font = config.resolvedWeekdayFont
            
            // Check if this position is Saturday or Sunday
            if index == saturdayPosition || index == sundayPosition {
                label.textColor = config.weekendTextColor
            } else {
                label.textColor = config.weekdayLabelColor
            }
        }
    }
}
