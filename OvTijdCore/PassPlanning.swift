//
//  PassPlanning.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 22-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

import SwiftyJSON

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

    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Amsterdam")
        return dateFormatter
    }()

    static func generate(from json: JSON) -> PassPlanning {
        let tat = dateFormatter.dateFromString(json["TargetArrivalTime"].stringValue)!
        let eat = dateFormatter.dateFromString(json["ExpectedArrivalTime"].stringValue)!
        let tdt = dateFormatter.dateFromString(json["TargetDepartureTime"].stringValue)!
        let edt = dateFormatter.dateFromString(json["ExpectedDepartureTime"].stringValue)!

        return PassPlanning(targetArrivalTime: tat,
                            targetDepartureTime: tdt,
                            expectedArrivalTime: eat,
                            expectedDepartureTime: edt)
    }
}