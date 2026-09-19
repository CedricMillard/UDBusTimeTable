//
//  MapView.swift
//  UDBusTimeTable
//
//  Created by Cedric Millard on 19/09/2026.
//

import SwiftUI
import MapKit

let BustStopCoord = CLLocationCoordinate2D(latitude: BusStopLat, longitude: BusStopLong)
let MapCenter = CLLocationCoordinate2D(latitude: 35.973288, longitude: 139.588044)

struct MapView: View {
    
    @State private var position: MapCameraPosition = .camera(MapCamera (centerCoordinate: MapCenter, distance: 300))
    
    var body: some View {
        VStack {
            Map(position: $position,
                interactionModes: [.zoom, .pan]) {
                
                Annotation(String(localized: LocalizedStringResource("UD Bus Stop")),
                           coordinate: BustStopCoord, anchor:.bottom) {
                    VStack(spacing:0) {
                        //Image(systemName: "bus.fill")
                        Image("busLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(2)
                            .background(Color.accentColor)
                            .cornerRadius(32)
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color.accentColor)
                            .rotationEffect(Angle(degrees: 180))
                            .offset(y:-3)
                    }
                }
            }
                .frame(width: 350, height: 350)
            Button(action:{
                position = .camera(MapCamera (centerCoordinate: MapCenter, distance: 300))
            }) {
                Text("Reset Map")
            }
        }
    }
}
