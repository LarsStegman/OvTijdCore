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

    static func generate(from json: JSON) -> StopArea {
        let town = json["TimingPointTown"].stringValue
        let name = json["Name"].stringValue
        let location = CLLocation(latitude: json["Latitude"].doubleValue,
                                  longitude: json["Longitude"].doubleValue)
        let code = json["StopAreaCode"].string

        return StopArea(code: code, name: name, town: town, location: location)
    }
}

public func ==(lhs: StopArea, rhs: StopArea) -> Bool {
    return lhs.name == rhs.name && lhs.town == rhs.town
}
