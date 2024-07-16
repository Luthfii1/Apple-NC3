//
//  GetAllPlanEventsUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation
import CoreLocation
import WeatherKit

// GET PLANNED FEATURES
// TODO: UseCase when Get all Plans
// TODO: UseCase when Pick the Detail Plan
// TODO: UseCase when filtering Plan

// WEATHER FEATURES
// TODO: UseCase to Get Weather for all Plans
// TODO: UseCase to Get Detail Weather


class GetAllPlansUseCase: GetAllPlanUseCasesProtocol{
    let planRepository: PlanRepositoryProtocol
    let utils: Utils
    
    init(planRepository: PlanRepositoryProtocol) {
        self.planRepository = planRepository
        utils = Utils()
    }
    
    func executeEvent() async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.planCategory == .Event
        }
        
        if eventPlans.isEmpty {
            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
        }
        
        let result = try await getWeatherAndSetBackground(eventPlans: eventPlans)
        
        return result
    }
    
    
    func executeRoutine() async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.planCategory == .Routine
        }
        
        if eventPlans.isEmpty {
            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
        }
        
        let result = try await getWeatherAndSetBackground(eventPlans: eventPlans)
        
        return result
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

