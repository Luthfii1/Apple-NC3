//
//  DetailPlanView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct DetailPlanView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm : DetailPlanViewModel
    var planId: UUID
    
    var body: some View {
        VStack {
            if (vm.state.isLoading) {
                ProgressView("Loading logs...")
            } else {
                VStack (spacing: 4) {
                    Text("Hello, this is Detail Plan View with plan: \(vm.detailPlan.title)")
                    
                    Text("AQI for location \(vm.detailPlan.location.coordinatePlace.longitude);\(vm.detailPlan.location.coordinatePlace.latitude) is \(String( vm.detailPlan.weatherPlan?.AQIndex ?? 0))")
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
