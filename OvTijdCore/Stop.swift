//
//  Stop.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

public struct Stop: TimingPoint {
    let town: String
    let name: String
    let location: CLLocationCoordinate2D

    public let timingPointName: String
    public let timingPointCode: Int

    let announcements = [String]()
    let wheelChairAccessible: Bool?
    let visualAccessible: Bool?
}