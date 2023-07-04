//
//  LocationManager.swift
//  DemoFirebase
//
//  Created by Shubhdeep on 2023-06-29.
//

import Foundation
import CoreLocation

class LocationServices: NSObject, CLLocationManagerDelegate {
    
    public static let shared = LocationServices()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = manager.location?.coordinate
//    }
//
}
