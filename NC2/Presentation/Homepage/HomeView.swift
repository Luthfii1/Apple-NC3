//
//  HomeView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if (vm.state.isLoading) {
                    ProgressView("Fetching data...")
                } else {
                    ScrollView {
                        Picker(selection: $vm.pickedPlanFilter, label: Text("Plan Filter")) {
                            Text("Event")
                                .tag(0)
                            
                            Text("Routine")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        
                        
                        VStack(alignment: .leading) {
                            ForEach(vm.sortedKeys, id: \.self) { date in
                                Section(
                                    header: Text(date)
                                        .font(.subheadline)
                                        .bold()
                                        .textCase(.uppercase)
                                        .padding(.top, 12)
                                ) {
                                    ForEach(vm.groupedPlans[date]!, id: \.id) { plan in
                                        SwipeableComponent(plan: plan)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)

                    }
                    .sheet(isPresented: $vm.state.isCreateSheetPresented) {
                        CreateEditPlanView(isCreate: true)
                            .environmentObject(DependencyInjection.shared.createEditPlanViewModel())
                    }
                    .sheet(isPresented: $vm.state.isEditSheetPresented) {
                        CreateEditPlanView(isCreate: false, idPlan: vm.idPlanEdit)
                            .environmentObject(DependencyInjection.shared.createEditPlanViewModel())
                    }
                    .refreshable {
                        await vm.refreshPage()
                    }
                    .navigationTitle("Plan")
                    .background(.backgroundView)
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            HStack {
                                Button(action: {
                                    vm.state.isCreateSheetPresented = true
                                }, label: {
                                    HStack () {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.body)
                                            .bold()
                                            .foregroundStyle(.button)
                                        
                                        Text("Add Plan")
                                            .font(.body)
                                            .bold()
                                            .foregroundStyle(.button)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                })
                                Spacer()
                                
                                Button(action: {
                                    if let url = URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    HStack(alignment: .center, spacing: 8) {
                                        Text(" Weather")
                                            .font(.headline)
                                            .foregroundStyle(.gray)
                                        
                                        Text("legal")
                                            .font(.caption)
                                            .underline()
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await vm.checkAndGetPlansData()
                }
            }
        }
    }
}
