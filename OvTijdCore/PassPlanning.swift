//
//  PassPlanning.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 22-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public struct PassPlanning: CustomStringConvertible {
    public let targetArrivalTime: NSDate
    public let targetDepartureTime: NSDate
    public var expectedArrivalTime: NSDate
    public var expectedDepartureTime: NSDate

    public var description: String {
        let df = NSDateFormatter()
        df.dateFormat = "HH:mm:ss"
        return "\(df.stringFromDate(targetArrivalTime)) \(df.stringFromDate(expectedArrivalTime)) → \(df.stringFromDate(targetDepartureTime)) \(df.stringFromDate(expectedDepartureTime))"
    }
}