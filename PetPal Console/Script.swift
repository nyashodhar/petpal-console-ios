//
//  Script.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/24/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import Foundation

class Script: NSObject, NSCoding {
    var title: String = ""
    var body: String = ""
    var fileName: String = ""

    override init () {
        super.init()
    }
    
    func getTitle() -> String {
        return title
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(body, forKey: "body")
    }
    
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectOfClass(NSString.self, forKey: "title") as NSString
        body   = aDecoder.decodeObjectOfClass(NSString.self, forKey: "body") as NSString
    }
}