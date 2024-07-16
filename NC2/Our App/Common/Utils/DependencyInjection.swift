//
//  DependencyInjection.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation
import SwiftData

class DependencyInjection: ObservableObject{
    private var modelContext: ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: IMPLEMENTATION
    lazy var planLocalDataSource = PlanLocalDataSource(modelContext: modelContext)
    lazy var aqiDataSource = AQIRemoteDataSource()
    
    lazy var planRepository = PlanRepository(planLocalDataSource: planLocalDataSource)
    lazy var aqiRepository = AQIRepository(AQIRemoteDataSource: aqiDataSource)
    
    // MARK: IMPLEMENTATION USE CASES
    lazy var getPlanPreviewUseCase = GetAllPlansUseCase(planRepository: planRepository)
    lazy var refreshPageViewUseCase = RefreshHomeViewUseCase(planRepository: planRepository)
    lazy var detailPlanUseCase = PlanDetailUseCase(AQIRepository: aqiRepository, planRepository: planRepository)
    
    // MARK: TESTING
    lazy var dummyPlanRepository = DummyPlanRepository(dummyPlans: dummyPlans)
    lazy var dummyGetAllPlansPreviewUseCase = GetAllPlansUseCase(planRepository: dummyPlanRepository)
    lazy var dummyRefreshHomeViewUseCase = RefreshHomeViewUseCase(planRepository: DummyPlanRepository(dummyPlans: dummyPlans))
    lazy var dummyDetailPlanUseCase = PlanDetailUseCase(AQIRepository: aqiRepository, planRepository: dummyPlanRepository)
    
    // MARK: FUNCTION
    func homeViewModel() -> HomeViewModel {
        HomeViewModel(
            getAllPlansUseCase: getPlanPreviewUseCase,
            refreshHomeViewUseCase: refreshPageViewUseCase
        )
    }
    
    func dummyHomeViewModel() -> HomeViewModel {
        HomeViewModel(
           getAllPlansUseCase: dummyGetAllPlansPreviewUseCase,
           refreshHomeViewUseCase: dummyRefreshHomeViewUseCase
       )
    }
    
    func detailPlanViewModel() -> DetailPlanViewModel {
//        DetailPlanViewModel(planDetailUseCase: detailPlanUseCase)
        DetailPlanViewModel(getDetailUseCase: detailPlanUseCase)
    }
    
    func dummyDetailPlanViewModel() -> DetailPlanViewModel {
//        DetailPlanViewModel(planDetailUseCase: dummyDetailPlanUseCase)
        DetailPlanViewModel(getDetailUseCase: dummyDetailPlanUseCase)
    }
}