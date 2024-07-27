//
//  DependencyInjection.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation
import SwiftData

//Grouping UseCase ke dalam satu fungsi
class DependencyInjection: ObservableObject{
    static let shared = DependencyInjection()
    
    private init() {}
    
    private var modelContext: ModelContext?
    func initializer(modelContext: ModelContext) {
        self.modelContext = modelContext
        
    }
    
    // MARK: IMPLEMENTATION
    lazy var planLocalDataSource = PlanLocalDataSource(modelContext: modelContext!)
    lazy var aqiDataSource = AQIRemoteDataSource()
    
    lazy var planRepository = PlanRepository(planLocalDataSource: planLocalDataSource)
    lazy var aqiRepository = AQIRepository(AQIRemoteDataSource: aqiDataSource)
    
    // MARK: IMPLEMENTATION USE CASES
    lazy var getPlanPreviewUseCase = PlanUseCases(planRepository: planRepository, AQIRepository: aqiRepository)
    lazy var refreshPageViewUseCase = RefreshHomeViewUseCase(planRepository: planRepository)
    
    // MARK: TESTING
    lazy var dummyPlanRepository = DummyPlanRepository(dummyPlans: dummyPlans)
    lazy var dummyGetAllPlansPreviewUseCase = PlanUseCases(planRepository: dummyPlanRepository, AQIRepository: aqiRepository)
    lazy var dummyRefreshHomeViewUseCase = RefreshHomeViewUseCase(planRepository: DummyPlanRepository(dummyPlans: dummyPlans))
    
    // MARK: FUNCTION
    func homeViewModel() -> HomeViewModel {
        HomeViewModel(
            getAllPlansUseCase: getPlanPreviewUseCase
        )
    }
    
    func detailPlanViewModel() -> DetailPlanViewModel {
        DetailPlanViewModel(planUseCase: getPlanPreviewUseCase)
    }
    
    func createPlanViewModel() -> CreateEditPlanViewModel {
        CreateEditPlanViewModel(
            planUseCase: getPlanPreviewUseCase
        )
    }
}
