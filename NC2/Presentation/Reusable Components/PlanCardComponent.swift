//
//  PlanCardComponent.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import SwiftUI

struct PlanCardComponent: View {
    var plan: HomeCardUIModel
    @EnvironmentObject var dependencyInjection: DependencyInjection
    
    var body: some View {
        NavigationLink(destination: DetailPlanView(planId: plan.id)
            .environmentObject(dependencyInjection.detailPlanViewModel())
        ) {
            ZStack {
                Image(plan.backgroundCard ?? "clearCard")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(plan.title)
                                .shadowedText(font: .body)
                            
                            Text(plan.location.nameLocation)
                                .shadowedText(font: .subheadline)
                        }
                        
                        Spacer()
                        
                        if plan.allDay {
                            Text("All Day")
                                .shadowedText(font: .subheadline)
                        } else {
                            VStack(alignment: .trailing, spacing: 8) {
                                Text(plan.durationPlan.start.formattedTime())
                                    .shadowedText(font: .subheadline)
                                
                                Text(plan.durationPlan.end.formattedTime())
                                    .shadowedText(font: .subheadline)
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "cloud.sun.fill")
                            .shadowedText(font: .body)
                        
                        Text("\(String(format: "%.1f", plan.temperature ?? 0))°C")
                            .shadowedText(font: .body)
                        
                        Text(plan.weatherDescription?.toFrontCapital() ?? "fetching data")
                            .shadowedText(font: .body)
                    }
                    .padding(.vertical, 4)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .padding(.vertical, 4)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    PlanCardComponent(plan: dummyPlansEntity[6])
}
