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
        
    }
    
    func deletePlan(at offsets: IndexSet) async throws {
        
    }
    
    func updatePlan(at offsets: IndexSet) async throws {
        
    }
}
