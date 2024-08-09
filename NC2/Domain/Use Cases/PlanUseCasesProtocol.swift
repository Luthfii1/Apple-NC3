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
    func getDetailPlan(planId: UUID) async throws -> PlanModel
    func getWeatherAndSetBackground() async throws
    func insertPlan(plan: PlanModel) async throws
    func deletePlan(planId: UUID) async throws
    func updatePlan(plan: PlanModel) async throws
    func removePreviousDatePlans() async throws
}

protocol RefreshHomeViewUseCaseProtocol {
    func execute(isEvent: Int) async throws -> [HomeCardUIModel]
}
