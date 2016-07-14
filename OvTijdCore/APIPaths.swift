//
//  APIPaths.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

struct APIPaths {
    struct Root {
        static let API = "ovapi.nl"
        static let KV78Turbo = "kv78turbo.ovapi.nl"
    }

    static let Stops = "haltes"
    static let StopsEndpoint = "stops"
    static let Near = "?near="
    static let maxNumberOfStopAreas = 50
}