//
//  UDBusCountDownWidget.swift
//  UDBusCountDownWidget
//
//  Created by Cedric Millard on 2026/08/23.
//

import WidgetKit
import SwiftUI

func getSampleCountDown() -> UDBusCountDownEntry
{
    let curDate = Date()
    let targetDate = Calendar.current.date(byAdding: .minute, value: 3, to: curDate) ?? curDate
    let UDBusCountDownSampleEntry = UDBusCountDownEntry(date: Date(), targetDate: targetDate, type: .bus, busDirection: .toStation, trainDirection: .toOomiya)
    return UDBusCountDownSampleEntry
}

struct UDBusCountDownProvider: AppIntentTimelineProvider {
    typealias Entry = UDBusCountDownEntry
    typealias Intent = UDBusCountDownIntent
    
    func placeholder(in context: Context) -> UDBusCountDownEntry {
        getSampleCountDown()
    }
    
    func snapshot(for configuration:UDBusCountDownIntent, in context: Context) async-> UDBusCountDownEntry {
        
        getSampleCountDown()
    }
    
    //Return the data needed for the widget for a full hour
    // iHour = hour (eg 18 for 18Hxx)
    // iBus = if true return but time, if false return train time
    // iAddOneExtra = add next bus from next hour for the widget
    func getBusOrTrainDatePerHour(iHour:Int, CountDownType: UDBusCountDownType, iAvoidShonanShinjuku: Bool, iBusDirection: UDBusCountDownBusDirection, iTrainDirection: UDBusCountDownTrainDirection, iAddOneExtra:Bool)->[UDBusCountDownEntry] {
        var listDates: [UDBusCountDownEntry]=[]
        var listTimes: [CountDownDataRaw]=[]
        if(CountDownType==UDBusCountDownType.bus) {
            listTimes = getBusTimePerHour(iHour: iHour, isBusToPlant:iBusDirection == .toPlant, iAddOneExtra: iAddOneExtra)
        }
        else {
            listTimes = getTrainTimePerHour(iHour: iHour, iAvoidShonanShinjuku: iAvoidShonanShinjuku, iAddOneExtra: iAddOneExtra)
        }
        
        for item in listTimes {
            listDates.append(UDBusCountDownEntry(date: time2Date(iTime: item.updateTime), targetDate: time2Date(iTime: item.departureTime), type: CountDownType, busDirection: iBusDirection, trainDirection: iTrainDirection))
        }
        return listDates
    }

    func timeline(for configuration:UDBusCountDownIntent, in context: Context) async -> Timeline<Entry> {
        
        let currentDate = Date()
        let currentHour = (Calendar.current.component(.hour, from: currentDate))
        
        let CountDownType = configuration.countDownType
        let AvoidShonanShinjuku = configuration.AvoidShonanShinjuku
        var BusDirection = configuration.BusDirection
        let TrainDirection = configuration.TrainDirection
        
        if BusDirection == .autoTime {
            BusDirection = (currentHour < 12) ? .toPlant : .toStation
        }
        
        let entries: [UDBusCountDownEntry] = getBusOrTrainDatePerHour (iHour: currentHour, CountDownType: CountDownType,iAvoidShonanShinjuku: AvoidShonanShinjuku ?? false, iBusDirection: BusDirection ?? .toStation, iTrainDirection: TrainDirection ?? .toOomiya, iAddOneExtra: true)
        
        let roundedDate = Calendar.current.date(bySettingHour: currentHour, minute: 0, second: 0, of: currentDate) ?? currentDate
        let timelineUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: roundedDate) ?? currentDate
        return Timeline(entries: entries, policy: .after(timelineUpdateDate))
    }

}
