//
//  LocationBasedTimingPointGenerator.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 08-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

/**
	A TimingPointGenerator which generates the timing points based on a
	location. The generator searches for the nearest timing points.
*/
public class LocationBasedTimingPointGenerator: TimingPointGenerator {

	private var location: CLLocation

	init(at location: CLLocation) {
		self.location = location
	}

	public func timingPoints(forLocation location: CLLocation, useIn callback: ([TimingPoint]?) -> Void) {
		// TODO: Implement
	}

	public func timingPoints(useIn callback: ([TimingPoint]?) -> Void) {
		// TODO: Implement
	}
	
	
}