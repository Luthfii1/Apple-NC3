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
    let container : ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: PlanModel.self)
        } catch {
            fatalError("Failed to initialize SwiftData")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            // MARK: TESTING IMPLEMENTATION
            let dummyGetAllPlansPreviewUseCase = GetAllPlansUseCase(
                planRepository: DummyPlanRepository(dummyPlans: dummyPlans)
            )
            let dummyRefreshHomeViewUseCase = RefreshHomeViewUseCase(planRepository: DummyPlanRepository(dummyPlans: dummyPlans))
            let dummyHomeViewModel = HomeViewModel(
                getAllPlansUseCase: dummyGetAllPlansPreviewUseCase,
                refreshHomeViewUseCase: dummyRefreshHomeViewUseCase
            )
            
            // MARK: IMPLEMENTATION
            let planLocalDataSource = PlanLocalDataSource(modelContext: container.mainContext)
            let planRepository = PlanRepository(planLocalDataSource: planLocalDataSource)
            let getPlanPreviewUseCase = GetAllPlansUseCase(
                planRepository: planRepository
            )
            let refreshPageViewUseCase = RefreshHomeViewUseCase(planRepository: planRepository)
            let homeViewModel = HomeViewModel(
                getAllPlansUseCase: getPlanPreviewUseCase,
                refreshHomeViewUseCase: refreshPageViewUseCase
            )
            
            // MARK: CALL HOMEVIEW AND SET VM
            HomeView(vm: dummyHomeViewModel)
            
//            // MARK: LEARN VIEW
//            let getLocalTodos = GetTodosLocalSwiftDataDataSource(modelContext: container.mainContext)
//            let getRemoteTodos = GetTodosRemoteDataSource()
//            let getTodosRepo = TodoRepository(localData: getLocalTodos, remoteData: getRemoteTodos)
//            let getTodosUseCase = GetTodosUseCase(getTodosRepo: getTodosRepo)
//            let insertTodoUseCase = InsertTodoUseCase(todosRepository: getTodosRepo)
//            let deleteTodoUseCase = DeleteTodoUseCase(todosRepository: getTodosRepo)
//            let homepageViewModel = HomepageViewModel(getTodosUseCase: getTodosUseCase, insertTodoUseCase: insertTodoUseCase, deleteTodoUseCase: deleteTodoUseCase)
//            HomepageView(vm: homepageViewModel)
        }
        .modelContainer(container)
    }
}

