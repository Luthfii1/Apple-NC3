//
//  DeleteTodoUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import Foundation

class DeleteTodoUseCase {
    private let todosRepository: TodosRepositoryProtocol
    
    init(todosRepository: TodosRepositoryProtocol) {
        self.todosRepository = todosRepository
    }
    
    func execute(at offset: IndexSet) async throws -> [Todo] {
        try await todosRepository.deleteTodo(at: offset)
        return try await todosRepository.getTodos()
    }
}
