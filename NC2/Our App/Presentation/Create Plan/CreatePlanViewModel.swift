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
    @Published var comparePlan: PlanModel
    private let planUseCase: PlanUseCasesProtocol
    private let detailUseCase: PlanDetailUseCasesProtocol
    
    init(planUseCase: PlanUseCasesProtocol, detailUseCase: PlanDetailUseCasesProtocol) {
        self.planUseCase = planUseCase
        self.detailUseCase = detailUseCase
        self.state = StateView()
        self.newPlan = PlanModel()
        self.comparePlan = PlanModel()
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
    
    @MainActor
    func updatePlan(homeViewModel: HomeViewModel) async {
        self.state.isLoading = true
        Task {
            do {
                try await planUseCase.updatePlan(plan: newPlan)
                await homeViewModel.fetchPlansBasedOnFilter()
            } catch {
                print("Failed to load plans: \(error)")
            }
            self.state.isLoading.toggle()
        }
    }
    
    @MainActor
    func getDetailPlan(planId: UUID) async {
        self.state.isLoading = true
        Task{
            do {
                let detailPlan = try await detailUseCase.executeGetDetailPlan(planId: planId)
                DispatchQueue.main.async {
                    self.newPlan = detailPlan
                    self.comparePlan = detailPlan
                }
            } catch {
                print("Failed when get detail plan: \(error)")
            }
            self.state.isLoading = false
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
    
    func cancelEditChanges() -> Bool {
        return hasUnsavedChanges()
    }
    
    private func hasUnsavedChanges() -> Bool {
        return newPlan.title != comparePlan.title ||
        newPlan.location != comparePlan.location ||
        newPlan.durationPlan != comparePlan.durationPlan ||
        newPlan.allDay != comparePlan.allDay ||
        newPlan.planCategory != comparePlan.planCategory ||
        newPlan.reminder != comparePlan.reminder ||
        newPlan.daysRepeat != comparePlan.daysRepeat
    }
}
