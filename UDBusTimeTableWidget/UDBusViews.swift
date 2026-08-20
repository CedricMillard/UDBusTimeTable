//
//  UDBusViews.swift
//  UDBusTimeTableExtension
//
//  Created by Erin Millard on 2026/08/10.
//

import WidgetKit
import SwiftUI

struct UDBusWidgetView : View {
    var entry: UDBusProvider.Entry

    @AppStorage("BusTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var BusTimeBuffer = 5
    @AppStorage("TrainTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var TrainTimeBuffer = 3
    @AppStorage("AvoidShonanShinjuku", store: UserDefaults(suiteName: appGroupSuite)) private var AvoidShonanShinjuku = false
    
    var body: some View {
        
        VStack {
            Grid(verticalSpacing: 5){
                GridRow {
                    Text("Bus")
                        .bold()
                    Text (">")
                        .bold()
                    Text("Train")
                        .bold()
                }
                //Spacer()
                Divider()
                GridRow(alignment: .top) {
                    Text(timeToString(iTime: entry.timeTable.prevBus.departureTime))
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    Text (">")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    if entry.timeTable.prevTrain.count == 1 {
                        Text(timeToString(iTime: entry.timeTable.prevTrain[0].departureTime))
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    }
                    else
                    {
                        Grid{
                            
                            GridRow{
                                Text(timeToString(iTime: entry.timeTable.prevTrain[1].departureTime))
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                            GridRow{
                                Text("("+timeToString(iTime: entry.timeTable.prevTrain[0].departureTime)+")")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                    .italic()
                            }
                        }
                    }
                }
                Divider()
                GridRow(alignment: .top) {
                    Text(timeToString(iTime: entry.timeTable.curBus.departureTime))
                        .bold()
                        .foregroundColor(getBusFontColor(iIsOperateRedDays: entry.timeTable.curBus.isActiveRedDays))
                        
                    
                    Text (">")
                        .bold()
                    
                    if entry.timeTable.curTrain.count == 1 {
                        Text(timeToString(iTime: entry.timeTable.curTrain[0].departureTime))
                            .foregroundColor(getTrainFontColor(iIsShonan: entry.timeTable.curTrain[0].isShonan))
                            .bold()
                    }
                    else
                    {
                        Grid{
                            
                            GridRow{
                                Text(timeToString(iTime: entry.timeTable.curTrain[1].departureTime))
                                    .foregroundColor(getTrainFontColor(iIsShonan: entry.timeTable.curTrain[1].isShonan))
                                    .bold()
                            }
                            GridRow{
                                Text("("+timeToString(iTime: entry.timeTable.curTrain[0].departureTime)+")")
                                    .font(.footnote)
                                    .foregroundColor(getTrainFontColor(iIsShonan: entry.timeTable.curTrain[0].isShonan))
                                    //.bold( entry.timeTable.curTrain[0].isShonan)
                            }
                            
                        }
                    }
                }
                Divider()
                GridRow(alignment: .top){
                    Text(timeToString(iTime: entry.timeTable.nextBus.departureTime))
                        .font(.footnote)
                        .foregroundColor(getBusFontColor(iIsOperateRedDays: entry.timeTable.nextBus.isActiveRedDays))
                        //.bold(!entry.timeTable.nextBus.isActiveRedDays)
                    
                    Text (">")
                        .font(.footnote)
                    
                    if entry.timeTable.nextTrain.count == 1 {
                        Text(timeToString(iTime: entry.timeTable.nextTrain[0].departureTime))
                            .font(.footnote)
                            .foregroundColor(getTrainFontColor(iIsShonan: entry.timeTable.nextTrain[0].isShonan))
                            //.bold( entry.timeTable.nextTrain[0].isShonan)
                    }
                    else
                    {
                        Grid{
                            GridRow{
                                Text(timeToString(iTime: entry.timeTable.nextTrain[1].departureTime))
                                    .font(.footnote)
                                    .foregroundColor(getTrainFontColor(iIsShonan: entry.timeTable.nextTrain[1].isShonan))
                                    //.bold( entry.timeTable.nextTrain[1].isShonan)
                            }
                            GridRow{
                                Text("("+timeToString(iTime: entry.timeTable.nextTrain[0].departureTime)+")")
                                    .font(.caption2)
                                    .foregroundColor(getTrainFontColor(iIsShonan: entry.timeTable.nextTrain[0].isShonan))
                                    //.bold( entry.timeTable.nextTrain[0].isShonan)
                            }
                        }
                    }
                }
            }
            //Spacer()
        }
    }
}
