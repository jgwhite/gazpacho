//
//  EpisodeViewController.swift
//  Gazpacho
//
//  Created by Jamie White on 16/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation
import WebKit

class EpisodeViewController: NSViewController, WebPolicyDelegate {

    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var webView: WebView!

    let avdiStyles = "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://avdi.org/stylesheets/code.css\" />"
    let ourStyles = "<style type=\"text/css\">body { font-family: sans-serif; font-size: 14px; line-height: 1.4 } p { max-width: 40em } pre { margin: 1.4em 0; border-left: 5px solid #f92661; padding-left: 10px }</style>"

    var episode: Episode? {
        didSet {
            if episode != oldValue {
                update()
            }
        }
    }

    var credentials: Credentials? {
        didSet {
            update()
        }
    }

    override func viewDidLoad() {
        update()
    }

    func update() {
        displayHTML()
        displayVideo()
    }

    func displayHTML() {
        if let html = self.episode?.description {
            let htmlWithCSS = avdiStyles + ourStyles + html
            webView.mainFrame.loadHTMLString(htmlWithCSS, baseURL: NSURL(string: "http://www.rubytapas.com/")!)
        }
    }

    func displayVideo() {
        if let url = self.episode?.url, let credentials = self.credentials {
            let token = Base64.encode("\(credentials.username):\(credentials.password)")
            let headers = ["Authorization": "Basic \(token!)"]
            let asset = AVURLAsset(URL: NSURL(string: url)!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            let item = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: item)

            playerView.player = player

            player.play()
        }
    }

    func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        if let url = request.URL {
            let urlString = url.absoluteString

            if !blacklisted(urlString) && whitelisted(urlString) {
                listener.use()
            } else {
                NSWorkspace.sharedWorkspace().openURL(url)
            }
        }
    }


    private func blacklisted(str: String) -> Bool {
        return BLACKLIST.contains() { str.hasPrefix($0) }
    }

    private func whitelisted(str: String) -> Bool {
        return WHITELIST.contains() { str.hasPrefix($0) }
    }

    private let WHITELIST = [
        "https://rubytapas.dpdcart.com",
        "http://www.rubytapas.com/",
        "http://avdi.org"
    ]

    private let BLACKLIST = [
        "https://rubytapas.dpdcart.com/subscriber/download"
    ]
}
