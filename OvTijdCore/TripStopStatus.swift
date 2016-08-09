//
//  TripStopStatus.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 25-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public enum TripStopStatus: String {
    case Planned
    case Cancel
    case Unknown
    case Driving
    case Arrived
    case Passed

    public init?(rawValue: String) {
        if let status = TripStopStatus(rawValue: rawValue.lowercaseString.capitalizedString) {
            self = status
        } else {
            return nil
        }
    }
}