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
            DependencyInjection.shared.initializer(modelContext: container.mainContext)
            
        } catch {
            fatalError("Failed to initialize SwiftData")
        }
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(DependencyInjection.shared.homeViewModel())
        }
        .modelContainer(container)
    }
}
