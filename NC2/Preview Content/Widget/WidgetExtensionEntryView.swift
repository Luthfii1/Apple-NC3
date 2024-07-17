//
//  WidgetExtensionEntryView.swift
//  NC2
//
//  Created by Syafrie Bachtiar on 17/07/24.
//

import SwiftUI

struct WidgetExtensionEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.widgetPlan.title)
            Text("Temp: \(entry.widgetPlan.temprature)")
            Text("Duration: \(entry.widgetPlan.durationPlan)")
            Text(entry.widgetPlan.allDay ? "All Day" : "Not All Day")
        }
        .containerBackground(Color(UIColor.systemBackground), for: .widget)
    }
}

