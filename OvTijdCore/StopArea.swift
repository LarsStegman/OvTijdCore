//
//  StopArea.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

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
}

public func ==(lhs: StopArea, rhs: StopArea) -> Bool {
    return lhs.name == rhs.name && lhs.town == rhs.town
}
