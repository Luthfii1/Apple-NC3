//
//  HomeViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var plans: [PlanCardEntity] = []
    @Published var pickedPlanFilter = 0
    private let getAllPlansPreviewUseCase: GetAllPlanUseCasesProtocol
    private let refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol
    
    init(getAllPlansPreviewUseCase: GetAllPlanUseCasesProtocol, refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol) {
        self.getAllPlansPreviewUseCase = getAllPlansPreviewUseCase
        self.refreshHomeViewUseCase = refreshHomeViewUseCase
    }
    
    func getPlans() async {
        Task {
            do {
                let plansFetched = try await getAllPlansPreviewUseCase.execute()
                DispatchQueue.main.async {
                    self.plans = plansFetched
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
        }
    }
    
    func refreshPage() async {
        Task {
            do {
                let plansFetched = try await refreshHomeViewUseCase.execute()
                DispatchQueue.main.async {
                    self.plans = plansFetched
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
        }
    }
}
