//
//  PlanCardEntity.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

class PlanCardEntity {
    let title: String
    let date: Date
    let allDay: Bool
    let durationPlan: DurationTimePlan
    let location: String
    let degree: Int
    let descriptionWeather: String
    
    init(title: String, date: Date, allDay: Bool, durationPlan: DurationTimePlan, location: String, degree: Int, descriptionWeather: String) {
        self.title = title
        self.date = date
        self.allDay = allDay
        self.durationPlan = durationPlan
        self.location = location
        self.degree = degree
        self.descriptionWeather = descriptionWeather
    }
}
