//
//  Journey.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

public struct Pass {
    public let code: String
    public let transportType: Transport

    public let location: CLLocationCoordinate2D
}