//
//  LearnTrunkBased.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

class LearnTrunkBased: GetTodosLocalSwiftDataProtocol {
    func getTodos() async throws -> [Todo] {
        return dummyLocalEmpty
    }
    
    func insertTodo(todo: Todo) async throws {
        
    }
    
    func deleteTodo(at offsets: IndexSet) async throws {
        
    }
}
