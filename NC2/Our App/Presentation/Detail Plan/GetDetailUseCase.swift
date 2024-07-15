//
//  GetDetailUseCase.swift
//  NC2
//
//  Created by Glenn Leonali on 15/07/24.
//

import Foundation

class GetDetailUseCase: GetDetailUseCaseProtocol {
    private let detailRepository: DummyPlanRepository
    
    init(detailRepository: DummyPlanRepository) {
        self.detailRepository = detailRepository
    }
    
    func execute() async throws -> PlanModel {
        let data = try await detailRepository.getPlan()
        
//        let result = data.map { plan in
        let result = data.map { plan in
            PlanModel(
                title: plan.title,
                location: plan.location,
                address: plan.address,
                coordinatePlace: plan.coordinatePlace,
                duration: plan.durationPlan,
                isRepeat: plan.isRepeat,
                date: plan.date,
                allDay: plan.allDay)
            //            PlanCardEntity(
            //                title: plan.title,
            //                date: plan.date,
            //                allDay: plan.allDay,
            //                durationPlan: plan.durationPlan,
            //                location: plan.location,
            //                degree: plan.weatherPlan?.looksLikeHotDegree ?? 0,
            //                descriptionWeather: plan.weatherPlan?.generalDescription ?? "--"
            //            )
        }
        
        return result.first.unsafelyUnwrapped
    }
}

