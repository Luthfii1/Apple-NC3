//
//  HomeViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var plans: [HomeCardUIModel] = []
    @Published var selectedPlan: HomeCardUIModel? = nil
    @Published var idPlanEdit: UUID = UUID()
    @Published var isNewOpen: Bool
    @Published var state: StateView = StateView()
    @Published var pickedPlanFilter: Int = 0 {
        didSet {
            Task {
                await getPlansByFilter()
            }
        }
    }
    @Published var offset: CGFloat = 0
    @Published var isSwiped = false
    @Published var buttonHeight: CGFloat = 100
    
    private let getAllPlansUseCase: PlanUseCasesProtocol
    
    init(getAllPlansUseCase: PlanUseCasesProtocol) {
        self.getAllPlansUseCase = getAllPlansUseCase
        self.isNewOpen = true
    }
    
    var groupedPlans: [String: [HomeCardUIModel]] {
        Dictionary(grouping: plans) { plan in
            DateFormatter.localizedString(from: plan.durationPlan.start, dateStyle: .medium, timeStyle: .none)
        }
    }
    
    @MainActor
    func checkAndGetPlansData() async {
        if isNewOpen {
            await firstOpenApp()
            self.isNewOpen = false
        } else {
            await getPlansByFilter()
        }
    }
    
    @MainActor
    func refreshPage() async {
        await firstOpenApp()
    }
    
    @MainActor
    func firstOpenApp() async {
        self.state.isLoading = true
        do {
            try await getAllPlansUseCase.getAllPlans()
            try await getAllPlansUseCase.removePreviousDatePlans()
            try await getAllPlansUseCase.getAllPlans()
            await getPlansByFilter()
            self.state.isLoading = false
        } catch {
            print("Failed to get all plans: \(error)")
            self.state.isLoading = false
        }
        
        await self.refreshGetWeather()
    }
    
    @MainActor
    func refreshGetWeather() async {
        do {
            try await getAllPlansUseCase.getWeatherAndSetBackground()
            await getPlansByFilter()
        } catch {
            print("Failed to get weather and set background: \(error)")
        }
    }
    
    @MainActor
    func getPlansByFilter() async {
        do {
            let plansFetched = try await getAllPlansUseCase.getAllPlansByFilter(
                category: pickedPlanFilter == 0 ?
                    .Event : .Routine
            )
            self.plans = plansFetched
        } catch {
            print("Failed to load plans: \(error)")
        }
    }
    
    @MainActor
    func insertPlan(plan: PlanModel) async {
        do {
            try await getAllPlansUseCase.insertPlan(plan: plan)
            await getPlansByFilter()
        } catch {
            print("Failed to load plans: \(error)")
        }
        
        await self.refreshGetWeather()
    }
    
    @MainActor
    func updatePlan(plan: PlanModel) async {
        do {
            try await getAllPlansUseCase.updatePlan(plan: plan)
            await getPlansByFilter()
        } catch {
            print("Failed to load plans: \(error)")
        }
        
        await self.refreshGetWeather()
    }
    
    @MainActor
    func deletePlan(planId: UUID) async {
        self.state.isLoading = true
        do {
            try await getAllPlansUseCase.deletePlan(planId: planId)
            try await getAllPlansUseCase.getAllPlans()
            await getPlansByFilter()
        } catch {
            print("Failed to load plans: \(error)")
        }
        self.state.isLoading.toggle()
    }
    
    func resetSwipeOffsetFlag() {
        self.state.resetSwipeOffset = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.state.resetSwipeOffset = false
        }
    }
}
