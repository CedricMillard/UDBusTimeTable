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
    let UDBusCountDownSampleEntry = UDBusCountDownEntry(date: Date(), targetDate: targetDate, type: .bus)
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
    
    func timeline(for configuration:UDBusCountDownIntent, in context: Context) async -> Timeline<Entry> {
        
        var entries: [UDBusCountDownEntry] = []
        
        let currentDate = Date()
        let currentHour = (Calendar.current.component(.hour, from: currentDate))
        
        let CountDownType = configuration.countDownType
        let AvoidShonanShinjuku = configuration.AvoidShonanShinjuku
        
        
        let listDates: [Date] = getBusOrTrainDatePerHour (iHour: currentHour, iBus: (CountDownType==UDBusCountDownType.bus),iAvoidShonanShinjuku: AvoidShonanShinjuku, iAddOneExtra: true)
        
        var prevDate = Calendar.current.date(bySettingHour: currentHour, minute: 0, second: 0, of: currentDate) ?? currentDate
        
        for item in listDates {
            
            let entry = UDBusCountDownEntry(date: prevDate, targetDate: item, type: CountDownType)
            entries.append(entry)
            prevDate = item
            
        }
        let roundedDate = Calendar.current.date(bySettingHour: currentHour, minute: 0, second: 0, of: currentDate) ?? currentDate
        let timelineUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: roundedDate) ?? currentDate
        return Timeline(entries: entries, policy: .after(timelineUpdateDate))
    }

}
