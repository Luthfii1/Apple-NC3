//
//  HomepageViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import Foundation
import SwiftData

// Homepage View Model is important as a bridge between the presentation with the use cases
// View Model have responsible about the logic to get data from use cases
class HomepageViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var textTodo = ""
    private let getTodosUseCase: GetTodosUseCase
    private let insertTodoUseCase: InsertTodoUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    
    init( getTodosUseCase: GetTodosUseCase, insertTodoUseCase: InsertTodoUseCase, deleteTodoUseCase: DeleteTodoUseCase) {
        self.getTodosUseCase = getTodosUseCase
        self.insertTodoUseCase = insertTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
    }
    
    func getTodos() async {
        Task {
            do {
                let fetchedTodos = try await getTodosUseCase.execute()
                DispatchQueue.main.async {
                    self.todos = fetchedTodos
                }
            } catch {
                print("Failed to load todos: \(error)")
            }
        }
    }
    
    func insertTodo() async {
        Task {
            do {
                let insertTodo = try await insertTodoUseCase.execute(todo: Todo(title: textTodo))
                
                DispatchQueue.main.async {
                    self.textTodo = ""
                    self.todos = insertTodo
                }
            } catch {
                print("Failed to insert todo: \(error)")
            }
        }
    }
    
    func deleteTodo(at offset: IndexSet) async {
        Task {
            do {
                let deleteTodo = try await deleteTodoUseCase.execute(at: offset)
                
                DispatchQueue.main.async {
                    self.todos = deleteTodo
                }
            } catch {
                print("Error when delete todo: \(error)")
            }
        }
    }
}
