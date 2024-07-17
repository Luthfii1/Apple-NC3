//
//  CreatePlanViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation
import MapKit
import SwiftData
import WidgetKit

class CreatePlanViewModel: ObservableObject {
    @Published var state: StateView
    @Published var newPlan: PlanModel
    private let planUseCase: PlanUseCasesProtocol
    
    init(planUseCase: PlanUseCasesProtocol) {
        self.planUseCase = planUseCase
        self.state = StateView()
        self.newPlan = PlanModel()
    }
    
    private var widgetPlan = WidgetPlanModel(
        id: UUID(),
        title: "Morning Routine",
        temprature: 22,
        durationPlan: Date(),
        allDay: false
    )
    
    @MainActor
    func insertPlan(homeViewModel: HomeViewModel) async {
        self.state.isLoading = true
        Task {
            do {
                try await planUseCase.insertPlan(plan: newPlan)
                DispatchQueue.main.async {
                    self.widgetPlan.id = self.newPlan.id
                    self.widgetPlan.title = self.newPlan.title
                    self.widgetPlan.temprature = self.newPlan.weatherPlan?.hotDegree ?? 0
                    self.widgetPlan.durationPlan = self.newPlan.durationPlan.start
                    self.widgetPlan.allDay = self.newPlan.allDay
                    
                    self.saveWidgetPlanModel(self.widgetPlan)
                    WidgetCenter.shared.reloadAllTimelines()
                }
                await homeViewModel.fetchPlansBasedOnFilter()
            } catch {
                print("Failed to load plans: \(error)")
            }
            self.state.isLoading.toggle()
        }
    }
    
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
        return !newPlan.title.isEmpty && !newPlan.location.nameLocation.isEmpty
    }
    
    func setWindowBackgroundColor(_ color: UIColor) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.backgroundColor = color
        }
    }
    
    private func saveWidgetPlanModel(_ model: WidgetPlanModel) {
        if let sharedDefaults = UserDefaults(suiteName: AppGroupManager.suiteName) {
            let encoder = JSONEncoder()
            if let encodedModel = try? encoder.encode(model) {
                sharedDefaults.set(encodedModel, forKey: "widgetPlanModel")
            }
        }
    }
    
    func cancelAction() -> Bool {
        return !newPlan.title.isEmpty || !newPlan.location.nameLocation.isEmpty
    }
}
