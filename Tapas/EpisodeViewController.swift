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

class EpisodeViewController: NSViewController {
    
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var webView: WebView!

    var episode: Episode? {
        didSet {
            self.update()
        }
    }
    var credentials: Credentials? {
        didSet {
            self.update()
        }
    }

    override func viewDidLoad() {
        self.update()
    }

    func update() {
        self.displayHTML()
        self.displayVideo()
    }

    func displayHTML() {
        if let html = self.episode?.description {
            self.webView.mainFrame.loadHTMLString(html, baseURL: NSURL(string: "http://www.rubytapas.com/")!)
        }
    }

    func displayVideo() {
        if let url = self.episode?.url, let credentials = self.credentials {
            let token = Base64.encode("\(credentials.username):\(credentials.password)")
            let headers = ["Authorization": "Basic \(token!)"]
            let asset = AVURLAsset(URL: NSURL(string: url)!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            let item = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: item)

            self.playerView.player = player

            player.play()
        }
    }
}
