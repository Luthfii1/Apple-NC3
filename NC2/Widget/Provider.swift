//
//  widget.swift
//  widget
//
//  Created by Syafrie Bachtiar on 14/07/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetPlan: WidgetPlanModel(id: UUID(), title: "Placeholder", temprature: Int(0.0), durationPlan: Date(), allDay: false))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), widgetPlan: loadWidgetPlanModel() ?? WidgetPlanModel(id: UUID(), title: "Snapshot", temprature: Int(0.0), durationPlan: Date(), allDay: false))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, widgetPlan: loadWidgetPlanModel() ?? WidgetPlanModel(id: UUID(), title: "Timeline", temprature: Int(0.0), durationPlan: Date(), allDay: false))
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func loadWidgetPlanModel() -> WidgetPlanModel? {
        if let sharedDefaults = UserDefaults(suiteName: AppGroupManager.suiteName),
           let savedModel = sharedDefaults.object(forKey: "widgetPlanModel") as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(WidgetPlanModel.self, from: savedModel)
        }
        return nil
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetPlan: WidgetPlanModel
}
