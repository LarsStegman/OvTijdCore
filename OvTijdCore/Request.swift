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

     - Parameter location: The location
     - Parameter handler: The found StopAreas will be provided via a callback.
     */
    public func stopAreas(near: CLLocation, handler callback: ([StopArea]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let request = self.generateURL(base: self.apiLocation,
                                       endpoint: "\(APIPaths.Stops.Stops)/\(APIPaths.Stops.Endpoint)",
                                       options: [APIPaths.Stops.NearOption: "\(near.coordinate.latitude),\(near.coordinate.longitude)",
                                        "limit": "\(APIPaths.maxNumberOfStopAreas)"])

            let url = NSURL(string: request)!

            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let queryResults = self.rewriteOvApi(from: JSON(data: dataFromApi))
                var stopAreas = [StopArea]()

                for stopArea in queryResults.arrayValue {
                    if let sa = StopArea(from: stopArea) {
                        stopAreas.append(sa)
                    }
                }
                callback(stopAreas)
            }
        }
    }

    /**
     Retrieves the timing points for a certain stop area.
     
     - Important: This method is not executed on the main queue.
     
     - Parameter inStopArea: The stop area for which the timing points have to be retrieved
     - Parameter handler: The retrieved timing points will be provided via the callback
     */
    public func timingPoints(inStopArea stopArea: StopArea, handler callback: ([TimingPoint]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let request = self.generateURL(base: self.apiLocation,
                                       endpoint: "\(APIPaths.Stops.Stops)/\(APIPaths.TimingPoint.Endpoint)",
                                        options: [APIPaths.TimingPoint.TownOption: stopArea.town,
                                            APIPaths.TimingPoint.NameOption: stopArea.name])
            let url = NSURL(string: request)!
            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let queryResults = self.rewriteOvApi(from: JSON(data: dataFromApi))
                var timingPoints = [TimingPoint]()

                for timingPoint in queryResults.arrayValue {
                    if let tp = TimingPoint(from: timingPoint) {
                        timingPoints.append(tp)
                    }

                }

                callback(timingPoints)
            }
        }
    }

    /**
     Retrieves the Stop for the given TimingPoints. The stops will also contain a list of passes which will occur in 
     the near future.

     - Important: This method is not executed on the main queue.

     - Parameter forTimingPoints: A list of timing points
     - Parameter handler: The found Stops will be provided via a callback.
     */
    public func stops(forTimingPoints timingPoints: [TimingPoint], handler callback: ([Stop]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let timingPointCodes = timingPoints.map({ "\($0.timingPointCode)" }).joinWithSeparator(",")
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
        guard let stopsDict = stops.dictionary else {
            return stopsResult
        }

        for (_, details) in stopsDict {
            guard let stop = Stop(from: details["Stop"]) else {
                break;
            }

            for (passtimeCode, pass) in details["Passes"].dictionaryValue {
                if let pass = Pass(from: pass, passtimeCode: passtimeCode) {
                    stop.add(pass)
                    pass.stop = stop
                }
            }

            stopsResult.append(stop)
        }

        return stopsResult
    }

    /**
     Retrieves the journeys corresponding to the provided identifiers
     
     - Important: This method is not executed on the main queue
     
     - Parameter forIdentifiers: The identifiers of the journey
     - Parameter hander:
     */
    public func journeys(forIdentifiers identifiers: [String], handler callback: ([Journey]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let journeyIdentifiers = identifiers.joinWithSeparator(",")
            let request = self.generateURL(base: self.kv78Location,
                                           endpoint: "\(APIPaths.Journey.Journey)/\(journeyIdentifiers)",
                                           options: [String: String]())
            let url = NSURL(string: request)!
            let dataFromNetwork = NSData(contentsOfURL: url)
            if let dataFromApi = dataFromNetwork {
                let queryResults = JSON(data: dataFromApi)
                let journeyPasses = self.generateJourneys(from: queryResults)

                callback(journeyPasses)
            }
        }
    }

    private func generateJourneys(from passes: JSON) -> [Journey] {
        var journeys = [Journey]()
        guard let passDict = passes.dictionary else {
            return journeys
        }

        for (passtimeCode, journey) in passDict {
            let stops = journey["Stops"]
            guard   let first = stops.first?.1,
                    let details = JourneyDetails(from: first),
                    let lineDetails = LineDetails(from: first) else {
                break
            }

            let journey = Journey(details: details, lineDetails: lineDetails)
            var passes = [Pass]()
            for (_, pass) in stops {
                if let journeyPass = Pass(from: pass, passtimeCode: passtimeCode) {
                    passes.append(journeyPass)
                }
            }

            journey.add(passes)
            journeys.append(journey)
        }

        return journeys
    }



    /**
     Generates a dictionary based on the given data.
     
     The given data should be of format

     `{"Columns": [...], "Rows": [...]}`
     
     The returned data will be of format

     `[{key0: value0, key1: value1}, {key0: value0, key1: value1}, ...]`

     - Returns: The rewritten JSON object.
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
        // Replacing the ampersands in the value and key should be done in `stringByAddingPercentEncodingWithAllowedCharacters:_`, but the implementation is bugged atm. If this is fixed in the future, please do so.
        for (key, value) in options {
            url += key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                .stringByReplacingOccurrencesOfString("&", withString: "%26").stringByAppendingString("=")

            url += value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                .stringByReplacingOccurrencesOfString("&", withString: "%26").stringByAppendingString("&")
        }
        return url
    }

}
