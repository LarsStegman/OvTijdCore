//
//  JourneyDetails.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 09-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

import SwiftyJSON

public struct JourneyDetails {
    public let journeyNumber: Int
    public let journeyPatternCode: Int
    public let lineDirection: Int
    public let orderNumber: Int

    init(journeyNumber: Int, journeyPatternCode: Int, lineDirection: Int, orderNumber: Int) {
        self.journeyNumber = journeyNumber
        self.journeyPatternCode = journeyPatternCode
        self.lineDirection = lineDirection
        self.orderNumber = orderNumber
    }

    /**
     Generate JourneyDetails from the given JSON object.
     
     - Parameter from: A json object with the following keys: 
        - "JourneyNumber"       : `Int`
        - "JourneyPatternCode"  : `Int`
        - "LineDirection"       : `Int`
        - "UserStopOrderNumber" : `Int`
        - "JourneyStopType"     : `String`
     */
    init?(from json: JSON) {
        let nf = NSNumberFormatter()
        nf.decimalSeparator = "."
        if  let journeyNumber = nf.numberFromString(json["JourneyNumber"].stringValue) as? Int,
            let journeyPatternCode = nf.numberFromString(json["JourneyPatternCode"].stringValue) as? Int,
            let lineDirection = nf.numberFromString(json["LineDirection"].stringValue) as? Int,
            let orderNumber = nf.numberFromString(json["UserStopOrderNumber"].stringValue) as? Int {

            self.init(journeyNumber: journeyNumber, journeyPatternCode: journeyPatternCode,
                      lineDirection: lineDirection, orderNumber: orderNumber)
        } else {
            print("JourneyDetails: parse error: \(json)")
            return nil
        }
    }
}