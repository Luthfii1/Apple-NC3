//
//  PlanRepository.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

class PlanRepository: PlanRepositoryProtocol {
    private let planLocalDataSource: PlanLocalDataSourceProtocol
    init(planLocalDataSource: PlanLocalDataSourceProtocol) {
        self.planLocalDataSource = planLocalDataSource
    }
    
    func getAllPlans() async throws -> [PlanModel] {
        let localData = try await planLocalDataSource.getAllPlans()
        
        return localData
    }
    
    func insertPlan(plan: PlanModel) async throws {
        print("plan repo: \(plan.id) \(plan.durationPlan.start)")
        try await planLocalDataSource.insertPlan(plan: plan)
    }
    
    func deletePlan(plan: PlanModel) async throws {
        try await planLocalDataSource.deletePlan(plan: plan)
    }
    
    func updatePlan(plan: PlanModel) async throws {
        try await planLocalDataSource.updatePlan(plan: plan)
    }
}
//
//extension PlanRepository: AQIRepositoryProtocol {
//    func getAQI(geoLocation: Coordinate) async throws -> AQIResponse {
//        <#code#>
//    }
//}
