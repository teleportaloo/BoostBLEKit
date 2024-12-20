//
//  MotorStartSpeedTimeCommand.swift
//  
//
//  Created by Andy Wallace on 12/15/22.
//

import Foundation

import Foundation

public struct MotorStartSpeedTimeCommand: Command {
    
    public let portId: PortId
    public let time: UInt16
    public let speed: Int8
    public let maxPower: UInt8

    
    /// speed: 0 = HOLD
    public init(portId: PortId, time: UInt16, speed: Int8, maxPower: UInt8 = 100) {
        self.portId = portId
        self.speed = speed
        self.maxPower = maxPower
        self.time = time
    }
    
    public var data: Data {
        let speed = UInt8(bitPattern: self.speed)
        let bigTime = UInt8(time >> 8)
        let smallTime = UInt8(time & 0xFF)
        
        return Data([0x0C, 0x00, 0x81, portId, 0x11, 0x09, smallTime, bigTime, speed, maxPower, 0x7F, 0x03])
    }
}

