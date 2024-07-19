//
//  ReminderEnum.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation

enum REMINDER: String, Codable {
    case None, AtTime, _5MinBefore, _10MinBefore, _15MinBefore, _30MinBefore, _1HourBefore
}
