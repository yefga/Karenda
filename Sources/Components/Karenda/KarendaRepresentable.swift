//
//  KarendaRepresentable.swift
//  Karenda
//
//  Created by Yefga on 2026-01-03.
//

import SwiftUI

/// SwiftUI wrapper for KarendaView
///
/// Use this to embed the Karenda calendar in SwiftUI views.
///
/// ## Example Usage
/// ```swift
/// struct ContentView: View {
///     @State private var selectedStartDate: String?
///     @State private var selectedEndDate: String?
///
///     var body: some View {
///         KarendaRepresentable(
///             config: KarendaConfig(
///                 startDate: "01/01/2024",
///                 endDate: "31/12/2024"
///             ),
///             selectedStartDate: $selectedStartDate,
///             selectedEndDate: $selectedEndDate
///         )
///     }
/// }
/// ```
@available(iOS 13.0, *)
public struct KarendaRepresentable: UIViewRepresentable {
    
    // MARK: - Properties
    
    /// The configuration for the calendar
    public let config: KarendaConfig
    
    /// Binding to the selected start date (format: dd/MM/yyyy)
    @Binding public var selectedStartDate: String?
    
    /// Binding to the selected end date (format: dd/MM/yyyy)
    @Binding public var selectedEndDate: String?
    
    /// Called when a date is tapped
    public var onDateTapped: ((String) -> Void)?
    
    /// Called when the visible month changes
    public var onMonthChanged: ((Int, Int) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a new KarendaRepresentable.
    /// - Parameters:
    ///   - config: The calendar configuration
    ///   - selectedStartDate: Binding to the selected start date
    ///   - selectedEndDate: Binding to the selected end date
    ///   - onDateTapped: Optional callback when a date is tapped
    ///   - onMonthChanged: Optional callback when the visible month changes
    public init(
        config: KarendaConfig,
        selectedStartDate: Binding<String?>,
        selectedEndDate: Binding<String?>,
        onDateTapped: ((String) -> Void)? = nil,
        onMonthChanged: ((Int, Int) -> Void)? = nil
    ) {
        self.config = config
        self._selectedStartDate = selectedStartDate
        self._selectedEndDate = selectedEndDate
        self.onDateTapped = onDateTapped
        self.onMonthChanged = onMonthChanged
    }
    
    // MARK: - UIViewRepresentable
    
    public func makeUIView(context: Context) -> KarendaView {
        let karendaView = KarendaView(config: config)
        karendaView.delegate = context.coordinator
        return karendaView
    }
    
    public func updateUIView(_ uiView: KarendaView, context: Context) {
        // Update config if needed (this recreates the view)
        // Only update if the config actually changed to avoid unnecessary reloads
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    public class Coordinator: NSObject, KarendaDelegate {
        var parent: KarendaRepresentable
        
        init(_ parent: KarendaRepresentable) {
            self.parent = parent
        }
        
        public func didSelectCalendar(startDate: String, endDate: String) {
            parent.selectedStartDate = startDate
            parent.selectedEndDate = endDate
        }
        
        public func didClearSelection() {
            parent.selectedStartDate = nil
            parent.selectedEndDate = nil
        }
        
        public func didTapDate(_ date: String) {
            parent.onDateTapped?(date)
        }
        
        public func didScrollToMonth(_ month: Int, year: Int) {
            parent.onMonthChanged?(month, year)
        }
    }
}

// MARK: - Convenience Initializers

@available(iOS 13.0, *)
public extension KarendaRepresentable {
    
    /// Creates a KarendaRepresentable with minimal configuration.
    /// - Parameters:
    ///   - startDate: Start date string (dd/MM/yyyy)
    ///   - endDate: End date string (dd/MM/yyyy)
    ///   - selectedStartDate: Binding to selected start date
    ///   - selectedEndDate: Binding to selected end date
    init(
        startDate: String,
        endDate: String,
        selectedStartDate: Binding<String?>,
        selectedEndDate: Binding<String?>
    ) {
        let config = KarendaConfig(startDate: startDate, endDate: endDate)
        self.init(
            config: config,
            selectedStartDate: selectedStartDate,
            selectedEndDate: selectedEndDate
        )
    }
    
    /// Creates a KarendaRepresentable for single date selection.
    /// - Parameters:
    ///   - startDate: Start date string (dd/MM/yyyy)
    ///   - endDate: End date string (dd/MM/yyyy)
    ///   - selectedDate: Binding to selected date
    init(
        startDate: String,
        endDate: String,
        selectedDate: Binding<String?>
    ) {
        let config = KarendaConfig(
            startDate: startDate,
            endDate: endDate,
            isMultiSelectEnabled: false
        )
        self.init(
            config: config,
            selectedStartDate: selectedDate,
            selectedEndDate: .constant(nil)
        )
    }
}

// MARK: - View Modifiers

@available(iOS 13.0, *)
public extension KarendaRepresentable {
    
    /// Sets the callback for when a date is tapped.
    func onDateTapped(_ action: @escaping (String) -> Void) -> KarendaRepresentable {
        var copy = self
        copy.onDateTapped = action
        return copy
    }
    
    /// Sets the callback for when the visible month changes.
    func onMonthChanged(_ action: @escaping (Int, Int) -> Void) -> KarendaRepresentable {
        var copy = self
        copy.onMonthChanged = action
        return copy
    }
}

// MARK: - Preview Provider

#if DEBUG
@available(iOS 13.0, *)
struct KarendaRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        KarendaPreviewWrapper()
    }
    
    struct KarendaPreviewWrapper: View {
        @State private var startDate: String?
        @State private var endDate: String?
        
        var body: some View {
            VStack {
                Text("Selected: \(startDate ?? "None") - \(endDate ?? "None")")
                    .padding()
                
                KarendaRepresentable(
                    config: KarendaConfig(
                        startDate: "01/01/2024",
                        endDate: "31/12/2024",
                        holidays: [
                            KarendaHoliday(date: "25/12/2024", name: "Christmas")
                        ]
                    ),
                    selectedStartDate: $startDate,
                    selectedEndDate: $endDate
                )
            }
        }
    }
}
#endif
