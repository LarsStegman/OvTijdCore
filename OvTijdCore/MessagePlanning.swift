//
//  MessagePlanning.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 16-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

import SwiftyJSON

public struct MessagePlanning {
    public let duration: MessageDuration
    public let startTime: NSDate
    public let endTime: NSDate?

    init(duration: MessageDuration, start: NSDate, end: NSDate?) {
        self.duration = duration
        self.startTime = start
        self.endTime = end
    }

    init?(from json: JSON) {
        let df = NSDateFormatter()
        df.timeZone = NSTimeZone(name: "Europe/Amsterdam")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if  let duration = MessageDuration(string: json["MessageDurationType"].string),
            let startString = json["MessageStartTime"].string,
            let start = df.dateFromString(startString),
            let endString = json["MessageEndTime"].string {
            let end = df.dateFromString(endString)

            self.init(duration: duration, start: start, end: end)
        } else {
            print("MessagePlanning: parse error: \(json)")
            return nil
        }
    }
}