//
//  JourneyStopType.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 08-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public enum JourneyStopType: String {
    case First
    case Intermediate
    case Last

    public init?(rawValue: String) {
        if let type = JourneyStopType(rawValue: rawValue.lowercaseString.capitalizedString) {
            self = type
        } else {
            return nil
        }
    }
}