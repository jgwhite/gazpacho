//
//  AuthenticateViewController.swift
//  Gazpacho
//
//  Created by Jamie White on 14/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class AuthenticateViewController: NSViewController {
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var signInButton: NSButton!

    override func viewDidAppear() {
        self.view.window?.makeFirstResponder(self.emailField)
    }

    @IBAction func authenticate(sender: AnyObject) {
        if let parent = self.parentViewController as? MainViewController {
            let email = self.emailField.stringValue
            let password = self.passwordField.stringValue
            let credentials = Credentials(username: email, password: password)
            parent.loadLibrary(credentials)
        }
    }
}
