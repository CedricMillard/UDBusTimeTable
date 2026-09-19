//
//  HourlyContentView.swift
//  UDBusTimeTable
//
//  Created by Cedric Millard on 19/09/2026.
//

import SwiftUI


struct HourlyContentView: View {
    let hour: Int
    let isBusToPlant: Bool
    
    @Binding var currentTime: Int
    
    @AppStorage("BusTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var BusTimeBuffer = 1
    @AppStorage("TrainTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var TrainTimeBuffer = 3
    @AppStorage("TrainDirection", store: UserDefaults(suiteName: appGroupSuite)) private var TrainDirection = "Oomiya"
    @AppStorage("AvoidShonanShinjuku", store: UserDefaults(suiteName: appGroupSuite)) private var AvoidShonanShinjuku = false
    
    var body: some View {
        
        let lHourlyTables: [BusTrainTimeTable] = getTimeTable()
        let nextBusIndex: Int = getNextBusIndex()
        let nextBus = getBusFromIndex(iIndex: nextBusIndex, isBusToPlant: isBusToPlant)
        
        ScrollView{
            VStack {
                HStack(spacing:50) {
                    Text("Bus")
                        .bold()
                        .frame(width:100)
                    if !isBusToPlant && TrainDirection != "No Train" {
                        Text("Train")
                            .bold()
                            .frame(width:100)
                    }
                }
                Divider()
                ForEach(lHourlyTables) { item in
                    HStack (spacing:50){
                        
                        Text(timeToString(iTime: item.curBus.departureTime))
                            .foregroundColor(getBusFontColor(iIsOperateRedDays: item.curBus.isActiveRedDays))
                            .frame(width:100)
                        if !isBusToPlant && TrainDirection != "No Train" {
                            if (item.curTrain.count==1){
                                Text(timeToString(iTime: item.curTrain[0].departureTime))
                                    .foregroundColor(getTrainFontColor(iIsShonan: item.curTrain[0].isShonan))
                                    .frame(width:100)
                            }
                            else {
                                VStack{
                                    Text(timeToString(iTime: item.curTrain[1].departureTime))
                                        .foregroundColor(getTrainFontColor(iIsShonan: item.curTrain[1].isShonan))
                                    
                                    Text("("+timeToString(iTime: item.curTrain[0].departureTime)+")")
                                        .font(.footnote)
                                        .foregroundColor(getTrainFontColor(iIsShonan: item.curTrain[0].isShonan))
                                }
                                .frame(width:100)
                            }
                        }
                    }
                    .bold(item.curBus.departureTime == nextBus.departureTime)
                    .padding((item.curBus.departureTime == nextBus.departureTime && nextBus.departureTime > 0) ? 2 : 0)
                    .border((item.curBus.departureTime == nextBus.departureTime && nextBus.departureTime > 0) ? Color.green : Color.clear)
                    Divider()
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
    
    func getTrainDirectionFromString (iDirection:String) -> UDBusTrainDirection {
        var TrainDirection:UDBusTrainDirection
        switch iDirection {
        case "Oomiya":
            TrainDirection = .toOomiya
        case "Kagohara":
            TrainDirection = .toKagohara
        case "No Train":
            TrainDirection = .noTrain
        default:
            TrainDirection = .noTrain
        }
        return TrainDirection
    }
    
    func getTimeTable() -> [BusTrainTimeTable] {
        var lHourlyTables: [BusTrainTimeTable] = []
        let TrainDirection2 = getTrainDirectionFromString (iDirection: TrainDirection)
        
        if isBusToPlant {
            lHourlyTables = getBusTimeTablePerHour(iHour: hour, toPlant:true, BusTimeBuffer: 0, iAddOneExtra: false)
        }
        else {
            lHourlyTables = getBusTrainTimeTablePerHour(iHour: hour, BusTimeBuffer: BusTimeBuffer, TrainTimeBuffer: TrainTimeBuffer, iTrainDirection: TrainDirection2, AvoidShonanShinjuku: AvoidShonanShinjuku, iAddOneExtra: false)
        }
        return lHourlyTables
    }
    
    func getNextBusIndex() -> Int {
        var nextBusIndex:Int = 0
        if isBusToPlant {
            nextBusIndex = getNextBusToPlant(iTime: currentTime)
        }
        else {
            nextBusIndex = getNextBusToAgeo(iTime: currentTime, BusTimeBuffer: BusTimeBuffer)
        }
        return nextBusIndex
    }
}
