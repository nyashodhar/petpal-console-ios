//
//  Device.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/11/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import Foundation
import CoreBluetooth


class Device: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral
    var connectedListeners = Array<((error: NSError?) -> Void)?>()
    var readListeners = [String: Array<((data: NSData?, error: NSError?) -> Void)?>]()
    var serviceListeners = Array<((services: [CBService]) -> Void)?>()
    var characteristicsListeners = [String: Array<((characteristics: [CBCharacteristic]) -> Void)?>]()
    var connected: Bool = false
    var centralManager: CBCentralManager
    
    init(peripheral: CBPeripheral, centralManager: CBCentralManager) {
        self.peripheral = peripheral
        self.centralManager = centralManager
        super.init()
        peripheral.delegate = self
        connected = true // todo:
    }

    func connect(connected: (error: NSError?) -> Void) {
        //check if connected
        connectedListeners.append(connected)
        centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    func getServices(callback: (services: [CBService]) -> Void) {
      // todo: check cache
        serviceListeners.append(callback)
        peripheral.discoverServices(nil) // todo: should check for spesific service....
    }
    
    func getCharacteristics(serviceUUID: CBUUID, callback: (characteristics: [CBCharacteristic]) -> Void) {
       connectedDevice?.getServices({ (services) -> Void in
            for service: CBService in services {
                if (service.UUID == serviceUUID) {
                    var listeners = self.characteristicsListeners[serviceUUID.UUIDString]
                    if (listeners == nil) {
                        listeners = Array<((characteristics: [CBCharacteristic]) -> Void)?>()
                        listeners?.append(callback)
                        self.characteristicsListeners[serviceUUID.UUIDString] = listeners
                    } else {
                        listeners?.append(callback)
                    }
                    self.peripheral.discoverCharacteristics(nil, forService:service)
                }
            }
            
        })
    
    }
    
    func write(data: NSData, forCharacteristic: CBCharacteristic, type: CBCharacteristicWriteType) {
        if connected {
            peripheral.writeValue(data, forCharacteristic: forCharacteristic, type: type)
        }
    }
    
    func read(characteristic: CBCharacteristic, readValue: (data: NSData?, error: NSError?) -> Void) {
        var listeners = readListeners[characteristic.UUID.UUIDString]
        if (listeners == nil) {
            listeners = Array<((data: NSData?, error: NSError?) -> Void)?>()
            readListeners[characteristic.UUID.UUIDString] = listeners
        }
        readListeners[characteristic.UUID.UUIDString]?.append(readValue)
 
        peripheral.readValueForCharacteristic(characteristic)
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        var services = peripheral.services as? [CBService]
        for callback in serviceListeners {
            callback!(services: services!)
        }
        
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("updated value")
        if let listeners = readListeners[characteristic.UUID.UUIDString] {
            println("updated value listener size=\(listeners.count)")

            var value = characteristic.value
            for listener in listeners {
                listener!(data: value, error: error)
            }
            
        }
        
        // read again???
        
    }
  
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if (error != nil) {
            println("error discoverCharacteristicsForService services (maybe...)");
            //   [self cleanup];
            return;
        }
        if let listeners = characteristicsListeners[service.UUID.UUIDString] {
            for listener in listeners {
                listener!(characteristics: service.characteristics as [CBCharacteristic])
            }
        }
    }
    
    
    func didConnect(error: NSError?) {
        for listener in connectedListeners {
            listener!(error: error)
        }
    }
}