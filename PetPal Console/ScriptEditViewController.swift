//
//  ScriptEditViewController.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/24/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import UIKit

class ScriptEditViewController: UIViewController {
    var script: Script?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = script?.title
        bodyTextView.text = script?.body
        
    }
    
    @IBAction func runClicked(sender: UIButton) {
        if (connectedDevice == nil || !connectedDevice!.isConnected()) {
            var alert = UIAlertController(title: "", message: "No connected device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        save()
        connectedDevice?.write((bodyTextView.text + "\n").dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!)
        self.performSegueWithIdentifier("run", sender: self)
        
        
    }
    
    @IBAction func backClicked(sender: UIButton) {
        self.save()
        self.performSegueWithIdentifier("list", sender: self)
    }
    
    func save() {
        var title  = titleTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (title == "") {
            // todo: we shold allow the title to be empty...
            var alert = UIAlertController(title: "", message: "Please enter a title", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let fileManager = NSFileManager.defaultManager()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let newFile = documentsPath.stringByAppendingPathComponent(title + ".basic");
        // don't overwrite another file with the same title
        if (title != script?.title && fileManager.fileExistsAtPath(newFile)) {
            var alert = UIAlertController(title: "", message: "Script already exists", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        bodyTextView.text.writeToFile(newFile, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        // file was renamed
        if (title != script?.title) {
            var oldFile = documentsPath.stringByAppendingPathComponent(script!.title + ".basic")
            fileManager.removeItemAtPath(oldFile, error: nil)
        }
 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let tabBarController = segue.destinationViewController as? UITabBarController {
            if (segue.identifier == "list") {
                tabBarController.selectedIndex = 2
            } else if (segue.identifier == "run") {
                tabBarController.selectedIndex = 1
            }
        }
    }
}