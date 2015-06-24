//
//  MainViewController.swift
//  Tapas
//
//  Created by Jamie White on 14/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    var currentViewController: NSViewController?

    override func viewDidLoad() {
        if let credentials = self.fetchCredentials() {
            self.loadLibrary(credentials)
        } else {
            self.show("authenticate")
        }
    }

    func loadLibrary(credentials: Credentials) {
        self.show("loading")

        self.fetchEpisodes(credentials) {
            (episodes: [Episode]?) in

            dispatch_async(dispatch_get_main_queue()) {
                self.show("library")

                let vc = self.currentViewController as! LibraryViewController
                vc.episodes = episodes
                vc.credentials = credentials
            }
        }
    }

    func fetchEpisodes(credentials: Credentials, then: [Episode]? -> Void) {
        let fetcher = FeedFetcher()

        fetcher.fetch(credentials) {
            (data: NSData?) in

            if let data = data {
                let parser = FeedParser(data: data)
                let episodes = parser.parse()

                then(episodes)
            } else {
                then(nil)
            }
        }
    }

    func show(name: String) {
        if let newViewController = self.storyboard?.instantiateControllerWithIdentifier(name) as? NSViewController {
            if let oldViewController = self.currentViewController {
                oldViewController.removeFromParentViewController()
                oldViewController.view.removeFromSuperview()
            }

            let newView = newViewController.view

            newView.frame = self.view.bounds
            newView.autoresizingMask = NSAutoresizingMaskOptions([.ViewWidthSizable, .ViewHeightSizable])

            self.currentViewController = newViewController
            self.addChildViewController(newViewController)
            self.view.addSubview(newView)
        }
    }

    func fetchCredentials() -> Credentials? {
        let query = [
            (kSecReturnAttributes as String) : kCFBooleanTrue,
            (kSecClass as String)            : kSecClassInternetPassword,
            (kSecAttrServer as String)       : "rubytapas.dpdcart.com"
        ]

        var itemRef: Unmanaged<AnyObject>?
        SecItemCopyMatching(query, &itemRef)

        if let username = itemRef?.takeRetainedValue()["acct"] as? String {
            let usernameLength = username.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

            let serverName = "rubytapas.dpdcart.com"
            let serverNameLength = serverName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

            var passwordLength: UInt32 = 0
            var passwordData: UnsafeMutablePointer<Void> = nil

            SecKeychainFindInternetPassword(
                nil,
                UInt32(serverNameLength),
                serverName,
                0, // securityDomainLength
                nil, // securityDomain
                UInt32(usernameLength),
                username,
                0, // pathLength
                nil, // path
                0, // port
                SecProtocolType(kSecProtocolTypeHTTPS),
                SecAuthenticationType(kSecAuthenticationTypeDefault),
                &passwordLength,
                &passwordData,
                nil // itemRef
            )

            if let password = NSString(bytes: passwordData, length: Int(passwordLength), encoding: NSUTF8StringEncoding) as? String {
                return Credentials(username: username, password: password)
            }
        }

        return nil
    }
}
