//
//  BlueBasicDevice.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/17/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import CoreBluetooth

class BlueBasicDevice: NSObject {
    let commsServiceCBUUID = CBUUID(string: "25FB9E91-1616-448D-B5A3-F70A64BDA73A")
    let readCharacteristicCBUUID = CBUUID(string: "C3FBC9E2-676B-9FB5-3749-2F471DCF07B2")
    let writeCharacteristicCBUUID = CBUUID(string: "D6AF9B3C-FE92-1CB2-F74B-7AFB7DE57E6D")
    var writeCharacteristic: CBCharacteristic?
    var readCharacteristic: CBCharacteristic?
    
    var device: Device
    
    init(device: Device) {
        self.device = device
    }
    
    func isConnected() -> Bool {
        return writeCharacteristic != nil && readCharacteristic != nil && device.connected
    }
    
    func connect(callback: (error: NSError?) -> Void) {
        self.device.connect({(error: NSError?) in
            if (error == nil) {
                self.device.getCharacteristics(self.commsServiceCBUUID, callback: { (characteristics: [CBCharacteristic]) -> Void in
                    for characteristic: CBCharacteristic in characteristics {
                        if (characteristic.UUID == self.readCharacteristicCBUUID) {
                            self.readCharacteristic = characteristic
                        } else if (characteristic.UUID == self.writeCharacteristicCBUUID) {
                            self.writeCharacteristic = characteristic
                        }
                    }
                    if (self.writeCharacteristic == nil || self.readCharacteristic == nil) {
                        callback(error: NSError(domain: "BlueBasicDevice", code: -1, userInfo: nil))
                        
                    } else {
                        callback(error: nil)
                    }
                })
                
            } else {
                callback(error: error)
            }
        })
        
    }
    
    func read(callback: (data: NSData) -> Void) {
        if (self.readCharacteristic != nil) {
            self.device.peripheral.setNotifyValue(true, forCharacteristic: self.readCharacteristic)
            self.device.read(self.readCharacteristic!, readValue: { (data, error) -> Void in
                if (data != nil) {
                    callback(data: data!)
                }
            })
        }
    }
    
    func write(data: NSData) {
      self.device.write(data, forCharacteristic: writeCharacteristic!, type: .WithResponse)
    }
}
