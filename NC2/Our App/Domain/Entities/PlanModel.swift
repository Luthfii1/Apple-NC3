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
    var location: Location
    var weatherPlan: Weather?
    var durationPlan: DurationTimePlan
    var daysRepeat: [DAYS]?
    var planCategory: PLANCATEGORY
    var reminder: REMINDER
    var allDay: Bool
    var suggest: String?
    
    init(
        id: UUID = UUID(),
        title: String = "",
        location: Location = Location(nameLocation: "", detailAddress: "", coordinatePlace: Coordinate(longitude: 0.0, latitude: 0.0)),
        weatherPlan: Weather? = nil,
        durationPlan: DurationTimePlan = DurationTimePlan(start: Date(), end: Date()),
        daysRepeat: [DAYS]? = nil,
        planCategory: PLANCATEGORY = .Event,
        reminder: REMINDER = .None,
        allDay: Bool = false,
        suggest: String? = nil
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.weatherPlan = weatherPlan
        self.durationPlan = durationPlan
        self.daysRepeat = daysRepeat
        self.planCategory = planCategory
        self.reminder = reminder
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
