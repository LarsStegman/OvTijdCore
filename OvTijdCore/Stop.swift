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

    /**
     Generate LineDetails from the given JSON object.

     - Parameter from: A json object with the following keys:
         - "Latitude"          : `Double`
         - "Longitude"         : `Double`
         - Required keys for `TimingPoint`
     */
    convenience init?(from json: JSON) {
        let nf = NSNumberFormatter()
        nf.decimalSeparator = "."
        if  let latitude = nf.numberFromString(json["Latitude"].stringValue) as? Double,
            let longitude = nf.numberFromString(json["Longitude"].stringValue) as? Double,
            let timingPoint = TimingPoint(from: json) {

            self.init(timingPoint: timingPoint, location: CLLocation(latitude: latitude, longitude: longitude))
        } else {
            print("Stop: parse error: \(json)")

            return nil
        }
    }
}