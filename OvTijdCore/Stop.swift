//
//  Stop.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

import SwiftyJSON

public class Stop: NSObject {
    public let timingPoint: TimingPoint
    public let location: CLLocation

    public var passes = [Pass]()

    public func add(pass: Pass) {
        passes.append(pass)
    }

    init(timingPoint: TimingPoint, location: CLLocation) {
        self.location = location
        self.timingPoint = timingPoint
    }

    class func generate(from json: JSON) -> Stop {
        let location = CLLocation(latitude: json["Latitude"].doubleValue,
                                  longitude: json["Longitude"].doubleValue)
        let timingPoint = TimingPoint.generate(from: json)
        return Stop(timingPoint: timingPoint, location: location)
    }
}