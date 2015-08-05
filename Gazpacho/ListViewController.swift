//
//  ListViewController.swift
//  Gazpacho
//
//  Created by Jamie White on 17/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class ListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var tableView: NSTableView!

    var filter: String = "" {
        didSet {
            update()
        }
    }

    var episodes: [Episode]? {
        didSet {
            update()
        }
    }

    private var _results: [Episode]?

    var results: [Episode] {
        if let results = _results {
            return results
        }

        if let episodes = episodes {
            if filter.isEmpty {
                _results = episodes
            } else {
                _results = episodes.filter() {
                    let normalTitle = $0.title.lowercaseString
                    return normalTitle.rangeOfString(filter) != nil
                }
            }
        } else {
            _results = []
        }

        return _results!
    }

    var libraryViewController: LibraryViewController? {
        return parentViewController as? LibraryViewController
    }

    var episode: Episode? {
        get {
            return libraryViewController?.episode
        }
        set {
            libraryViewController?.episode = newValue
        }
    }

    var episodeIndex: Int? {
        if let episode = episode {
            return results.indexOf(episode)
        } else {
            return nil
        }
    }

    @IBAction func updateSearch(sender: AnyObject) {
        filter = searchField.stringValue.lowercaseString
    }

    func update() {
        _results = nil

        tableView.deselectAll(nil)
        tableView.reloadData()

        if let index = episodeIndex {
            tableView.selectRowIndexes(NSIndexSet(index: index), byExtendingSelection: false)
        }
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return results.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return results[row].title
    }

    func tableViewSelectionDidChange(notification: NSNotification) {
        guard (0..<results.count).contains(tableView.selectedRow) else {
            return
        }

        episode = results[tableView.selectedRow]
    }

    func tableView(tableView: NSTableView, shouldEditTableColumn tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false
    }

}
