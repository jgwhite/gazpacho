//
//  AppDelegate.swift
//  Tapas
//
//  Created by Jamie White on 14/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func showMainWindow(sender: AnyObject) {
        showMainWindow()
    }

    func showMainWindow() {
        mainWindow?.makeKeyAndOrderFront(self)
    }

    var mainWindow: NSWindow? {
        return NSApplication.sharedApplication().windows[0]
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        mainWindow?.excludedFromWindowsMenu = true
    }

    func applicationShouldHandleReopen(app: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showMainWindow()
        return true
    }

}

