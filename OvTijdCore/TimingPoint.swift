//
//  Stop.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 08-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

/**
	A TimingPoint is one stop in a StopArea, e.g. one single bus sign. Next to 
	that a TimingPoint might also be a virtual point where a vehicle might
	stop, like a stop line on a bridge.
*/
public struct TimingPoint {
	let name: String
	let direction: String
	let location: CLLocation
	let isTimingStop: Bool
}