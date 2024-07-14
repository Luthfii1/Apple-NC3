//
//  HomeViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var plans: [PlanCardEntity] = []
    @Published var state: StateView = StateView()
    @Published var pickedPlanFilter = 0
    private let getAllPlansPreviewUseCase: GetAllPlanUseCasesProtocol
    private let refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol
    
    init(getAllPlansPreviewUseCase: GetAllPlanUseCasesProtocol, refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol) {
        self.getAllPlansPreviewUseCase = getAllPlansPreviewUseCase
        self.refreshHomeViewUseCase = refreshHomeViewUseCase
    }
    
    @MainActor
    func getPlans() async {
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await getAllPlansPreviewUseCase.execute()
                DispatchQueue.main.async {
                    self.plans = plansFetched
                    self.state.isLoading.toggle()
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
        }
    }
    
    @MainActor
    func refreshPage() async {
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await refreshHomeViewUseCase.execute()
                DispatchQueue.main.async {
                    self.plans = plansFetched
                    self.state.isLoading.toggle()
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
        }
    }
}
