//
//  Port.swift
//  BoostBLEKit
//
//  Created by Shinichiro Oba on 17/01/2018.
//  Copyright © 2018 bricklife.com. All rights reserved.
//

import Foundation

public typealias PortId = UInt8

public enum Port: CaseIterable {
    
    case A
    case B
    case C
    case D
    case AB
    case IMU_Tilt
    case IMU_Accel
    case IMU_Gyro
    case IMU_TempA
    case IMU_TempB
}

extension Port: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .A:
            return "A"
        case .B:
            return "B"
        case .C:
            return "C"
        case .D:
            return "D"
        case .AB:
            return "A and B"
        case .IMU_Tilt:
            return "IMU Tilt"
        case .IMU_Accel:
            return "IMU Accel"
        case .IMU_Gyro:
            return "IMU Gyro"
        case .IMU_TempA:
            return "IMU_TempA"
        case .IMU_TempB:
            return "IMU_TempB"
        }
    }
}
