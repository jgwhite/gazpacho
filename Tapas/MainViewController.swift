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
        self.show("authenticate")
    }

    func authenticateWithEmail(email: String, password: String) {
        self.show("loading")

        let fetcher = FeedFetcher()

        fetcher.fetch(email: email, password: password) { (data: NSData?) in
            if let data = data {
                let parser = FeedParser(data: data)
                let episodes = parser.parse()

                dispatch_async(dispatch_get_main_queue()) {
                    self.show("library")
                    let vc = self.currentViewController as! LibraryViewController
                    vc.episodes = episodes
                    vc.email = email
                    vc.password = password
                }
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
}
