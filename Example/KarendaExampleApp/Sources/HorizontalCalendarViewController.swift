//
//  HorizontalCalendarViewController.swift
//  KarendaExampleApp
//
//  Created on 2026-01-03.
//

import UIKit
import Karenda

/// Example view controller demonstrating horizontal paging calendar (1 month per page)
final class HorizontalCalendarViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.text = "Swipe left/right to change months"
        return label
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var karendaView: KarendaView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Horizontal Calendar"
        view.backgroundColor = .systemBackground
        
        setupCalendar()
        setupLayout()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    
    private func setupCalendar() {
        let today = Date()
        let sixMonthsLater = Calendar.current.date(byAdding: .month, value: 6, to: today)!
        
        let startDateString = KarendaConfig.formatDate(today)
        let endDateString = KarendaConfig.formatDate(sixMonthsLater)
        
        // Holidays with names
        let holidays: [KarendaHoliday] = [
            KarendaHoliday(date: "01/01/2026", name: "New Year's Day"),
            KarendaHoliday(date: "14/02/2026", name: "Valentine's Day")
        ]
        
        // Custom styling with horizontal paging
        let config = KarendaConfig(
            startDate: startDateString,
            endDate: endDateString,
            holidays: holidays,
            isMultiSelectEnabled: true,
            direction: .horizontal,                   // Horizontal: 1 month per page
            startDayOfWeek: .monday,                  // Week starts on Monday
            selectedBackgroundColor: .systemPurple,
            selectionCornerRadius: 100,               // Circular selection
            rangeBackgroundColor: UIColor.systemPurple.withAlphaComponent(0.15),
            textTintColor: .label,
            todayTextColor: .systemPurple,
            dayFont: .systemFont(ofSize: 17, weight: .medium),
            headerFont: .systemFont(ofSize: 20, weight: .bold)
        )
        
        karendaView = KarendaView(config: config)
        karendaView.translatesAutoresizingMaskIntoConstraints = false
        karendaView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(selectionLabel)
        view.addSubview(monthLabel)
        view.addSubview(karendaView)
        
        NSLayoutConstraint.activate([
            selectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            monthLabel.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor, constant: 8),
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            monthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            karendaView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 16),
            karendaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            karendaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            karendaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let prevButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(previousMonthTapped)
        )
        
        let nextButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.right"),
            style: .plain,
            target: self,
            action: #selector(nextMonthTapped)
        )
        
        let todayButton = UIBarButtonItem(
            title: "Today",
            style: .plain,
            target: self,
            action: #selector(scrollToTodayTapped)
        )
        
        navigationItem.leftBarButtonItems = [prevButton, nextButton]
        navigationItem.rightBarButtonItem = todayButton
    }
    
    // MARK: - Actions
    
    @objc private func previousMonthTapped() {
        karendaView.goToPreviousMonth(animated: true)
    }
    
    @objc private func nextMonthTapped() {
        karendaView.goToNextMonth(animated: true)
    }
    
    @objc private func scrollToTodayTapped() {
        karendaView.scrollToToday(animated: true)
    }
}

// MARK: - KarendaDelegate

extension HorizontalCalendarViewController: KarendaDelegate {
    
    func didSelectCalendar(startDate: String, endDate: String) {
        if startDate == endDate {
            selectionLabel.text = "Selected: \(startDate)"
        } else {
            selectionLabel.text = "Range: \(startDate) → \(endDate)"
        }
    }
    
    func didClearSelection() {
        selectionLabel.text = "Swipe left/right to change months"
    }
    
    func didScrollToMonth(_ month: Int, year: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        if let date = Calendar.current.date(from: DateComponents(year: year, month: month)) {
            monthLabel.text = formatter.string(from: date)
        }
    }
}
