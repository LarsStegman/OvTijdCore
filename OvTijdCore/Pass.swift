//
//  Pass.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

public class Pass {
    public let code: String
    public let transportType: Transport
    public let timingPoint: TimingPoint

    public let lineDetails: LineDetails
    public var planning: PassPlanning

    public var status: TripStopStatus
    public weak var stop: Stop?

    init(code: String, transport: Transport, timingPoint: TimingPoint, lineDetails: LineDetails, planning: PassPlanning, status: TripStopStatus) {
        self.code = code
        self.transportType = transport
        self.timingPoint = timingPoint
        self.lineDetails = lineDetails
        self.planning = planning
        self.status = status
    }
}
