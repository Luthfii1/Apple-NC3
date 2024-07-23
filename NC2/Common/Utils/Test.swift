//
//  DependencyInjection.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation
import SwiftData

//Grouping UseCase ke dalam satu fungsi
class Test {
    
    static let shared = Test()
    
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
    lazy var getPlanPreviewUseCase = PlanUseCases(planRepository: planRepository)
    lazy var refreshPageViewUseCase = RefreshHomeViewUseCase(planRepository: planRepository)
    lazy var detailPlanUseCase = PlanDetailUseCase(AQIRepository: aqiRepository, planRepository: planRepository)
    
    // MARK: TESTING
    lazy var dummyPlanRepository = DummyPlanRepository(dummyPlans: dummyPlans)
    lazy var dummyGetAllPlansPreviewUseCase = PlanUseCases(planRepository: dummyPlanRepository)
    lazy var dummyRefreshHomeViewUseCase = RefreshHomeViewUseCase(planRepository: DummyPlanRepository(dummyPlans: dummyPlans))
    lazy var dummyDetailPlanUseCase = PlanDetailUseCase(AQIRepository: aqiRepository, planRepository: dummyPlanRepository)
    
    
    
    // MARK: FUNCTION
    func homeViewModel() -> HomeViewModel {
        HomeViewModel(
            getAllPlansUseCase: getPlanPreviewUseCase
        )
    }
    
//    func notificationManager() -> NotificationManager {
//        NotificationManager(getDetailUseCase: getPlanPreviewUseCase)
//    }
    
    func dummyHomeViewModel() -> HomeViewModel {
        HomeViewModel(
           getAllPlansUseCase: dummyGetAllPlansPreviewUseCase
       )
    }
    
    func detailPlanViewModel() -> DetailPlanViewModel {
        DetailPlanViewModel(getDetailUseCase: detailPlanUseCase)
    }
    
    func dummyDetailPlanViewModel() -> DetailPlanViewModel {
        DetailPlanViewModel(getDetailUseCase: dummyDetailPlanUseCase)
    }
}
