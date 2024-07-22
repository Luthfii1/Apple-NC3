//
//  GetDetailUseCase.swift
//  NC2
//
//  Created by Glenn Leonali on 15/07/24.
//

import Foundation

class GetDetailUseCase: GetDetailUseCaseProtocol {
    private let detailRepository: PlanRepositoryProtocol

    init(detailRepository: PlanRepositoryProtocol) {
        self.detailRepository = detailRepository
    }

    func execute() async throws -> PlanModel {
        let data = try await detailRepository.getAllPlans()
        // TODO: Get Detail Plan based on id

        return data.first.unsafelyUnwrapped
    }
}
