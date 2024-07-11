//
//  GetTodosUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import Foundation

class GetTodosUseCase {
    private let getTodosRepo: TodosRepositoryProtocol
    
    init(getTodosRepo: TodosRepositoryProtocol) {
        self.getTodosRepo = getTodosRepo
    }
    
    func execute() async throws -> [Todo] {
        return try await getTodosRepo.getTodos()
    }
}
