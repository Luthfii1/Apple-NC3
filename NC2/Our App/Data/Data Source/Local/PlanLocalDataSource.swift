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
    
    func getPlan() async throws -> [PlanModel] {
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
    
    func updatePlan(at offsets: IndexSet) async throws {
        
    }
}
