//
//  NC2App.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct NC2App: App {
    let container : ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: PlanModel.self)
        } catch {
            fatalError("Failed to initialize SwiftData")
        }
        ReminderViewModel.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
//            // MARK: TESTING IMPLEMENTATION
            let dummyGetAllPlansPreviewUseCase = GetAllPlansPreviewUseCase(
                planRepository: DummyPlanRepository(dummyPlans: dummyPlans),
                AQIRepository: AQIRepository(AQIRemoteDataSource: AQIRemoteDataSource())
            )
            let dummyRefreshHomeViewUseCase = RefreshHomeViewUseCase(planRepository: DummyPlanRepository(dummyPlans: dummyPlans))
            let dummyHomeViewModel = HomeViewModel(getAllPlansPreviewUseCase: dummyGetAllPlansPreviewUseCase, refreshHomeViewUseCase: dummyRefreshHomeViewUseCase)
            
            // MARK: IMPLEMENTATION
            let planLocalDataSource = PlanLocalDataSource(modelContext: container.mainContext)
            let planRepository = PlanRepository(planLocalDataSource: planLocalDataSource)
            let getPlanPreviewUseCase = GetAllPlansPreviewUseCase(
                planRepository: planRepository,
                AQIRepository: AQIRepository(AQIRemoteDataSource: AQIRemoteDataSource())
            )
            let refreshPageViewUseCase = RefreshHomeViewUseCase(planRepository: planRepository)
            let homeViewModel = HomeViewModel(getAllPlansPreviewUseCase: getPlanPreviewUseCase, refreshHomeViewUseCase: refreshPageViewUseCase)
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

