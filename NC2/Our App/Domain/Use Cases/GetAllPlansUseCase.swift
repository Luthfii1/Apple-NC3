//
//  GetAllPlanEventsUseCase.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation
import CoreLocation

// GET PLANNED FEATURES
// TODO: UseCase when Get all Plans
// TODO: UseCase when Pick the Detail Plan
// TODO: UseCase when filtering Plan

// WEATHER FEATURES
// TODO: UseCase to Get Weather for all Plans
// TODO: UseCase to Get Detail Weather


class GetAllPlansUseCase: GetAllPlanUseCasesProtocol{
    let planRepository: PlanRepositoryProtocol
    
    init(planRepository: PlanRepositoryProtocol) {
        self.planRepository = planRepository
    }
    
    func executeEvent() async throws -> [PlanCardEntity] {
        var result = [PlanCardEntity]()
        var background = "clearCard"
        
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.planCategory == .Event
        }
        
        if eventPlans.isEmpty {
//            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
            return [] as [PlanCardEntity]
        }
        
        for plan in eventPlans {
            if let hourlyForecast = await WeatherManager.shared.hourlyForecast(
                for: CLLocation(
                    latitude: plan.location.coordinatePlace.latitude,
                    longitude: plan.location.coordinatePlace.longitude
                ),
                date: plan.durationPlan.start
            ) {
                print("forecast: \(hourlyForecast)")
            } else {
                print("Failed to fetch hourly forecast for plan: \(plan.title)")
            }
            
            // TODO: Logic to change the background
//            Clear
//            Background: "clearCard"
//            Condition: clear weather && day
//
//            Partly cloudy
//            Background: "partlyCloudyCard"
//            Condition: partly cloudy weather && day
//
//            Cloudy
//            Background: "cloudyCard"
//            Condition: overcast or cloudy weather && day
//
//            Rainy
//            Background: "rainCard"
//            Condition: drizzle, rain, heavy rain weather, either day or night
//
//            Thunderstorm
//            Background: "thunderStormCard"
//            Condition: thunderstorm, strong storm, either day or night
//
//            Terik - scorching
//            Background: "scorchingCard"
//            Condition: high temp + high UV index && day
//
//            night
//          Background: "nightCard"
//              Condition: when already night at every condition except rain or thunderstorm
            
            let planCardEntity = PlanCardEntity(
                id: plan.id,
                title: plan.title,
                allDay: plan.allDay,
                durationPlan: plan.durationPlan,
                location: plan.location,
                temperature: plan.weatherPlan?.hotDegree ?? 0,
                weatherDescription: plan.weatherPlan?.generalDescription ?? "no data",
                backgroundCard: background
            )
            
            result.append(planCardEntity)
        }
        
        return result
    }
    
    
    func executeRoutine() async throws -> [PlanCardEntity] {
        let allPlans = try await planRepository.getAllPlans()
        let eventPlans = allPlans.filter {
            $0.planCategory == .Routine
        }
        
        if eventPlans.isEmpty {
//            throw NSError(domain: "GetAllPlanEventsUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No event plans found"])
            return [] as [PlanCardEntity]
        }
        
        let result = eventPlans.map { plan in
            PlanCardEntity(
                id: plan.id,
                title: plan.title,
                allDay: plan.allDay,
                durationPlan: plan.durationPlan,
                location: plan.location,
                temperature: plan.weatherPlan?.hotDegree ?? 0,
                weatherDescription: plan.weatherPlan?.generalDescription ?? "no data",
                backgroundCard: "clearCard"
            )
        }
        
        return result
    }
}
