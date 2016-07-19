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

    public let town: String
    public let name: String
    public let location: CLLocation

    let stops = [Stop]()

    func timingPointsInStopArea() -> [Stop] {
        return [Stop]()
    }
}