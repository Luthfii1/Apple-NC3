//
//  PlanUseCasesProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

protocol GetAllPlanUseCasesProtocol {
    func execute() async throws -> [PlanCardEntity]
}

protocol RefreshHomeViewUseCaseProtocol {
    func execute() async throws -> [PlanCardEntity]
}
