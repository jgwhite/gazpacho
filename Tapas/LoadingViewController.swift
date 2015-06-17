//
//  LoadingViewController.swift
//  Tapas
//
//  Created by Jamie White on 16/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class LoadingViewController: NSViewController {
    @IBOutlet weak var progressIndicator: NSProgressIndicator!

    override func viewDidLoad() {
        self.progressIndicator.startAnimation(self)
    }
}
