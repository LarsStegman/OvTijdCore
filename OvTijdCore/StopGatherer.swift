//
//  StopGatherer.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

public class StopGatherer {

    public func getStopAreasNear(location: CLLocationCoordinate2D, handler callback: ([StopArea]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            let apiLocation = "https://\(APIPaths.Root.API)/\(APIPaths.Stops)/\(APIPaths.StopsEndpoint)\(APIPaths.Near)"
            let request = "\(apiLocation)\(location.latitude),\(location.longitude)&limit=\(APIPaths.maxNumberOfStopAreas)"
            let url = NSURL(string: request)!

            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let results = JSON(data: dataFromApi)
                let queryResults = self.rewriteOvApi(from: results)
                callback(self.generateStopAreas(from: queryResults))
            }
        }
    }

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

         {"Columns": [...], "Rows": [...]}
     
     The returned data will be of format

         [{key0: value0, key1: value1}, {key0: value0, key1: value1}, ...]

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
