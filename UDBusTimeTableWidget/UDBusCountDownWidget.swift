//
//  UDBusCountDownWidgetBundle.swift
//  UDBusCountDownWidget
//
//  Created by Cedric Millard on 2026/08/23.
//

import WidgetKit
import SwiftUI

struct UDBusCountDownWidget: Widget {
    let kind: String = "UDBusCountDownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent:UDBusCountDownIntent.self, provider: UDBusCountDownProvider()) { entry in
            if #available(iOS 17.0, *) {
                UDBusCountDownView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                UDBusCountDownView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("UD Bus Train count-down Widget")
        .description("Widget showing the time left to the next bus or train from UD Ageo Plant towards Oomiya")
        .supportedFamilies([.accessoryCircular])
    }
}

#Preview(as: .systemSmall) {
    UDBusCountDownWidget()
} timeline: {
    getSampleCountDown()
}
