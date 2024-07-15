//
//  DetailPlanView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct DetailPlanView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm : DetailPlanViewModel
    var planId: UUID
    
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
                // MARK: nanti apus
                Text("tes")
            } else {
                VStack(alignment: .leading) {
                    VStack {
                        // MARK: ganti jadi vm.plan.weatherPlan
                        Text("\(vm.hourlyForecast?.first?.condition.description ?? "No data yet")")
                            .font(.title)
                            .bold()
                        
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("\(String(describing: vm.plan.date.formatted(date: .complete, time: .omitted)))")
                            Text(" | ")
                            // MARK: ganti jadi duration
                            Text("\(String(describing: vm.plan.date.formatted(date: .omitted, time: .shortened)))")
                        }
    
                        HStack {
                            Image(systemName: "pin.fill")
                            VStack(alignment: .leading) {
                                Text("\(vm.plan.title)")
                                Text("\(vm.plan.location)")
                            }
                        }
                    }
                    
                    // MARK: place for illustration
                    VStack {
                        
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            VStack {
                                // MARK: ganti jadi vm.plan.weatherPlan -> symbolName, condition
                                Image(systemName: vm.hourlyForecast?.first?.symbolName ?? "questionmark")
                                Text("\(vm.hourlyForecast?.first?.condition.description ?? "No data yet")")
                            }.frame(width: 164, height: 74)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                            
                            VStack(alignment: .leading) {
                                //                        Text("\(vm.hourlyForecast?.first?.temperature.value.formatted(.number.precision(.fractionLength(1))) ?? "--")ºC")
                                Text("\(vm.plan.weatherPlan?.hotDegree ?? 0)ºC")
                                // MARK: ini ganti jadi apa ya??
                                Text("Humidity will make it feel warmer.")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }.frame(width: 164, height: 74)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                        }
                        
                        HStack {
                            VStack {
                                HStack {
                                    Image(systemName: "sun.max.fill")
                                    Text("\(vm.plan.weatherPlan?.UVIndex ?? 0)")
                                }
                                Text("UV index")
                                // MARK: GANTI
                                Text("Partly Cloudy")
                            }
                            VStack {
                                HStack {
                                    Image(systemName: "umbrella.fill")
                                    //                            Text("\(((vm.hourlyForecast?.first?.precipitationChance ?? 0) * 100).formatted(.number.precision(.fractionLength(0))))%")
                                    // MARK: ini typo harusnya Precipitation
                                    Text("\(vm.plan.weatherPlan?.Percipitation ?? 0)%")
                                }
                                Text("Precipitation")
                                // MARK: ganti
                                Text("Partly Cloudy")
                            }
                            VStack {
                                HStack {
                                    Image(systemName: "wind")
                                    // MARK: ganti
                                    Text("\(vm.plan.weatherPlan?.AQIndex ?? 0)")
                                }
                                Text("AQI")
                                // MARK: ganti
                                Text("Partly Cloudy")
                            }
                        }.frame(width: 345, height: 80)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                        
                        VStack {
                            if let hourly = vm.hourlyForecast {
                                // MARK: ganti
                                Text("Sunny conditions expected around 11AM")
                                Divider()
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 12) {
                                        ForEach(hourly, id: \.date) { hour in
                                            HourDetailsCell(hourWeather: hour)
                                            Divider()
                                        }
                                    }
                                }
                                .padding(.all, 5)
                            }
                        }.frame(width: 345, height: 120)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .onAppear{
            Task {
                // await vm.getHourlyWeather()
                await vm.getDetailPlan(planId: planId)
            }
        }
    }
}

//#Preview {
//    DetailPlanView()
//}
