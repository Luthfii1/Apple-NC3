//
//  PlanModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import Foundation
import SwiftData

@Model
class PlanModel: Identifiable, Equatable, Hashable {
    var id: UUID
    var title: String
    var location: String
    var address: String
    var coordinatePlace: Coordinate
    var weatherPlan: Weather?
    var durationPlan: DurationTimePlan
    var isRepeat: Bool
    var date: Date
    var allDay: Bool
    var suggest: String?
    
    init(id: UUID = UUID(), title: String, location: String, address: String, coordinatePlace: Coordinate, weatherPlan: Weather? = nil, duration: DurationTimePlan, isRepeat: Bool, date: Date, allDay: Bool, suggest: String? = nil) {
        self.id = id
        self.title = title
        self.location = location
        self.address = address
        self.coordinatePlace = coordinatePlace
        self.weatherPlan = weatherPlan
        self.durationPlan = duration
        self.isRepeat = isRepeat
        self.date = date
        self.allDay = allDay
        self.suggest = suggest
    }
    
    static func == (lhs: PlanModel, rhs: PlanModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
