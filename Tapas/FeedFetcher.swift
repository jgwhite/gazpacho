//
//  FeedFetcher.swift
//  Tapas
//
//  Created by Jamie White on 16/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class FeedFetcher {
    let url = NSURL(string: "https://rubytapas.dpdcart.com/feed")!

    func fetch(email email: String, password: String, then: (NSData?) -> Void) {
        let url = self.url
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let userPasswordString = "\(email):\(password)"
        let base64EncodedCredential = self.base64Encode(userPasswordString)
        let authString = "Basic \(base64EncodedCredential!)"
        let request = NSMutableURLRequest(URL: url)

        request.setValue(authString, forHTTPHeaderField: "Authorization")

        let task = session.dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

            then(data)
        }
        
        task!.resume()
    }

    func base64Encode(string: String) -> String? {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        } else {
            return nil
        }
    }
}
