//
//  AppIntent.swift
//  UDBusCountDownWidget
//
//  Created by Cedric Millard on 2026/08/23.
//

import WidgetKit
import AppIntents


enum UDBusCountDownType: String, AppEnum {
    case bus
    case train
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Countdown Type"
    }
    
    static var caseDisplayRepresentations: [UDBusCountDownType : DisplayRepresentation] {
        [
            .bus: "Next Bus",
            .train: "Next Train"
        ]
    }
}

struct UDBusCountDownIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "UDBus CountDown Settings"
    static var description: LocalizedStringResource = "Choose next bus or next train countdown"
    
    // An example configurable parameter.
    @Parameter(title: "Countdown for ", default: .bus)
    var countDownType: UDBusCountDownType
    
    @Parameter(title: "AvoidShonanShinjuku", default: false)
    var AvoidShonanShinjuku: Bool
    
    init(){}
    
    init(countDownType: UDBusCountDownType, AvoidShonanShinjuku: Bool) {
        self.countDownType = countDownType
        self.AvoidShonanShinjuku = AvoidShonanShinjuku
    }

    func perform () async throws -> some IntentResult {
        return .result()
    }
}
