//
//  BluetoothContext.swift
//  PetPal
//
//  Created by Haavar Valeur on 10/21/14.
//  Copyright (c) 2014 PetPal. All rights reserved.
//

import Foundation
import CoreBluetooth

/*
protocol BluetoothDelegate {
    func discovered(device: Device)
}*/

class BluetoothContext: NSObject, CBCentralManagerDelegate {
    var centralManager : CBCentralManager!
    var deviceListeners = Array<((device: Device) -> Void)?>()
    var discoveredDevices = [String: Device]()
    //var connectedListeners = [String: Array<((error: NSError?) -> Void)?>]()
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
        println("created bluetooth context")
    }
    
    
    func addDeviceListener(listener: (device: Device?) -> Void) {
        deviceListeners.append(listener)
        if (centralManager.state == CBCentralManagerState.PoweredOn) {
            centralManager.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            // centralManager.scanForPeripheralsWithServices(nil, options:nil)
            println("Scranning for all services");
        }
        
    }
    /*
    func connect(device: Device, connected: (error: NSError?) -> Void) {
        //check if connected
        var listners = connectedListeners[device.peripheral.identifier.UUIDString]
        if (listners == nil) {
            listners = Array<((error: NSError?) -> Void)?>()
            listners?.append(connected)
            connectedListeners[device.peripheral.identifier.UUIDString] = listners
            centralManager.connectPeripheral(device.peripheral, options: nil)
        } else {
            listners?.append(connected)
        }
    }*/
    
    /*
    func stop() {
    scanning = false
    centralManager.stopScan()
    }*/
    
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!)  {
        if (central.state == CBCentralManagerState.PoweredOn) {
            println("bluetooth powered on")
            if !(deviceListeners.isEmpty) {
                centralManager.scanForPeripheralsWithServices(nil, options:[CBCentralManagerScanOptionAllowDuplicatesKey: true])
                println("Scranning for all services");
            }
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        var device: Device? = discoveredDevices[peripheral.identifier.UUIDString]
        if (device == nil) {
            println("Discovered device \(peripheral.identifier.UUIDString)")
            device = Device(peripheral: peripheral, centralManager: centralManager)
            discoveredDevices[peripheral.identifier.UUIDString] = device
            
        }
        for listener in deviceListeners {
            listener!(device: device!)
        }
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed to connect")
        if let device = discoveredDevices[peripheral.identifier.UUIDString] {
            device.didConnect(error)
        }
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Connected to \(peripheral)")
        if let device = discoveredDevices[peripheral.identifier.UUIDString] {
            println("sending connect message")
            device.didConnect(nil)
        }
        //peripheral.delegate = self
        // [peripheral discoverServices:@[[CBUUID UUIDWithString:BLUETOOTH_LISTEN_SERVICE]]];
        
        //peripheral.discoverServices(nil)
        
    }
    
    /*
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        println("discovered services error=\(error)")
        if (error != nil) {
            println("error discovering services (probably not)")
            //        [self cleanup];
            return;
        }
        for service in peripheral.services {
            //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
            println("Got service description=\(service.description) uuid=\(service.UUID)")
            peripheral.discoverCharacteristics(nil, forService:service as CBService)
            
        }
        // Discover other characteristics
    }
    
   */
    
    
    
}