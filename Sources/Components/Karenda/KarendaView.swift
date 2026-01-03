//
//  KarendaView.swift
//  Karenda
//
//  Created on 2026-01-03.
//

import UIKit

/// A customizable date picker view using UICollectionView.
public final class KarendaView: UIView {
    
    // MARK: - Public Properties
    
    public weak var delegate: KarendaDelegate?
    public private(set) var config: KarendaConfig
    public private(set) var selectedStartDate: Date?
    public private(set) var selectedEndDate: Date?
    
    // MARK: - Private Properties
    
    private var months: [KarendaMonthData] = []
    private let calendarHelper = Calendar.current
    private var currentMonthIndex: Int = 0
    
    // Vertical mode
    private var verticalCollectionView: UICollectionView?
    
    // Horizontal mode - paging scroll view with collection views
    private var horizontalScrollView: UIScrollView?
    private var monthCollectionViews: [UICollectionView] = []
    
    private var selectionState: SelectionState = .none
    
    private enum SelectionState {
        case none
        case startSelected
        case rangeSelected
    }
    
    // MARK: - Initialization
    
    public init(config: KarendaConfig) {
        self.config = config
        super.init(frame: .zero)
        generateCalendarData()
        setupView()
    }
    
    public convenience init() {
        let startDate = KarendaConfig.formatDate(Date())
        let endDate = KarendaConfig.formatDate(Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date())
        let config = KarendaConfig(startDate: startDate, endDate: endDate)
        self.init(config: config)
    }
    
    required init?(coder: NSCoder) {
        let startDate = KarendaConfig.formatDate(Date())
        let endDate = KarendaConfig.formatDate(Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date())
        self.config = KarendaConfig(startDate: startDate, endDate: endDate)
        super.init(coder: coder)
        generateCalendarData()
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if config.direction == .horizontal {
            layoutHorizontalScrollView()
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = config.backgroundColor
        
        switch config.direction {
        case .vertical:
            setupVerticalMode()
        case .horizontal:
            setupHorizontalMode()
        }
    }
    
    private func generateCalendarData() {
        let generator = KarendaDataGenerator(config: config)
        months = generator.generateMonths()
    }
    
    // MARK: - Vertical Mode
    
    private func setupVerticalMode() {
        let layout = createVerticalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = config.backgroundColor
        collectionView.showsVerticalScrollIndicator = true
        
        registerCellsAndSupplementaryViews(for: collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.verticalCollectionView = collectionView
    }
    
    private func registerCellsAndSupplementaryViews(for collectionView: UICollectionView) {
        collectionView.register(KarendaDayCell.self, forCellWithReuseIdentifier: KarendaDayCell.reuseIdentifier)
        collectionView.register(
            KarendaMonthHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: KarendaMonthHeaderView.reuseIdentifier
        )
        collectionView.register(
            KarendaMonthFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: KarendaMonthFooterView.reuseIdentifier
        )
    }
    
    private func createVerticalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            self?.createMonthSection(sectionIndex: sectionIndex, environment: environment)
        }
    }
    
    private func createMonthSection(sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 7.0),
            heightDimension: .fractionalWidth(1.0 / 7.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0 / 7.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(70)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        var supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = [header]
        
        // Footer - only if this month has holidays
        if sectionIndex < months.count {
            let month = months[sectionIndex]
            let holidaysInMonth = config.holidays(forMonth: month.month, year: month.year)
            
            if !holidaysInMonth.isEmpty {
                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(50)
                )
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )
                supplementaryItems.append(footer)
            }
        }
        
        section.boundarySupplementaryItems = supplementaryItems
        
        return section
    }
    
    // MARK: - Horizontal Mode (Paging ScrollView + CollectionViews)
    
    private func setupHorizontalMode() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.backgroundColor = config.backgroundColor
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.horizontalScrollView = scrollView
        
        createMonthCollectionViews()
    }
    
    private func createMonthCollectionViews() {
        guard let scrollView = horizontalScrollView else { return }
        
        monthCollectionViews.forEach { $0.removeFromSuperview() }
        monthCollectionViews.removeAll()
        
        for index in 0..<months.count {
            let layout = createSingleMonthLayout(monthIndex: index)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = config.backgroundColor
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            collectionView.tag = index
            
            registerCellsAndSupplementaryViews(for: collectionView)
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            scrollView.addSubview(collectionView)
            monthCollectionViews.append(collectionView)
        }
    }
    
    private func createSingleMonthLayout(monthIndex: Int) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, environment in
            self?.createMonthSection(sectionIndex: monthIndex, environment: environment)
        }
    }
    
    private func layoutHorizontalScrollView() {
        guard let scrollView = horizontalScrollView, bounds.width > 0 else { return }
        
        let pageWidth = bounds.width
        let pageHeight = bounds.height
        
        scrollView.contentSize = CGSize(
            width: pageWidth * CGFloat(months.count),
            height: pageHeight
        )
        
        for (index, collectionView) in monthCollectionViews.enumerated() {
            collectionView.frame = CGRect(
                x: CGFloat(index) * pageWidth,
                y: 0,
                width: pageWidth,
                height: pageHeight
            )
        }
    }
    
    // MARK: - Public Methods
    
    public func updateConfig(_ config: KarendaConfig) {
        self.config = config
        backgroundColor = config.backgroundColor
        
        verticalCollectionView?.removeFromSuperview()
        verticalCollectionView = nil
        horizontalScrollView?.removeFromSuperview()
        horizontalScrollView = nil
        monthCollectionViews.removeAll()
        
        generateCalendarData()
        clearSelection()
        setupView()
    }
    
    public func clearSelection() {
        selectedStartDate = nil
        selectedEndDate = nil
        selectionState = .none
        reloadAllData()
        delegate?.didClearSelection()
    }
    
    public func scrollToDate(_ date: Date, animated: Bool = true) {
        let components = calendarHelper.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else { return }
        
        for (index, monthData) in months.enumerated() {
            if monthData.year == year && monthData.month == month {
                currentMonthIndex = index
                
                switch config.direction {
                case .vertical:
                    let indexPath = IndexPath(item: 0, section: index)
                    verticalCollectionView?.scrollToItem(at: indexPath, at: .top, animated: animated)
                    
                case .horizontal:
                    guard let scrollView = horizontalScrollView else { return }
                    let offsetX = CGFloat(index) * scrollView.bounds.width
                    scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
                }
                
                delegate?.didScrollToMonth(monthData.month, year: monthData.year)
                break
            }
        }
    }
    
    public func scrollToToday(animated: Bool = true) {
        scrollToDate(Date(), animated: animated)
    }
    
    public func selectDates(startDate: String, endDate: String? = nil) {
        guard let start = KarendaConfig.parseDate(startDate) else { return }
        
        selectedStartDate = calendarHelper.startOfDay(for: start)
        
        if let endDateString = endDate, let end = KarendaConfig.parseDate(endDateString) {
            selectedEndDate = calendarHelper.startOfDay(for: end)
            selectionState = .rangeSelected
        } else {
            selectedEndDate = selectedStartDate
            selectionState = config.isMultiSelectEnabled ? .startSelected : .rangeSelected
        }
        
        reloadAllData()
        
        if selectionState == .rangeSelected {
            delegate?.didSelectCalendar(
                startDate: KarendaConfig.formatDate(selectedStartDate!),
                endDate: KarendaConfig.formatDate(selectedEndDate ?? selectedStartDate!)
            )
        }
    }
    
    public func currentVisibleMonth() -> (month: Int, year: Int)? {
        guard currentMonthIndex < months.count else { return nil }
        let month = months[currentMonthIndex]
        return (month.month, month.year)
    }
    
    public func goToNextMonth(animated: Bool = true) {
        guard currentMonthIndex < months.count - 1 else { return }
        currentMonthIndex += 1
        scrollToMonthIndex(currentMonthIndex, animated: animated)
    }
    
    public func goToPreviousMonth(animated: Bool = true) {
        guard currentMonthIndex > 0 else { return }
        currentMonthIndex -= 1
        scrollToMonthIndex(currentMonthIndex, animated: animated)
    }
    
    private func scrollToMonthIndex(_ index: Int, animated: Bool) {
        switch config.direction {
        case .vertical:
            let indexPath = IndexPath(item: 0, section: index)
            verticalCollectionView?.scrollToItem(at: indexPath, at: .top, animated: animated)
            
        case .horizontal:
            guard let scrollView = horizontalScrollView else { return }
            let offsetX = CGFloat(index) * scrollView.bounds.width
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
        }
        
        let month = months[index]
        delegate?.didScrollToMonth(month.month, year: month.year)
    }
    
    private func reloadAllData() {
        switch config.direction {
        case .vertical:
            verticalCollectionView?.reloadData()
        case .horizontal:
            monthCollectionViews.forEach { $0.reloadData() }
        }
    }
    
    // MARK: - Selection Logic
    
    private func handleDateSelection(_ date: Date) {
        let normalizedDate = calendarHelper.startOfDay(for: date)
        let dateString = KarendaConfig.formatDate(normalizedDate)
        
        delegate?.didTapDate(dateString)
        
        if config.isMultiSelectEnabled {
            handleMultiSelect(normalizedDate)
        } else {
            handleSingleSelect(normalizedDate)
        }
        
        reloadAllData()
    }
    
    private func handleSingleSelect(_ date: Date) {
        if selectedStartDate == date {
            clearSelection()
            return
        }
        
        selectedStartDate = date
        selectedEndDate = date
        selectionState = .rangeSelected
        
        delegate?.didSelectCalendar(
            startDate: KarendaConfig.formatDate(date),
            endDate: KarendaConfig.formatDate(date)
        )
    }
    
    private func handleMultiSelect(_ date: Date) {
        switch selectionState {
        case .none:
            selectedStartDate = date
            selectedEndDate = nil
            selectionState = .startSelected
            
        case .startSelected:
            guard let startDate = selectedStartDate else {
                selectedStartDate = date
                return
            }
            
            if date == startDate {
                clearSelection()
                return
            }
            
            if date < startDate {
                selectedStartDate = date
                selectedEndDate = startDate
            } else {
                selectedEndDate = date
            }
            selectionState = .rangeSelected
            
            delegate?.didSelectCalendar(
                startDate: KarendaConfig.formatDate(selectedStartDate!),
                endDate: KarendaConfig.formatDate(selectedEndDate!)
            )
            
        case .rangeSelected:
            selectedStartDate = date
            selectedEndDate = nil
            selectionState = .startSelected
        }
    }
    
    private func getCellState(for date: Date) -> KarendaDayCellState {
        guard let startDate = selectedStartDate else {
            return .normal
        }
        
        let normalizedDate = calendarHelper.startOfDay(for: date)
        
        guard let endDate = selectedEndDate else {
            return normalizedDate == startDate ? .selected : .normal
        }
        
        if normalizedDate == startDate && normalizedDate == endDate {
            return .selected
        } else if normalizedDate == startDate {
            return .rangeStart
        } else if normalizedDate == endDate {
            return .rangeEnd
        } else if normalizedDate > startDate && normalizedDate < endDate {
            return .inRange
        }
        
        return .normal
    }
}

// MARK: - UICollectionViewDataSource

extension KarendaView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch config.direction {
        case .vertical:
            return months.count
        case .horizontal:
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch config.direction {
        case .vertical:
            return months[section].days.count
        case .horizontal:
            let monthIndex = collectionView.tag
            guard monthIndex < months.count else { return 0 }
            return months[monthIndex].days.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: KarendaDayCell.reuseIdentifier,
            for: indexPath
        ) as? KarendaDayCell else {
            return UICollectionViewCell()
        }
        
        let monthIdx: Int
        switch config.direction {
        case .vertical:
            monthIdx = indexPath.section
        case .horizontal:
            monthIdx = collectionView.tag
        }
        
        guard monthIdx < months.count else { return cell }
        
        let day = months[monthIdx].days[indexPath.item]
        let state: KarendaDayCellState = day.date.map { getCellState(for: $0) } ?? .normal
        
        cell.configure(with: day, config: config, state: state)
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let monthIdx: Int
        switch config.direction {
        case .vertical:
            monthIdx = indexPath.section
        case .horizontal:
            monthIdx = collectionView.tag
        }
        
        guard monthIdx < months.count else {
            return UICollectionReusableView()
        }
        
        let month = months[monthIdx]
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: KarendaMonthHeaderView.reuseIdentifier,
                for: indexPath
            ) as? KarendaMonthHeaderView else {
                return UICollectionReusableView()
            }
            header.configure(with: month.title, config: config)
            return header
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: KarendaMonthFooterView.reuseIdentifier,
                for: indexPath
            ) as? KarendaMonthFooterView else {
                return UICollectionReusableView()
            }
            
            let holidaysInMonth = config.holidays(forMonth: month.month, year: month.year)
            footer.configure(with: holidaysInMonth, config: config)
            return footer
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension KarendaView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let monthIdx: Int
        switch config.direction {
        case .vertical:
            monthIdx = indexPath.section
        case .horizontal:
            monthIdx = collectionView.tag
        }
        
        guard monthIdx < months.count else { return }
        
        let day = months[monthIdx].days[indexPath.item]
        
        guard let date = day.date, day.isEnabled else { return }
        
        handleDateSelection(date)
    }
}

// MARK: - UIScrollViewDelegate

extension KarendaView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentMonthFromScroll(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCurrentMonthFromScroll(scrollView)
        }
    }
    
    private func updateCurrentMonthFromScroll(_ scrollView: UIScrollView) {
        switch config.direction {
        case .vertical:
            if let visibleIndexPath = verticalCollectionView?.indexPathsForVisibleItems.sorted().first {
                currentMonthIndex = visibleIndexPath.section
            }
        case .horizontal:
            let pageWidth = scrollView.bounds.width
            if pageWidth > 0 {
                let page = Int(round(scrollView.contentOffset.x / pageWidth))
                currentMonthIndex = min(max(page, 0), months.count - 1)
            }
        }
        
        guard currentMonthIndex < months.count else { return }
        let month = months[currentMonthIndex]
        delegate?.didScrollToMonth(month.month, year: month.year)
    }
}
