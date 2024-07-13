//
//  WeatherModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation

struct Weather: Codable, Equatable, Hashable{
    var id: UUID = UUID()
    var generalDescription: String
    var hotDegree: Int
    var looksLikeHotDegree: Int
    var UVIndex: Int
    var Percipitation: Int
    var AQIndex: Int?
}
