//
//  PlanUseCasesProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

protocol PlanUseCasesProtocol {
    func getAllPlans() async throws
    func getAllPlansByFilter(category: PLANCATEGORY) async throws -> [HomeCardUIModel]
    func getWeatherAndSetBackground() async throws
    func insertPlan(plan: PlanModel) async throws
    func deletePlan(planId: UUID) async throws
    func updatePlan(plan: PlanModel) async throws
    func removePreviousDatePlans() async throws
}

protocol RefreshHomeViewUseCaseProtocol {
    func execute(isEvent: Int) async throws -> [HomeCardUIModel]
}

protocol PlanDetailUseCasesProtocol {
    func execute(planId: UUID) async throws -> PlanModel
    func executeGetDetailPlan(planId: UUID) async throws -> PlanModel
}

protocol GetDetailUseCaseProtocol {
    func execute() async throws -> PlanModel
}
