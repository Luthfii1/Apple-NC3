//
//  HomeView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Picker(selection: $vm.pickedPlanFilter, label: Text("Plan Filter")) {
                    Text("Event").tag(0)
                    Text("Routine").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                VStack (alignment: .leading) {
                    ForEach(vm.plans, id: \.title) { plan in
                        Text(DateFormatter.localizedString(from: plan.date, dateStyle: .medium, timeStyle: .none))
                            .font(.subheadline)
                            .bold()
                            .textCase(.uppercase)
                        
                        PlanCardComponent(plan: plan)
                    }
                }
                .padding(.horizontal, 12)
            }
            .refreshable {
                await vm.refreshPage()
            }
            .navigationTitle("Plan")
            .background(.backgroundView)
        }
        .onAppear {
            Task {
                await vm.getPlans()
            }
        }
    }
}

//struct HomeView_Preview: PreviewProvider {
//    // Create dummy GetAllPlansPreviewUseCase that uses dummyPlans
////    let getAllPlansPreviewUseCase = GetAllPlansPreviewUseCase(planRepository: PlanRepository(dummyPlans: dummyPlans))
////    let viewModel = HomeViewModel(getAllPlansPreviewUseCase: GetAllPlansPreviewUseCase(planRepository: PlanRepository(dummyPlans: dummyPlans)))
//
//    static var previews: some View {
////        HomeView(vm: viewModel)
//        let viewModel = HomeViewModel(getAllPlansPreviewUseCase: GetAllPlansPreviewUseCase(planRepository: PlanRepository(dummyPlans: dummyPlans)))
//                HomeView(vm: viewModel)
//    }
//}
