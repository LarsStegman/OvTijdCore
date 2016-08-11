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

    init(destinationName: String, lineName: String, publicNumber: String) {
        self.destinationName = destinationName
        self.lineName = lineName
        self.publicNumber = publicNumber
    }

    /**
     Generate LineDetails from the given JSON object.

     - Parameter from: A json object with the following keys:
         - "LinePublicNumber"   : `String`
         - "LineName"           : `String`
         - "DestinationName50"  : `String`
     */
    init?(from json: JSON) {
        if  let name = json["DestinationName50"].string,
            let lineName = json["LineName"].string,
            let publicNumber = json["LinePublicNumber"].string {

            self.init(destinationName: name, lineName: lineName, publicNumber: publicNumber)
        } else {
            return nil
        }
    }
}