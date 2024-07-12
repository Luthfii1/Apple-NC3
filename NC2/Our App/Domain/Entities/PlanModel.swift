//
//  PlanModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class PlanModel: Identifiable, Equatable, Hashable{
    var id: UUID
    var title: String
    var location: String
    var address: String
    var coordinatePlace: CLLocationCoordinate2D
    var weatherPlan: Weather?
    var timeStart: Date
    var timeEnd: Date
    var suggest: String?
    
    init(id: UUID = UUID(), title: String, location: String, address: String, coordinatePlace: CLLocationCoordinate2D, weatherPlan: Weather? = nil, timeStart: Date, timeEnd: Date, suggest: String? = nil) {
        self.id = id
        self.title = title
        self.location = location
        self.address = address
        self.coordinatePlace = coordinatePlace
        self.weatherPlan = weatherPlan
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.suggest = suggest
    }
}
