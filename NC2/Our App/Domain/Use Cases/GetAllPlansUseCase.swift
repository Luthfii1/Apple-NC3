//
//  GetAllPlanEventsUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

// GET PLANNED FEATURES
// TODO: UseCase when Get all Plans
// TODO: UseCase when Pick the Detail Plan
// TODO: UseCase when filtering Plan

// WEATHER FEATURES
// TODO: UseCase to Get Weather for all Plans
// TODO: UseCase to Get Detail Weather


class GetAllPlansUseCase: GetAllPlanUseCasesProtocol{
    let planRepository: PlanRepositoryProtocol
    
    init(planRepository: PlanRepositoryProtocol) {
        self.planRepository = planRepository
    }
    
    func executeEvent() async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.reminder == .None
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
    
    func executeRoutine() async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.reminder != .None
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
