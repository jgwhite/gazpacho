//
//  FeedParser.swift
//  Gazpacho
//
//  Created by Jamie White on 16/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Cocoa

class FeedParser: NSObject, NSXMLParserDelegate {
    var data: NSData
    var state: String = "idle"
    var result: [Episode] = []

    init(data: NSData) {
        self.data = data
    }

    func parse() -> [Episode] {
        let parser = NSXMLParser(data: self.data)
        parser.delegate = self
        parser.parse()
        return self.result
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
        case "item":
            let episode = Episode()
            self.result.append(episode)
        case "enclosure":
            self.state = "enclosure"
            if let episode = self.result.last {
                episode.url = attributeDict["url"]
            }
        default:
            self.state = elementName
        }
    }

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if let episode = self.result.last {
            switch self.state {
            case "title":
                episode.title += string
            case "link":
                episode.link += string
            case "description":
                episode.description += string
            case "guid":
                episode.guid += string
            case "pubDate":
                episode.pubDate += string
            case "itunes:subtitle":
                episode.itunesSubtitle += string
            case "itunes:image":
                episode.itunesImage += string
            default:
                return
            }
        }
    }
}
