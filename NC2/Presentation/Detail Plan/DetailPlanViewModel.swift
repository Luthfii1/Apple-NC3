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
    
    private let planUseCase: PlanUseCasesProtocol
    
    init(planUseCase: PlanUseCasesProtocol) {
        self.planUseCase = planUseCase
    }
    
    @MainActor
    func getHourlyWeather() async {
        do {
            let weatherFetched = try await GetDetailWeatherUseCase(location: detailPlan.location.coordinatePlace, date: detailPlan.durationPlan.start).execute()
            self.hourlyForecast = weatherFetched
        } catch {
            print("Failed to load weather: \(error)")
        }
    }
    
    @MainActor
    func getDetailPlan(planId: UUID) async {
        self.isLoading = true
        do {
            let detailPlan = try await planUseCase.getDetailPlan(planId: planId)
            self.detailPlan = detailPlan
            self.isLoading = false
            
            await self.getHourlyWeather()
            await self.getDayWeather()
        } catch {
            print("Error when getting detail plan because \(error)")
        }
        self.isLoading = false
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
    
    func getBackgroundPage() -> String {
        return (self.detailPlan.background != nil) ? (self.detailPlan.background! + "Detail") : "clearDetail"
    }
    
    func getCTABackground() -> String {
        return Utils().setCTA(condition: self.detailPlan.weatherPlan?.first?.condition ?? .clear, isDay: self.detailPlan.weatherPlan?.first?.isDaylight ?? true, isBadUV: self.isBadUV(uvi: self.detailPlan.weatherPlan?.first?.uvIndex.value ?? 0), isBadAQI: self.isBadAQI(aqi: self.detailPlan.aqiIndex ?? 0))
    }
    
    func detailTime(isDate: Bool) -> String {
        if isDate {
            return (String(describing: self.detailPlan.durationPlan.start.formatted(date: .complete, time: .omitted)))
        }
        return ("\(String(describing: self.detailPlan.durationPlan.start.formatted(date: .omitted, time: .shortened))) - \(String(describing: self.detailPlan.durationPlan.end.formatted(date: .omitted, time: .shortened)))")
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
    
    func aqiDescription(aqi: Int) -> String {
        if aqi < 0 {
            return String(localized: "NO DATA")
        }else if aqi <= 50 {
            return String(localized: "The air quality is good with little or no risk. Feel free to enjoy your outdoor activities without concern.")
        }else if aqi <= 100 {
            return String(localized: "Air quality is acceptable but may pose a moderate health concern for sensitive individuals. If you're sensitive to air pollution, consider reducing prolonged or heavy exertion outdoors.")
        }else if aqi <= 150 {
            return String(localized: "Sensitive individuals may experience health effects. It’s advisable for sensitive groups to reduce prolonged or heavy exertion outdoors and consider wearing a mask if needed.")
        }else if aqi <= 200 {
            return String(localized: "Everyone may start to experience health effects, with more serious effects for sensitive groups. Limit outdoor activities, especially for sensitive groups. Wear a mask and keep windows closed.")
        }else if aqi <= 300 {
            return String(localized: "Health alert: everyone may experience more serious health effects. Avoid outdoor activities, use air purifiers indoors, and keep windows closed.")
        }else {
            return String(localized: "Health warnings of emergency conditions, where the entire population is likely to be affected. Stay indoors as much as possible, use air purifiers, wear a mask if you need to go outside, and keep windows and doors closed tightly.")
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
    
    func uviDescription(uvi: Int) -> String {
        if uvi < 0 {
            return String(localized: "NO DATA")
        }else if uvi <= 2 {
            return String(localized: "Enjoy your time outside with minimal risk of sunburn. However, it’s still a good idea to wear sunglasses and apply sunscreen if you plan to be outdoors for an extended period.")
        }else if uvi <= 5 {
            return String(localized: "The sun is moderately strong, so cover up with clothing, wear a hat and sunglasses, and use sunscreen with SPF 30+. Seek shade during midday hours.")
        }else if uvi <= 7 {
            return String(localized: "The UV index is high, increasing the risk of skin damage. Limit your sun exposure between 10 a.m. and 4 p.m., seek shade, wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses, and use broad-spectrum SPF 30+ sunscreen.")
        }else if uvi <= 10 {
            return String(localized: "UV levels are very high, meaning unprotected skin can burn quickly. Minimize sun exposure between 10 a.m. and 4 p.m., seek shade, cover up with clothing, wear a hat and UV-blocking sunglasses, and use broad-spectrum SPF 30+ sunscreen.")
        }else {
            return String(localized: "Extreme UV levels pose a serious risk of skin damage. Avoid sun exposure between 10 a.m. and 4 p.m., seek shade, wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses, and apply broad-spectrum SPF 30+ sunscreen generously and frequently.")
        }
    }
    
    func precipitationCondition(prepCon: Double) -> String {
        if prepCon < 0 {
            return String(localized: "NO DATA")
        }else if prepCon <= 0.2 {
            return String(localized: "VERY LOW")
        }else if prepCon <= 0.4 {
            return String(localized: "LOW")
        }else if prepCon <= 0.6 {
            return String(localized: "MODERATE")
        }else if prepCon <= 0.8 {
            return String(localized: "HIGH")
        }else {
            return String(localized: "VERY HIGH")
        }
    }
    
    func precipitationDescription(prepCon: Double) -> String {
        if prepCon < 0 {
            return String(localized: "NO DATA")
        }else if prepCon <= 20 {
            return String(localized: "Expect dry weather with little to no precipitation. Perfect for outdoor activities without any special precautions.")
        }else if prepCon <= 40 {
            return String(localized: "There's a slight chance of light rain or drizzle. It’s a good idea to bring an umbrella just in case while enjoying your day outdoors.")
        }else if prepCon <= 60 {
            return String(localized: "Occasional showers are likely. Keep an umbrella or raincoat handy and consider indoor alternatives for your activities.")
        }else if prepCon <= 80 {
            return String(localized: "Widespread showers are expected. Be prepared for rain throughout the day, wear waterproof clothing, and plan for indoor activities if possible.")
        }else {
            return String(localized: "Heavy rain or thunderstorms are very likely. It’s best to avoid outdoor activities, wear waterproof clothing, and stay safe indoors.")
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
            Make the content max 5 words containing recommendation using 'sunscreen' if UV is high, 'mask' if AQI is high, 'umbrella' if raining, or any clothes based on the weather. Show only the call-to-action copywriting! No emoji!
            """)
    }
    
    func getWeatherDetails() -> [WeatherDetailUIModel] {
        var details = [WeatherDetailUIModel]()
        
        if let uvi = detailPlan.weatherPlan?.first?.uvIndex.value {
            details.append(WeatherDetailUIModel(
                title: "UV Index",
                condition: uviCondition(uvi: uvi),
                iconName: "sun.max.fill",
                value: "\(uvi)",
                description: uviDescription(uvi: uvi)
            ))
        }
        
        if let prep = detailPlan.weatherPlan?.first?.precipitationChance {
            details.append(WeatherDetailUIModel(
                title: "Precipitation",
                condition: precipitationCondition(prepCon: prep),
                iconName: "umbrella.fill",
                value: "\((prep * 100).formatted(.number.precision(.fractionLength(0))))%",
                description: precipitationDescription(prepCon: prep)
            ))
        }
        
        if let aqi = detailPlan.aqiIndex {
            details.append(WeatherDetailUIModel(
                title: "Air Quality Condition",
                condition: aqiCondition(aqi: aqi),
                iconName: "wind",
                value: "\(aqi)",
                description: aqiDescription(aqi: aqi)
            ))
        }
        
        return details
    }
}
