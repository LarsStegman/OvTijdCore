//
//  TimingPointGenerator.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 08-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation
import CoreLocation

/**
	A TimingPointGenerator can generate a list of timing points based on some
	given information.
*/
public protocol TimingPointGenerator {

	/**
		Generates the timing points and provides the result as an argument
		for the callback.
		- parameter useIn The callback in which the results are used.
	*/
	func timingPoints(useIn callback: ([TimingPoint]?) -> Void)
}
