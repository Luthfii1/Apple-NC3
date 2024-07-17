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
    @Published var state: StateView
    @Published var newPlan: PlanModel
    private let planUseCase: PlanUseCasesProtocol
    private let detailUseCase: PlanDetailUseCasesProtocol
    
    init(planUseCase: PlanUseCasesProtocol, detailUseCase: PlanDetailUseCasesProtocol) {
        self.planUseCase = planUseCase
        self.detailUseCase = detailUseCase
        self.state = StateView()
        self.newPlan = PlanModel()
    }
    
    @MainActor
    func insertPlan(homeViewModel: HomeViewModel) async {
        self.state.isLoading = true
        Task {
            do {
                try await planUseCase.insertPlan(plan: newPlan)
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
    
    func cancelAction() -> Bool {
        return !newPlan.title.isEmpty || !newPlan.location.nameLocation.isEmpty
    }
}
