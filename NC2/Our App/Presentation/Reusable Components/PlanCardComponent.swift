//
//  PlanCardComponent.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import SwiftUI

struct PlanCardComponent: View {
    var plan: PlanCardEntity
    
    var body: some View {
        NavigationLink(destination:
                        DetailPlanView(vm: DetailPlanViewModel(planDetailUseCase: PlanDetailUseCase(AQIRepository: AQIRepository(AQIRemoteDataSource: AQIRemoteDataSource()), planRepository: DummyPlanRepository(dummyPlans: dummyPlans))),  planId: plan.id)) {
            VStack (alignment: .leading, spacing: 8) {
                HStack (alignment: .top) {
                    VStack (alignment: .leading, spacing: 8) {
                        Text(plan.title)
                            .font(.body)
                            .bold()
                            .foregroundStyle(.default)
                        
                        Text(plan.location)
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
                            Text(plan.durationPlan.start)
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(.default)
                            
                            Text(plan.durationPlan.end)
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
                    
                    Text("\(plan.degree)°")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.default)
                    
                    Text(plan.descriptionWeather)
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
