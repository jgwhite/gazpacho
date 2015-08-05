//
//  Episode.swift
//  Gazpacho
//
//  Created by Jamie White on 16/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class Episode: Equatable {
    var title: String = ""
    var url: String?
    var link: String = ""
    var description: String = ""
    var guid: String = ""
    var pubDate: String = ""
    var itunesSubtitle: String = ""
    var itunesImage: String = ""

}

func == (lhs: Episode, rhs: Episode) -> Bool {
    return lhs.guid == rhs.guid
}