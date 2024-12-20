//
//  RGBLightColorCommand.swift
//  BoostBLEKit
//
//  Created by Shinichiro Oba on 06/07/2018.
//  Copyright © 2018 bricklife.com. All rights reserved.
//

import Foundation

public struct RGBLightColorCommand: Command {
    
    public let portId: PortId
    public let color: Color
    public let mode: UInt8
    
    public init(portId: PortId, color: Color) {
        self.portId = portId
        self.color = color
        self.mode = 0x00
    }
    
    public init(colorSensorPortId: PortId, color: Color) {
        self.portId = colorSensorPortId
        self.color = color
        self.mode = 0x05
    }
    
    public var data: Data {
        return Data([0x08, 0x00, 0x81, portId, 0x11, 0x51, mode, color.rawValue])
    }
}
