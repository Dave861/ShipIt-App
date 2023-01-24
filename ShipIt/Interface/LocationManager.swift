//
//  LocationManager.swift
//  ShipIt
//
//  Created by Mihnea on 1/24/23.
//

import Foundation
import CoreLocation

class LocationManager {
    public let manager = CLLocationManager()
    private var location = CLLocation()
    
    public func requestLocation() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.startUpdatingLocation()
            location = manager.location ?? CLLocation()
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
        }
    }
    
    public func calculateDistance(address : CLLocation) -> Double {
        return manager.location?.distance(from: address) ?? 0.0
    }
}
