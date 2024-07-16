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
    @StateObject var dependencyInjection: DependencyInjection
    
    init() {
        do {
            container = try ModelContainer(for: PlanModel.self)
            let dependency = DependencyInjection(modelContext: container.mainContext)
            _dependencyInjection = StateObject(wrappedValue: dependency)
        } catch {
            fatalError("Failed to initialize SwiftData")
        }
        ReminderViewModel.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(dependencyInjection)
                .environmentObject(dependencyInjection.dummyHomeViewModel())
        }
        .modelContainer(container)
    }
}

