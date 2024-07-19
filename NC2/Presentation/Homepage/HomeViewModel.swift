//
//  HomeViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var plans: [PlanCardEntity] = []
    @Published var idPlanEdit: UUID = UUID()
    @Published var state: StateView = StateView()
    @Published var pickedPlanFilter: Int = 0 {
        didSet {
            Task {
                await fetchPlansBasedOnFilter()
            }
        }
    }
    private let getAllPlansUseCase: PlanUseCasesProtocol
    private let refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol
    
    init(getAllPlansUseCase: PlanUseCasesProtocol, refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol) {
        self.getAllPlansUseCase = getAllPlansUseCase
        self.refreshHomeViewUseCase = refreshHomeViewUseCase
    }
    
    var groupedPlans: [String: [PlanCardEntity]] {
        Dictionary(grouping: plans) { plan in
            DateFormatter.localizedString(from: plan.durationPlan.start, dateStyle: .medium, timeStyle: .none)
        }
    }
    
    @MainActor
    func getPlanEvents() async {
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await getAllPlansUseCase.getEvent()
                DispatchQueue.main.async {
                    self.plans = plansFetched
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
            
            self.state.isLoading.toggle()
        }
    }
    
    @MainActor
    func deletePlan(planId: UUID) async {
        self.state.isLoading = true
        Task {
            do {
                try await getAllPlansUseCase.deletePlan(planId: planId)
                Task {
                    await fetchPlansBasedOnFilter()
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
            self.state.isLoading.toggle()
        }
    }
    
    @MainActor
    func refreshPage() async {
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await refreshHomeViewUseCase.execute(isEvent: self.pickedPlanFilter)
                DispatchQueue.main.async {
                    self.plans = plansFetched
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
            
            self.state.isLoading.toggle()
        }
    }
    
    @MainActor
    func getPlanRoutine() async {
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await getAllPlansUseCase.getRoutine()
                DispatchQueue.main.async {
                    self.plans = plansFetched
                }
            } catch {
                print("Failed to load plans: \(error)")
            }
            
            self.state.isLoading.toggle()
        }
    }
    
    @MainActor
    func fetchPlansBasedOnFilter() async {
        if pickedPlanFilter == 0 {
            await getPlanEvents()
        } else {
            await getPlanRoutine()
        }
    }
}