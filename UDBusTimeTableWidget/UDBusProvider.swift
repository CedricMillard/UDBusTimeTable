//
//  UDBusProvider.swift
//  UDBusTimeTableExtension
//
//  Created by Cedric Millard on 2026/08/10.
//

import WidgetKit
import CoreLocation

func getSampleTimeTable() -> UDBusEntry
{
    let nextBus : [BusData] =  getNext3BusToAgeo(iTime: 17*60+55, BusTimeBuffer: 3)
    let nextTrains:[[TrainData]] = getTrainsFromBuses(iBuses: nextBus, TrainTimeBuffer: 3, iTrainDirection: .toOomiya, AvoidShonanShinjuku: false)
    let timeTable = BusTrainTimeTable(prevBus: nextBus[0], curBus: nextBus[1], nextBus: nextBus[2], prevTrain: nextTrains[0], curTrain: nextTrains[1], nextTrain: nextTrains[2])
    let UDBusSampleEntry = UDBusEntry(date: Date(), timeTable: timeTable, busDirection: .toStation, trainDirection: .toOomiya)
    return UDBusSampleEntry
}

struct UDBusProvider: AppIntentTimelineProvider {
    typealias Entry = UDBusEntry
    typealias Intent = UDBusIntent
    
    private let fetcher = userLocationFetcher()
    
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
        let roundedDate = Calendar.current.date(bySettingHour: currentHour, minute: 0, second: 0, of: currentDate) ?? currentDate
        
        /*
         let customDefaults = UserDefaults(suiteName: appGroupSuite) ?? .standard
         let TrainTimeBuffer = (customDefaults.object(forKey: "TrainTimeBuffer") != nil) ? customDefaults.integer(forKey: "TrainTimeBuffer") : 2
         
         let BusTimeBuffer = (customDefaults.object(forKey: "BusTimeBuffer") != nil) ? customDefaults.integer(forKey: "BusTimeBuffer") : 5
         
         let AvoidShonanShinjuku = (customDefaults.object(forKey: "AvoidShonanShinjuku") != nil) ? customDefaults.bool(forKey: "AvoidShonanShinjuku") : false
         */
        
        var BusDirection = configuration.BusDirection
        var BusTimeBuffer = configuration.BusTimeBuffer ?? 5
        let TrainDirection = configuration.TrainDirection ?? .toOomiya
        let TrainTimeBuffer = configuration.TrainTimeBuffer ?? 3
        let AvoidShonanShinjuku = configuration.AvoidShonanShinjuku ?? false
    
        //fetch user location and compare with plant location
        let locManager = CLLocationManager()
        if BusDirection == .autoLocation && locManager.isAuthorizedForWidgetUpdates {
            let userLocation: CLLocation? = await withCheckedContinuation {continuation in
                fetcher.fetch(accuracy: kCLLocationAccuracyKilometer)  { location in
                    continuation.resume(returning: location)
                }
            }
            if let userLocation = userLocation {
                BusDirection = userLocation.distance(from: CLLocation(latitude: UDPlantLat, longitude: UDPlantLong)) < 1200 ? .toStation : .toPlant
            }
        }
        
        //In case BusDirection is still .autolocation, it means user location is unknown => fallback on time location
        if BusDirection == .autoLocation || BusDirection == .autoTime {
            BusDirection = (currentHour < 12) ? .toPlant : .toStation
        }
        
        var lHourlyTables: [BusTrainTimeTable] = []
        
        if BusDirection == .toStation {
            lHourlyTables = getBusTrainTimeTablePerHour(iHour: currentHour, BusTimeBuffer: BusTimeBuffer, TrainTimeBuffer: TrainTimeBuffer, iTrainDirection: TrainDirection, AvoidShonanShinjuku: AvoidShonanShinjuku, iAddOneExtra: true)
        }
        else {
            BusTimeBuffer = 1
            lHourlyTables = getBusTimeTablePerHour(iHour: currentHour, toPlant:true, BusTimeBuffer: BusTimeBuffer, iAddOneExtra: true)
        }
        
        for item in lHourlyTables {
            var refreshDate = roundedDate
            if item.prevBus.departureTime>0 {
                let prevBusHour = item.prevBus.departureTime / 60
                let prevBusMin = item.prevBus.departureTime % 60
                let busDate = Calendar.current.date(bySettingHour: prevBusHour, minute: prevBusMin, second: 0, of: currentDate) ?? currentDate
                refreshDate = Calendar.current.date(byAdding: .minute, value: 1-BusTimeBuffer, to: busDate) ?? currentDate
            }
            
            let entry = UDBusEntry(date: refreshDate, timeTable: item, busDirection: BusDirection, trainDirection: TrainDirection)
            
            entries.append(entry)
        }
        let timelineUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: roundedDate) ?? currentDate
        return Timeline(entries: entries, policy: .after(timelineUpdateDate))
    }
}

