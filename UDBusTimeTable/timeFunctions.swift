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
            //First try with a bus duration of 10 minutes
            let deltaT = TrainFromAgeo[i].departureTime - (iBus.departureTime + busDuration + TrainTimeBuffer)
            if deltaT >= 0 && !(AvoidShonanShinjuku && TrainFromAgeo[i].isShonan) {
                trains.append(TrainFromAgeo[i])
                if deltaT >= iBus.duration - stdBusDuration {
                    break
                }
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
func getTimeTablePerHour(iHour:Int, TrainTimeBuffer:Int, AvoidShonanShinjuku:Bool, iAddOneExtra:Bool)->[BusTrainTimeTable] {
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
            (iAddOneExtra && getBusFromIndex(iIndex: i-1).departureTime-4>(iHour+1)*60) {
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

func getTrainFontColor (iIsShonan:Bool)->Color {
    if iIsShonan {return .indigo}
    return .primary
}

func getBusFontColor (iIsOperateRedDays:Bool)->Color {
    if !iIsOperateRedDays {return .orange}
    return .primary
}
