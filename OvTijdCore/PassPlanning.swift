//
//  PassPlanning.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 22-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public struct PassPlanning {
    public let targetArrivalTime: NSDate
    public let targetDepartureTime: NSDate
    public var expectedArrivalTime: NSDate
    public var expectedDeparture: NSDate
}