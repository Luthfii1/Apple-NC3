//
//  TodosLocalSwiftDataDataSource.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import Foundation
import SwiftData

class GetTodosLocalSwiftDataDataSource: GetTodosLocalSwiftDataProtocol {
    private var modelContext: ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func insertTodo(todo: Todo) async throws {
        modelContext.insert(todo)
        try modelContext.save()
    }
    
    func getTodos() async throws -> [Todo] {
        let fetchDescriptor = FetchDescriptor<Todo>()
        let localData = try modelContext.fetch(fetchDescriptor)
        
        return localData
    }
    
    func deleteTodo(at offsets: IndexSet) async throws {
        let fetchDescriptor = FetchDescriptor<Todo>()
        let localData = try modelContext.fetch(fetchDescriptor)
        
        for offset in offsets {
            let todo = localData[offset]
            modelContext.delete(todo)
        }
        
        try modelContext.save()
    }
}
