//
//  WidgetPlanModel.swift
//  Widget&Notif
//
//  Created by Syafrie Bachtiar on 17/07/24.
//

import Foundation

struct WidgetPlanModel: Codable, Identifiable {
    var id: UUID
    var title: String
    var temprature: Double
    var durationPlan: Date
    var allDay: Bool
}
