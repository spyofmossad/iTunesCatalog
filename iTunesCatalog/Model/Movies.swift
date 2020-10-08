//
//  Movies.swift
//  iTunesCatalog
//
//  Created by Dmitry on 04.10.2020.
//

import Foundation

struct Movies: Codable {
    let resultCount: Int
    let results: [Movie]
}

struct Movie: Codable {
    let trackId: Int?
    let trackName, primaryGenreName: String?
    let artworkUrl100: String?
    let longDescription: String?
    let trackPrice: Double?
    let currency: String?
}

extension Movie {
    var fullPrice: String {
        if let price = trackPrice,
           let currency = currency {
            return "\(price.description) \(currency)"
        }
        
        return "N/A"
    }
}
