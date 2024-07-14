//
//  GetPlanUseCases.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

// GET PLANNED FEATURES
// TODO: UseCase when Get all Plans
// TODO: UseCase when Pick the Detail Plan
// TODO: UseCase when filtering Plan

// WEATHER FEATURES
// TODO: UseCase to Get Weather for all Plans
// TODO: UseCase to Get Detail Weather

class GetAllPlansPreviewUseCase: GetAllPlanUseCasesProtocol {
    private let planRepository: PlanRepositoryProtocol
    
    init(planRepository: PlanRepositoryProtocol, AQIRepository: AQIRepositoryProtocol) {
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


