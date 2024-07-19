//
//  WidgetExtension_Previews.swift
//  widgetExtension
//
//  Created by Syafrie Bachtiar on 17/07/24.
//

import SwiftUI
import WidgetKit

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExtensionEntryView(entry: SimpleEntry(date: Date(), widgetPlan: WidgetPlanModel(id: UUID(), title: "Preview", temprature: Double(Int(22.5)), durationPlan: Date(), allDay: true)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
