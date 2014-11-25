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
    }
    
    @IBAction func backClicked(sender: UIButton) {
    //    script?.body = bodyTextView.text
    //    script?.title = titleTextField.text
        self.performSegueWithIdentifier("list", sender: self)

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