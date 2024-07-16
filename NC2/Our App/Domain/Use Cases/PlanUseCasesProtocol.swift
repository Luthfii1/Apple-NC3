//
//  PlanUseCasesProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

protocol PlanUseCasesProtocol {
    func executeEvent() async throws -> [PlanCardEntity]
    func executeRoutine() async throws -> [PlanCardEntity]
}

protocol RefreshHomeViewUseCaseProtocol {
    func execute(isEvent: Int) async throws -> [PlanCardEntity]
}

protocol PlanDetailUseCasesProtocol {
    func execute(planId: UUID) async throws -> PlanModel
    func executeEdit(planId: UUID) async throws -> PlanModel
}

protocol GetDetailUseCaseProtocol {
    func execute() async throws -> PlanModel
}
