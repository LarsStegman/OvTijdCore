//
//  JourneyStopType.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 08-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

/**
 The kind of stop, i.e. the first in a journey.
 */
public enum JourneyStopType: String {
    case First
    case Intermediate
    case Last

    public init?(string: String?) {
        if  let str = string,
            let type = JourneyStopType(rawValue: str.lowercaseString.capitalizedString) {
            self = type
        } else {
            print("JourneyStopType: parse error: \(string)")
            return nil
        }
    }
}