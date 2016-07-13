//
//  Request.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

/**
 Request retrieves data from an API.
 */
public class Request {

    private let apiLocation: String
    private let kv78Location: String

    init(apiLocation: String = APIPaths.Root.API, kv78APILocation kv78Location: String = APIPaths.Root.KV78Turbo) {
        self.apiLocation = "https://\(apiLocation)"
        self.kv78Location = kv78Location
    }

    /**
     Retrieves the StopAreas near the provided location.
 
     - Important: This method is not executed on the main queue.

     - Parameter location The location
     - Parameter handler The found StopAreas will be provided via a callback.
     */
    public func getStopAreasNear(location: CLLocationCoordinate2D, handler callback: ([StopArea]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            let api = "\(self.apiLocation)/\(APIPaths.Stops)/\(APIPaths.StopsEndpoint)\(APIPaths.Near)"
            let request = "\(api)\(location.latitude),\(location.longitude)&limit=\(APIPaths.maxNumberOfStopAreas)"
            let url = NSURL(string: request)!

            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let results = JSON(data: dataFromApi)
                let queryResults = self.rewriteOvApi(from: results)
                callback(self.generateStopAreas(from: queryResults))
            }
        }
    }

    /**
     Generates StopAreas from the specified JSON Object
     */
    private func generateStopAreas(from stopAreas: JSON) -> [StopArea] {
        var results = [StopArea]()

        for stopArea in stopAreas.arrayValue {
            let town = stopArea["TimingPointTown"].stringValue
            let name = stopArea["Name"].stringValue
            let location = CLLocationCoordinate2D(latitude: stopArea["Latitude"].doubleValue,
                                                  longitude: stopArea["Longitude"].doubleValue)
            let code = stopArea["StopAreaCode"].string
            results.append(StopArea(code: code, town: town, name: name, location: location))
        }

        return results
    }

    /**
     Generates a dictionary based on the given data.
     
     The given data should be of format

     `{"Columns": [...], "Rows": [...]}`
     
     The returned data will be of format

     `[{key0: value0, key1: value1}, {key0: value0, key1: value1}, ...]`

     - Returns The rewritten data.
     */
    private func rewriteOvApi(from json: JSON) -> JSON {
        var results = [[String: String]]()

        let columns = json["Columns"].arrayValue
        for row in json["Rows"].arrayValue {
            var rowWithKeys = [String: String]()
            for i in 0..<columns.count {
                let rowVal = row.arrayValue[i].description
                if rowVal != "null" {
                    rowWithKeys[columns[i].string!] = rowVal
                }
            }
            results.append(rowWithKeys)
        }

        return JSON(results)
    }

}
