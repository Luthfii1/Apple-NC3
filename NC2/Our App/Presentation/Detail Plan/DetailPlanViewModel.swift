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
    // TODO: Manage the view of DetailPlanView
//    let location = CLLocation(latitude: -6.302481, longitude: 106.652323)
    
//    @Published var isLoading = false
    @Published var plan: PlanModel = dummyPlans.first.unsafelyUnwrapped
    @Published var hourlyForecast: Forecast<HourWeather>?
    
    private let getDetailUseCase: GetDetailUseCaseProtocol
    
    init(getDetailUseCase: GetDetailUseCaseProtocol) {
        self.getDetailUseCase = getDetailUseCase
    }
        @Published var detailPlan: PlanModel = PlanModel()
        @Published var state: StateView = StateView()
//        private let planDetailUseCase: PlanDetailUseCase
    //    
    //    init(planDetailUseCase: PlanDetailUseCase) {
    //        self.planDetailUseCase = planDetailUseCase
    //    }
    
    func getHourlyWeather() async {
        isLoading = true
        Task {
            do {
//                let planFetched = try await getDetailUseCase.execute()
//                let weatherFetched = try await GetDetailWeatherUseCase(location: planFetched.coordinatePlace, date: planFetched.date).execute()
                let weatherFetched = try await GetDetailWeatherUseCase(location: plan.coordinatePlace, date: plan.date).execute()
                DispatchQueue.main.async {
//                    self.plan = planFetched
                    self.hourlyForecast = weatherFetched
                    self.isLoading = false
                }
            } catch {
                print("Failed to load weather: \(error)")
                print("Failed to load weather: \(error)")
            }
        }
    }
    
//    @MainActor
//    func getDetailPlan(planId: UUID) async {
//        self.state.isLoading = true
//        do {
//            let detailPlan = try await planDetailUseCase.execute(planId: planId)
//            DispatchQueue.main.async {
//                self.detailPlan = detailPlan
//                self.state.isLoading.toggle()
//            }
//        } catch {
//            print("Error when getting detail plan because \(error)")
//            DispatchQueue.main.async {
//                self.state.isLoading.toggle()
//            }
//        }
//    }
    
//    func getPlan() async {
//        Task {
//            do {
//                let planFetched = try await getDetailUseCase.execute()
//                DispatchQueue.main.async {
//                    self.plan = planFetched
//                }
//            } catch {
//                print("Failed to load weather: \(error)")
//            }
//        }
//    }
}
