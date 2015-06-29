//
//  EpisodeViewController.swift
//  Tapas
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
            webView.mainFrame.loadHTMLString(html, baseURL: NSURL(string: "http://www.rubytapas.com/")!)
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

    override func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        let url = request.URL!

        if url.absoluteString.hasPrefix("https://rubytapas.dpdcart.com/subscriber/download") {
            NSWorkspace.sharedWorkspace().openURL(url)
        } else {
            listener.use()
        }
    }
}
