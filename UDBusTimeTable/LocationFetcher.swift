//
//  LocationFetcher.swift
//  UDBusTimeTableWidgetExtension
//
//  Created by Cedric Millard on 20/09/2026.
//

import CoreLocation

class userLocationFetcher: NSObject, CLLocationManagerDelegate {
    private let locManager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?
    
    func fetch(accuracy: CLLocationAccuracy, completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        locManager.delegate = self
        locManager.desiredAccuracy = accuracy
        locManager.requestLocation()
    }
    
    func locationManager (_ locManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(locations.last)
        completion = nil
    }
    
    func locationManager(_ locManager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
        completion = nil
    }
}
