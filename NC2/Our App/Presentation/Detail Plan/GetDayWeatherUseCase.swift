//
//  GetDayWeatherUseCase.swift
//  NC2
//
//  Created by Glenn Leonali on 16/07/24.
//

import Foundation
import WeatherKit
import CoreLocation

class GetDayWeatherUseCase {
    var location: Coordinate
    var date: Date

    init(location: Coordinate, date: Date) {
        self.location = location
        self.date = date
    }

    func execute() async throws -> Forecast<DayWeather>? {
        let dayForecast = await WeatherManager.shared.dayForecast(for: CLLocation(
            latitude: location.latitude,
            longitude: location.longitude
        ), date: date)

        return dayForecast
    }
}
