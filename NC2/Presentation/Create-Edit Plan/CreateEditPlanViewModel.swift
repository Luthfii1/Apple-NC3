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

class CreateEditPlanViewModel: ObservableObject {
    @Published var state: StateView
    @Published var newPlan: PlanModel
    @Published var comparePlan: PlanModel
    @Published var discardChanges: Bool = false
    private let planUseCase: PlanUseCasesProtocol
    
    init(planUseCase: PlanUseCasesProtocol) {
        self.planUseCase = planUseCase
        self.state = StateView()
        self.newPlan = PlanModel()
        self.comparePlan = PlanModel()
    }
    
    @MainActor
    func insertPlan(homeViewModel: HomeViewModel) async {
        await self.checkDurationStartAndEnd()
        await homeViewModel.insertPlan(plan: newPlan)
    }
    
    @MainActor
    func updatePlan(homeViewModel: HomeViewModel) async {
        do {
            await self.checkDurationStartAndEnd()
            try await homeViewModel.updatePlan(plan: newPlan)
        } catch {
            print("error update plan")
        }
    }
    
    @MainActor
    func cancelPlan(homeViewModel: HomeViewModel) async {
        print("cancelling")
        let tempPlan = newPlan
        let backToPreviousData = comparePlan
        
        self.newPlan = self.comparePlan
        
        async let updateTempPlan: () = homeViewModel.updatePlan(plan: tempPlan)
        async let updateBackToPreviousData: () = homeViewModel.updatePlan(plan: backToPreviousData)
        
        do {
            try await updateTempPlan
        } catch {
            print("Failed to update plan with tempPlan: \(error)")
        }
        
        do {
            try await updateBackToPreviousData
        } catch {
            print("Failed to update plan with backToPreviousData: \(error)")
        }
    }
    
    @MainActor
    func getDetailPlan(planId: UUID) async {
        DispatchQueue.main.async {
            self.state.isLoading = true
        }
        do {
            let detailPlan = try await planUseCase.getDetailPlan(planId: planId)
            self.newPlan = detailPlan
            self.comparePlan = detailPlan.copy()
        } catch {
            print("Failed when get detail plan: \(error)")
        }
        DispatchQueue.main.async {
            self.state.isLoading = false
        }
    }
    
    func checkDurationStartAndEnd() async {
        if newPlan.durationPlan.end < newPlan.durationPlan.start {
            newPlan.durationPlan.end = newPlan.durationPlan.start
        }
    }
        
    private var todayDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    private var currentTime: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute], from: Date())
    }
    
    var dateRange: ClosedRange<Date> {
        if self.newPlan.planCategory == .Event {
            let now = Calendar.current.date(bySettingHour: currentTime.hour!, minute: currentTime.minute!, second: 0, of: todayDate) ?? todayDate
            return now...Date.distantFuture
        } else {
            return Date.distantPast...Date.distantFuture
        }
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
    
    func resetPlanValue() {
        self.newPlan = PlanModel()
        self.comparePlan = PlanModel()
    }
    
    func hasUnsavedChanges() -> Bool {
        return newPlan.title != comparePlan.title ||
        newPlan.location != comparePlan.location ||
        newPlan.durationPlan != comparePlan.durationPlan ||
        newPlan.allDay != comparePlan.allDay ||
        newPlan.planCategory != comparePlan.planCategory ||
        newPlan.reminder != comparePlan.reminder ||
        newPlan.daysRepeat != comparePlan.daysRepeat
    }
}
