//
//  UDBusProvider.swift
//  UDBusTimeTableExtension
//
//  Created by Cedric Millard on 2026/08/10.
//

import WidgetKit

func getSampleTimeTable() -> UDBusEntry
{
    let nextBus : [BusData] =  getNext3BusToAgeo(iTime: 17*60+55, BusTimeBuffer: 3)
    let nextTrains:[[TrainData]] = getTrainsFromBuses(iBuses: nextBus, TrainTimeBuffer: 3, AvoidShonanShinjuku: false)
    let timeTable = BusTrainTimeTable(prevBus: nextBus[0], curBus: nextBus[1], nextBus: nextBus[2], prevTrain: nextTrains[0], curTrain: nextTrains[1], nextTrain: nextTrains[2])
    let UDBusSampleEntry = UDBusEntry(date: Date(), timeTable: timeTable)
    return UDBusSampleEntry
}


/*struct UDBusProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> UDBusEntry {
        return getSampleTimeTable()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (UDBusEntry) -> ()) {
        
        completion(getSampleTimeTable())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("Call getTimeline")
        var entries: [UDBusEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let currentHour = (Calendar.current.component(.hour, from: currentDate))
        
        let customDefaults = UserDefaults(suiteName: appGroupSuite) ?? .standard
        let TrainTimeBuffer = (customDefaults.object(forKey: "TrainTimeBuffer") != nil) ? customDefaults.integer(forKey: "TrainTimeBuffer") : 2
        
        let BusTimeBuffer = (customDefaults.object(forKey: "BusTimeBuffer") != nil) ? customDefaults.integer(forKey: "BusTimeBuffer") : 5
        
        let AvoidShonanShinjuku = (customDefaults.object(forKey: "AvoidShonanShinjuku") != nil) ? customDefaults.bool(forKey: "AvoidShonanShinjuku") : false
        
        print("TrainBuffer=\(TrainTimeBuffer) / BusBuffer=\(BusTimeBuffer) / AvoidShonan=\(AvoidShonanShinjuku)")
        
        let lHourlyTables: [BusTrainTimeTable] = getTimeTablePerHour(iHour: currentHour, TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku, iAddOneExtra: true)
        for item in lHourlyTables {
            var refreshDate = currentDate
            if item.prevBus.departureTime>0 {
                let prevBusHour = item.prevBus.departureTime / 60
                let prevBusMin = item.prevBus.departureTime % 60
                let busDate = Calendar.current.date(bySettingHour: prevBusHour, minute: prevBusMin, second: 0, of: currentDate) ?? currentDate
                refreshDate = Calendar.current.date(byAdding: .minute, value: 1-BusTimeBuffer, to: busDate) ?? currentDate
            }
            
            let entry = UDBusEntry(date: refreshDate, timeTable: item)
            entries.append(entry)
        }
        let roundedDate = Calendar.current.date(bySettingHour: currentHour, minute: 0, second: 0, of: currentDate) ?? currentDate
        let timelineUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: roundedDate) ?? currentDate
        let timeline = Timeline(entries: entries, policy: .after(timelineUpdateDate))
        completion(timeline)
    }
}*/

struct UDBusProvider: AppIntentTimelineProvider {
    typealias Entry = UDBusEntry
    typealias Intent = UDBusIntent
    
    func placeholder(in context: Context) -> UDBusEntry {
        getSampleTimeTable()
    }
    
    func snapshot(for configuration:UDBusIntent, in context: Context) async-> UDBusEntry {
        
        getSampleTimeTable()
    }
    
    func timeline(for configuration:UDBusIntent, in context: Context) async -> Timeline<Entry> {
        
        var entries: [UDBusEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let currentHour = (Calendar.current.component(.hour, from: currentDate))
        
        let TrainTimeBuffer = configuration.TrainTimeBuffer
        let BusTimeBuffer = configuration.BusTimeBuffer
        let AvoidShonanShinjuku = configuration.AvoidShonanShinjuku
        
        let lHourlyTables: [BusTrainTimeTable] = getTimeTablePerHour(iHour: currentHour, BusTimeBuffer: BusTimeBuffer, TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku, iAddOneExtra: true)
        for item in lHourlyTables {
            var refreshDate = currentDate
            if item.prevBus.departureTime>0 {
                let prevBusHour = item.prevBus.departureTime / 60
                let prevBusMin = item.prevBus.departureTime % 60
                let busDate = Calendar.current.date(bySettingHour: prevBusHour, minute: prevBusMin, second: 0, of: currentDate) ?? currentDate
                refreshDate = Calendar.current.date(byAdding: .minute, value: 1-BusTimeBuffer, to: busDate) ?? currentDate
            }
            
            let entry = UDBusEntry(date: refreshDate, timeTable: item)
            entries.append(entry)
        }
        let roundedDate = Calendar.current.date(bySettingHour: currentHour, minute: 0, second: 0, of: currentDate) ?? currentDate
        let timelineUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: roundedDate) ?? currentDate
        return Timeline(entries: entries, policy: .after(timelineUpdateDate))
    }
}

