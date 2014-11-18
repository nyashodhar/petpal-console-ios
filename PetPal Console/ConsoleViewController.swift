//
//  ConsoleViewController.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/11/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConsoleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var consoleLabel: ConsoleLabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var mainScrollView: UIScrollView!
    var keyboardControl: KeyboardControl!
    var gestureRecognizer: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardControl = KeyboardControl(scrollView: mainScrollView, textFields: [inputTextField])
        inputTextField.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        var gestureRecognizer = UITapGestureRecognizer(target:self, action: "tapped")
        mainScrollView.addGestureRecognizer(gestureRecognizer)
        inputTextField.becomeFirstResponder()
       
        //var inputCharacteristic = list[UUIDs.commsService]!.characteristics[UUIDS.inputCharacteristicUUID]
        // todo: only if new device...
        if (connectedDevice != nil && connectedDevice?.connected == true) {
            println("got connected dev")
            connectedDevice?.getCharacteristics(UUIDs.commsService, callback: { (characteristics: [CBCharacteristic]) -> Void in
                println("got chars")
                for characteristic: CBCharacteristic in characteristics {
                    println("characteristic=\(characteristic.UUID.UUIDString)")
                    if (characteristic.UUID == UUIDs.inputCharacteristic) {
                        println("got read characteristic")
                        connectedDevice?.peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                        connectedDevice?.read(characteristic, readValue: { (data, error) -> Void in
                           println("read data")
                            if (data != nil) {
                                
                                var text = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                println("text=\(text!)")
                                self.consoleLabel.addText(text!)

                            }
                        })
                    }
                }
            })
            
            
          
 
            
            
        }
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardControl.activate()
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardControl.deavtivate()
    }
    
    func tapped () {
        if !(inputTextField.isFirstResponder()) {
            inputTextField.becomeFirstResponder()
        } else {
            inputTextField.resignFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate m
        if (connectedDevice != nil && connectedDevice?.connected == true) {
            var text = inputTextField.text
            inputTextField.text = ""
            consoleLabel.addText(text + "\n")
            //  connectedDevice?.write(<#data: NSData#>, forCharacteristic: <#CBCharacteristic#>, type: <#CBCharacteristicWriteType#>)
        } else {
            var alert = UIAlertController(title: "", message: "No connected device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return true
    }
    
    
    
}
