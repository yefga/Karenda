//
//  KarendaDayCell.swift
//  Karenda
//
//  Created on 2026-01-03.
//

import UIKit

/// Cell state for selection appearance
enum KarendaDayCellState {
    case normal
    case selected
    case rangeStart
    case rangeEnd
    case inRange
}

/// Collection view cell representing a single day in the calendar
final class KarendaDayCell: UICollectionViewCell {
    
    static let reuseIdentifier = "KarendaDayCell"
    
    // MARK: - UI Elements
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    private let rangeBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    private var cornerRadius: CGFloat = 0
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        contentView.addSubview(rangeBackgroundView)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            // Range background (full width for connecting days)
            rangeBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rangeBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rangeBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rangeBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.heightAnchor),
            
            // Selection background
            selectionBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor),
            
            // Day label
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        let maxRadius = selectionBackgroundView.bounds.width / 2
        // If cornerRadius is 0, use square; if very large, use circle
        if cornerRadius <= 0 {
            selectionBackgroundView.layer.cornerRadius = 0
        } else if cornerRadius >= maxRadius {
            selectionBackgroundView.layer.cornerRadius = maxRadius
        } else {
            selectionBackgroundView.layer.cornerRadius = cornerRadius
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        selectionBackgroundView.backgroundColor = .clear
        rangeBackgroundView.backgroundColor = .clear
        dayLabel.textColor = .label
        cornerRadius = 0
    }
    
    // MARK: - Configuration
    
    func configure(with day: KarendaDayItem, config: KarendaConfig, state: KarendaDayCellState) {
        self.cornerRadius = config.selectionCornerRadius
        dayLabel.font = config.resolvedDayFont
        
        // Empty cell
        guard day.date != nil else {
            dayLabel.text = nil
            selectionBackgroundView.backgroundColor = .clear
            rangeBackgroundView.backgroundColor = .clear
            return
        }
        
        dayLabel.text = "\(day.dayNumber)"
        
        // Apply selection state
        applyState(state, day: day, config: config)
        
        // Update corner radius after config is set
        setNeedsLayout()
    }
    
    private func applyState(_ state: KarendaDayCellState, day: KarendaDayItem, config: KarendaConfig) {
        // Reset backgrounds
        selectionBackgroundView.backgroundColor = .clear
        rangeBackgroundView.backgroundColor = .clear
        
        // Determine text color based on day properties
        var textColor: UIColor
        
        if !day.isEnabled {
            textColor = config.disabledTextColor
        } else if day.isHoliday {
            textColor = config.holidayTextColor
        } else if day.isToday {
            textColor = config.todayTextColor
        } else if day.isWeekend {
            textColor = config.weekendTextColor
        } else {
            textColor = config.resolvedDayTextColor
        }
        
        // Apply selection styling
        switch state {
        case .normal:
            dayLabel.textColor = textColor
            
        case .selected:
            selectionBackgroundView.backgroundColor = config.selectedBackgroundColor
            dayLabel.textColor = config.selectedTextColor
            
        case .rangeStart:
            selectionBackgroundView.backgroundColor = config.selectedBackgroundColor
            rangeBackgroundView.backgroundColor = config.rangeBackgroundColor
            // Mask right half for range connection
            rangeBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            rangeBackgroundView.layer.cornerRadius = 0
            dayLabel.textColor = config.selectedTextColor
            
        case .rangeEnd:
            selectionBackgroundView.backgroundColor = config.selectedBackgroundColor
            rangeBackgroundView.backgroundColor = config.rangeBackgroundColor
            // Mask left half for range connection
            rangeBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            rangeBackgroundView.layer.cornerRadius = 0
            dayLabel.textColor = config.selectedTextColor
            
        case .inRange:
            rangeBackgroundView.backgroundColor = config.rangeBackgroundColor
            rangeBackgroundView.layer.maskedCorners = []
            rangeBackgroundView.layer.cornerRadius = 0
            dayLabel.textColor = textColor
        }
    }
}
