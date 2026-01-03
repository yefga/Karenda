//
//  VerticalCalendarViewController.swift
//  KarendaExampleApp
//
//  Created by Yefga on 2026-01-03.
//

import UIKit
import Karenda

/// Example view controller demonstrating vertical scrolling calendar with multi-select
final class VerticalCalendarViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.text = "Select a date range"
        return label
    }()
    
    private var karendaView: KarendaView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vertical Calendar"
        view.backgroundColor = .systemBackground
        
        setupCalendar()
        setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupCalendar() {
        // Calculate date range: today to 1 year from now
        let today = Date()
        let oneYearLater = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        
        let startDateString = KarendaConfig.formatDate(today)
        let endDateString = KarendaConfig.formatDate(oneYearLater)
        
        // Define some sample holidays
        let holidays = [
            "01/01/2026",
            "14/02/2026",
            "25/12/2026"
        ]
        
        // Create configuration with new options
        let config = KarendaConfig(
            startDate: startDateString,
            endDate: endDateString,
            publicHolidays: holidays,
            isMultiSelectEnabled: true,
            direction: .vertical,                    // Vertical scrolling
            startDayOfWeek: .monday,                 // Week starts on Sunday
            selectedBackgroundColor: .systemBlue,
            selectionCornerRadius: 20               // Rounded corners on selection
        )
        
        // Create calendar view
        karendaView = KarendaView(config: config)
        karendaView.translatesAutoresizingMaskIntoConstraints = false
        karendaView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(selectionLabel)
        view.addSubview(karendaView)
        
        NSLayoutConstraint.activate([
            selectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            karendaView.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor, constant: 16),
            karendaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            karendaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            karendaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - KarendaDelegate

extension VerticalCalendarViewController: KarendaDelegate {
    
    func didSelectCalendar(startDate: String, endDate: String) {
        if startDate == endDate {
            selectionLabel.text = "Selected: \(startDate)"
        } else {
            selectionLabel.text = "Range: \(startDate) → \(endDate)"
        }
    }
    
    func didClearSelection() {
        selectionLabel.text = "Select a date range"
    }
    
    func didTapDate(_ date: String) {
        print("Tapped: \(date)")
    }
    
    func didScrollToMonth(_ month: Int, year: Int) {
        print("Scrolled to: \(month)/\(year)")
    }
}
