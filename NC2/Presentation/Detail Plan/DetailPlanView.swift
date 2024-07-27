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
    
    var body: some View {
        VStack(spacing: 0) {
            if vm.isLoading {
                ProgressView("Loading...")
            } else {
                ZStack{
                    Image(vm.getBackgroundPage())
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(vm.detailPlan.weatherPlan?.first?.condition.description ?? "No data yet")")
                                .shadowedText(font: .system(size: 34, weight: .heavy, design: .rounded))
                                .foregroundStyle(Color.white)
                                .bold()
                                .padding(.bottom, 8)
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "clock.fill")
                                    .shadowedText(font: .system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(vm.detailTime(isDate: true))")
                                        .shadowedText(font: .body)
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                    
                                    Text("\(vm.detailPlan.allDay ? "All Day" : vm.detailTime(isDate: false))")
                                        .shadowedText(font: .body)
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                }
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "pin.fill")
                                    .shadowedText(font: .system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(vm.detailPlan.title)")
                                        .shadowedText(font: .body)
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                    
                                    Text("\(vm.detailPlan.location.nameLocation)")
                                        .shadowedText(font: .body)
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                }
                            }
                        }
                        
                        HStack (alignment: .bottom, spacing: 20) {
                            Spacer()
                            
                            VStack {
                                Text(gemini.inProgress ? "Summarizing..." : gemini.outputText)
                                    .foregroundStyle(Color.black)
                                    .font(Font.custom("NanumPen", size: 28))
                                    .padding(.trailing, 24)
                                    .frame(alignment: .center)
                            }
                            .background(Image(.chatBox))
                            
                            Image(vm.getCTABackground())
                        }
                        .padding(.vertical, 40)
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                HStack(spacing: 16) {
                                    HStack {
                                        Spacer()
                                        VStack(alignment: .leading, spacing: 0) {
                                            Spacer()
                                            
                                            Text("\(Int(ceil(vm.detailPlan.weatherPlan?.first?.temperature.value ?? 0)))ºC")
                                                .font(.title)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            Text("Feels like \(Int(ceil(vm.detailPlan.weatherPlan?.first?.apparentTemperature.value ?? 0)))ºC")
                                                .font(.caption)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.bgDetailCard)
                                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    )
                                    
                                    HStack(spacing: 12) {
                                        Spacer()
                                        VStack(spacing: 0) {
                                            Spacer()
                                            
                                            Text("HIGHEST")
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                                .foregroundStyle(Color.detailSecondary)
                                            
                                            if let highTemp = vm.dayForecast?.first?.highTemperature.value {
                                                Text("\(Int(ceil(highTemp)))ºC")
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
                                        
                                        VStack(spacing: 0) {
                                            Spacer()
                                            
                                            Text("LOWEST")
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                                .foregroundStyle(Color.detailSecondary)
                                            
                                            if let lowTemp = vm.dayForecast?.first?.lowTemperature.value {
                                                Text("\(Int(ceil(lowTemp)))ºC")
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
                                        Spacer()
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.bgDetailCard)
                                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    )
                                }
                                .frame(height: 64)
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
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.bgDetailCard)
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                )
                                .padding(.bottom, 16)
                                
                                ForEach(vm.getWeatherDetails()) { detail in
                                    WeatherDetailComponent(
                                        title: detail.title,
                                        condition: detail.condition,
                                        iconName: detail.iconName,
                                        value: detail.value,
                                        description: detail.description
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 48)
                }
            }
        }
        .onAppear{
            Task {
                await vm.getDetailPlan(planId: planId)
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
