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
                var stopAreas = [StopArea]()

                for stopArea in queryResults.arrayValue {
                    stopAreas.append(StopArea.generate(from: stopArea))
                }
                callback(stopAreas)
            }
        }
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
                    timingPoints.append(TimingPoint.generate(from: timingPoint))
                }

                callback(timingPoints)
            }
        }
    }

    // FIXME: From here we need to start working on moving the parse code to the classes/structures

    public func stops(forTimingPoints timingPoints: [TimingPoint], handler callback: ([Stop]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let timingPointCodes = timingPoints.map({ "\($0.timingPointCode)" }).joinWithSeparator(", ")
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
                let stop = Stop.generate(from: details["Stop"])
                let passes = details["Passes"]
                for (passtimeCode, pass) in passes.dictionaryValue {
                    let pass = Pass.generate(from: pass, passtimeCode: passtimeCode)
                    stop.add(pass)
                    pass.stop = stop
                }

                stopsResult.append(stop)
            }

            return stopsResult
        }

        return [Stop]()
    }

    public func passes(forIdentifiers identifiers: [String], handler callback: ([Journey]) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let journeyIdentifiers = identifiers.joinWithSeparator(", ")
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
        if let passDict = passes.dictionary {
            for (passtimeCode, journey) in passDict {
                journeys.append(generateJourney(passtimeCode, from: journey))
            }
        }
        return journeys
    }

    private func generateJourney(passtimeCode: String, from journey: JSON) -> Journey {
        let journeyDict = journey.dictionaryValue
        var passes = [JourneyPass]()
        for (_, pass) in journeyDict["Stops"]!.dictionaryValue {
            passes.append(generateJourneyPass(passtimeCode, jPass: pass))
        }

    }

    

    private func generateJourneyDetails(from journeyDetails: JSON) -> JourneyDetails {
        let orderNumber = dict["UserStopOrderNumber"]!.intValue
        let stopType = JourneyStopType(rawValue: dict["JourneyStopType"]!.stringValue)!
        let journeyNumber = dict["JourneyNumber"]!.intValue

        return JourneyDetails(journeyNumber: journeyNumber, journeyPatternCode: 0, lineDirection: 0)
    }

    private func generateJourneyPass(passtimeCode: String, jPass: JSON) -> JourneyPass {
        let pass = generatePass(passtimeCode, pass: jPass)
        let dict = jPass.dictionaryValue
        let orderNumber = dict["UserStopOrderNumber"]!.intValue
        let stopType = JourneyStopType(rawValue: dict["JourneyStopType"]!.stringValue)!
        let journeyNumber = dict["JourneyNumber"]!.intValue
        return JourneyPass(pass: pass,
                           journeyStopType: stopType,
                           stopOrderNumber: orderNumber,
                           journeyNumber: journeyNumber)
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
