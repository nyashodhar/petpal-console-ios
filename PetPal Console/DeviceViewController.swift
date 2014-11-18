//
//  ViewController.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/11/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import UIKit
import CoreBluetooth //todo: should not bleed in here

class DeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var devices = [Device]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pullToRefresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        bluetoohContext.addDeviceListener { (device) -> Void in
           // println("got dev in view")
            if !contains(self.devices, device!) {
                self.devices.append(device!)
                self.tableView.reloadData()
            }
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var device: Device = devices[indexPath.row]
        println("did click \(device.peripheral.identifier.UUIDString)")
        device.connect({(error: NSError?) in
            if (error == nil) {
                println("did connect!!!")
                connectedDevice = device
           //    self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers[1]
               /*
                device.getServices({(services: [CBService]) in
                    
                    var foundCommService = false
                    for service in services {
                       println("found service \(service.UUID.UUIDString)")
                        if (service.UUID.UUIDString == UUIDs.commsService) {
                            foundCommService = true
                            connectedDevice = device
                        }
                    }
                    if (foundCommService) {
                        self.tabBarController?.selectedIndex = 1
                    }

                })*/
                
                 self.performSegueWithIdentifier("show_console", sender: self)
            } else {
                println("failed to connect!")
            }
        })
        
    }
    
    func pullToRefresh(sender: UIRefreshControl) {
        devices.removeAll(keepCapacity: true)
        tableView.reloadData();
        sender.endRefreshing()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell", forIndexPath: indexPath) as UITableViewCell
        
        let device = devices[indexPath.row]
        let name = device.peripheral.name
        if (name != nil)  {
            cell.textLabel.text = name
        } else {
             cell.textLabel.text = devices[indexPath.row].peripheral.identifier.UUIDString
        }
        device.getServices { (services) -> Void in
            var found = false
            for service in services {
                if (service.UUID.UUIDString == UUIDs.commsService.UUIDString) {
                    found = true
                    break
                    
                }
            }
            if (!found) {
                cell.textLabel.text = cell.textLabel.text! + " (not ours)"
            }
        }
        
        
       // cell.imageView.sizeToFit()
        return cell
    }

}

