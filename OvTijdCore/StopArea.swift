//
//  StopArea.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

import SwiftyJSON

public struct StopArea: Equatable {
    let code: String?

    public let name: String
    public let town: String
    public let location: CLLocation

    init(code: String?, name: String, town: String, location: CLLocation) {
        self.code = code
        self.name = name
        self.town = town
        self.location = location
    }

    /**
     Generate StopArea from the given JSON object.

     - parameter from: A json object with the following keys:
         - "StopAreaCode"       : `String`
         - "Name"               : `String`
         - "Longitude"          : `Double`
         - "Latitude"           : `Double`
         - "TimingPointTown"    : `String`
     */
    init?(from json: JSON) {
        let nf = NSNumberFormatter()
        if let town = json["TimingPointTown"].string,
            let name = json["Name"].string,
            let latitude = nf.numberFromString(json["Latitude"].stringValue) as? Double,
            let longitude = nf.numberFromString(json["Longitude"].stringValue) as? Double,
            let code = json["StopAreaCode"].string {

            self.init(code: code, name: name, town: town, location: CLLocation(latitude: latitude, longitude: longitude))
        } else {
            return nil
        }
    }
}

public func ==(lhs: StopArea, rhs: StopArea) -> Bool {
    return lhs.name == rhs.name && lhs.town == rhs.town
}
