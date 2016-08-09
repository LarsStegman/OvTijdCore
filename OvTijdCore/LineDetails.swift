//
//  PassTargetDetails.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 22-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

import SwiftyJSON

public struct LineDetails {
    public let destinationName: String
    public let lineName: String
    public let publicNumber: String

    static func generate(from json: JSON) -> LineDetails {
        let name = json["DestinationName50"].stringValue
        let lineName = json["LineName"].stringValue
        let publicNumber = json["LinePublicNumber"].stringValue
        return LineDetails(destinationName: name, lineName: lineName, publicNumber: publicNumber)
    }
}