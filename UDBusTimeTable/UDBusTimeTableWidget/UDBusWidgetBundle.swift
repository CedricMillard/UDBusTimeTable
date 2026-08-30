//
//  UDBusWidgetBundle.swift
//  UDBusTimeTableWidgetExtension
//
//  Created by Cedric Millard on 2026/08/23.
//

import WidgetKit
import SwiftUI

@main
struct UDBusWidgetBundle: WidgetBundle {
    var body: some Widget {
        UDBusTimeTableWidget()
        UDBusCountDownWidget()
    }
}
