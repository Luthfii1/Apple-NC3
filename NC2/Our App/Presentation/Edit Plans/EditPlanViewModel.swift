//
//  EditPlanViewModel.swift
//  NC2
//
//  Created by Felicia Himawan on 14/07/24.
//
import Foundation
import SwiftData
import MapKit

class EditPlanViewModel: ObservableObject {
    @Published var plan: PlanModel
    @Published var title: String
    @Published var location: String
    
    @Published var allDay: Bool
    //    @Published var eventPicker: String
    //    @Published var reminderPicker: String
    @Published var startDate: Date
    @Published var endDate: Date
    
    @Published var searchLocation: String = ""
    @Published var selectedLocation: MKMapItem? = nil
    @Published var isSheetPresented: Bool = false
    
    @Published var showDiscardChangesDialog: Bool = false
    @Published var showDeleteAlert: Bool = false
    
    @Published var latitude: Double
    @Published var longitude: Double
    @Published var address: String
    
    @Published var daysRepeat: Set<DAYS>
    @Published var eventPicker: PLANCATEGORY
    @Published var reminderPicker: REMINDER
    
//    private var planDetailUseCase: PlanDetailUseCasesProtocol
    

    
    
    //    let EventSelection = ["One time event", "Routines"]
    //    let ReminderSelection = ["None", "At time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before"]
    
    
    init(plan: PlanModel) {
        self.plan = plan
        self.title = plan.title
        self.location = plan.location.nameLocation
        self.address = plan.location.detailAddress
        self.allDay = plan.allDay
        self.eventPicker = plan.planCategory
        self.reminderPicker = plan.reminder
        self.startDate = plan.durationPlan.start
        self.endDate = plan.durationPlan.end
        self.latitude = plan.location.coordinatePlace.latitude
        self.longitude = plan.location.coordinatePlace.longitude
        self.daysRepeat = Set(plan.daysRepeat ?? [])
        
    }
    
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
    
    func saveChanges(context: ModelContext) {
        let updatedLocation = Location(
            nameLocation: location,
            detailAddress: address,
            coordinatePlace: Coordinate(longitude: longitude, latitude: latitude)
        )
        let updatedDuration = DurationTimePlan(start: startDate, end: endDate)
        
        plan.title = title
        plan.location = updatedLocation
        plan.durationPlan = updatedDuration
        plan.allDay = allDay
        plan.planCategory = eventPicker
        plan.reminder = reminderPicker
        plan.daysRepeat = Array(daysRepeat)
        
        do {
            try context.save()
            print("Plan updated successfully")
        } catch {
            print("Failed to update plan: \(error)")
        }
    }
    
    func deletePlan(context: ModelContext) {
        context.delete(plan)
        do {
            try context.save()
        } catch {
            print("Failed to delete plan: \(error)")
        }
    }
    
    func setWindowBackgroundColor(_ color: UIColor) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.backgroundColor = color
        }
    }
    
    func cancelAction() -> Bool {
        return hasUnsavedChanges()
    }
    
    private func hasUnsavedChanges() -> Bool {
        return title != plan.title ||
        location != plan.location.nameLocation ||
        address != plan.location.detailAddress ||
        allDay != plan.allDay ||
        eventPicker != plan.planCategory ||
        reminderPicker != plan.reminder ||
        startDate != plan.durationPlan.start ||
        endDate != plan.durationPlan.end ||
        latitude != plan.location.coordinatePlace.latitude ||
        longitude != plan.location.coordinatePlace.longitude ||
        daysRepeat != Set(plan.daysRepeat ?? [])
    }
}
