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

    let request = Request(apiLocation: "https://\(APIPaths.Root.API)", kv78APILocation: APIPaths.Root.KV78Turbo)
    lazy var locationManager: CLLocationManager = {
        let locman = CLLocationManager()
        locman.delegate = self
        locman.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locman.distanceFilter = 100
        return locman
    }()

    var currentLocation: CLLocation?

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.currentLocation = newLocation
        }
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

    }
}