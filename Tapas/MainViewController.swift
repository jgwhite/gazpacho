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

    var signOutMenuItem: NSMenuItem? {
        let app = NSApplication.sharedApplication()
        let menu = app.menu
        return menu?.itemAtIndex(1)?.submenu?.itemAtIndex(2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = NSApplication.sharedApplication().delegate as? AppDelegate {
            delegate.mainViewController = self
        }
        
        if let credentials = Credentials.fetch() {
            self.loadLibrary(credentials)
        } else {
            self.showAuthenticate()
        }
    }

    func signOut() {
        self.showAuthenticate()
    }

    func loadLibrary(credentials: Credentials) {
        self.show("loading")

        self.fetchEpisodes(credentials) {
            (episodes: [Episode]?) in

            if episodes?.count > 0 {
                Credentials.store(credentials)
                self.signOutMenuItem?.enabled = true

                self.show("library") {
                    let vc = self.currentViewController as! LibraryViewController
                    vc.episodes = episodes
                    vc.credentials = credentials
                }
            } else {
                print("Failed to fetch episodes, attempting re-auth")
                self.showAuthenticate()
            }

        }
    }

    func showAuthenticate() {
        Credentials.deleteAll()
        self.show("authenticate")
        self.signOutMenuItem?.enabled = false
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
        show(name, then: nil)
    }

    func show(name: String, then: (() -> Void)?) {
        dispatch_async(dispatch_get_main_queue()) {
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

            if let then = then {
                then()
            }
        }
    }
}
