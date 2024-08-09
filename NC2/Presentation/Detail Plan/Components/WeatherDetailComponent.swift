//
//  DescriptionCardDetailPlan.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 27/07/24.
//

import SwiftUI

struct WeatherDetailComponent: View {
    let title: String
    let condition: String
    let iconName: String
    let value: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("\(title)   |   \(condition)   |   ")
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                
                Image(systemName: iconName)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                
                Text("   \(value)   ")
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
            }
            .padding(.top, 12)
            .padding(.leading, 16)
            .padding(.bottom, 8)
            
            Divider()
                .padding(.bottom, 8)
            
            Text(description)
                .font(.caption)
                .foregroundColor(Color.white)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.bgDetailCard)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding(.bottom, 16)
    }
}

//#Preview {
//    WeatherDetailComponent(title: "UV Index", condition: "Good", iconName: "pin.fill", value: "8", description: "description")
//}
