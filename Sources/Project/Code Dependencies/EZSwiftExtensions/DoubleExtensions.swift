//
//  DoubleExtensions.swift
//  EZSwiftExtensionsExample
//
//  Created by Goktug Yilmaz on 12/19/15.
//  Copyright © 2015 Goktug Yilmaz. All rights reserved.
//
import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#endif

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence

extension Double {
    
    /// EZSE: Converts Double to String
    public var toString: String { return String(self) }

    /// EZSE: Converts Double to Int
    public var toInt: Int { return Int(self) }
    
    #if os(iOS) || os(tvOS)
    
    /// EZSE: Converts Double to CGFloat
    public var toCGFloat: CGFloat { return CGFloat(self)}
    #endif
    
    /// EZSE: Creating the exponent operator
    static public func ** (lhs: Double, rhs: Double) -> Double {
        return pow(lhs, rhs)
    }
}

// MARK: - Deprecated 1.8
extension Double {

    
    @available(*, deprecated, renamed: "rounded(toPlaces:)")
    public func getRoundedByPlaces(_ places: Int) -> Double {
        return rounded(toPlaces: places)
    }

    
    @available(*, deprecated, renamed: "round(toPlaces:)")
    public mutating func roundByPlaces(_ places: Int) {
        self.round(toPlaces: places)
    }

    
    @available(*, deprecated, renamed: "ceiled(toPlaces:)")
    public func getCeiledByPlaces(_ places: Int) -> Double {
        return ceiled(toPlaces: places)
    }
    
    @available(*, deprecated, renamed: "ceil(toPlaces:)")
    public mutating func ceilByPlaces(_ places: Int) {
        self.ceil(toPlaces: places)
    }
    
    public var abs: Double {
        if self > 0 {
            return self
        } else {
            return -self
        }
    }

}