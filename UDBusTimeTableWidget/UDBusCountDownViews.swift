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
    
    func getDeltaTimeSec() -> Int {
        guard Date()<entry.targetDate else {
            return -1
        }
        return Int(DateInterval(start: Date(), end: entry.targetDate).duration)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primary.opacity(0.3), lineWidth: 6)
                .padding(3)
            
            VStack (alignment: .center) {
                Image(entry.type == .bus ? "busLogo" : "trainLogo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundStyle(.white)
                
                let deltaT = getDeltaTimeSec()
                if deltaT < 3600 && deltaT >= 0 {
                    Text(entry.targetDate, style:.timer)
                        .multilineTextAlignment(.center)
                }
                else {
                    Text("--:--")
                        .multilineTextAlignment(.center)
                }
                
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
    }
}
