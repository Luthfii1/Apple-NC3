//
//  PlanCardComponent.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import SwiftUI

struct PlanCardComponent: View {
    var plan: PlanCardEntity
    @EnvironmentObject var dependencyInjection : DependencyInjection
    
    var body: some View {
        NavigationLink(destination:DetailPlanView(planId: plan.id)
            .environmentObject(dependencyInjection.dummyDetailPlanViewModel())
        ) {
            VStack (alignment: .leading, spacing: 8) {
                HStack (alignment: .top) {
                    VStack (alignment: .leading, spacing: 8) {
                        Text(plan.title)
                            .font(.body)
                            .bold()
                            .foregroundStyle(.default)
                        
                        Text(plan.location.nameLocation)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.locationPlan)
                    }
                    
                    Spacer()
                    
                    if (plan.allDay) {
                        Text("all-day")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.default)
                    } else {
                        VStack (alignment: .trailing, spacing: 8){
                            Text(String(plan.durationPlan.start.formattedTime()))
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(.default)
                            
                            Text(plan.durationPlan.end.formattedTime())
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(.locationPlan)
                        }
                    }
                }
                
                HStack{
                    Image(systemName: "cloud.sun.fill")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.default)
                    
                    Text("\(plan.temperature)°")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.default)
                    
                    Text(plan.weatherDescription)
                        .font(.body)
                        .bold()
                        .foregroundStyle(.default)
                }
                .padding(.vertical, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.card)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    PlanCardComponent(plan: dummyPlansEntity[6])
}
