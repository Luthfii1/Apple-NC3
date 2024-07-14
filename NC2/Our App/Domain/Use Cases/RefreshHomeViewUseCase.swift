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
        let eventPlans = allPlans.filter {
            isEvent == 0 ?
            $0.isRepeat == false :
            $0.isRepeat == true
        }
        
        if eventPlans.isEmpty {
            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
        }
        
        let result = eventPlans.map { plan in
            PlanCardEntity(
                id: plan.id,
                title: plan.title,
                date: plan.date,
                allDay: plan.allDay,
                durationPlan: plan.durationPlan,
                location: plan.location,
                degree: plan.weatherPlan?.looksLikeHotDegree ?? 0,
                descriptionWeather: plan.weatherPlan?.generalDescription ?? "--"
            )
        }
        
        return result
    }
}
