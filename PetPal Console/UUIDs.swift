//
//  UUIDs.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/12/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import Foundation
import CoreBluetooth

struct UUIDs {
    static let commsService = CBUUID(string: "25FB9E91-1616-448D-B5A3-F70A64BDA73A")
    static let inputCharacteristic = CBUUID(string: "C3FBC9E2-676B-9FB5-3749-2F471DCF07B2")
    static let outputCharacteristic = CBUUID(string: "D6AF9B3C-FE92-1CB2-F74B-7AFB7DE57E6D")
}