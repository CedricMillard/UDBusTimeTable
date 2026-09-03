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

enum UDBusCountDownBusDirection: String, AppEnum {
    case toPlant
    case toStation
    case autoTime
    //case autoLocation
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Bus Direction"
    }
    
    static var caseDisplayRepresentations: [UDBusCountDownBusDirection : DisplayRepresentation] {
        [
            .toPlant: "towards UD Plan",
            .toStation: "towards Ageo Station",
            .autoTime: "Smart Change (time)"
            //.autoLocation: "Smart Change (location)"
        ]
    }
}

enum UDBusCountDownTrainDirection: String, AppEnum {
    case toOomiya
    case toKagohara
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Train Direction"
    }
    
    static var caseDisplayRepresentations: [UDBusCountDownTrainDirection : DisplayRepresentation] {
        [
            .toOomiya: "towards Oomiya",
            .toKagohara: "towards Kagohara",
        ]
    }
}

struct UDBusCountDownIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "UDBus CountDown Settings"
    static var description: LocalizedStringResource = "Choose next bus or next train countdown"
    
    // An example configurable parameter.
    @Parameter(title: "Countdown for ", default: .bus)
    var countDownType: UDBusCountDownType
    
    @Parameter(title: "Bus Direction", default: .autoTime)
    var BusDirection: UDBusCountDownBusDirection?
    
    @Parameter(title: "Train Direction", default: .toOomiya)
    var TrainDirection: UDBusCountDownTrainDirection?
    
    @Parameter(title: "Avoid ShonanShinjuku or Rapid", default: false)
    var AvoidShonanShinjuku: Bool?
    
    init(){}
    
    init(countDownType: UDBusCountDownType, BusDirection:UDBusCountDownBusDirection, TrainDirection: UDBusCountDownTrainDirection, AvoidShonanShinjuku: Bool) {
        self.countDownType = countDownType
        self.AvoidShonanShinjuku = AvoidShonanShinjuku
        self.BusDirection = BusDirection
        self.TrainDirection = TrainDirection
    }
    
    static var parameterSummary: some ParameterSummary {
        Switch(\.$countDownType){
            Case(.bus){
                Summary{
                    \.$countDownType
                    \.$BusDirection
                }
            }
            Case(.train)
            {
                /*Switch(\.$TrainDirection){
                    Case(.toOomiya) {*/
                        Summary {
                            \.$countDownType
                            \.$TrainDirection
                            \.$AvoidShonanShinjuku
                        }/*
                    }
                    Case(.toKagohara) {
                        Summary{
                            \.$countDownType
                            \.$TrainDirection
                        }
                    }
                    DefaultCase{
                        Summary {
                            \.$countDownType
                            \.$TrainDirection
                        }
                    }
                }*/
            }
            DefaultCase {
                Summary {
                    \.$countDownType
                }
            }
        }
    }

    func perform () async throws -> some IntentResult {
        return .result()
    }
}
