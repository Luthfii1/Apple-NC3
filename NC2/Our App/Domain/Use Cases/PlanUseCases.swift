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
    let planRepository: PlanRepositoryProtocol
    let utils: Utils
    
    init(planRepository: PlanRepositoryProtocol) {
        self.planRepository = planRepository
        utils = Utils()
    }
    
    func getEvent() async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.planCategory == .Event
        }
        
        if eventPlans.isEmpty {
            return [] as [PlanCardEntity]
        }
        
        let result = try await getWeatherAndSetBackground(eventPlans: eventPlans)
        
        return result
    }
    
    
    func getRoutine() async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.planCategory == .Routine
        }
        
        if eventPlans.isEmpty {
//            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
            return [] as [PlanCardEntity]
        }
        
        let result = try await getWeatherAndSetBackground(eventPlans: eventPlans)
        
        return result
    }
    
    func insertPlan(plan: PlanModel) async throws {
        try await planRepository.insertPlan(plan: plan)
    }
    
    func getPlanData() -> PlanModel {
        dummyPlans.first.unsafelyUnwrapped
    }
    
    private func getWeatherAndSetBackground(eventPlans: [PlanModel]) async throws -> [PlanCardEntity] {
        var result = [PlanCardEntity]()
        
        for plan in eventPlans {
            var background = "clearCard"
            var temperature: Double = 0
            var condition: String = "no data"
            
            if let hourlyForecastPlan = await WeatherManager.shared.hourlyForecast(
                for: CLLocation(
                    latitude: plan.location.coordinatePlace.latitude,
                    longitude: plan.location.coordinatePlace.longitude
                ),
                date: plan.durationPlan.start
            ) {
                if let firstForecast = hourlyForecastPlan.forecast.first {
                    condition = firstForecast.condition.rawValue
                    temperature = firstForecast.temperature.value
                    background = utils.setBackground(condition: firstForecast.condition, date: plan.durationPlan.start, state: .Card)
                }
            } else {
                print("Failed to fetch hourly forecast for plan: \(plan.title)")
            }
            
            let planCardEntity = PlanCardEntity(
                id: plan.id,
                title: plan.title,
                allDay: plan.allDay,
                durationPlan: plan.durationPlan,
                location: plan.location,
                temperature: Int(temperature),
                weatherDescription: condition,
                backgroundCard: background
            )
            
            result.append(planCardEntity)
        }
        
        return result
    }
    
}

