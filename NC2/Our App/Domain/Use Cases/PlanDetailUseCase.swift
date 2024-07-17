//
//  PlanDetailUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

class PlanDetailUseCase: PlanDetailUseCasesProtocol {
    private let AQIRepository: AQIRepositoryProtocol
    private let planRepository: PlanRepositoryProtocol
    
    init(AQIRepository: AQIRepositoryProtocol, planRepository: PlanRepositoryProtocol) {
        self.AQIRepository = AQIRepository
        self.planRepository = planRepository
    }
    
    func execute(planId: UUID) async throws -> PlanModel {
        let dataPlans = try await planRepository.getAllPlans()
        guard let plan = dataPlans.first(where: { $0.id == planId }) else {
            throw NSError(domain: "PlanDetailUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Plan not found"])
        }
        
        let coordinatePlace = plan.location.coordinatePlace
        let currentAQIData = try await AQIRepository.getAQI(geoLocation: coordinatePlace)
        plan.weatherPlan?.AQIndex = currentAQIData.data.aqi
        
        return plan
    }
    
    func executeGetDetailPlan(planId: UUID) async throws -> PlanModel {
        let dataPlans = try await planRepository.getAllPlans()
        guard let plan = dataPlans.first(where: { $0.id == planId }) else {
            throw NSError(domain: "PlanDetailUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Plan not found"])
        }
        
        return plan
    }
}
