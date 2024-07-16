//
//  PlanLocalDataSourceProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

protocol PlanLocalDataSourceProtocol {
    func getAllPlans() async throws -> [PlanModel]
    func insertPlan(plan: PlanModel) async throws
    func deletePlan(at offsets: IndexSet) async throws
    func updatePlan(at offsets: IndexSet) async throws
}
