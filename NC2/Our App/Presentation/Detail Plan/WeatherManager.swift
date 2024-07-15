//
//  WeatherManager.swift
//  Weather
//
//  Created by Glenn Leonali on 09/07/24.
//

import Foundation
import WeatherKit
import CoreLocation

@Observable class WeatherManager {
    static let shared = WeatherManager()
    private let service = WeatherService.shared
    
    func currentWeather(for location: CLLocation) async -> CurrentWeather? {
        let currentWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location,
                including: .current)
            return forcast
        }.value
        return currentWeather
    }
    
    func dailyForecast(for location: CLLocation) async -> Forecast<DayWeather>? {
        let dayWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location,
                including: .daily)
            return forcast
        }.value
        return dayWeather
    }
    
    func hourlyForecast(for location: CLLocation, date: Date) async -> Forecast<HourWeather>? {
        let hourWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location,
                including: .hourly(startDate: date, endDate: date.addingTimeInterval(25*3600)))
            return forcast
        }.value
        return hourWeather
    }
    
    func weatherAttribution() async -> WeatherAttribution? {
        let attrib = await Task.detached(priority: .userInitiated) {
            return try? await self.service.attribution
        }.value
        return attrib
    }
    
    enum WeatherDataHelper {
        public static func findDailyTempMinMax(_ daily: Forecast<DayWeather>) -> (min: Double, max: Double) {
            let minElement = daily.min { valA, valB in
                valA.lowTemperature.value < valB.lowTemperature.value
            }
            let min = minElement?.lowTemperature.value ?? 0
            
            let maxElement = daily.max { valA, valB in
                valA.highTemperature.value < valB.highTemperature.value
            }
            let max = maxElement?.highTemperature.value ?? 200
            
            return (min, max)
        }
    }
}
