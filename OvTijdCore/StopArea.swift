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

    let town: String
    let name: String
    let location: CLLocationCoordinate2D

    let stops = [Stop]()
}