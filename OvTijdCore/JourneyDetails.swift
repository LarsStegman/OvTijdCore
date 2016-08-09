//
//  JourneyDetails.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 09-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public struct JourneyDetails {
    public let journeyNumber: Int
    public let journeyPatternCode: Int
    public let lineDirection: Int
    public let orderNumber: Int
    public let stopType: JourneyStopType
}