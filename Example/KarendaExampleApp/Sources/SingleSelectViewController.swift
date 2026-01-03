//
//  SingleSelectViewController.swift
//  KarendaExampleApp
//
//  Created on 2026-01-03.
//

import UIKit
import Karenda

/// Example view controller demonstrating single date selection mode with square corners
final class SingleSelectViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.text = "Tap to select a single date"
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Clear Selection", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.isHidden = true
        return button
    }()
    
    private var karendaView: KarendaView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Single Select"
        view.backgroundColor = .systemBackground
        
        setupCalendar()
        setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupCalendar() {
        let today = Date()
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        let sixMonthsLater = Calendar.current.date(byAdding: .month, value: 6, to: today)!
        
        let startDateString = KarendaConfig.formatDate(threeMonthsAgo)
        let endDateString = KarendaConfig.formatDate(sixMonthsLater)
        
        // No holidays for this example
        let config = KarendaConfig(
            startDate: startDateString,
            endDate: endDateString,
            holidays: [],
            isMultiSelectEnabled: false,              // Single selection mode
            direction: .vertical,
            startDayOfWeek: .sunday,
            selectedBackgroundColor: .systemTeal,
            selectionCornerRadius: 0,                 // Square selection (default)
            textTintColor: .darkGray,
            selectedTextColor: .white,
            todayTextColor: .systemOrange,
            holidayTextColor: .systemPink,
            dayFont: .systemFont(ofSize: 17, weight: .medium),
            headerFont: .systemFont(ofSize: 18, weight: .semibold),
            weekdayFont: .systemFont(ofSize: 12, weight: .medium)
        )
        
        karendaView = KarendaView(config: config)
        karendaView.translatesAutoresizingMaskIntoConstraints = false
        karendaView.delegate = self
        
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(selectionLabel)
        view.addSubview(clearButton)
        view.addSubview(karendaView)
        
        NSLayoutConstraint.activate([
            selectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            clearButton.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor, constant: 8),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 32),
            
            karendaView.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 8),
            karendaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            karendaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            karendaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func clearTapped() {
        karendaView.clearSelection()
    }
}

// MARK: - KarendaDelegate

extension SingleSelectViewController: KarendaDelegate {
    
    func didSelectCalendar(startDate: String, endDate: String) {
        selectionLabel.text = "Selected: \(startDate)"
        clearButton.isHidden = false
        
        // Show a confirmation alert
        let alert = UIAlertController(
            title: "Date Selected",
            message: "You selected \(startDate)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func didClearSelection() {
        selectionLabel.text = "Tap to select a single date"
        clearButton.isHidden = true
    }
}
