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
    public let transportType: Transport
    public let timingPoint: TimingPoint

    public let lineDetails: LineDetails
    public var planning: PassPlanning

    public var status: TripStopStatus
    public weak var stop: Stop?

    init(code: String, transport: Transport, timingPoint: TimingPoint,
         lineDetails: LineDetails, planning: PassPlanning, status: TripStopStatus) {
        self.code = code
        self.transportType = transport
        self.timingPoint = timingPoint
        self.lineDetails = lineDetails
        self.planning = planning
        self.status = status
    }

    public var description: String {
        return "\(lineDetails.publicNumber)\t\(lineDetails.destinationName)\t\t\(planning)"
    }

    static func generate(from json: JSON, passtimeCode: String) -> Pass {
        let transport = Transport(rawValue: json["TransportType"].stringValue)!
        let timingPoint = TimingPoint.generate(from: json)
        let lineDetails = LineDetails.generate(from: json)
        let passPlanning = PassPlanning.generate(from: json)
        let status = TripStopStatus(rawValue: json["TripStopStatus"].stringValue)!
        return Pass(code: passtimeCode,
                    transport: transport,
                    timingPoint: timingPoint,
                    lineDetails: lineDetails,
                    planning: passPlanning,
                    status: status)
    }
}

public func ==(lhs: Pass, rhs: Pass) -> Bool {
    return lhs.code == rhs.code
}