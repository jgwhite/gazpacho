//
//  LibraryViewController.swift
//  Tapas
//
//  Created by Jamie White on 14/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class LibraryViewController: NSSplitViewController {

    var listViewController: ListViewController {
        return self.splitViewItems[0].viewController as! ListViewController
    }

    var episodeViewController: EpisodeViewController {
        return self.splitViewItems[1].viewController as! EpisodeViewController
    }

    var episodes: [Episode]? {
        get {
            return self.listViewController.episodes
        }
        set {
            self.listViewController.episodes = newValue
        }
    }

    var episode: Episode? {
        get {
            return self.episodeViewController.episode
        }
        set {
            self.episodeViewController.episode = newValue
        }
    }

    var email: String? {
        get {
            return self.episodeViewController.email
        }
        set {
            self.episodeViewController.email = newValue
        }
    }

    var password: String? {
        get {
            return self.episodeViewController.password
        }
        set {
            self.episodeViewController.password = newValue
        }
    }

}