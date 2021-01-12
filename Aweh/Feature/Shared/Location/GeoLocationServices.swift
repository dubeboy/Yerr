//
//  GeoLocationServices.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/16.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeoLocationServicesDelegate {
    func didFetchCurrentLocation(_ location: Location)
    func fetchCurrentLocationFailed(error: Error)
}

class GeoLocationServices: NSObject {
    
    let locationManager = CLLocationManager()
    var delegate: GeoLocationServicesDelegate
    
    init(delegate: GeoLocationServicesDelegate) {
        self.delegate = delegate
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        if canUseLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            //            locationManager.startUpdatingLocation()
        }
    }
    
    private func canUseLocationManager() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension GeoLocationServices: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geoLocation = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude)
            delegate.didFetchCurrentLocation(geoLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate.fetchCurrentLocationFailed(error: error)
    }
}
