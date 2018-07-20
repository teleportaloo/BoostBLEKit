//
//  Boost.swift
//  BoostBLEKitTests
//
//  Created by ooba on 20/07/2018.
//  Copyright © 2018 bricklife.com. All rights reserved.
//

import Foundation

public final class Boost {
    
    public final class MoveHub: Hub {
        
        public init() {}
        
        public var connectedDevices: [PortId : DeviceType] = [
            0x32: .rgbLight,
            0x37: .builtInMotor,
            0x38: .builtInMotor,
            0x39: .builtInMotor,
            0x3a: .tiltSensor,
            0x3b: .currentSensor,
            0x3c: .voltageSensor,
            ]
        
        public let portMap: [Port: PortId] = [
            .A:     0x37,
            .B:     0x38,
            .C:     0x01,
            .D:     0x02,
            .AB:    0x39,
            ]
        
        public func powerCommand(port: Port, power: Int8) -> Command? {
            guard let portId = portId(for: port) else { return nil }
            guard let deviceType = connectedDevices[portId] else { return nil }
            
            switch deviceType {
            case .interactiveMotor, .builtInMotor:
                return InteractiveMotorPowerCommand(portId: portId, power: power)
            case .mediumMotor, .trainMotor:
                return MotorPowerCommand(portId: portId, power: power)
            default:
                return nil
            }
        }
    }
}
