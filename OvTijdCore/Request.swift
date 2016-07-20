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

    init(apiLocation: String, kv78APILocation kv78Location: String) {
        self.apiLocation = apiLocation
        self.kv78Location = kv78Location
    }

    /**
     Retrieves the StopAreas near the provided location.
 
     - Important: This method is not executed on the main queue.

     - Parameter location The location
     - Parameter handler The found StopAreas will be provided via a callback.
     */
    public func stopAreas(near: CLLocation, handler callback: ([StopArea]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let request = self.generateURL(base: self.apiLocation,
                                       endpoint: "\(APIPaths.Stops.Stops)/\(APIPaths.Stops.Endpoint)",
                                       options: [APIPaths.Stops.NearOption: "\(near.coordinate.latitude),\(near.coordinate.longitude)", "limit": "\(APIPaths.maxNumberOfStopAreas)"])

            let url = NSURL(string: request)!

            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let results = JSON(data: dataFromApi)
                let queryResults = self.rewriteOvApi(from: results)
                var stopAreas = self.generateStopAreas(from: queryResults)

                for i in 0..<stopAreas.count {
                    stopAreas[i] = self.includeTimingpoints(inStopArea: stopAreas[i])
                }

                callback(stopAreas)
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
            let location = CLLocation(latitude: stopArea["Latitude"].doubleValue,
                                      longitude: stopArea["Longitude"].doubleValue)
            let code = stopArea["StopAreaCode"].string
            results.append(StopArea(code: code, name: name, town: town, location: location))
        }

        return results
    }

    private func includeTimingpoints(inStopArea stopArea: StopArea) -> StopArea {
        let request = generateURL(base: self.apiLocation,
                                  endpoint: "\(APIPaths.Stops.Stops)/\(APIPaths.TimingPoint.Endpoint)",
                                  options: [APIPaths.TimingPoint.TownOption: stopArea.town, APIPaths.TimingPoint.NameOption: stopArea.name])
        let url = NSURL(string: request)
        let dataFromNetwork = NSData(contentsOfURL: url!)
        if let dataFromApi = dataFromNetwork {
            let queryResults = self.rewriteOvApi(from: JSON(data: dataFromApi))
            let stopAreaCode = queryResults.array?.first?["StopAreaCode"].stringValue
            var resultingStopArea = StopArea(code: stopArea.code ?? stopAreaCode, name: stopArea.name, town: stopArea.town, location: stopArea.location)

            for timingPoint in queryResults.arrayValue {
                let town = timingPoint["TimingPointTown"].stringValue
                let name = timingPoint["TimingPointName"].stringValue
                let code = timingPoint["TimingPointCode"].intValue
                resultingStopArea.addTimingPoint(TimingPoint(timingPointCode: code, timingPointName: name, timingPointTown: town))
            }

            return resultingStopArea
        }
        return stopArea
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

    private func generateURL(base base: String, endpoint: String, options: [String: String]) -> String {
        var url = "\(base)/\(endpoint)"
        if options.count > 0 {
            url += "?"
        }
        for (key, value) in options {
            url += "\(key)=\(value)&"
        }
        return url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }

}
