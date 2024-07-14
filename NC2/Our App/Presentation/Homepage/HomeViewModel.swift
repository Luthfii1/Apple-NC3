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
            DateFormatter.localizedString(from: plan.date, dateStyle: .medium, timeStyle: .none)
        }
    }
    
    @MainActor
    func getPlanEvents() async {
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await getAllPlansUseCase.executeEvent()
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
                let plansFetched = try await refreshHomeViewUseCase.execute(isEvent: self.pickedPlanFilter)
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
    func getPlanRoutine() async {
        self.state.isLoading = true
        Task {
            do {
                let plansFetched = try await getAllPlansUseCase.executeRoutine()
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
    func fetchPlansBasedOnFilter() async {
        if pickedPlanFilter == 0 {
            await getPlanEvents()
        } else {
            await getPlanRoutine()
        }
    }
}
