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
        if let credentials = Credentials.fetch() {
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
        FeedFetcher.fetch(credentials) {
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
}
