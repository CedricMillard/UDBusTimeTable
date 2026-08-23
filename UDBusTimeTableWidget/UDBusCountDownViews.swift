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
    
    //@Environment(\.widgetFamily) var family
    
   /* @AppStorage("BusTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var BusTimeBuffer = 5
    @AppStorage("TrainTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var TrainTimeBuffer = 3
    @AppStorage("AvoidShonanShinjuku", store: UserDefaults(suiteName: appGroupSuite)) private var AvoidShonanShinjuku = false
    */
    
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
                //.font(.system(size: 10))
                
        }
        .gaugeStyle(.accessoryCircular)
        /*VStack {
            if entry.type == .bus {
                Text("UD Bus in")
                    .font(.system(size: 10))
            }
            else {
                Text("Train in")
                    .font(.system(size: 10))
            }
            Text(entry.targetDate, style:.timer)
        }*/
    }
}
