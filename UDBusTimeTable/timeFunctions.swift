//
//  TimeTables.swift
//  AgeoBusTimeTable
//
//  Created by Cedric Millard on 2026/06/22.
//
// Bus: return time of this bus and the next one (convenient for the widget).
//  advcanced version: manage the red days
// Train: return an array with id of next train and next next train if there is a risk to miss it
//    criteria: bus trip more than 10 minutes and time to catch less than 3 minutes
//    //  advcanced version: manage the red days

import Foundation
import SwiftUI

let stdBusDuration = 9

let appGroupSuite = "group.CMillard.UDBusTimetable"

struct BusData: Hashable, Codable {
    let departureTime : Int
    let duration : Int
    var isActiveRedDays : Bool = true
}

struct TrainData: Hashable, Codable, Identifiable {
    let id = UUID()
    let departureTime : Int
    let isShonan : Bool
}

struct BusTrainTimeTable: Hashable, Codable, Identifiable {
    let id = UUID()
    let prevBus : BusData
    let curBus : BusData
    let nextBus : BusData
    
    let prevTrain : [TrainData]
    let curTrain : [TrainData]
    let nextTrain : [TrainData]
}

func timeToString(iTime: Int) -> String {
    if (iTime<0){
        return "--:--"
    }
    var sHour = String(iTime/60)
    if(sHour.count < 2) {sHour = "0" + sHour}
    
    var sMin = String(iTime%60)
    if(sMin.count < 2) {sMin = "0" + sMin}
    
    return sHour + ":" + sMin
}

func getBusFromIndex(iIndex: Int)->BusData {
    var bus = BusData(departureTime:-1,duration:-1)
    if iIndex>=0 && iIndex<UDtoAgeo.count {
        bus = UDtoAgeo[iIndex]
    }
    return bus
}

// Return the index of the best bus
func getNextBusToAgeo(iTime: Int, BusTimeBuffer:Int)->Int {
    var result = -1
    for i in 0..<UDtoAgeo.count {
        if iTime + BusTimeBuffer <= UDtoAgeo[i].departureTime {
            result = i
            break
        }
    }
    return result
}

func getNext3BusToAgeo(iTime: Int, BusTimeBuffer: Int)->[BusData] {
    let curBusIndex = getNextBusToAgeo(iTime: iTime, BusTimeBuffer: BusTimeBuffer)
    var curBusTime = BusData(departureTime:-1,duration:-1)
    var prevBusTime = BusData(departureTime:-1,duration:-1)
    var nextBusTime = BusData(departureTime:-1,duration:-1)
    
    if curBusIndex>=0 {
        curBusTime = UDtoAgeo[curBusIndex]
        
        if curBusIndex-1>=0 {
            prevBusTime = UDtoAgeo[curBusIndex-1]
        }

        if curBusIndex+1<UDtoAgeo.count {
            nextBusTime = UDtoAgeo[curBusIndex+1]
        }
    }
    else if iTime>0 {
        prevBusTime = UDtoAgeo[UDtoAgeo.count - 1]
    }

    return [prevBusTime, curBusTime, nextBusTime]
}

func getTrainsFromBuses(iBuses: [BusData], TrainTimeBuffer:Int, AvoidShonanShinjuku: Bool)->[[TrainData]] {
    var trains:[[TrainData]] = []

    for bus in iBuses {
            trains.append(getNextTrainFromAgeoBus(iBus: bus, TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku))
    }

    return trains
}

func getNextTrainFromAgeoBus(iBus: BusData, TrainTimeBuffer:Int, AvoidShonanShinjuku:Bool)->[TrainData] {

    var trains:[TrainData] = []
    var busDuration = stdBusDuration

    if(iBus.departureTime < 0) {
        trains.append(TrainData(departureTime: -1, isShonan: false))
    }
    else
    {    
        for i in 0..<TrainFromAgeo.count {
            //First try with standard bus duration
            let deltaT = TrainFromAgeo[i].departureTime - (iBus.departureTime + busDuration + TrainTimeBuffer)
            if deltaT >= 0 && !(AvoidShonanShinjuku && TrainFromAgeo[i].isShonan) {
                trains.append(TrainFromAgeo[i])
                //This trains also works with real bus duration
                if deltaT >= iBus.duration - stdBusDuration {
                    break
                }
                //Try again with real bus duration
                else {
                    busDuration = iBus.duration
                }
            }
        }
    }

    if trains.count == 0 {
        trains.append(TrainData(departureTime: -1, isShonan: false))
    }

    return trains
}

//Return the data needed for the widget for a full hour
// iHour = hour (eg 18 for 18Hxx) 
func getTimeTablePerHour(iHour:Int, BusTimeBuffer:Int, TrainTimeBuffer:Int, AvoidShonanShinjuku:Bool, iAddOneExtra:Bool)->[BusTrainTimeTable] {
    var listTimeTables: [BusTrainTimeTable]=[]
    //If hour is before the first bus
    if iHour < Int(UDtoAgeo[0].departureTime/60) {
        listTimeTables.append(BusTrainTimeTable(prevBus: BusData(departureTime: -1, duration: -1),
                                                curBus: BusData(departureTime: -1, duration: -1),
                                                nextBus: UDtoAgeo[0],
                                                prevTrain: [TrainData(departureTime: -1, isShonan: false)],
                                                curTrain: [TrainData(departureTime: -1, isShonan: false)],
                                                nextTrain: getNextTrainFromAgeoBus(iBus: UDtoAgeo[0],TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku)
                                                ))
        return listTimeTables
    }
    
    //If hour is after the last bus
    if iHour > Int(UDtoAgeo[UDtoAgeo.count-1].departureTime/60) {
        listTimeTables.append(BusTrainTimeTable(prevBus: UDtoAgeo[UDtoAgeo.count-1], 
                                                curBus: BusData(departureTime: -1, duration: -1),
                                                nextBus: BusData(departureTime: -1, duration: -1),
                                                prevTrain: getNextTrainFromAgeoBus(iBus: UDtoAgeo[UDtoAgeo.count-1],TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku),
                                                curTrain: [TrainData(departureTime: -1, isShonan: false)],
                                                nextTrain: [TrainData(departureTime: -1, isShonan: false)]))
        
        return listTimeTables
    }

    //Go through the timetable to find suitable bus
    for i in 0..<UDtoAgeo.count {
        //If not adding extra, stop when current bus time is above hour
        //If add extra, continut until previous bus time display is on next hour
        if (!iAddOneExtra && UDtoAgeo[i].departureTime>=(iHour+1)*60) ||
            (iAddOneExtra && getBusFromIndex(iIndex: i-1).departureTime-BusTimeBuffer+1>(iHour+1)*60) {
                break
        }
            
        if UDtoAgeo[i].departureTime>=iHour*60 {
        
            let curBus = getBusFromIndex(iIndex: i) 
            let prevBus = getBusFromIndex(iIndex: i-1)
            let nextBus = getBusFromIndex(iIndex: i+1)

            let curTrain = getNextTrainFromAgeoBus(iBus: curBus, TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku)
            let prevTrain = getNextTrainFromAgeoBus(iBus: prevBus, TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku)
            let nextTrain = getNextTrainFromAgeoBus(iBus: nextBus, TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku)

            listTimeTables.append(BusTrainTimeTable(prevBus: prevBus,
                                                    curBus: curBus,
                                                    nextBus: nextBus,
                                                    prevTrain: prevTrain,
                                                    curTrain: curTrain,
                                                    nextTrain: nextTrain))
        }
    }
    //If we reached the last bus (not next bus), add one dummy bus
    if iAddOneExtra && listTimeTables[listTimeTables.count-1].nextBus.departureTime<0 {
        listTimeTables.append(BusTrainTimeTable(prevBus: UDtoAgeo[UDtoAgeo.count-1],
                                                curBus: BusData(departureTime: -1, duration: -1),
                                                nextBus: BusData(departureTime: -1, duration: -1),
                                                prevTrain: getNextTrainFromAgeoBus(iBus: UDtoAgeo[UDtoAgeo.count-1], TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku),
                                                curTrain: [TrainData(departureTime: -1, isShonan: false)],
                                                nextTrain: [TrainData(departureTime: -1, isShonan: false)]))
    }
    return listTimeTables
}

func time2Date(iTime:Int) -> Date {
    return Calendar.current.date(bySettingHour: iTime/60, minute: iTime%60, second: 0, of: Date()) ?? Date()
}

//Return the data needed for the widget for a full hour
// iHour = hour (eg 18 for 18Hxx)
// iBus = if true return but time, if false return train time
// iAddOneExtra = add next bus from next hour for the widget
func getBusOrTrainDatePerHour(iHour:Int, iBus: Bool, iAvoidShonanShinjuku: Bool, iAddOneExtra:Bool)->[Date] {
    var listDates: [Date]=[]
    var listTimes: [Int]=[]
    if(iBus) {
        listTimes = getBusTimePerHour(iHour: iHour, iAddOneExtra: iAddOneExtra)
    }
    else {
        listTimes = getTrainTimePerHour(iHour: iHour, iAvoidShonanShinjuku: iAvoidShonanShinjuku, iAddOneExtra: iAddOneExtra)
    }
    
    for item in listTimes {
        //The bus is before requested time, so set it to tommorow
        if Int(item/60)<iHour {
            listDates.append(Calendar.current.date(byAdding: .hour, value: 24, to: time2Date(iTime: item)) ??  time2Date(iTime: item))
        }
        else {
            listDates.append(time2Date(iTime: item))
        }
    }
    return listDates
}

//Return the list of bus departure time for a given hour
// iHour = hour (eg 18 for 18Hxx)
// iAddOneExtra = add next bus from next hour for the widget
func getBusTimePerHour(iHour:Int, iAddOneExtra:Bool)->[Int] {
    var listTimes: [Int]=[]
    //If hour is before the first bus
    if iHour < Int(UDtoAgeo[0].departureTime/60) || iHour > Int(UDtoAgeo[UDtoAgeo.count-1].departureTime/60){
        if iAddOneExtra {
            listTimes.append(UDtoAgeo[0].departureTime)
        }
        return listTimes
    }

    //Go through the timetable to find suitable bus
    for i in 0..<UDtoAgeo.count {
        //If not adding extra, stop when current bus time is above hour
        //If add extra, continue until previous bus time display is on next hour
        if UDtoAgeo[i].departureTime>=(iHour+1)*60 {
            if iAddOneExtra {
                listTimes.append(UDtoAgeo[i].departureTime)
            }
                break
        }
            
        if UDtoAgeo[i].departureTime>=iHour*60 {
        
            listTimes.append(UDtoAgeo[i].departureTime)
        }
    }
    return listTimes
}

//Return the list of train departure time for a given hour
// iHour = hour (eg 18 for 18Hxx)
// iAddOneExtra = add next train from next hour for the widget
func getTrainTimePerHour(iHour:Int, iAvoidShonanShinjuku:Bool, iAddOneExtra:Bool)->[Int] {
    var listTimes: [Int]=[]
    //If hour is before the first bus or after the last bus
    if iHour < Int(TrainFromAgeo[0].departureTime/60) || iHour > Int(TrainFromAgeo[TrainFromAgeo.count-1].departureTime/60){
        if iAddOneExtra {
            for i in 0..<TrainFromAgeo.count {
                if !(iAvoidShonanShinjuku && TrainFromAgeo[i].isShonan) {
                    listTimes.append(TrainFromAgeo[i].departureTime)
                }
                if listTimes.count>0 {
                    break
                }
            }
        }
        return listTimes
    }

    //Go through the timetable to find suitable train
    for i in 0..<TrainFromAgeo.count {
        //If not adding extra, stop when current train time is above hour
        //If add extra, continue until previous train time display is on next hour
        if TrainFromAgeo[i].departureTime>=(iHour+1)*60 {
            if iAddOneExtra {
                var found:Bool = false
                var j:Int = i
                while !found && j<TrainFromAgeo.count {
                    if !(iAvoidShonanShinjuku && TrainFromAgeo[i].isShonan) {
                        listTimes.append(TrainFromAgeo[i].departureTime)
                        found = true
                    }
                    j+=1
                }
            }
            break
        }
            
        if TrainFromAgeo[i].departureTime>=iHour*60 && !(iAvoidShonanShinjuku && TrainFromAgeo[i].isShonan) {
            listTimes.append(TrainFromAgeo[i].departureTime)
        }
    }
    return listTimes
}


func getTrainFontColor (iIsShonan:Bool)->Color {
    if iIsShonan {return .indigo}
    return .primary
}

func getBusFontColor (iIsOperateRedDays:Bool)->Color {
    if !iIsOperateRedDays {return .orange}
    return .primary
}
