//
//  Tracks.swift
//  iTunesCatalog
//
//  Created by Dmitry on 03.10.2020.
//

import Foundation

struct Tracks: Codable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Codable {
    let wrapperType: Wrapper
    let trackName, artistName: String?
    let collectionName: String?
    let trackNumber, trackTimeMillis: Int?
}

enum Wrapper: String, Codable {
    case collection
    case track
}

extension Track {
    var artistAlbum: String? {
        if let artist = artistName,
           let album = collectionName {
            return "\(artist) - \(album)"
        }
        return nil
    }
    
    var trackWithNumber: String? {
        if let number = trackNumber?.description,
           let trackName = trackName {
            return "\(number). \(trackName)"
        }
        return nil
    }
}
