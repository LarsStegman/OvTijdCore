//
//  TimingPoint.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

import SwiftyJSON

public struct TimingPoint {
    public let timingPointCode: Int
    public let timingPointName: String
    public let timingPointTown: String

    /**
     Generate timing points from the specified JSON Object.

     - Parameter: from The JSON from which the timing points are generated.
     */
    static func generate(from json: JSON) -> TimingPoint {
        let town = json["TimingPointTown"].stringValue
        let name = json["TimingPointName"].stringValue
        let code = json["TimingPointCode"].intValue
        return TimingPoint(timingPointCode: code, timingPointName: name, timingPointTown: town)
    }
}