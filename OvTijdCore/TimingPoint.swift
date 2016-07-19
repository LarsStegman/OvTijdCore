//
//  TimingPoint.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 13-07-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public protocol TimingPoint {
    var timingPointCode: Int { get }
    var timingPointName: String { get }
}