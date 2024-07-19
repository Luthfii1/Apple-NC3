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

    @EnvironmentObject var dependencyInjection: DependencyInjection
    @EnvironmentObject var vmHome : HomeViewModel
    
    var body: some View {
        VStack {
            if vm.isLoading || gemini.inProgress {
                ProgressView("Loading...")
            } else {
                ZStack{
                    Image(Utils().setBackground(condition: vm.detailPlan.weatherPlan?.first?.condition ?? .clear, isDay: vm.detailPlan.weatherPlan?.first?.isDaylight ?? true, date: vm.detailPlan.durationPlan.start, state: .Detail))
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("\(vm.detailPlan.weatherPlan?.first?.condition.description ?? "No data yet")")
                                .shadowedText(font: .system(size: 34, weight: .heavy, design: .rounded))
                                .foregroundStyle(Color.white)
                                .bold()
                                .padding(.bottom, 12)
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                    .shadowedText(font: .system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                
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
                                }else{
                                    Text("\(String(describing: vm.detailPlan.durationPlan.start.formatted(date: .omitted, time: .shortened))) - \(String(describing: vm.detailPlan.durationPlan.end.formatted(date: .omitted, time: .shortened)))")
                                        .shadowedText(font: .body)
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                }
                            }
                            .padding(.bottom, 12)
                            
                            HStack(alignment: .top) {
                                Image(systemName: "pin.fill")
                                    .shadowedText(font: .system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                VStack(alignment: .leading) {
                                    Text("\(vm.detailPlan.title)")
                                        .shadowedText(font: .body)
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                    Text("\(vm.detailPlan.location.nameLocation)")
                                        .shadowedText(font: .footnote)
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                }
                                .padding(.bottom, 12)
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
                                    .offset(x:4, y:24)
                                    
                                    Image(Utils().setCTA(condition: vm.detailPlan.weatherPlan?.first?.condition ?? .clear, isDay: vm.detailPlan.weatherPlan?.first?.isDaylight ?? true, isBadUV: vm.isBadUV(uvi: vm.detailPlan.weatherPlan?.first?.uvIndex.value ?? 0), isBadAQI: vm.isBadAQI(aqi: vm.detailPlan.aqiIndex ?? 0)))
                                    
                                }
                            }
                            .frame(width: 350, height: 224)
                            .padding(.bottom, 12)
                            .offset(x: 24)
                            
                            VStack {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading) {
                                        Text("\(String(format: "%.1f", vm.detailPlan.weatherPlan?.first?.temperature.value ?? 0))ºC")
                                            .font(.title)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                        Text("Feels like \(String(format: "%.1f", vm.detailPlan.weatherPlan?.first?.apparentTemperature.value ?? 0))ºC")
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                    }.frame(width: 164, height: 74)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                    
                                    HStack {
                                        VStack {
                                            Text("HIGHEST")
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                                .foregroundStyle(Color.detailSecondary)
                                            if let highTemp = vm.dayForecast?.first?.highTemperature.value { Text("\(highTemp.formatted(.number.precision(.fractionLength(1))))ºC")
                                                    .font(.body)
                                                    .foregroundStyle(Color.white)
                                                    .fontWeight(.semibold)
                                                    .fontDesign(.rounded)
                                            } else {
                                                Text("--")
                                                    .foregroundStyle(Color.white)
                                            }
                                        }
                                        
                                        VStack {
                                            Text("LOWEST")
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                                .foregroundStyle(Color.detailSecondary)
                                            
                                            if let lowTemp = vm.dayForecast?.first?.lowTemperature.value { Text("\(lowTemp.formatted(.number.precision(.fractionLength(1))))ºC")
                                                    .font(.body)
                                                    .foregroundStyle(Color.white)
                                                    .fontWeight(.semibold)
                                                    .fontDesign(.rounded)
                                            } else {
                                                Text("--")
                                                    .foregroundStyle(Color.white)
                                            }
                                        }
                                    }
                                    .frame(width: 164, height: 74)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                }.padding(.bottom, 8)
                                
                                HStack(spacing: 48) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "sun.max.fill")
                                                .font(.body)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            Text("\(vm.detailPlan.weatherPlan?.first?.uvIndex.value ?? 0)")
                                                .font(.body)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                        }
                                        Text("UV index")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                            .foregroundStyle(Color.detailSecondary)
                                        Text(vm.uviCondition(uvi: vm.detailPlan.weatherPlan?.first?.uvIndex.value ?? -1))
                                            .font(.caption2)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "umbrella.fill")
                                                .font(.body)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            Text("\(((vm.detailPlan.weatherPlan?.first?.precipitationChance ?? 0) * 100).formatted(.number.precision(.fractionLength(0))))%")
                                                .font(.body)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                        }
                                        Text("Precipitation")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                            .foregroundStyle(Color.detailSecondary)
                                        Text(vm.precipitationCondition(prepCon: (vm.detailPlan.weatherPlan?.first?.precipitationChance ?? -1)*100))
                                            .font(.caption2)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "wind")
                                                .font(.body)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                            Text("\(vm.detailPlan.aqiIndex ?? 0)")
                                                .font(.body)
                                                .foregroundStyle(Color.white)
                                                .fontWeight(.semibold)
                                                .fontDesign(.rounded)
                                        }
                                        Text("AQI")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                            .foregroundStyle(Color.detailSecondary)
                                        Text(vm.aqiCondition(aqi: vm.detailPlan.aqiIndex ?? -1))
                                            .font(.caption2)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                    }
                                }.frame(width: 344, height: 80)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 8)
                                    .opacity(0.95)
                                
                                VStack(alignment: .leading) {
                                    if let hourly = vm.detailPlan.weatherPlan {
                                        Text("Hourly Forecast")
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                            .padding(.top, 12)
                                            .padding(.leading, 18)
                                        Divider()
                                        
                                        ScrollView(.horizontal) {
                                            HStack(spacing: 12) {
                                                ForEach(hourly, id: \.date) { hour in
                                                    HourDetailsCell(hourWeather: hour)
                                                        .padding(.horizontal, 5)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.bottom, 12)
                                    }
                                }.frame(width: 344, height: 120)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                            }
                            .preferredColorScheme(.dark)
                        }
                        .padding(.leading, 8)
                        .padding(.bottom, 16)
                    }
                }
                .sheet(isPresented: $vmHome.state.isCreateSheetPresented) {
                    CreateEditPlanView(isCreate: true)
                        .environmentObject(dependencyInjection.createPlanViewModel())
                }
                .sheet(isPresented: $vmHome.state.isEditSheetPresented) {
                    CreateEditPlanView(isCreate: false, idPlan: vmHome.idPlanEdit)
                        .environmentObject(dependencyInjection.createPlanViewModel())
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
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    vmHome.state.isEditSheetPresented = true
                    vmHome.idPlanEdit = planId
                }, label: {
                    Text("Edit")
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.white)
                })
            }
        }
    }
}

