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
    let AQIRepository: AQIRepositoryProtocol
    let utils: Utils
    
    init(planRepository: PlanRepositoryProtocol, AQIRepository: AQIRepositoryProtocol) {
        self.planRepository = planRepository
        self.utils = Utils()
        self.AQIRepository = AQIRepository
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
    
    func getDetailPlan(planId: UUID) async throws -> PlanModel {
        guard let plan = self.allPlans.first(where: { $0.id == planId }) else {
            throw NSError(domain: "PlanDetailUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Plan not found"])
        }
        
        return plan
    }
    
    func getWeatherAndSetBackground() async throws {
        for plan in self.allPlans {
            var background = "clearCard"
            
            let coordinatePlace = plan.location.coordinatePlace
            
            do {
                let currentAQIData = try await AQIRepository.getAQI(geoLocation: coordinatePlace)
                plan.aqiIndex = currentAQIData.data.aqi
            } catch {
                print("Failed to get AQI data: \(error)")
                plan.aqiIndex = nil
            }
            
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
        }
        
        try await self.getAllPlans()
    }
    
    func insertPlan(plan: PlanModel) async throws {
        let plans = convertMultipleRoutinePlans(plan: plan)
        
        for detailPlan in plans {
            print(detailPlan.daysRepeat)
            try await planRepository.insertPlan(plan: detailPlan)
        }
        
        try await self.getAllPlans()
    }
    
    func getPlanData() -> PlanModel {
        return dummyPlans.first.unsafelyUnwrapped
    }
    
    func updatePlan(plan: PlanModel) async throws {
        try await planRepository.updatePlan(plan: plan)
        try await self.getAllPlans()
    }
    
    func deletePlan(planId: UUID) async throws {
        guard let plan = allPlans.first(where: { $0.id == planId }) else {
            throw NSError(domain: "PlanDetailUseCase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Plan not found"])
        }
        
        try await planRepository.deletePlan(plan: plan)
    }
    
    func removePreviousDatePlans() async throws {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        
        for plan in allPlans {
            if (plan.planCategory == .Event) {
                if (plan.durationPlan.start < currentDate) {
                    try await self.deletePlan(planId: plan.id)
                }
            } else {
                if (plan.durationPlan.start) < currentDate {
                    let updatePlan = self.updateRoutineDatePlans(plan: plan)
                    try await self.updatePlan(plan: updatePlan)
                }
            }
        }
    }
    
    private func updateRoutineDatePlans(plan: PlanModel) -> PlanModel {
        let startDate = plan.durationPlan.start
        let endDate = plan.durationPlan.end
        let dayRepeat = plan.daysRepeat?.first
        
        plan.durationPlan.start = getNextOccurrence(of: dayRepeat!, from: startDate)
        plan.durationPlan.end = getNextOccurrence(of: dayRepeat!, from: endDate)
        
        return plan
    }
    
    private func convertMultipleRoutinePlans(plan: PlanModel) -> [PlanModel] {
        var plans: [PlanModel] = []
        guard plan.planCategory == .Repeat, let daysRepeat = plan.daysRepeat else { return [plan] }
        
        let now = Date()
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: now)
        
        for dayRepeat in daysRepeat {
            let addPlan = plan.copy(withId: UUID())
            let startDate = addPlan.durationPlan.start
            let endDate = addPlan.durationPlan.end
            
            if let dayOfWeek = DAYS.from(weekday: today), dayRepeat == dayOfWeek {
                if startDate < now {
                    addPlan.durationPlan.start = getNextOccurrence(of: dayRepeat, from: startDate)
                    addPlan.durationPlan.end = getNextOccurrence(of: dayRepeat, from: addPlan.durationPlan.end)
                }
            } else {
                addPlan.durationPlan.start = getNextOccurrence(of: dayRepeat, from: startDate)
                addPlan.durationPlan.end = getNextOccurrence(of: dayRepeat, from: endDate)
            }
            
            addPlan.daysRepeat = [dayRepeat]
            plans.append(addPlan)
        }
        
        return plans
    }
    
    private func getNextOccurrence(of day: DAYS, from date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = day.weekday
        var components = calendar.dateComponents([.hour, .minute, .second], from: date)
        components.weekday = weekday
        
        if let nextDate = calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) {
            return nextDate
        }
        
        return calendar.date(byAdding: .weekOfYear, value: 1, to: date) ?? date
    }
}

