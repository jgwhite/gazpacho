//
//  Base64.swift
//  Gazpacho
//
//  Created by Jamie White on 17/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Foundation

struct Base64 {
    static func encode(string: String) -> String? {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        } else {
            return nil
        }
    }
}