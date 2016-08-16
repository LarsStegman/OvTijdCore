//
//  MessageDuration.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 16-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public enum MessageDuration: String {
    case Remove
    case Firstvejo
    case Endtime

    public init?(string: String?) {
        if let durationString = string,
            let duration = MessageDuration(rawValue: durationString.lowercaseString.capitalizedString) {
            self = duration
        } else {
            print("MessageDuration: parse error: \(string)")
            return nil
        }
    }
}