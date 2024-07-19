//
//  ReminderEnum.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation

enum REMINDER: String, Codable, CaseIterable {
    case None
    case AtTime = "At time of event"
    case _5MinBefore = "5 minutes before"
    case _10MinBefore = "10 minutes before"
    case _15MinBefore = "15 minutes before"
    case _30MinBefore = "30 minutes before"
    case _1HourBefore = "1 hour before"
    case _2HourBefore = "2 hours before"
    case _1DayBefore = "1 day before"
}
