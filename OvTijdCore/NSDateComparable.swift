//
//  NSDateComparable.swift
//  OvTijdCore
//
//  Created by Lars Stegman on 16-08-16.
//  Copyright © 2016 Stegman. All rights reserved.
//

import Foundation

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

extension NSDate: Comparable {

}
