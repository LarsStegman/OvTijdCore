//
//  Transport.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public enum Transport: String {
    case Bus
    case Tram
    case Metro
    case Train
    case Boat

    public init?(string: String?) {
        if let transportString = string,
            let transport = Transport(rawValue: transportString.lowercaseString.capitalizedString) {
            self = transport
        } else {
            print("Transport: parse error: \(string)")
            return nil
        }
    }
}