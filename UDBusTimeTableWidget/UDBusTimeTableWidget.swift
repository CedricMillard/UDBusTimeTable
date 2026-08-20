//
//  UDBusTimeTable.swift
//  UDBusTimeTable
//
//  Created by Erin Millard on 2026/08/10.
//

import WidgetKit
import SwiftUI


//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }

@main
struct UDBusTimeTableWidget: Widget {
    let kind: String = "UDBusTimeTableWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UDBusProvider()) { entry in
            if #available(iOS 17.0, *) {
                UDBusWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                UDBusWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("UD Bus/Train Timetable Widget")
        .description("Widget showing the next bus and connecting train from UD Ageo towards Oomiya")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    UDBusTimeTableWidget()
} timeline: {
    getSampleTimeTable()
}
