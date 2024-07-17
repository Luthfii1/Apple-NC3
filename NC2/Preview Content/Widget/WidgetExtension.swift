//
//  widgetBundle.swift
//  widget
//
//  Created by Syafrie Bachtiar on 14/07/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtension: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MainWidget()
    }
}

struct MainWidget: Widget {
    let kind: String = "MainWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Main Widget")
        .description("This is an example widget.")
    }
}
