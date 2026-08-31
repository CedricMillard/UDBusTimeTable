//
//  ContentView.swift
//  AgeoBusTimeTable
//
//  Created by Cedric Millard on 2026/06/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            BusToStationView(isFlipped: $isFlipped)
                .opacity(isFlipped ? 0.0 : 1.0)
            BusToPlantView(isFlipped: $isFlipped)
                .opacity(isFlipped ? 1.0 : 0.0)
                .rotation3DEffect(.degrees(180), axis: (x:0.0, y:1.0, z:0.0))
        }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x:0.0, y:1.0, z:0.0), perspective: 0.5)
    }
}

#Preview (){
    ContentView()
}

