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
            if !contains(self.devices, device!) {
                self.devices.append(device!)
                self.tableView.reloadData()
            }
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var device: Device = devices[indexPath.row]
        var blueBasicDevice = BlueBasicDevice(device: device)
        blueBasicDevice.connect({(error: NSError?) in
            if (error == nil) {
                connectedDevice = blueBasicDevice
                self.tabBarController?.selectedIndex = 1
            } else {
                var alert = UIAlertController(title: "", message: "Unable to connect to device", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

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
        return cell
    }

}

