//
//  MessageType.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 16-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public enum MessageType: String {
    case General
    case Additional
    case Overrule
    case Bottomline

    public init?(string: String?) {
        if let typeString = string,
            let type = MessageType(rawValue: typeString.lowercaseString.capitalizedString) {
            self = type
        } else {
            print("MessageType: parse error: \(string)")

            return nil
        }
    }
}