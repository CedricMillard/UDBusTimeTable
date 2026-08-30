//
//  UDBusCountDownViews.swift
//  UDBusCountDownWidgetExtension
//
//  Created by Erin Millard on 2026/08/23.
//

import WidgetKit
import SwiftUI


struct UDBusCountDownView : View {
    var entry: UDBusCountDownProvider.Entry
    
    var body: some View {
        Gauge(value:1) {
            if entry.type == .bus {
                Text("Bus")
                    .bold()
            }
            else {
                Text("Train")
                    .bold()
            }
        } currentValueLabel: {
            Text(entry.targetDate, style:.timer)
                .frame(maxWidth: .infinity,alignment: .center)
                
        }
        .gaugeStyle(.accessoryCircular)
    }
}
