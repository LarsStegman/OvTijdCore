//
//  Journey.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 10-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public class Journey {
    public let details: JourneyDetails
    public let lineDetails: LineDetails

    public private(set) var passes = [Pass]() {
        didSet {
            passes.sortInPlace({ $0.journeyDetails.orderNumber < $1.journeyDetails.orderNumber })
        }
    }

    init(details: JourneyDetails, lineDetails: LineDetails) {
        self.details = details
        self.lineDetails = lineDetails
    }

    public func add(pass: Pass) {
        passes.append(pass)
    }

    public func add(passes: [Pass]) {
        self.passes.appendContentsOf(passes)
    }
}