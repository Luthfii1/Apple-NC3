//
//  HomeView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    @EnvironmentObject var dependencyInjection: DependencyInjection
    
    var body: some View {
        NavigationStack {
            VStack {
                if (vm.state.isLoading) {
                    ProgressView("Loading logs...")
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
                        
                        
                        VStack (alignment: .leading) {
                            ForEach(vm.groupedPlans.keys.sorted(), id: \.self) { date in
                                Section(
                                    header: Text(date)
                                        .font(.subheadline)
                                        .bold()
                                        .textCase(.uppercase)
                                        .padding(.top, 12)
                                ) {
                                    ForEach(vm.groupedPlans[date]!, id: \.id) { plan in
                                        SwipeableView(plan: plan)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .sheet(isPresented: $vm.state.isCreateSheetPresented) {
                        CreatePlanView(isCreate: true)
                            .environmentObject(dependencyInjection.createPlanViewModel())
                    }
                    .sheet(isPresented: $vm.state.isEditSheetPresented) {
                        CreatePlanView(isCreate: false, idPlan: vm.idPlanEdit)
                            .environmentObject(dependencyInjection.createPlanViewModel())
                    }
                    .refreshable {
                        await vm.fetchPlansBasedOnFilter()
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
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await vm.fetchPlansBasedOnFilter()
                }
            }
        }
        .tint(Color.white)
    }
}
