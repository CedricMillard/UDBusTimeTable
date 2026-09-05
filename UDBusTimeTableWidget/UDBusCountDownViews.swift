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
        ZStack {
            Circle()
                .stroke(Color.primary.opacity(0.1), lineWidth: 6)
                .padding(3)
            
            VStack (alignment: .center) {
                Image(entry.type == .bus ? "busLogo" : "trainLogo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundStyle(.white)
                
                Text(entry.targetDate, style:.timer)
                    .multilineTextAlignment(.center)
                
                if entry.type == .bus {
                    if entry.busDirection == .toPlant {
                        Text("\u{2192}UD")
                            .bold()
                            .font(.caption)
                    }
                    else {
                        Text("\u{2192}Ageo")
                            .bold()
                            .font(.caption)
                    }
                }
                else {
                    if entry.trainDirection == .toOomiya {
                        Text("\u{2192}Oomiya")
                            .bold()
                            .font(.caption)
                    }
                    else {
                        Text("\u{2192}Kago.")
                            .bold()
                            .font(.caption)
                    }
                }
            }
        }
        .containerBackground(.clear, for: .widget)
        /*Gauge(value:1) {
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
        .gaugeStyle(.accessoryCircular)*/
    }
}
