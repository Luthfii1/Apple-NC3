//
//  HomeView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    @State private var showAlert: Bool = false
    @State private var isCreateSheetPresented = false
//    @State private var selectedPlan: PlanCardEntity?
//    @State private var isEditSheetPresented: Bool = false
    
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
                                        PlanCardComponent(plan: plan)
//                                            .contextMenu {
//                                                Button(action: {
//                                                    selectedPlan = plan
//                                                    isEditSheetPresented = true
//                                                }) {
//                                                    Text("Edit")
//                                                }
//                                            }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .sheet(isPresented: $isCreateSheetPresented) {
                        CreatePlanView()
                    }                    
//                    .sheet(isPresented: $isEditSheetPresented) {
//                        EditPlanView(viewModel: EditPlanViewModel(plan: selectedPlan))
//                    }
                    .refreshable {
                        await vm.fetchPlansBasedOnFilter()
                    }
                    .navigationTitle("Plan")
                    .background(.backgroundView)
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            HStack {
                                Button(action: {
                                    print("Add Plan")
                                    isCreateSheetPresented = true
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
    }
}
