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
    public let transportType: Transport
    public let publicNumber: String

    init(destinationName: String, transport: Transport, lineName: String, publicNumber: String) {
        self.destinationName = destinationName
        self.transportType = transport
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
        if  let transport = Transport(string: json["TransportType"].string),
            let name = json["DestinationName50"].string,
            let lineName = json["LineName"].string,
            let publicNumber = json["LinePublicNumber"].string {

            self.init(destinationName: name, transport: transport, lineName: lineName, publicNumber: publicNumber)
        } else {
            print("LineDetails: parse error: \(json)")
            return nil
        }
    }
}