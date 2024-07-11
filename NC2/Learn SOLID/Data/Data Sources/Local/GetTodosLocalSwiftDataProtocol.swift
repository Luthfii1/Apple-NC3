//
//  GetTodosLocalSwiftDataProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import Foundation
import SwiftData

// Protocol to create abstraction of function
protocol GetTodosLocalSwiftDataProtocol {
    func getTodos() async throws -> [Todo]
    func insertTodo(todo: Todo) async throws
    func deleteTodo(at offsets: IndexSet) async throws
}
