//
//  RefreshHomeViewUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

class RefreshHomeViewUseCase: RefreshHomeViewUseCaseProtocol {
    private let planRepository: PlanRepositoryProtocol
    
    init(planRepository: PlanRepositoryProtocol) {
        self.planRepository = planRepository
    }
    
    func execute(isEvent: Int) async throws -> [HomeCardUIModel] {
        let allPlans = try await planRepository.getAllPlans()
        
        let eventPlans = allPlans.filter { plan in
            isEvent == 0 ?
                plan.planCategory == .Event :
                plan.planCategory == .Routine
        }
        
        if eventPlans.isEmpty {
//            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
            return [] as [HomeCardUIModel]
        }
        
        let result = eventPlans.map { plan in
            HomeCardUIModel(
                id: plan.id,
                title: plan.title,
                allDay: plan.allDay,
                durationPlan: plan.durationPlan,
                location: plan.location,
                temperature: plan.weatherPlan?.first?.temperature.value ?? 0,
                weatherDescription: plan.weatherPlan?.first?.condition.rawValue ?? "no data",
                backgroundCard: "clearCard"
            )
        }
        
        return result
    }
}
