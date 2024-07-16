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
    var timeStart: Date
    var timeEnd: Date
    var allDay: Bool
    var eventPicker: String
    var reminderPicker: String
    var latitude: Double
    var longitude: Double
    var address: String
    var daysRepeat: [DAYS]?
    
    init(id: UUID = UUID(), title: String, location: String, timeStart: Date, timeEnd: Date, allDay: Bool, eventPicker: String, reminderPicker: String, latitude: Double, longitude: Double, address: String, daysRepeat: [DAYS]? = nil) {
        self.id = id
        self.title = title
        self.location = location
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.allDay = allDay
        self.eventPicker = eventPicker
        self.reminderPicker = reminderPicker
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.daysRepeat = daysRepeat
    }
}
