//
//  IOType.swift
//  BoostBLEKit
//
//  Created by Shinichiro Oba on 17/01/2018.
//  Copyright © 2018 bricklife.com. All rights reserved.
//

import Foundation

public typealias SensorData = (a: Int32, b: Int32, c: Int32)

public enum IOType: Equatable, Hashable {
    
    case mediumMotor                // 0x01 (1)
    case trainMotor                 // 0x02 (2)
    case ledLight                   // 0x08 (8)
    case voltageSensor              // 0x14 (20)
    case currentSensor              // 0x15 (21)
    case piezoSpeaker               // 0x16 (22)
    case rgbLight                   // 0x17 (23)
    case tiltSensor                 // 0x22 (34)
    case motionSensor               // 0x23 (35)
    case colorAndDistanceSensor     // 0x25 (37)
    case interactiveMotor           // 0x26 (38)
    case builtInMotor               // 0x27 (39)
    case builtInTiltSensor          // 0x28 (40)
    case trainBaseMotor             // 0x29 (41)
    case trainBaseSpeaker           // 0x2a (42)
    case trainBaseColorSensor       // 0x2b (43)
    case trainBaseSpeedometer       // 0x2c (44)
    case largeMotor                 // 0x2e (46)
    case extraLargeMotor            // 0x2f (47)
    case mediumAngularMotor         // 0x30 (48)
    case largeAngularMotor          // 0x31 (49)
    case powerControlButton         // 0x37 (55)
    case poweredUpImuAccelerometer  // 0x39 (57)    // ARW
    case poweredUpImuGyro           // 0x3A (58)    // ARW
    case poweredUpImuPosition       // 0x3B (59)    // ARW
    case poweredUpImuTemperature    // 0x3C (60)
    case colorSensor                // 0x3d (61)
    case distanceSensor             // 0x3e (62)
    case forceSensor                // 0x3f (63)
    case colorLightMatrix           // 0x40 (64)
    case smallAngularMotor          // 0x41 (65)
    case marioAccelerometer         // 0x47 (71)
    case marioColorBarcodeSensor    // 0x49 (73)
    case marioPantsSensor           // 0x4a (74)
    case mediumAngularMotorGray     // 0x4b (75)
    case largeAngularMotorGray      // 0x4c (76)
    case unknown(UInt8)
}

extension IOType {
    
    init(rawValue: UInt8) {
        switch rawValue {
        case 0x01:
            self = .mediumMotor
        case 0x02:
            self = .trainMotor
        case 0x08:
            self = .ledLight
        case 0x14:
            self = .voltageSensor
        case 0x15:
            self = .currentSensor
        case 0x16:
            self = .piezoSpeaker
        case 0x17:
            self = .rgbLight
        case 0x22:
            self = .tiltSensor
        case 0x23:
            self = .motionSensor
        case 0x25:
            self = .colorAndDistanceSensor
        case 0x26:
            self = .interactiveMotor
        case 0x27:
            self = .builtInMotor
        case 0x28:
            self = .builtInTiltSensor
        case 0x29:
            self = .trainBaseMotor
        case 0x2a:
            self = .trainBaseSpeaker
        case 0x2b:
            self = .trainBaseColorSensor
        case 0x2c:
            self = .trainBaseSpeedometer
        case 0x2e:
            self = .largeMotor
        case 0x2f:
            self = .extraLargeMotor
        case 0x30:
            self = .mediumAngularMotor
        case 0x31:
            self = .largeAngularMotor
        case 0x37:
            self = .powerControlButton
        case 0x39:
            self = .poweredUpImuAccelerometer
        case 0x3A:
            self = .poweredUpImuGyro
        case 0x3B:
            self = .poweredUpImuPosition
        case 0x3C:
            self = .poweredUpImuTemperature
        case 0x3d:
            self = .colorSensor
        case 0x3e:
            self = .distanceSensor
        case 0x3f:
            self = .forceSensor
        case 0x40:
            self = .colorLightMatrix
        case 0x41:
            self = .smallAngularMotor
        case 0x47:
            self = .marioAccelerometer
        case 0x49:
            self = .marioColorBarcodeSensor
        case 0x4a:
            self = .marioPantsSensor
        case 0x4b:
            self = .mediumAngularMotorGray
        case 0x4c:
            self = .largeAngularMotorGray
        default:
            self = .unknown(rawValue)
        }
    }
    
    public var canSupportMotorStartPowerCommand: Bool {
        switch self {
        case .mediumMotor, .trainMotor, .ledLight, .interactiveMotor, .builtInMotor, .trainBaseMotor, .largeMotor, .extraLargeMotor, .mediumAngularMotor, .largeAngularMotor, .smallAngularMotor, .mediumAngularMotorGray, .largeAngularMotorGray:
            return true
        default:
            return false
        }
    }
    
    public var motorAbsPosition: Bool {
            switch self {
            case .interactiveMotor, .builtInMotor,  .largeMotor, .extraLargeMotor, .mediumAngularMotor, .largeAngularMotor, .smallAngularMotor, .mediumAngularMotorGray, .largeAngularMotorGray:
                return true
            default:
                return false
            }
        }
        
        public func equivalent(to: IOType) -> Bool {
            if self == to {
                return true
            }
            
            if self.motorAbsPosition && to.motorAbsPosition {
                return true
            }
            
            return false
        }
        
        static func int16Le(bytes : inout [UInt8], offset: Int) -> Int16 {
            return Int16(bytes[offset]) + Int16(bytes[offset+1]) << 8
        }
        
        public func dataConverterClosure(subType: Int) ->  ((_: Data) -> SensorData?)? {
            switch self {
            case .poweredUpImuAccelerometer:
                return { (data: Data) -> SensorData? in
                    guard data.count > 5 else { return nil }
                    var bytes = [UInt8](data)
                    // Measured in mG
                    let x = Int32( Float(IOType.int16Le(bytes: &bytes, offset: 0)) / 4.096);
                    let y = Int32( Float(IOType.int16Le(bytes: &bytes, offset: 2)) / 4.096);
                    let z = Int32( Float(IOType.int16Le(bytes: &bytes, offset: 4)) / 4.096);
                    return (a:x,b:y,c:z)
                }
            case .poweredUpImuGyro:
                return { (data: Data) -> SensorData? in
                    guard data.count > 5 else { return nil}
                    var bytes = [UInt8](data)
                    // Measured in DPS - degrees per second.
                    let x = Int32((Int(IOType.int16Le(bytes: &bytes, offset: 0)) * 7) / 400)
                    let y = Int32((Int(IOType.int16Le(bytes: &bytes, offset: 2)) * 7) / 400)
                    let z = Int32((Int(IOType.int16Le(bytes: &bytes, offset: 4)) * 7) / 400)
                    return (a:x,b:y,c:z)
                }
            case .poweredUpImuPosition:
                return { (data: Data) -> SensorData? in
                    guard data.count > 5 else { return nil }
                    var bytes = [UInt8](data)
                    // Measured in degrees
                    var z = IOType.int16Le(bytes: &bytes, offset: 0)
                    let x = IOType.int16Le(bytes: &bytes, offset: 2)
                    let y = IOType.int16Le(bytes: &bytes, offset: 4)
                    
                    // workaround for calibration problem or bug in technicMediumHub firmware 1.1.00.0000
                    if (y == 90 || y == -90) {
                        z = (y < 0 ? -1 : 1 ) * (z + 180)
                        if (z > 180)  { z -= 360 }
                        if (z < -180) {z += 360 }
                    }
                    return (a:Int32(x),b:Int32(y),c:Int32(z))
                }
            case .builtInTiltSensor:
                return { (data: Data) -> SensorData? in
                    guard data.count > 1 else { return nil }
                    let bytes = [UInt8](data)
                    
                    let x = Int8(bitPattern: bytes[0])
                    let y = Int8(bitPattern: bytes[1])
                    
                    return (a:Int32(x),b:Int32(y), c:0)
                }
            case .tiltSensor:
                return { (data: Data) -> SensorData? in
                    guard data.count > 1 else { return nil }
                    let bytes = [UInt8](data)
                    
                    let x : Int32 = Int32(Int8(bitPattern: bytes[0])) * 2
                    let y : Int32 = Int32(Int8(bitPattern: bytes[1])) * 2
                    
                    return (a:x,b:y, c:0)
                }
            case .colorAndDistanceSensor:
                return { (data: Data) -> SensorData? in
                    guard data.count > 2 else { return nil }
                    guard subType < 4 else { return nil}
                    guard subType <= data.count else { return nil }
                    
                    
                    let bytes = [UInt8](data)
                    
                    if (subType  == 0) {
                        return (a: Int32(bytes[subType]), b:0, c:0)
                    }
                    
                    var distance = Double(bytes[1])
                    let partial = Double(bytes[3])
                    
                    if (partial > 0) {
                        // print(partial)
                        distance +=  1.0 / partial;
                    }
                    var result: UInt8
                    
                    var mm = ((Float(distance) * 25.4) - 20)
                    if mm < 0 {
                        mm = 0
                    }
                    if (mm < 255) {
                        result = UInt8(mm)
                    } else {
                        result = 255
                    }
                    
                    return (a: Int32(result), b:0, c:0)
                }
            case .poweredUpImuTemperature:
                return { (data: Data) -> SensorData? in
                    guard data.count > 1 else { return nil }
                    var bytes = [UInt8](data)
                    return (a: Int32(IOType.int16Le(bytes: &bytes, offset: 0)), b:0, c:0)
                }
            case .interactiveMotor, .builtInMotor,  .largeMotor, .extraLargeMotor, .mediumAngularMotor, .largeAngularMotor, .smallAngularMotor, .mediumAngularMotorGray, .largeAngularMotorGray:
                return { (data: Data) -> SensorData? in
                    guard data.count > 1 else { return nil }
                    var bytes = [UInt8](data)
                    
                    let p = IOType.int16Le(bytes: &bytes, offset: 0)
                    
                    // print("\(bytes[0]) \(bytes[1]) \(p) \(bytes.count)")
                    return (a: Int32(p), b:0, c:0)
                }
            default:
                return nil
            }
        }
        
        public func closeEnoughClosure() ->  ((_: SensorData, _: SensorData) -> Bool)? {
            switch self {
            case .poweredUpImuPosition, .poweredUpImuGyro, .poweredUpImuAccelerometer:
                return { (lhs: SensorData, rhs: SensorData) -> Bool in
                    return abs(Int(lhs.a) - Int(rhs.a)) < 2 && abs(Int(lhs.b) - Int(rhs.b)) < 2 && abs(Int(lhs.c) - Int(rhs.c)) < 2
                }
            case .colorAndDistanceSensor:
                return { (lhs: SensorData, rhs: SensorData) -> Bool in
                    return lhs.a == rhs.a
                }
            case .tiltSensor, .builtInTiltSensor:
                return { (lhs: SensorData, rhs: SensorData) -> Bool in
                    return abs(Int(lhs.a) - Int(rhs.a)) < 2 && abs(Int(lhs.b) - Int(rhs.b)) < 2
                }
            case .poweredUpImuTemperature:
                return { (lhs: SensorData, rhs: SensorData) -> Bool in
                    abs(Int(lhs.a) - Int(rhs.a)) < 20
                }
            case .interactiveMotor, .builtInMotor,  .largeMotor, .extraLargeMotor, .mediumAngularMotor, .largeAngularMotor, .smallAngularMotor, .mediumAngularMotorGray, .largeAngularMotorGray:
                return { (lhs: SensorData, rhs: SensorData) -> Bool in
                    abs(Int(lhs.a) - Int(rhs.a)) < 2
                }
            default:
                return nil
            }
        }
    
    public var defaultSensorMode: UInt8? {
        switch self {
        case .mediumMotor:
            return nil
        case .trainMotor:
            return nil
        case .ledLight:
            return nil
        case .voltageSensor:
            return nil // return 0
        case .currentSensor:
            return nil // return 0
        case .piezoSpeaker:
            return nil
        case .rgbLight:
            return 0 // Not working on Boost and Powered Up
        case .tiltSensor:
            return 0 // ARW // 0: Tilt (x,y), 1: 2D Orientation, 2: Impact Count?? (3 bytes) 3: Tilt (x,y,z)
        case .motionSensor:
            return 0 // 0: Distance, 1: Count, 2: ?? (6 bytes)
        case .colorAndDistanceSensor:
            return 8 // 8: Color, Distance, and Ambient Light Level
        case .interactiveMotor:
            return 2 // 0: ??, 1: Speed, 2: Position
        case .builtInMotor:
            return 2 // 0: ??, 1: Speed, 2: Position
        case .builtInTiltSensor:
            return 0 // 0: Tilt (x,y), 1: 2D Orientation, 2: 3D Orientation, 3: Impact Count, 4: Tilt (x,y,z)
        case .trainBaseMotor:
            return nil
        case .trainBaseSpeaker:
            return nil
        case .trainBaseColorSensor:
            return 1 // 0: Realtime, 1: Detect
        case .trainBaseSpeedometer:
            return 0 // 0: Speed, 1: Distance
        case .largeMotor:
            return 2 // 0: ??, 1: Speed, 2: Position, 3: Absolute Position
        case .extraLargeMotor:
            return 3 // 0: ??, 1: Speed, 2: Position, 3: Absolute Position
        case .mediumAngularMotor:
            return 3 // 0: ??, 1: Speed, 2: Position, 3: Absolute Position
        case .largeAngularMotor:
            return 3 // 0: ??, 1: Speed, 2: Position, 3: Absolute Position
        case .powerControlButton:
            return 0 // ARW
        case .colorSensor:
            return 0 // 0: Color
        case .distanceSensor:
            return 0 // 0: Distance (mm)
        case .forceSensor:
            return 0 // 0: Pressure (%)
        case .colorLightMatrix:
            return 2 // 0: ?, 1: ?, 2: Matrix
        case .smallAngularMotor:
            return 3 // 0: ??, 1: Speed, 2: Position, 3: Absolute Position
        case .marioAccelerometer:
            return nil
        case .marioColorBarcodeSensor:
            return 0 // 0: TAG, 1: RGB
        case .marioPantsSensor:
            return 0 // 0: PANT
        case .mediumAngularMotorGray:
            return 3 // 0: ??, 1: Speed, 2: Position, 3: Absolute Position
        case .largeAngularMotorGray:
            return 3 // 0: ??, 1: Speed, 2: Position, 3: Absolute Position
        case .poweredUpImuAccelerometer:
            return 0
        case .poweredUpImuGyro:
            return 0
        case .poweredUpImuPosition:
            return 0   // 0: tilt 1, Impact Count
        case .poweredUpImuTemperature:
            return 0
            
        case .unknown:
            return nil
        }
    }
}

extension IOType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .mediumMotor:
            return "Medium Motor"
        case .trainMotor:
            return "Train Motor"
        case .ledLight:
            return "LED Light"
        case .voltageSensor:
            return "Voltage Sensor"
        case .currentSensor:
            return "Current Sensor"
        case .piezoSpeaker:
            return "Piezo Speaker"
        case .rgbLight:
            return "RGB Light"
        case .tiltSensor:
            return "Tilt Sensor"
        case .motionSensor:
            return "Motion Sensor"
        case .colorAndDistanceSensor:
            return "Color & Distance Sensor"
        case .interactiveMotor:
            return "Interactive Motor"
        case .builtInMotor:
            return "Built-in Motor"
        case .builtInTiltSensor:
            return "Built-in Tilt Sensor"
        case .trainBaseMotor:
            return "Duplo Train Base Motor"
        case .trainBaseSpeaker:
            return "Duplo Train Base Speaker"
        case .trainBaseColorSensor:
            return "Duplo Train Base Color Sensor"
        case .trainBaseSpeedometer:
            return "Duplo Train Base Speedometer"
        case .largeMotor:
            return "L Motor"
        case .extraLargeMotor:
            return "XL Motor"
        case .mediumAngularMotor:
            return "Medium Angular Motor"
        case .largeAngularMotor:
            return "Large Angular Motor"
        case .powerControlButton:
            return "Power Control Button"
        case .colorSensor:
            return "Color Sensor"
        case .distanceSensor:
            return "Distance Sensor"
        case .forceSensor:
            return "Force Sensor"
        case .colorLightMatrix:
            return "Color Light Matrix"
        case .smallAngularMotor:
            return "Small Angular Motor"
        case .marioAccelerometer:
            return "Mario Accelerometer"
        case .marioColorBarcodeSensor:
            return "Mario Color Barcode Sensor"
        case .marioPantsSensor:
            return "Mario Pants Sensor"
        case .mediumAngularMotorGray:
            return "Medium Angular Motor (Gray)"
        case .largeAngularMotorGray:
            return "Large Angular Motor (Gray)"
        case .poweredUpImuAccelerometer: // ARW
            return "Powered Up IMU Accelerometer"
        case .poweredUpImuGyro: // ARW
            return "Powered Up IMU Gyro"
        case .poweredUpImuPosition: // ARW
            return "Powered Up IMU Position"
        case .poweredUpImuTemperature: // ARW
            return "Powered Up IMU Temperature"
        case .unknown(let ioType):
            return String(format: "Unknown IO Type (0x%02x)", ioType)
        }
    }
}
