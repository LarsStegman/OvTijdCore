//
//  Message.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 16-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

import SwiftyJSON

public struct Message: Equatable {
    public let content: String
    public let codeDate: NSDate
    public let codeNumber: Int
    public let type: MessageType
    public let planning: MessagePlanning

    init(codeDate: NSDate, codeNumber: Int, content: String, type: MessageType, planning: MessagePlanning) {
        self.codeDate = codeDate
        self.codeNumber = codeNumber
        self.content = content
        self.type = type
        self.planning = planning
    }

    init?(from json: JSON) {
        let codeDateDF = NSDateFormatter()
        codeDateDF.timeZone = NSTimeZone(name: "Europe/Amsterdam")
        codeDateDF.dateFormat = "yyyy-MM-dd"
        if  let cDt = json["MessageCodeDate"].string,
            let codeDate = codeDateDF.dateFromString(cDt),
            let codeNumber = json["MessageCodeNumber"].int,
            let content = json["MessageContent"].string,
            let type = MessageType(string: json["MessageType"].string),
            let planning = MessagePlanning(from: json) {

            self.init(codeDate: codeDate, codeNumber: codeNumber, content: content,
                      type: type, planning: planning)
        } else {
            print("Message: parse error: \(json)")
            return nil
        }

    }
}

public func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.codeDate == rhs.codeDate && lhs.codeNumber == rhs.codeNumber
}