//
//  OvTijdManager.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

public class OVTManager {

    public static let sharedInstance = OVTManager()
    private init() {}

    let request = Request(apiLocation: "https://\(APIPaths.Root.API)", kv78APILocation: "http://\(APIPaths.Root.KV78Turbo)")

    /**
     Provides the nearest stop area
     
     - Parameter: near The location to search for
     - Parameter: useIn The closure in which the results will be used.
     */
    public func stopAreas(near: CLLocation, useIn callback: ([StopArea]) -> Void) {
        self.request.stopAreas(near, handler: callback)
    }

    /**
     Provides a list of timing points for a certain stop area.
     
     - Parameter: forStopArea The stop area for which the TimingPoints need to be provided
     - Parameter: useIn The closure in which the results will be used.
     */
    public func timingPoints(forStopArea stopArea: StopArea, useIn callback: ([TimingPoint]) -> Void) {
        self.request.timingPoints(inStopArea: stopArea, handler: callback)
    }

    public func stops(stopArea: StopArea, useIn callback: ([Stop]) -> Void) {
        self.timingPoints(forStopArea: stopArea) { [weak self] (timingPoints) in
            self?.request.stops(forTimingPoints: timingPoints) { (stops) in
                callback(stops)
            }
        }
    }

    /**
     Provides a list of journeys for the provided identifiers
     
     - Parameter forIdentifiers: The identifiers of the journeys, i.e. localpasstimecode
     - Parameter useIn: The closure in which the results will be used.
     */
    public func journey(forIdentifiers: [String], useIn callback: ([Journey]) -> Void) {
        self.request.journeys(forIdentifiers: forIdentifiers, handler: callback)
    }
}

