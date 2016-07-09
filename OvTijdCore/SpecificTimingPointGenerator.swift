//
//  SpecificTimingPointGenerator.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 08-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

/**
	A SpecificTimingPointGenerator generates a list of specific TimingPoints.
	If an id is not valid, nil will be returned.
*/
public class SpecificTimingPointGenerator: TimingPointGenerator {

	private var identifiers: [String]

	init(timingPointIdentifier timingPoint: String) {
		identifiers = [timingPoint]
	}

	init(timingPointsIdentifiers timingPoints: [String]) {
		identifiers = timingPoints
	}

	public func timingPoint(forIdentifer identifier: String, useIn callback: ([TimingPoint]?) -> Void) {
		// TODO: Implement
	}

	public func timingPoints(useIn callback: ([TimingPoint]?) -> Void) {
		// TODO: Implement
	}
}