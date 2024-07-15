//
//  NC2App.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import SwiftUI
import SwiftData

@main
struct NC2App: App {
//    let container : ModelContainer
//    
//    init() {
//        do {
//            container = try ModelContainer(for: Todo.self)
//        } catch {
//            fatalError("Failed to initialize SwiftData")
//        }
//    }
//    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [
            PlanModel.self
        ])
//        WindowGroup {
//            let getLocalTodos = GetTodosLocalSwiftDataDataSource(modelContext: container.mainContext)
//            let getRemoteTodos = GetTodosRemoteDataSource()
//            let getTodosRepo = TodoRepository(localData: getLocalTodos, remoteData: getRemoteTodos)
//            let getTodosUseCase = GetTodosUseCase(getTodosRepo: getTodosRepo)
//            let insertTodoUseCase = InsertTodoUseCase(todosRepository: getTodosRepo)
//            let deleteTodoUseCase = DeleteTodoUseCase(todosRepository: getTodosRepo)
//            let homepageViewModel = HomepageViewModel(getTodosUseCase: getTodosUseCase, insertTodoUseCase: insertTodoUseCase, deleteTodoUseCase: deleteTodoUseCase)
//            
//            HomepageView(vm: homepageViewModel)
       // }
        //.modelContainer(container)
    }
}

