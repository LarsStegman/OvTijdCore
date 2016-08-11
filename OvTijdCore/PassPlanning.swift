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

    init(targetArrivalTime: NSDate, targetDepartureTime: NSDate,
         expectedArrivalTime: NSDate, expectedDepartureTime: NSDate) {
        self.targetArrivalTime = targetArrivalTime
        self.targetDepartureTime = targetDepartureTime
        self.expectedArrivalTime = expectedArrivalTime
        self.expectedDepartureTime = expectedDepartureTime
    }

    /**
     Generate LineDetails from the given JSON object.

     - Important: The dates must be in format `"yyyy-MM-dd'T'HH:mm:ss"` and are parsed in time zone `"Europe/Amsterdam"`

     - Parameter from: A json object with the following keys:
         - "TargetArrivalTime"      : `String`
         - "ExpectedArrivalTime"    : `String`
         - "TargetDepartureTime"    : `String`
         - "ExpectedDepartureTime"  : `String`
     */
    init?(from json: JSON) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Amsterdam")

        if  let tatString = json["TargetArrivalTime"].string,
            let tat = dateFormatter.dateFromString(tatString),
            let eatString = json["ExpectedArrivalTime"].string,
            let eat = dateFormatter.dateFromString(eatString),
            let tdtString = json["TargetDepartureTime"].string,
            let tdt = dateFormatter.dateFromString(tdtString),
            let edtString = json["ExpectedDepartureTime"].string,
            let edt = dateFormatter.dateFromString(edtString) {

            self.init(targetArrivalTime: tat, targetDepartureTime: tdt, expectedArrivalTime: eat, expectedDepartureTime: edt)
        } else {
            print("PassPlanning: parse error: \(json)")

            return nil
        }
    }
}