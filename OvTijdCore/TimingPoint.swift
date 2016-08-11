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
    public let timingPointCode: String
    public let timingPointName: String
    public let timingPointTown: String

    init(timingPointCode: String, timingPointName: String, timingPointTown: String) {
        self.timingPointCode = timingPointCode
        self.timingPointName = timingPointName
        self.timingPointTown = timingPointTown
    }

    /**
     Generate timing point from the given JSON Object.

     - Parameter from: A json object with the following keys:
         - "TimingPointTown" : `String`
         - "TimingPointName" : `String`
         - "TimingPointCode" : `Int`
     */
    init?(from json: JSON) {
        if  let town = json["TimingPointTown"].string,
            let name = json["TimingPointName"].string,
            let code = json["TimingPointCode"].string {

            self.init(timingPointCode: code, timingPointName: name, timingPointTown: town)
        } else {
            print("TimingPoint: parse error: \(json)")

            return nil
        }
    }

}