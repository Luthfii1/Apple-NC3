//
//  GetAllPlanEventsUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation
import CoreLocation
import WeatherKit

class PlanUseCases: PlanUseCasesProtocol{
    var allPlans: [PlanModel] = []
    let planRepository: PlanRepositoryProtocol
    let utils: Utils
    
    init(planRepository: PlanRepositoryProtocol) {
        self.planRepository = planRepository
        utils = Utils()
    }
    
    func getAllPlans() async throws {
        self.allPlans = try await planRepository.getAllPlans()
    }
    
    func getAllPlansByFilter(category: PLANCATEGORY) async throws -> [HomeCardUIModel] {
        var result = [HomeCardUIModel]()
        
        let eventPlans = self.allPlans.filter {
            $0.planCategory == category
        }
        if eventPlans.isEmpty {
            return [] as [HomeCardUIModel]
        }
        
        for plan in eventPlans {
            let convertToPlanCardUIModel = HomeCardUIModel(
                id: plan.id,
                title: plan.title,
                allDay: plan.allDay,
                durationPlan: plan.durationPlan,
                location: plan.location,
                temperature: plan.weatherPlan?.first?.temperature.value,
                weatherDescription: plan.weatherPlan?.first?.condition.rawValue,
                backgroundCard: (plan.background ?? "thunderStorm") + "Card"
            )
            
            result.append(convertToPlanCardUIModel)
        }
        
        return result
    }
    
    func getWeatherAndSetBackground() async throws {
        for plan in self.allPlans {
            var background = "clearCard"
            
            if let hourlyForecastPlan = await WeatherManager.shared.hourlyForecast(
                for: CLLocation(
                    latitude: plan.location.coordinatePlace.latitude,
                    longitude: plan.location.coordinatePlace.longitude
                ),
                date: plan.durationPlan.start
            ) {
                if let firstForecast = hourlyForecastPlan.forecast.first {
                    background = utils.setBackground(
                        condition: firstForecast.condition,
                        isDay: firstForecast.isDaylight,
                        date: plan.durationPlan.start
                    )
                }
                
                plan.weatherPlan = hourlyForecastPlan
                plan.background = background
                try await planRepository.insertPlan(plan: plan)
            } else {
                print("Failed to fetch hourly forecast for plan: \(plan.title)")
            }
            
            try await self.getAllPlans()
        }
    }
    
    func insertPlan(plan: PlanModel) async throws {
        try await planRepository.insertPlan(plan: plan)
        try await self.getAllPlans()
    }
    
    func getPlanData() -> PlanModel {
        dummyPlans.first.unsafelyUnwrapped
    }
    
    func updatePlan(plan: PlanModel) async throws {
        try await planRepository.updatePlan(plan: plan)
    }
    
    func deletePlan(planId: UUID) async throws {
        guard let plan = allPlans.first(where: { $0.id == planId }) else {
            throw NSError(domain: "PlanDetailUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Plan not found"])
        }
        
        try await planRepository.deletePlan(plan: plan)
        try await self.getAllPlans()
    }
}

