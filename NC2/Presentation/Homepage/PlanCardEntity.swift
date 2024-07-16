//
//  PlanCardEntity.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

class PlanCardEntity: Identifiable {
    var id: UUID
    let title: String
    let allDay: Bool
    let durationPlan: DurationTimePlan
    let location: Location
    let temperature: Int
    let weatherDescription: String
    let backgroundCard: String
    
    init(id: UUID, title: String, allDay: Bool, durationPlan: DurationTimePlan, location: Location, temperature: Int, weatherDescription: String, backgroundCard: String) {
        self.id = id
        self.title = title
        self.allDay = allDay
        self.durationPlan = durationPlan
        self.location = location
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.backgroundCard = backgroundCard
    }
}
