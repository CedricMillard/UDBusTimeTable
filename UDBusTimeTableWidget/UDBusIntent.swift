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
    
    @Parameter(title: "Bus Direction", default: .autoTime)
    var BusDirection: UDBusCountDownBusDirection
    
    @Parameter(title: "Bus Time Buffer (minute)", default: 1)
    var BusTimeBuffer: Int?
   
    @Parameter(title: "Train Direction", default: .toOomiya)
    var TrainDirection: UDBusTrainDirection?
    
    @Parameter(title: "Train Time Buffer (minute)", default: 3)
    var TrainTimeBuffer: Int?
    
    @Parameter(title: "Avoid Shonan-Shinjuku or Rapid train", default: false)
    var AvoidShonanShinjuku: Bool?
    
    init(){}
    
    init(BusDirection: UDBusCountDownBusDirection, BusTimeBuffer: Int, TrainDirection:UDBusTrainDirection, TrainTimeBuffer: Int, AvoidShonanShinjuku: Bool) {
        self.BusDirection = BusDirection
        self.BusTimeBuffer = BusTimeBuffer
        self.TrainDirection = TrainDirection
        self.TrainTimeBuffer = TrainTimeBuffer
        self.AvoidShonanShinjuku = AvoidShonanShinjuku
    }

    static var parameterSummary: some ParameterSummary {
        Switch(\.$BusDirection){
            Case(.toPlant){
                Summary{
                    \.$BusDirection
                }
            }
            DefaultCase {
                Switch(\.$TrainDirection) {
                    Case(.noTrain) {
                        Summary {
                            \.$BusDirection
                            \.$BusTimeBuffer
                            \.$TrainDirection
                        }
                    }
                    DefaultCase {
                        Summary {
                            \.$BusDirection
                            \.$BusTimeBuffer
                            \.$TrainDirection
                            \.$TrainTimeBuffer
                            \.$AvoidShonanShinjuku
                        }
                    }
                }
            }
        }
    }
    
    func perform () async throws -> some IntentResult {
        return .result()
    }
}
