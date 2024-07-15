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
    @Published var eventPicker: String = "One time event"
    @Published var reminderPicker: String = "None"
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    @Published var searchLocation: String = ""
    @Published var selectedLocation: MKMapItem? = nil
    @Published var isSheetPresented: Bool = false
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    @Published var showDiscardChangesDialog: Bool = false
    
    let EventSelection = ["One time event", "Routines"]
    let ReminderSelection = ["None", "At time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before"]
    
    private var todayDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    private var tenDaysFromToday: Date {
        return Calendar.current.date(byAdding: .day, value: 10, to: todayDate) ?? Date()
    }
    
    private var currentTime: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute], from: Date())
    }
    
    var dateRange: ClosedRange<Date> {
        let now = Calendar.current.date(bySettingHour: currentTime.hour!, minute: currentTime.minute!, second: 0, of: todayDate) ?? todayDate
        return now...tenDaysFromToday
    }
    
    var isFormValid: Bool {
        return !title.isEmpty && !location.isEmpty
    }
    
    func locationSelected() {
        if let selectedLocation = selectedLocation {
            location = selectedLocation.name ?? "Unknown"
            latitude = selectedLocation.placemark.coordinate.latitude
            longitude = selectedLocation.placemark.coordinate.longitude
        }
    }
    
    func savePlan(context: ModelContext) {
        let newPlan = PlanModel(title: title, location: location, timeStart: startDate, timeEnd: endDate, allDay: allDay, eventPicker: eventPicker, reminderPicker: reminderPicker, latitude: latitude, longitude: longitude)
        context.insert(newPlan)
        do {
            try context.save()
            print("all done")
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
