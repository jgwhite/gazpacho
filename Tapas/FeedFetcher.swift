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

    func fetch(credentials: Credentials, then: (NSData?) -> Void) {
        let url = self.url
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let userPasswordString = "\(credentials.username):\(credentials.password)"
        let base64EncodedCredential = Base64.encode(userPasswordString)
        let authString = "Basic \(base64EncodedCredential!)"
        let request = NSMutableURLRequest(URL: url)

        request.setValue(authString, forHTTPHeaderField: "Authorization")

        let task = session.dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

            then(data)
        }
        
        task!.resume()
    }
}
