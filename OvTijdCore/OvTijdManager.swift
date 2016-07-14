//
//  OvTijdManager.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

public class OvTijdManager: NSObject, CLLocationManagerDelegate {

    private struct Constants {
        static let distanceFilter = 100.0
    }

    let request = Request(apiLocation: "https://\(APIPaths.Root.API)", kv78APILocation: APIPaths.Root.KV78Turbo)
    lazy var locationManager: CLLocationManager = {
        let locman = CLLocationManager()
        locman.delegate = self
        locman.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locman.distanceFilter = Constants.distanceFilter
        locman.startUpdatingLocation()
        return locman
    }()

    var currentLocation: CLLocationCoordinate2D?

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last?.coordinate {
            self.currentLocation = newLocation
            print("You're at \(newLocation)")
            self.locationManager.stopUpdatingLocation()
        }
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

    }

    public func nearbyStopAreas(useIn callback: ([StopArea]) -> Void) {
        self.request.stopAreasNear(CLLocationCoordinate2D(latitude: 51.85, longitude: 4.5), handler: callback)
    }
}