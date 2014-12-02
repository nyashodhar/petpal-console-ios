//
//  ConsoleLabel.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/13/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import UIKit
class ConsoleLabel: UILabel {
   override func drawTextInRect(rect: CGRect)
    {

        let lineArray = self.text!.componentsSeparatedByString("\n")
        var textHeight = self.font.lineHeight * CGFloat(lineArray.count)
        if (textHeight > rect.size.height) {
            var linesToRemove = Int(ceil((textHeight - rect.size.height) / self.font.lineHeight))
          //  println("need to trim text lines=\(linesToRemove)")
            self.text = lineArray[linesToRemove]
            for var i = linesToRemove + 1; i < lineArray.count; i++ {
                self.text = self.text! + "\n" + lineArray[i]
            }
            textHeight = self.font.lineHeight * CGFloat(lineArray.count - linesToRemove)
        }
        
        var y = (rect.size.height - textHeight)/2
        super.drawTextInRect(CGRectMake(0, y, rect.size.width, rect.size.height))
        
    }
    
    func addText(text: String) {
        if (self.text == nil) {
            self.text = text
        } else {
            self.text = self.text! + text
        }
    }
}
