//
//  OVTLocationManager.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 19-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

public class OVTLocationManager: NSObject, CLLocationManagerDelegate {

    private struct Constants {
        static let distanceFilter = 100.0
        static let accuracy = kCLLocationAccuracyHundredMeters
    }

    public static let sharedInstance = OVTLocationManager()
    private override init() {
        super.init()
    }

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = Constants.accuracy
        locationManager.distanceFilter = Constants.distanceFilter
        return locationManager
    }()

    // MARK: - Delegates

    private var delegates = [OVTLocationManagerDelegate]() {
        didSet {
            if delegates.count > 0 {
                self.startListening()
            } else {
                locationManager.stopUpdatingLocation()
            }
        }
    }

    public func startUpdatingLocations(forDelegate delegate: OVTLocationManagerDelegate) {
        delegates.append(delegate)
    }

    public func stopUpdateLocations(forDelegate delegate: OVTLocationManagerDelegate) {
        delegates = delegates.filter { $0 !== delegate }
    }

    // MARK: - LocationManagerDelegate

    var currentLocation: CLLocation? {
        didSet {
            if let newLocation = currentLocation {
                delegates.forEach { $0.update(newLocation) }
            }
        }
    }

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        guard error.domain == kCLErrorDomain else {
            print(error.localizedDescription)
            return
        }

        switch CLError(rawValue: error.code)! {
        case .Denied: manager.stopUpdatingLocation()
        default: break
        }
    }

    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined: locationManager.requestAlwaysAuthorization()
        case .AuthorizedAlways, .AuthorizedWhenInUse: locationManager.startUpdatingLocation()
        case .Denied, .Restricted: locationManager.stopUpdatingLocation(); self.fail(.NoLocationAccess)
        }
    }

    private func startListening() {
        guard CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .AuthorizedAlways else {
            locationManager.stopUpdatingLocation()
            self.fail(.NoLocationAccess)
            return
        }
        locationManager.startUpdatingLocation()
    }

    private func fail(with: OVTError) {
        self.delegates.forEach { $0.fail(with) }
    }
}

public protocol OVTLocationManagerDelegate: class {
    func update(location: CLLocation)
    func fail(with: OVTError)
}
