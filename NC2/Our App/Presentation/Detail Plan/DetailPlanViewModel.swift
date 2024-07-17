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
        isLoading = true
        Task {
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
    }
    
    @MainActor
    func getDetailPlan(planId: UUID) async {
        do {
            let detailPlan = try await getDetailUseCase.execute(planId: planId)
            DispatchQueue.main.async {
                self.detailPlan = detailPlan
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
    
    func getBackground(currentWeather: String) -> Image {
        if currentWeather == "Sunny" {
            return Image("CloudyBackground")
        }
            
        return Image(currentWeather)
    }
}
