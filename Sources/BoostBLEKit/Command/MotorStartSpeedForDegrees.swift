//
//  File.swift
//  
//
//  Created by Andy Wallace on 1/3/23.
//

import Foundation

public struct MotorStartSpeedForDegreesCommand: Command {
    
    public let portId: PortId
    public let degrees: Int32
    public let speed: Int8
    public let maxPower: UInt8

    
    /// speed: 0 = HOLD
    public init(portId: PortId, degrees: Int32, speed: Int8, maxPower: UInt8 = 100) {
        self.portId = portId
        self.speed = speed
        self.maxPower = maxPower
        self.degrees = degrees
    }
    
    public var data: Data {
        let speed = UInt8(bitPattern: self.speed)
        
        let d0 = UInt8(degrees & 0xFF)
        let d1 = UInt8((degrees >> 8) & 0xFF)
        let d2 = UInt8((degrees >> 16) & 0xFF)
        let d3 = UInt8((degrees >> 24) & 0xFF)
        
        return Data([0x0E, 0x00, 0x81, portId, 0x11, 0x0B, d0, d1, d2, d3 , speed, maxPower, 0x7F, 0x03])
    }
}


