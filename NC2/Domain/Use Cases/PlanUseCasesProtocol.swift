//
//  PlanUseCasesProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

protocol PlanUseCasesProtocol {
    func insertPlan(plan: PlanModel) async throws 
    func updatePlan(plan: PlanModel) async throws
    func deletePlan(planId: UUID) async throws
    // ========== UPDATED BELOW
    func getAllPlans() async throws
    func getAllPlansByFilter(category: PLANCATEGORY) async throws -> [PlanCardEntity]
    func getWeatherAndSetBackground() async throws
}

protocol RefreshHomeViewUseCaseProtocol {
    func execute(isEvent: Int) async throws -> [PlanCardEntity]
}

protocol PlanDetailUseCasesProtocol {
    func execute(planId: UUID) async throws -> PlanModel
    func executeGetDetailPlan(planId: UUID) async throws -> PlanModel
}

protocol GetDetailUseCaseProtocol {
    func execute() async throws -> PlanModel
}
