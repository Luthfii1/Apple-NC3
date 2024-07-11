//
//  TodoRepository.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import Foundation

class TodoRepository: TodosRepositoryProtocol {
    private let localData: GetTodosLocalSwiftDataProtocol
    private let remoteData: GetTodosRemoteProtocol
    
    init(localData: GetTodosLocalSwiftDataProtocol, remoteData: GetTodosRemoteProtocol) {
        self.localData = localData
        self.remoteData = remoteData
    }
    
    func getTodos() async throws -> [Todo] {
        let localTodos = try await localData.getTodos()
        let remoteTodos = try await remoteData.getTodos()
        
        if localTodos.isEmpty{
            return remoteTodos
        }
        return (localTodos + remoteTodos)
    }
    
    func insertTodo(todo: Todo) async throws {
        try await localData.insertTodo(todo: todo)
    }
    
    func deleteTodo(at offset: IndexSet) async throws {
        try await localData.deleteTodo(at: offset)
    }
}
