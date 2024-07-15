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
    
    func execute(isEvent: Int) async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        
        let eventPlans = allPlans.filter { plan in
            if plan.planCategory == .Event {
                return plan.daysRepeat == nil || plan.daysRepeat?.isEmpty == true
            } else {
                return plan.daysRepeat != nil && !plan.daysRepeat!.isEmpty
            }
        }
        
        if eventPlans.isEmpty {
            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
        }
        
        let result = eventPlans.map { plan in
            PlanCardEntity(
                id: plan.id,
                title: plan.title,
                allDay: plan.allDay,
                durationPlan: plan.durationPlan,
                location: plan.location,
                temperature: plan.weatherPlan?.hotDegree ?? 0,
                weatherDescription: plan.weatherPlan?.generalDescription ?? "no data"
            )
        }
        
        return result
    }
}
