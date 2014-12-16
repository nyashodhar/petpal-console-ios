//
//  ConsoleViewController.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/11/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConsoleViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var mainTextView: UITextView!

    var gestureRecognizer: UITapGestureRecognizer!
    var previouslyConnectedDevice: BlueBasicDevice?
    var outboundBuffer = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTextView.delegate = self
        mainTextView.dataDetectorTypes = .None
        mainTextView.layoutManager.allowsNonContiguousLayout = false
        mainTextView.becomeFirstResponder()

        var gestureRecognizer = UITapGestureRecognizer(target:self, action: "tapped")
        mainTextView.addGestureRecognizer(gestureRecognizer)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (connectedDevice != nil && connectedDevice?.isConnected() == true && connectedDevice != previouslyConnectedDevice) {
            println("got connected dev")
            self.previouslyConnectedDevice = connectedDevice
            self.mainTextView.text = ""
            
            connectedDevice?.read({(data: NSData) -> Void in
                var text = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.appendText(text!)
            })
        }
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: "UIKeyboardDidShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: "UIKeyboardDidHideNotification", object: nil)

    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIKeyboardDidShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIKeyboardDidHideNotification", object: nil)
    }
    
    func tapped () {
        if !(mainTextView.isFirstResponder()) {
            mainTextView.becomeFirstResponder()
        } else {
            mainTextView.resignFirstResponder()
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if (connectedDevice == nil || connectedDevice?.isConnected() == false){
            var alert = UIAlertController(title: "", message: "No connected device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if text.utf16Count > 0 {
            writeToBuffer(text)
            if range.location == mainTextView.text.utf16Count {
                return true
            } else {
                mainTextView.selectedRange = NSMakeRange(mainTextView.text!.utf16Count, 0)
                mainTextView.insertText(text)
                mainTextView.scrollRangeToVisible(NSMakeRange(mainTextView.text.utf16Count, 0))
                return false
            }
        }
        
        if range.location == mainTextView.text.utf16Count - 1 && outboundBuffer.utf16Count > 0 {
            outboundBuffer.removeAtIndex(outboundBuffer.endIndex.predecessor())
            return true
        } else {
            return false
        }

    }
    
    func writeToBuffer(_ str: String = "\n") {
        for ch in str {
            outboundBuffer.append(ch)
            if ch == "\n" || outboundBuffer.utf16Count > 64 {
                connectedDevice?.write(outboundBuffer.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!)
                outboundBuffer = ""
            }
        }
    }

    func keyboardDidShow(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size
        let insets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize!.height, 0)
        self.mainTextView.contentInset = insets
        self.mainTextView.scrollIndicatorInsets = insets
    }
    
    func keyboardDidHide(notification: NSNotification) {
        let  contentInsets: UIEdgeInsets = UIEdgeInsetsZero;
        self.mainTextView.contentInset = contentInsets;
        self.mainTextView.scrollIndicatorInsets = contentInsets;
    }
    
    func appendText(text: String) {
        mainTextView.selectedRange = NSMakeRange(mainTextView.text!.utf16Count, 0)
        mainTextView.insertText(text)
        mainTextView.scrollRangeToVisible(NSMakeRange(mainTextView.text!.utf16Count, 0))
    }
    

    
    
}
