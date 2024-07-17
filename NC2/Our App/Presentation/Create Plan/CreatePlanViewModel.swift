//
//  CreatePlanViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation
import MapKit
import SwiftData

class CreatePlanViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var location: String = ""
    @Published var allDay: Bool = false
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    @Published var searchLocation: String = ""
    @Published var selectedLocation: MKMapItem? = nil
    @Published var isSheetPresented: Bool = false
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var address: String = ""
    
    @Published var showDiscardChangesDialog: Bool = false
    
    @Published var daysRepeat: Set<DAYS> = []
    @Published var eventPicker: PLANCATEGORY = .Event
    @Published var reminderPicker: REMINDER = .None
    
    
    let EventSelection = PLANCATEGORY.allCases.map { $0.rawValue }
    let ReminderSelection = REMINDER.allCases.map { $0.rawValue }
    
    private var todayDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    private var currentTime: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute], from: Date())
    }
    
    var dateRange: ClosedRange<Date> {
        let now = Calendar.current.date(bySettingHour: currentTime.hour!, minute: currentTime.minute!, second: 0, of: todayDate) ?? todayDate
        return now...Date.distantFuture
    }

    var isFormValid: Bool {
        return !title.isEmpty && !location.isEmpty
    }
    
    func locationSelected() {
        if let selectedLocation = selectedLocation {
            self.location = selectedLocation.name ?? "Unknown"
            self.latitude = selectedLocation.placemark.coordinate.latitude
            self.longitude = selectedLocation.placemark.coordinate.longitude
            self.address = selectedLocation.placemark.locality ?? "No Locality"
        }
    }
    
    func savePlan(context: ModelContext, homeViewModel: HomeViewModel) {
        let locationSaved = Location(
                    nameLocation: location,
                    detailAddress: address,
                    coordinatePlace: Coordinate(longitude: longitude, latitude: latitude)
                )
        
        let durationPlan = DurationTimePlan(start: startDate, end: endDate)
                
                let newPlan = PlanModel(
                    title: title,
                    location: locationSaved,
                    durationPlan: durationPlan,
                    daysRepeat: Array(daysRepeat),
                    planCategory: eventPicker,
                    reminder: reminderPicker,
                    allDay: allDay
                )
        
        context.insert(newPlan)
        
        do {
            try context.save()
            Task {
                await homeViewModel.fetchPlansBasedOnFilter()
            }
        } catch {
            print("Failed to save plan: \(error)")
        }
    }
    
    func setWindowBackgroundColor(_ color: UIColor) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.backgroundColor = color
        }
    }
    
    func cancelAction() -> Bool {
        return !title.isEmpty || !location.isEmpty
    }
}
