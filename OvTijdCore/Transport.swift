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

    public func generateIcon(forId id: String) -> UIImage? {
        guard id != "" else {
            return nil
        }
        let imageName = self.rawValue.lowercaseString
        let image = UIImage(named: imageName, inBundle: NSBundle(identifier: "nl.stegman.OvTijdCore"), compatibleWithTraitCollection: nil)

        return image
    }

    public init?(rawValue: String) {
        if let transport = Transport(rawValue: rawValue.lowercaseString.capitalizedString) {
            self = transport
        } else {
            return nil
        }
    }

}