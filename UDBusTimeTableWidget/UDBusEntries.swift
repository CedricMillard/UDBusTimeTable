//
//  UDBusEntries.swift
//  UDBusTimeTableExtension
//
//  Created by Cedric Millard on 2026/08/10.
//

import WidgetKit

struct UDBusEntry: TimelineEntry {
    let date: Date
    let timeTable: BusTrainTimeTable
}
