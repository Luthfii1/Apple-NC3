//
//  PlanCardComponent.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import SwiftUI

struct PlanCardComponent: View {
    var plan: HomeCardUIModel
    
    var body: some View {
        NavigationLink(destination: DetailPlanView(planId: plan.id)
            .environmentObject(DependencyInjection.shared.detailPlanViewModel())
        ) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(plan.title)
                        .shadowedText(font: .body)
                    
                    Spacer()
                    
                    if plan.allDay {
                        Text("All Day")
                            .shadowedText(font: .subheadline)
                    } else {
                        Text("\(plan.durationPlan.start.formattedTime24Hour()) - \(plan.durationPlan.end.formattedTime24Hour())")
                            .shadowedText(font: .subheadline)
                    }
                }
                
                Text(plan.location.nameLocation.truncated(to: 15))
                    .shadowedText(font: .subheadline)
                
                
                
                HStack {
                    Image(systemName: "cloud.sun.fill")
                        .shadowedText(font: .body)
                    
                    Text("\(Int(ceil(plan.temperature ?? 0)))°C")
                        .shadowedText(font: .body)
                    
                    Text(plan.weatherDescription?.toFrontCapital() ?? "fetching data")
                        .shadowedText(font: .body)
                }
                .padding(.vertical, 4)
            }
            .frame(height: 120)
            .padding(.horizontal, 16)
            .background(
                Image(plan.backgroundCard ?? "clearCard")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
