//
//  EpisodeViewController.swift
//  Tapas
//
//  Created by Jamie White on 16/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeViewController: NSViewController {
    var episode: Episode?
    @IBOutlet weak var webView: WebView!

    override func viewDidAppear() {
        self.webView.mainFrame.loadHTMLString("<p>Hello</p>", baseURL: NSURL(string: "")!)
    }
}
