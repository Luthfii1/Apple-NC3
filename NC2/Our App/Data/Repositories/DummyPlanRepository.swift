//
//  DummyPlanRepository.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

class DummyPlanRepository: PlanRepositoryProtocol {
    func updatePlan(plan: PlanModel) async throws {
        
    }
    
    // MARK: TESTING
    private let plans: [PlanModel]
    init(dummyPlans: [PlanModel]) {
        self.plans = dummyPlans
    }
    
    func getAllPlans() async throws -> [PlanModel] {
        return plans
    }
    
    func insertPlan(plan: PlanModel) async throws {
            
    }
    
    func deletePlan(at offsets: IndexSet) async throws {
        
    }
    
    func updatePlan(at offsets: IndexSet) async throws {
        
    }
}
