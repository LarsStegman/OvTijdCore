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

    let request = Request(apiLocation: "https://\(APIPaths.Root.API)", kv78APILocation: APIPaths.Root.KV78Turbo)

    /**
     Provides the nearest stop area
     */
    public func stopAreas(near: CLLocation, useIn callback: ([StopArea]) -> Void) {
        self.request.stopAreas(near, handler: callback)
    }

    public init() {}
}

