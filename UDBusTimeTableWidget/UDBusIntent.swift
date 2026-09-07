//
//  UDBusIntent.swift
//  UDBusTimeTableWidgetExtension
//
//  Created by Cedric Millard on 2026/08/21.
//

import AppIntents

struct UDBusIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "UD Bus Widget Settings"
    static var description: LocalizedStringResource = "Configure buffer time for bus and train"
    
    @Parameter(title: "Bus Time Buffer", default: 5)
    var BusTimeBuffer: Int
   
    @Parameter(title: "Train Time Buffer", default: 3)
    var TrainTimeBuffer: Int
    
    @Parameter(title: "Train Direction", default: .toOomiya)
    var TrainDirection: UDBusCountDownTrainDirection
    
    @Parameter(title: "Avoid Shonan-Shinjuku or Rapid train", default: false)
    var AvoidShonanShinjuku: Bool
    
    init(){}
    
    init(BusTimeBuffer: Int, TrainTimeBuffer: Int, TrainDirection:UDBusCountDownTrainDirection, AvoidShonanShinjuku: Bool) {
        self.BusTimeBuffer = BusTimeBuffer
        self.TrainTimeBuffer = TrainTimeBuffer
        self.TrainDirection = TrainDirection
        self.AvoidShonanShinjuku = AvoidShonanShinjuku
    }

    func perform () async throws -> some IntentResult {
        return .result()
    }
}
