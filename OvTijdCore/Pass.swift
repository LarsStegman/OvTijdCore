//
//  Pass.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

import SwiftyJSON

public class Pass: Equatable, CustomStringConvertible {
    public let code: String
    public let timingPoint: TimingPoint

    public let lineDetails: LineDetails
    public let journeyDetails: JourneyDetails
    public var planning: PassPlanning

    public var status: TripStopStatus
    public weak var stop: Stop?

    public let stopType: JourneyStopType

    init(code: String, timingPoint: TimingPoint,
         lineDetails: LineDetails, journeyDetails: JourneyDetails, planning: PassPlanning, status: TripStopStatus, stopType: JourneyStopType) {
        self.code = code
        self.timingPoint = timingPoint
        self.lineDetails = lineDetails
        self.journeyDetails = journeyDetails
        self.planning = planning
        self.status = status
        self.stopType = stopType
    }

    /**
     Generate LineDetails from the given JSON object.

     - Parameter from: A json object with the following keys:
         - "TransportType"          : `String`
         - "TripStopStatus"         : `String`
         - Required keys for `TimingPoint`
         - Required keys for `LineDetails`
         - Required keys for `PassPlanning`
         - Required keys for `JourneyDetails`
     - Parameter passtimeCode: A code indicating the local pass time code
     */
    convenience init?(from json: JSON, passtimeCode: String) {
        if  let timingPoint = TimingPoint(from: json),
            let lineDetails = LineDetails(from: json),
            let passPlanning = PassPlanning(from: json),
            let journeyDetails = JourneyDetails(from: json),
            let status = TripStopStatus(string: json["TripStopStatus"].string),
            let stopType = JourneyStopType(string: json["JourneyStopType"].string) {
            
            self.init(code: passtimeCode,
                timingPoint: timingPoint,
                lineDetails: lineDetails,
                journeyDetails: journeyDetails,
                planning: passPlanning,
                status: status,
                stopType: stopType)
        } else {
            print("Pass: parse error: \(json)")
            return nil
        }
    }

    public var description: String {
        return "\(lineDetails.publicNumber)\t\(lineDetails.destinationName)\t\t\(planning)"
    }
}

public func ==(lhs: Pass, rhs: Pass) -> Bool {
    return lhs.code == rhs.code
}