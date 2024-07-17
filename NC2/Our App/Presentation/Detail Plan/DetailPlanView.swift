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
                            Text("\(vm.detailPlan.weatherPlan?.forecast.first?.condition.rawValue.toFrontCapital() ?? "No data yet")")
                                .font(.system(size: 34, weight: .heavy, design: .rounded))
                                .bold()
                                .padding(.top, 76)
                                .padding(.bottom, 12)
                            HStack {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                
                                Text("\(String(describing: vm.detailPlan.durationPlan.start.formatted(date: .complete, time: .omitted)))")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                                Text(" | ")
                                if vm.detailPlan.allDay {
                                    Text("All Day")
                                }else{
                                    Text("\(String(describing: vm.detailPlan.durationPlan.start.formatted(date: .omitted, time: .shortened))) - \(String(describing: vm.detailPlan.durationPlan.end.formatted(date: .omitted, time: .shortened)))")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                }
                            }
                            .padding(.bottom, 12)
                            
                            HStack {
                                Image(systemName: "pin.fill")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                VStack(alignment: .leading) {
                                    Text("\(vm.detailPlan.title)")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                    Text("\(vm.detailPlan.location.nameLocation)")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                }
                            }
                            .padding(.bottom, 12)
                        }
                        
                        // MARK: place for illustration
                        VStack {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: 300, height: 256)
                        }.padding(.bottom, 12)
                        
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(vm.detailPlan.weatherPlan?.first?.temperature.value ?? 0)ºC")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                    Text("Feels like \(vm.detailPlan.weatherPlan?.first?.apparentTemperature.value ?? 0)ºC")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                    // MARK: tes
                                    Text("\(vm.dayForecast?.first?.condition.accessibilityDescription ?? "--")")
                                }.frame(width: 168, height: 74)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                
                                HStack {
                                    VStack {
                                        Text("HIGHEST")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                        if let highTemp = vm.dayForecast?.forecast.first?.highTemperature.value { Text("\(highTemp.formatted(.number.precision(.fractionLength(1))))ºC")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                        } else {
                                            Text("--")
                                        }
                                    }.padding(.trailing, 4)
                                    
                                    VStack {
                                        Text("LOWEST")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                        
                                        if let lowTemp = vm.dayForecast?.forecast.first?.lowTemperature.value { Text("\(lowTemp.formatted(.number.precision(.fractionLength(1))))ºC")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                        } else {
                                            Text("--")
                                        }
                                    }
                                }.frame(width: 168, height: 74)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                            }
                            
                            HStack {
                                VStack {
                                    HStack {
                                        Image(systemName: "sun.max.fill")
                                        Text("\(vm.detailPlan.weatherPlan?.first?.uvIndex.value ?? 0)")
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
                                        //                                        Text("\(vm.detailPlan.weatherPlan?.Percipitation ?? 0)%")
                                        //                                        Text("\(vm.detailPlan.weatherPlan?.forecast.first?.precipitationChance ?? 0)%")
                                    }
                                    Text("Precipitation")
                                    // MARK: ganti
                                    Text("Partly Cloudy")
                                }
                                VStack {
                                    HStack {
                                        Image(systemName: "wind")
                                        // MARK: ganti
                                        Text("\(vm.detailPlan.aqiIndex ?? 0)")
                                    }
                                    Text("AQI")
                                    // MARK: ganti
                                    Text("Partly Cloudy")
                                }
                            }.frame(width: 344, height: 80)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                            
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
                            }.frame(width: 344, height: 120)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.bottom, 72)
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
    }
}

//#Preview {
//    DetailPlanView()
//}
