//
//  WeatherDetailUIModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 27/07/24.
//

import Foundation

struct WeatherDetailUIModel: Identifiable {
    let id = UUID()
    let title: String
    let condition: String
    let iconName: String
    let value: String
    let description: String
}
