//
//  TodosRepositoryProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import Foundation

protocol TodosRepositoryProtocol {
    func getTodos() async throws -> [Todo]
    func insertTodo(todo: Todo) async throws
    func deleteTodo(at offset: IndexSet) async throws
}
