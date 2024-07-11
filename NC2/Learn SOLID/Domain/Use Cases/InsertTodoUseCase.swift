//
//  InsertTodoUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import Foundation

class InsertTodoUseCase{
    private let todosRepository: TodosRepositoryProtocol
    
    init(todosRepository: TodosRepositoryProtocol) {
        self.todosRepository = todosRepository
    }
    
    func execute(todo: Todo) async throws -> [Todo] {
        try await todosRepository.insertTodo(todo: todo)
        return try await todosRepository.getTodos()
    }
}
