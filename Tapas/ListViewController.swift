//
//  ListViewController.swift
//  Tapas
//
//  Created by Jamie White on 17/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class ListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!

    var episodes: [Episode]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let count = self.episodes?.count {
            return count
        } else {
            return 0
        }
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return self.episodes?[row].title
    }

    func tableViewSelectionDidChange(notification: NSNotification) {
        if let episode = self.episodes?[self.tableView.selectedRow],
            let parent = self.parentViewController as? LibraryViewController {
            parent.episode = episode
        }
    }

}
