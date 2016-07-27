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
                let queryResults = self.rewriteOvApi(from: JSON(data: dataFromApi))
                let stopAreas = self.generateStopAreas(from: queryResults)

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

    /**
     Retrieves the timing points for a certain stop area.
     
     - Important: This method is not executed on the main queue.
     
     - Parameter: inStopArea The stop area for which the timing points have to be retrieved
     - Parameter: handler The retrieved timing points will be provided via the callback
     */
    public func timingPoints(inStopArea stopArea: StopArea, handler callback: ([TimingPoint]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let request = self.generateURL(base: self.apiLocation,
                                       endpoint: "\(APIPaths.Stops.Stops)/\(APIPaths.TimingPoint.Endpoint)",
                                        options: [APIPaths.TimingPoint.TownOption: stopArea.town, APIPaths.TimingPoint.NameOption: stopArea.name])
            let url = NSURL(string: request)!
            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let queryResults = self.rewriteOvApi(from: JSON(data: dataFromApi))
                var timingPoints = [TimingPoint]()
                for timingPoint in queryResults.arrayValue {
                    timingPoints.append(self.generateTimingPoint(from: timingPoint))
                }

                callback(timingPoints)
            }
        }
    }

    /**
     Generate timing points from the specified JSON Object.
     
     - Parameter: from The JSON from which the timing points are generated.
     */
    private func generateTimingPoint(from timingPoint: JSON) -> TimingPoint {
        let town = timingPoint["TimingPointTown"].stringValue
        let name = timingPoint["TimingPointName"].stringValue
        let code = timingPoint["TimingPointCode"].intValue
        return TimingPoint(timingPointCode: code, timingPointName: name, timingPointTown: town)
    }

    public func stops(forTimingPoints timingPoints: [TimingPoint], handler callback: ([Stop]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let timingPointCodes = timingPoints.reduce("") {
                (str: String, timingPoint: TimingPoint) -> String in
                return str.stringByAppendingString("\(timingPoint.timingPointCode)").stringByAppendingString(",")
            }
            let request = self.generateURL(base: self.kv78Location,
                                           endpoint: "\(APIPaths.TimingPoint.TimingPointCode)/\(timingPointCodes)",
                                           options: [String: String]())

            let url = NSURL(string: request)!
            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let queryResults = JSON(data: dataFromApi)
                let stops = self.generateStops(from: queryResults)

                callback(stops)
            }
        }
    }

    private func generateStops(from stops: JSON) -> [Stop] {
        var stopsResult = [Stop]()
        if let stopsDict = stops.dictionary {
            for (_, details) in stopsDict {
                let stop = generateStop(from: details["Stop"])
                let passes = details["Passes"]
                for (passtimeCode, pass) in passes.dictionaryValue {
                    stop.add(generatePass(passtimeCode, pass: pass))
                }

                stopsResult.append(stop)
            }

            return stopsResult
        }

        return [Stop]()
    }

    private func generateStop(from stop: JSON) -> Stop {
        let stopDict = stop.dictionaryValue
        let location = CLLocation(latitude: stopDict["Latitude"]!.doubleValue,
                                  longitude: stopDict["Longitude"]!.doubleValue)
        let timingPoint = generateTimingPoint(from: stop)
        return Stop(timingPoint: timingPoint, location: location)
    }

    private func generatePass(passtimeCode: String, pass: JSON) -> Pass {
        let passDict = pass.dictionaryValue
        let transport = Transport(rawValue: passDict["TransportType"]!.stringValue.lowercaseString.capitalizedString)!
        let timingPoint = generateTimingPoint(from: pass)
        let lineDetails = generateLineDetails(from: pass)
        let passPlanning = generatePassPlanning(from: pass)
        let status = TripStopStatus(rawValue: passDict["TripStopStatus"]!.stringValue.lowercaseString.capitalizedString)!
        return Pass(code: passtimeCode,
                    transport: transport,
                    timingPoint: timingPoint,
                    lineDetails: lineDetails,
                    planning: passPlanning,
                    status: status)
    }

    private func generateLineDetails(from lineDetails: JSON) -> LineDetails {
        let lineDetailsDict = lineDetails.dictionaryValue
        let name = lineDetailsDict["DestinationName50"]!.stringValue
        let lineName = lineDetailsDict["LineName"]!.stringValue
        let publicNumber = lineDetailsDict["LinePublicNumber"]!.stringValue
        return LineDetails(destinationName: name, lineName: lineName, publicNumber: publicNumber)
    }

    private func generatePassPlanning(from planning: JSON) -> PassPlanning {
        let planningDict = planning.dictionaryValue
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Amsterdam")

        let tat = dateFormatter.dateFromString(planningDict["TargetArrivalTime"]!.stringValue)!
        let eat = dateFormatter.dateFromString(planningDict["ExpectedArrivalTime"]!.stringValue)!
        let tdt = dateFormatter.dateFromString(planningDict["TargetDepartureTime"]!.stringValue)!
        let edt = dateFormatter.dateFromString(planningDict["ExpectedDepartureTime"]!.stringValue)!

        return PassPlanning(targetArrivalTime: tat, targetDepartureTime: tdt, expectedArrivalTime: eat, expectedDeparture: edt)
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
