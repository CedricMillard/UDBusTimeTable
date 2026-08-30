//
//  UDBusCountDownEntries.swift
//  UDBusCountDownWidgetExtension
//
//  Created by Erin Millard on 2026/08/23.
//

import WidgetKit

struct UDBusCountDownEntry: TimelineEntry {
    let date: Date
    let targetDate: Date
    let type: UDBusCountDownType
}
