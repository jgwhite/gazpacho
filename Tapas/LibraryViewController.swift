//
//  LibraryViewController.swift
//  Tapas
//
//  Created by Jamie White on 14/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa
import WebKit
import AVKit
import AVFoundation

class LibraryViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var playerView: AVPlayerView!

    var episodes: [Episode] = []
    var selectedEpisode: Episode?
    var email: String?
    var password: String?

    override func viewDidAppear() {
        self.tableView.reloadData()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.episodes.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return self.episodes[row].title
    }

    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedEpisode = self.episodes[self.tableView.selectedRow]

        self.displayHTML(selectedEpisode.description)

        if let url = selectedEpisode.url {
            self.displayVideo(url)
        }
    }

    func displayHTML(html: String) {
        self.webView.mainFrame.loadHTMLString(html, baseURL: NSURL(string: "http://www.rubytapas.com/")!)
    }

    func displayVideo(url: String) {
        let token = base64Encode("\(self.email!):\(self.password!)")
        let headers = ["Authorization": "Basic \(token!)"]
        let asset = AVURLAsset(URL: NSURL(string: url)!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)

        self.playerView.player = player

        player.play()
    }

    func base64Encode(string: String) -> String? {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        } else {
            return nil
        }
    }
}