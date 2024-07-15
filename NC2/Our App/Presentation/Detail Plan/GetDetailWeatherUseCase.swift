//
//  GetDetailWeatherUseCase.swift
//  NC2
//
//  Created by Glenn Leonali on 15/07/24.
//

import Foundation
import WeatherKit
import CoreLocation

class GetDetailWeatherUseCase {
    var location: Coordinate
    var date: Date
    
    init(location: Coordinate, date: Date) {
        self.location = location
        self.date = date
    }
    
    func execute() async throws -> Forecast<HourWeather> {
        let hourlyForecast = (await WeatherManager.shared.hourlyForecast(
            for: CLLocation(
                latitude: location.latitude,
                longitude: location.longitude
            ), date: date
        ))!
        
        return hourlyForecast
    }
}
