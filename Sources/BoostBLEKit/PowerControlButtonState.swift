//
//  PowerControlButtonState.swift
//  
//
//  Created by Andy Wallace on 12/14/22.
//

import Foundation

import Foundation

public typealias PowerControlButtonStateId = UInt8

public enum PowerControlButtonState: CaseIterable {
    
    case Plus
    case Minus
    case Stop
    case Released
}

extension PowerControlButtonState: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .Plus:
            return "1"
        case .Minus:
            return "-1"
        case .Stop:
            return "0"
        case .Released:
            return "Released"
        }
    }
}
