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
    
    func execute() async throws -> [PlanCardEntity] {
        let data = try await planRepository.getAllPlans()
        
        let result = data.map { plan in
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
