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
                ProgressView("Loading...")
            } else {
                ZStack{
                    vm.getBackground(currentWeather: "Sunny")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("\(vm.detailPlan.weatherPlan?.generalDescription ?? "No data yet")")
                                .font(.title)
                                .bold()
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("\(String(describing: vm.detailPlan.durationPlan.start.formatted(date: .complete, time: .omitted)))")
                                Text(" | ")
                                Text("\(String(describing: vm.detailPlan.durationPlan.start.formatted(date: .omitted, time: .shortened))) - \(String(describing: vm.detailPlan.durationPlan.end.formatted(date: .omitted, time: .shortened)))")
                            }
                            
                            HStack {
                                Image(systemName: "pin.fill")
                                VStack(alignment: .leading) {
                                    Text("\(vm.detailPlan.title)")
                                    Text("\(vm.detailPlan.location.nameLocation)")
                                }
                            }
                        }
                        
                        // MARK: place for illustration
                        VStack {
                            
                        }
                        
                        VStack {
//                            Spacer()
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(vm.detailPlan.weatherPlan?.hotDegree ?? 0)ºC")
                                    // MARK: ini ganti jadi apa ya??
                                    Text("Feels like \(vm.detailPlan.weatherPlan?.looksLikeHotDegree ?? 0)ºC")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                    //                                Text("\(vm.dayForecast?.first?.condition.accessibilityDescription ?? "--")")
                                }.frame(width: 164, height: 74)
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                                
                                HStack {
                                    VStack {
                                        Text("HIGHEST")
                                        Text("\(String(describing: vm.dayForecast?.first?.highTemperature.value.formatted(.number.precision(.fractionLength(1)))))ºC")
                                    }
                                    
                                    VStack {
                                        Text("LOWEST")
                                        Text("\(String(describing: vm.dayForecast?.first?.lowTemperature.value.formatted(.number.precision(.fractionLength(1)))))ºC")
                                    }
                                }.frame(width: 164, height: 74)
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                            }
                            
                            HStack {
                                VStack {
                                    HStack {
                                        Image(systemName: "sun.max.fill")
                                        Text("\(vm.detailPlan.weatherPlan?.UVIndex ?? 0)")
                                    }
                                    Text("UV index")
                                    // MARK: GANTI
                                    Text("Partly Cloudy")
                                }
                                VStack {
                                    HStack {
                                        Image(systemName: "umbrella.fill")
                                        Text("\(((vm.hourlyForecast?.first?.precipitationChance ?? 0) * 100).formatted(.number.precision(.fractionLength(0))))%")
                                        // MARK: ini typo harusnya Precipitation
                                        Text("\(vm.detailPlan.weatherPlan?.Percipitation ?? 0)%")
                                    }
                                    Text("Precipitation")
                                    // MARK: ganti
                                    Text("Partly Cloudy")
                                }
                                VStack {
                                    HStack {
                                        Image(systemName: "wind")
                                        // MARK: ganti
                                        Text("\(vm.detailPlan.weatherPlan?.AQIndex ?? 0)")
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
        }
        .onAppear{
            Task {
                await vm.getDetailPlan(planId: planId)
                await vm.getHourlyWeather()
                await vm.getDayWeather()
            }
        }
//        .background(vm.getBackground(currentWeather: "Sunny")
//            .resizable()
//            .scaledToFill()
//            .edgesIgnoringSafeArea(.all)
//            .transformEffect(.init(scaleX: 1.2, y: 1.2)))
    }
}

//#Preview {
//    DetailPlanView()
//}
