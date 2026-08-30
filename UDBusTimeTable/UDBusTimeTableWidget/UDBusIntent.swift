//
//  UDBusIntent.swift
//  UDBusTimeTableWidgetExtension
//
//  Created by Cedric Millard on 2026/08/21.
//

import AppIntents

struct UDBusIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "UDBus Widget Settings"
    static var description: LocalizedStringResource = "Configure buffer time for bus and train"
    
    @Parameter(title: "BusTimeBuffer", default: 5)
    var BusTimeBuffer: Int
   
    @Parameter(title: "TrainTimeBuffer", default: 3)
    var TrainTimeBuffer: Int
    
    @Parameter(title: "AvoidShonanShinjuku", default: false)
    var AvoidShonanShinjuku: Bool
    
    init(){}
    
    init(BusTimeBuffer: Int, TrainTimeBuffer: Int, AvoidShonanShinjuku: Bool) {
        self.BusTimeBuffer = BusTimeBuffer
        self.TrainTimeBuffer = TrainTimeBuffer
        self.AvoidShonanShinjuku = AvoidShonanShinjuku
    }

    func perform () async throws -> some IntentResult {
        return .result()
    }
}
