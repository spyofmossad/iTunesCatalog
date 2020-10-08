//
//  Artist.swift
//  iTunesCatalog
//
//  Created by Dmitry on 02.10.2020.
//

import Foundation

struct Artists: Codable {
    let resultCount: Int
    let results: [Artist]
}

struct Artist: Codable {
    let artistName: String?
    let artistId: Int?
    let primaryGenreName: String?
}
