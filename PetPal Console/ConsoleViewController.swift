//
//  ConsoleViewController.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/11/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import UIKit

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
       
     //   consoleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingHead
        mainScrollView.addGestureRecognizer(gestureRecognizer)
        inputTextField.becomeFirstResponder()

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
        var text = inputTextField.text
        inputTextField.text = ""
        consoleLabel.addTextLine(text)
        return true
    }
    
    

}
