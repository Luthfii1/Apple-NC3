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
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(plan.title)
                            .shadowedText(font: .body)

                        Text(plan.location.nameLocation.truncated(to: 15))
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
            .frame(minHeight: 100)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Image(plan.backgroundCard ?? "clearCard")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.vertical, 4)
        }
    }
}
