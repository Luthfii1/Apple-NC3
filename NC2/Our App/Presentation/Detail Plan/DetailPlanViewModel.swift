//
//  DetailPlanViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

class DetailPlanViewModel: ObservableObject {
    @Published var detailPlan: PlanModel = PlanModel()
    @Published var state: StateView = StateView()
    private let planDetailUseCase: PlanDetailUseCase
    
    init(planDetailUseCase: PlanDetailUseCase) {
        self.planDetailUseCase = planDetailUseCase
    }
    
    @MainActor
    func getDetailPlan(planId: UUID) async {
        self.state.isLoading = true
        do {
            let detailPlan = try await planDetailUseCase.execute(planId: planId)
            DispatchQueue.main.async {
                self.detailPlan = detailPlan
                self.state.isLoading.toggle()
            }
        } catch {
            print("Error when getting detail plan because \(error)")
            DispatchQueue.main.async {
                self.state.isLoading.toggle()
            }
        }
    }
}
