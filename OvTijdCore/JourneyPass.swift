//
//  JourneyPass.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 08-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public class JourneyPass: Pass {
    public let journeyStopType: JourneyStopType
    public let stopOrderNumber: Int
    public let journeyNumber: Int

    public init(code: String, transport: Transport, timingPoint: TimingPoint, lineDetails: LineDetails,
                planning: PassPlanning, status: TripStopStatus, journeyStopType: JourneyStopType, stopOrderNumber: Int,
                journeyNumber: Int) {
        self.journeyStopType = journeyStopType
        self.stopOrderNumber = stopOrderNumber
        self.journeyNumber = journeyNumber
        super.init(code: code, transport: transport, timingPoint: timingPoint, lineDetails: lineDetails,
                   planning: planning, status: status)
    }

    public convenience init(pass: Pass, journeyStopType: JourneyStopType, stopOrderNumber: Int, journeyNumber: Int) {
        self.init(code: pass.code, transport: pass.transportType, timingPoint: pass.timingPoint,
                  lineDetails: pass.lineDetails, planning: pass.planning, status: pass.status,
                  journeyStopType: journeyStopType, stopOrderNumber: stopOrderNumber, journeyNumber: journeyNumber)
    }
}