//
//  StopArea.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

public struct StopArea {
    let code: String?

    public let name: String
    public let town: String
    public let location: CLLocation

    public var stops = [TimingPoint]()

    init(code: String?, name: String, town: String, location: CLLocation) {
        self.code = code
        self.name = name
        self.town = town
        self.location = location
    }

    mutating func addTimingPoint(timingPoint: TimingPoint) {
        stops.append(timingPoint)
    }
}