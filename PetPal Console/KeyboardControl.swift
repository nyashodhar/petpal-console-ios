//
//  KeyboardControl.swift
//  PetPal
//
//  Created by Haavar Valeur on 11/3/14.
//  Copyright (c) 2014 PetPal. All rights reserved.
//

import UIKit


class KeyboardControl: NSObject {
    var scrollView: UIScrollView!
    var textFields: [UITextField]!
    var gestureRecognizer: UITapGestureRecognizer!
    var isKeyboardShowing = false
    
    init(scrollView: UIScrollView, textFields: [UITextField]) {
        self.scrollView = scrollView
        self.textFields = textFields
        
    }
    
    func activate () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
     //   gestureRecognizer = UITapGestureRecognizer(target:self, action: "hideKeyboard")
     //   scrollView.addGestureRecognizer(gestureRecognizer)
    }
    
    func deavtivate () {
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
      //  scrollView.removeGestureRecognizer(gestureRecognizer)
    }
    
    func hideKeyboard() {
        for (index, field : UIResponder) in enumerate(textFields) {
            field.resignFirstResponder()
        }
    }
    
    func keyboardWasShown (notification: NSNotification) {
        self.isKeyboardShowing = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size
        let insets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize!.height, 0)
        self.scrollView.contentInset = insets
        self.scrollView.scrollIndicatorInsets = insets
        self.scrollView.scrollEnabled = false
        for (index, field : UITextField) in enumerate(textFields) {
            if (field.isFirstResponder()) {
                self.scrollView.scrollRectToVisible(field.frame, animated: false)
            }
        }
    }
    
    func keyboardWillBeHidden (notification: NSNotification) {
        self.isKeyboardShowing = false
        let  contentInsets: UIEdgeInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
}