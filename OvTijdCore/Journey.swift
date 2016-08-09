//
//  Journey.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 09-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public class Journey {

    public private(set) var passes = [JourneyPass]() {
        didSet {
            passes.sortInPlace({ $0.stopOrderNumber < $1.stopOrderNumber })
        }
    }
    public let operatorCode: String
    public let transport: Transport

    public let journeyDetails: JourneyDetails
    public let lineDetails: LineDetails

    init(journeyDetails: JourneyDetails, operatorCode: String, transportType: Transport, lineDetails: LineDetails) {
        self.journeyDetails = journeyDetails
        self.operatorCode = operatorCode
        self.transport = transportType
        self.lineDetails = lineDetails
    }

    public func add(pass: JourneyPass) {
        passes.append(pass)
    }

    public func add(passes: [JourneyPass]) {
        self.passes.appendContentsOf(passes)
    }
}