//
//  WidgetPlanModel.swift
//  Widget&Notif
//
//  Created by Syafrie Bachtiar on 17/07/24.
//

import Foundation

struct WidgetPlanModel: Codable, Identifiable {
    let id: UUID
    let title: String
    let temprature: Double
    let durationPlan: String
    let allDay: Bool
}
