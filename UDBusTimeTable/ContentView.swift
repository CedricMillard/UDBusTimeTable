//
//  ContentView.swift
//  AgeoBusTimeTable
//
//  Created by Cedric Millard on 2026/06/22.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locManager = CLLocationManager()
    
    override init() {
        super.init()
        locManager.delegate = self
    }
    
    func requestLocationPermission(){
        locManager.requestWhenInUseAuthorization()
    }
}

struct ContentView: View {
    @State private var isFlipped = false
    @StateObject private var locManager = LocationManager()
    private let fetcher = userLocationFetcher()
    
    //Return if the first screen is the bus to station or to plant based on location
    private func setFlipFromPosition() async {
        //fetch user location and compare with plant location
        let locManager = CLLocationManager()
        var flip = false
        let status = locManager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            let userLocation: CLLocation? = await withCheckedContinuation {continuation in
                fetcher.fetch(accuracy: kCLLocationAccuracyReduced)  { location in
                    continuation.resume(returning: location)
                }
            }
            if let userLocation = userLocation {
                flip = userLocation.distance(from: CLLocation(latitude: UDPlantLat, longitude: UDPlantLong)) < 1000 ? false : true
            }
        }
        
        isFlipped = flip
    }
    
    var body: some View {
        
        ZStack {
            BusToStationView(isFlipped: $isFlipped)
                .opacity(isFlipped ? 0.0 : 1.0)
            BusToPlantView(isFlipped: $isFlipped)
                .opacity(isFlipped ? 1.0 : 0.0)
                .rotation3DEffect(.degrees(180), axis: (x:0.0, y:1.0, z:0.0))
        }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x:0.0, y:1.0, z:0.0), perspective: 0.5)
        .onAppear{
            locManager.requestLocationPermission()
        }
        .task {
            await setFlipFromPosition()
        }
    }
}

#Preview (){
    ContentView()
}

