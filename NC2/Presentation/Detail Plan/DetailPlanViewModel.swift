//
//  DetailPlanViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation
import WeatherKit
import SwiftUI
import CoreLocation

class DetailPlanViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var dayForecast: Forecast<DayWeather>?
    @Published var hourlyForecast: Forecast<HourWeather>?
    @Published var detailPlan: PlanModel = PlanModel()
    
    private let getDetailUseCase: PlanDetailUseCase
    
    init(getDetailUseCase: PlanDetailUseCase) {
        self.getDetailUseCase = getDetailUseCase
    }
    
    @MainActor
    func getHourlyWeather() async {
        self.isLoading = true
        do {
            let weatherFetched = try await GetDetailWeatherUseCase(location: detailPlan.location.coordinatePlace, date: detailPlan.durationPlan.start).execute()
            DispatchQueue.main.async {
                self.hourlyForecast = weatherFetched
                self.isLoading = false
            }
        } catch {
            print("Failed to load weather: \(error)")
        }
    }
    
    @MainActor
    func getDetailPlan(planId: UUID) async {
        self.isLoading = true
        do {
            let detailPlan = try await getDetailUseCase.execute(planId: planId)
            DispatchQueue.main.async {
                self.detailPlan = detailPlan
                self.isLoading = false
            }
        } catch {
            print("Error when getting detail plan because \(error)")
        }
    }
    
    @MainActor
    func getDayWeather() async {
        do {
            let dayWeather = try await GetDayWeatherUseCase(location: detailPlan.location.coordinatePlace, date: detailPlan.durationPlan.start).execute()
            DispatchQueue.main.async {
                self.dayForecast = dayWeather
            }
        } catch {
            print("Error when getting detail plan because \(error)")
        }
    }
    
    func aqiCondition(aqi: Int) -> String {
        if aqi < 0 {
            return String(localized: "NO DATA")
        }else if aqi <= 50 {
            return String(localized: "GOOD")
        }else if aqi <= 100 {
            return String(localized: "MODERATE")
        }else if aqi <= 150 {
            //            return "UNHEALTHY for Sensitive Groups"
            return String(localized: "UNHEALTHY")
        }else if aqi <= 200 {
            //            return "UNHEALTHY"
            return String(localized: "BAD")
        }else if aqi <= 300 {
            //            return "VERY UNHEALTHY"
            return String(localized: "VERY BAD")
        }else {
            return String(localized: "HAZARDOUS")
        }
    }
    
    func uviCondition(uvi: Int) -> String {
        if uvi < 0 {
            return String(localized: "NO DATA")
        }else if uvi <= 2 {
            return String(localized: "LOW")
        }else if uvi <= 5 {
            return String(localized: "MODERATE")
        }else if uvi <= 7 {
            return String(localized: "HIGH")
        }else if uvi <= 10 {
            return String(localized: "VERY HIGH")
        }else {
            return String(localized: "EXTREME")
        }
    }
    
    func precipitationCondition(prepCon: Double) -> String {
        if prepCon < 0 {
            return String(localized: "NO DATA")
        }else if prepCon <= 25 {
            return String(localized: "VERY LOW")
        }else if prepCon <= 50 {
            return String(localized: "LOW")
        }else if prepCon <= 75 {
            return String(localized: "HIGH")
        }else {
            return String(localized: "VERY HIGH")
        }
    }
    
    func isBadUV(uvi: Int) -> Bool {
        if uvi >= 3 {
            return true
        }
        return false
    }
    
    func isBadAQI(aqi: Int) -> Bool {
        if aqi > 100 {
            return true
        }
        return false
    }
    
    func generateInputText() -> String {
        let weather = String(describing: hourlyForecast?.first?.condition)
        let uvIndex = hourlyForecast?.first?.uvIndex.value ?? 0
        let precipitationChance = hourlyForecast?.first?.precipitationChance ?? 0
        let airQualityIndex = detailPlan.aqiIndex ?? 0
        
        return String(localized:
            """
            Weather: \(weather)
            UV: \(uvIndex)
            Precipitation chance: \(precipitationChance)
            Air quality index: \(airQualityIndex)
            Make the content max 5 words containing recommendation using 'sunscreen' if UV is high, 'mask' if AQI is high, 'umbrella' if raining, or any clothes based on the weather. End with emoji. Show only the call-to-action copywriting!
            """)
        //            """
        //            I want you to generate a call to action copywriting for me. I will give you information like this for each time I want you to generate the copywriting.
        //            Title: \(title)
        //            Weather: \(weather)
        //            UV: \(uvIndex)
        //            Precipitation chance: \(precipitationChance)
        //            Air quality index: \(airQualityIndex)
        //            Make the content max 5 words containing recommendation according to the data (like use sunscreen, mask, umbrella, jacket), end with emoji, show only the copywriting!
        //            """
    }
}
