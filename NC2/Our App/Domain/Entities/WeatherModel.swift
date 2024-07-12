//
//  WeatherModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation
import SwiftData

@Model
class Weather: Identifiable, Equatable, Hashable{
    var id: UUID
    var generalDescription: String
    var hotDegree: Int
    var looksLikeHotDegree: Int
    var UVIndex: Int
    var Percipitation: Int
    var AQIndex: Int?
    
    init(id: UUID = UUID(), generalDescription: String, hotDegree: Int, looksLikeHotDegree: Int, UVIndex: Int, Percipitation: Int, AQIndex: Int? = nil) {
        self.id = id
        self.generalDescription = generalDescription
        self.hotDegree = hotDegree
        self.looksLikeHotDegree = looksLikeHotDegree
        self.UVIndex = UVIndex
        self.Percipitation = Percipitation
        self.AQIndex = AQIndex
    }
}
