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
                if entry.busDirection == .toPlant {
                    Text("S\u{2192}P")
                        .bold()
                }
                else {
                    Text("S\u{2190}P")
                        .bold()
                }
            }
            else {
                if entry.trainDirection == .toOomiya {
                    Text("\u{2192}Oo")
                        .bold()
                }
                else {
                    Text("\u{2192}Ka")
                        .bold()
                }
            }
        } currentValueLabel: {
            Text(entry.targetDate, style:.timer)
                .frame(maxWidth: .infinity,alignment: .center)
                
        }
        .gaugeStyle(.accessoryCircular)
    }
}
