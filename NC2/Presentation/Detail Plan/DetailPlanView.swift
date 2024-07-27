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
    @StateObject var gemini = GeminiBotViewModel()
    var planId: UUID
    @EnvironmentObject var vmHome : HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if vm.isLoading || gemini.inProgress {
                ProgressView("Loading...")
            } else {
                ZStack{
                    Image((vm.detailPlan.background != nil) ? (vm.detailPlan.background! + "Detail") : "clearDetail")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading) {
                            Text("\(vm.detailPlan.weatherPlan?.first?.condition.description ?? "No data yet")")
                                .shadowedText(font: .system(size: 34, weight: .heavy, design: .rounded))
                                .foregroundStyle(Color.white)
                                .bold()
                                .padding(.bottom, 16)
                            
                          HStack(spacing: 0) {
                            Image(systemName: "clock.fill")
                                .shadowedText(font: .system(size: 14, weight: .semibold, design: .rounded))
                            
                            Text("\(String(describing: vm.detailPlan.durationPlan.start.formatted(date: .complete, time: .omitted)))")
                                .shadowedText(font: .body)
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            
                            Text(" | ")
                                .shadowedText(font: .body)
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            
                            if vm.detailPlan.allDay {
                                Text("All Day")
                                    .shadowedText(font: .body)
                                    .foregroundStyle(Color.white)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                            } else {
                                Text("\(String(describing: vm.detailPlan.durationPlan.start.formatted(date: .omitted, time: .shortened))) - \(String(describing: vm.detailPlan.durationPlan.end.formatted(date: .omitted, time: .shortened)))")
                                    .shadowedText(font: .body)
                                    .foregroundStyle(Color.white)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                            }
                        }
                        .padding(.bottom, 16)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Image(systemName: "pin.fill")
                                .shadowedText(font: .system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.white)
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(vm.detailPlan.title)")
                                    .shadowedText(font: .body)
                                    .foregroundStyle(Color.white)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                                    .padding(.bottom, 4)
                                
                                Text("\(vm.detailPlan.location.nameLocation)")
                                    .shadowedText(font: .footnote)
                                    .foregroundStyle(Color.white)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                            }
                        }

                        
                        VStack(alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(.chatBox)
                                    Text(gemini.outputText)
                                        .foregroundStyle(Color.black)
                                        .font(Font.custom("NanumPen", size: 28))
                                        .padding(.leading, 12)
                                        .padding(.trailing, 36)
                                        .padding(.top, 32)
                                        .multilineTextAlignment(.center)
                                }
                                .offset(x: 4, y: 48)
                                
                                Image(Utils().setCTA(condition: vm.detailPlan.weatherPlan?.first?.condition ?? .clear, isDay: vm.detailPlan.weatherPlan?.first?.isDaylight ?? true, isBadUV: vm.isBadUV(uvi: vm.detailPlan.weatherPlan?.first?.uvIndex.value ?? 0), isBadAQI: vm.isBadAQI(aqi: vm.detailPlan.aqiIndex ?? 0)))
                            }
                        }
                        .frame(width: 350)
                        .padding(.bottom, 16)
                        .offset(x: 24, y: -12)
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: 0) {
                                      //spacer, vstack, spacer
                                        Text("\(String(format: "%.0f", vm.detailPlan.weatherPlan?.first?.temperature.value ?? 0))ºC")
                                            .font(.title)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                        Text("Feels like \(String(format: "%.0f", vm.detailPlan.weatherPlan?.first?.apparentTemperature.value ?? 0))ºC")
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                      //spacer
                                    }
                                  //spacer
                                    .frame(width: 164, height: 70)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                    .padding(.trailing, 17)
                                    
                                    HStack(spacing: 0) {
                                        VStack(spacing: 0) {
                                            Text("HIGHEST")
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                                .foregroundStyle(Color.detailSecondary)
                                          
                                            if let highTemp = vm.dayForecast?.first?.highTemperature.value { 
                                              Text("\(highTemp.formatted(.number.precision(.fractionLength(0))))ºC")
                                                    .font(.body)
                                                    .foregroundStyle(Color.white)
                                                    .fontWeight(.semibold)
                                                    .fontDesign(.rounded)
                                            } else {
                                                Text("--")
                                                    .foregroundStyle(Color.white)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.trailing, 20)
                                        
                                        VStack(spacing: 0) {
                                            Text("LOWEST")
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                                .foregroundStyle(Color.detailSecondary)
                                            
                                            if let lowTemp = vm.dayForecast?.first?.lowTemperature.value { 
                                              Text("\(lowTemp.formatted(.number.precision(.fractionLength(0))))ºC")
                                                    .font(.body)
                                                    .foregroundStyle(Color.white)
                                                    .fontWeight(.semibold)
                                                    .fontDesign(.rounded)
                                            } else {
                                                Text("--")
                                                    .foregroundStyle(Color.white)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 2)
                                        
                                        Spacer()
                                    }
                                    .frame(width: 164, height: 70)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.bottom, 16)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    if let hourly = vm.detailPlan.weatherPlan {
                                        Text("Hourly Forecast")
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                            .padding(.top, 12)
                                            .padding(.leading, 16)
                                            .padding(.bottom, 8)
                                        
                                        Divider()
                                            .padding(.bottom, 8)
                                        
                                        ScrollView(.horizontal) {
                                            HStack(spacing: 20) {
                                                ForEach(hourly, id: \.date) { hour in
                                                    HourDetailsCell(hourWeather: hour)
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                        }
                                        .padding(.top, 8)
                                        .padding(.bottom, 12)
                                    }
                                }
                                .frame(width: 345, height: 128)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 16)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    if let uvi = vm.detailPlan.weatherPlan?.first?.uvIndex.value {
                                        HStack(spacing: 0) {
                                            Text("UV Index   |   \(vm.uviCondition(uvi: uvi))   |   ")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.medium)
                                                .fontDesign(.rounded)
                                            
                                            Image(systemName: "sun.max.fill")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            
                                            Text("   \(uvi)   ")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.medium)
                                                .fontDesign(.rounded)
                                        }
                                        .padding(.top, 12)
                                        .padding(.leading, 16)
                                        .padding(.bottom, 8)
                                        
                                        Divider()
                                            .padding(.bottom, 8)
                                        
                                        Text(vm.uviDescription(uvi: uvi))
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.medium)
                                            .fontDesign(.rounded)
                                            .padding(.horizontal, 16)
                                            .padding(.bottom, 12)
                                    }
                                }
                                .frame(width: 345)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 16)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    if let prep =
                                        vm.detailPlan.weatherPlan?.first?.precipitationChance {
                                        HStack(spacing: 0) {
                                            Text("Prepicitation   |   \(vm.precipitationCondition(prepCon: prep))   |   ")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.medium)
                                                .fontDesign(.rounded)
                                            
                                            Image(systemName: "umbrella.fill")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            
                                            Text("   \((prep*100).formatted(.number.precision(.fractionLength(0))))%   ")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.medium)
                                                .fontDesign(.rounded)
                                        }
                                        .padding(.top, 12)
                                        .padding(.leading, 16)
                                        .padding(.bottom, 8)
                                        
                                        Divider()
                                            .padding(.bottom, 8)
                                        
                                        Text(vm.precipitationDescription(prepCon: prep))
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.medium)
                                            .fontDesign(.rounded)
                                            .padding(.horizontal, 16)
                                            .padding(.bottom, 12)
                                    }
                                }
                                .frame(width: 345)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 16)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    if let aqi = vm.detailPlan.aqiIndex {
                                        HStack(spacing: 0) {
                                            Text("Air Quality Condition  |   \(vm.aqiCondition(aqi: aqi))   |   ")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.medium)
                                                .fontDesign(.rounded)
                                            
                                            Image(systemName: "wind")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            
                                            Text("   \(aqi)   ")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.medium)
                                                .fontDesign(.rounded)
                                        }
                                        .padding(.top, 12)
                                        .padding(.leading, 16)
                                        .padding(.bottom, 8)
                                        
                                        Divider()
                                            .padding(.bottom, 8)
                                        
                                        Text(vm.aqiDescription(aqi: aqi))
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.medium)
                                            .fontDesign(.rounded)
                                            .padding(.horizontal, 16)
                                            .padding(.bottom, 12)
                                    }
                                }
                                .frame(width: 345)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 16)
                            }
                            .padding(.bottom, 48)
                        }
                        .preferredColorScheme(.dark)
                        Spacer()
                    }
                    .padding(.leading, 4)
                    .padding(.top, 84)
                }
            }
        }
        .onAppear{
            Task {
                await vm.getDetailPlan(planId: planId)
                await vm.getHourlyWeather()
                await vm.getDayWeather()
                await gemini.summarize(inputText: vm.generateInputText())
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.white)
                    Text("Back")
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.white)
                })
            }
        }
    }
}

