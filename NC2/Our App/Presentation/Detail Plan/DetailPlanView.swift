//
//  DetailPlanView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct DetailPlanView: View {
    @StateObject var vm : DetailPlanViewModel
    var planId: UUID
    
    var body: some View {
        NavigationView {
            if (vm.state.isLoading) {
                ProgressView("Loading logs...")
            } else {
                VStack (spacing: 4) {
                    Text("Hello, this is Detail Plan View with plan: \(vm.detailPlan.title)")
                    
                    Text("AQI for location \(vm.detailPlan.coordinatePlace.longitude);\(vm.detailPlan.coordinatePlace.latitude) is \(String( vm.detailPlan.weatherPlan?.AQIndex ?? 0))")
                }
            }
        }
        .navigationTitle("Detail Plan")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            Task {
                await vm.getDetailPlan(planId: planId)
            }
        }
    }
}

//#Preview {
//    DetailPlanView()
//}
