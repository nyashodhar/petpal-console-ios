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
    var previouslyConnectedDevice: BlueBasicDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardControl = KeyboardControl(scrollView: mainScrollView, textFields: [inputTextField])
        inputTextField.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        var gestureRecognizer = UITapGestureRecognizer(target:self, action: "tapped")
        mainScrollView.addGestureRecognizer(gestureRecognizer)
        inputTextField.becomeFirstResponder()
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardControl.activate()
 
        if (connectedDevice != nil && connectedDevice?.isConnected() == true && connectedDevice != previouslyConnectedDevice) {
            println("got connected dev")
            self.previouslyConnectedDevice = connectedDevice
            self.consoleLabel.text = ""
            
            connectedDevice?.read({(data: NSData) -> Void in
                var text = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.consoleLabel.addText(text!)
            })
        }
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
        if (connectedDevice != nil && connectedDevice?.isConnected() == true) {
            var text = inputTextField.text
            inputTextField.text = ""
            consoleLabel.addText(text + "\n")
            connectedDevice?.write((text + "\n").dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!)
        } else {
            var alert = UIAlertController(title: "", message: "No connected device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return true
    }
    
    
    
}
