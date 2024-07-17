//
//  PlanLocalDataSource.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation
import SwiftData

class PlanLocalDataSource: PlanLocalDataSourceProtocol {
    private var modelContext: ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllPlans() async throws -> [PlanModel] {
        let fetchDescriptor = FetchDescriptor<PlanModel>()
        let localData = try modelContext.fetch(fetchDescriptor)
        
        return localData
    }
    
    func insertPlan(plan: PlanModel) async throws {
        modelContext.insert(plan)
        try modelContext.save()
    }
    
    func deletePlan(at offsets: IndexSet) async throws {
        let fetchDescriptor = FetchDescriptor<PlanModel>()
        let localData = try modelContext.fetch(fetchDescriptor)
        
        for offset in offsets {
            let plan = localData[offset]
            modelContext.delete(plan)
        }
        
        try modelContext.save()
    }
    
    func updatePlan(plan: PlanModel) async throws {
        let fetchDescriptor = FetchDescriptor<PlanModel>()
        var allData = try modelContext.fetch(fetchDescriptor)
        
        guard let index = allData.firstIndex(where: { $0.id == plan.id }) else {
            throw NSError(domain: "YourAppDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Plan not found for update"])
        }
        
        var existingPlan = allData[index]
        
        existingPlan.title = plan.title
        existingPlan.location = plan.location
        existingPlan.weatherPlan = plan.weatherPlan
        existingPlan.durationPlan = plan.durationPlan
        existingPlan.daysRepeat = plan.daysRepeat
        existingPlan.planCategory = plan.planCategory
        existingPlan.reminder = plan.reminder
        existingPlan.allDay = plan.allDay
        existingPlan.suggest = plan.suggest
        
        allData[index] = existingPlan
        
        try modelContext.save()
    }
}
