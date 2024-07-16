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
    @Published var pickedPlanFilter: Int = 0 {
        didSet {
            Task {
                await fetchPlansBasedOnFilter()
            }
        }
    }
    private let getAllPlansUseCase: GetAllPlanUseCasesProtocol
    private let refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol
    
    init(getAllPlansUseCase: GetAllPlanUseCasesProtocol, refreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol) {
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
        print("event")
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await getAllPlansUseCase.executeEvent()
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
    func refreshPage() async {
        print("refresh")
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
        print("routine")
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await getAllPlansUseCase.executeRoutine()
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
