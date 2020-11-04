//
//  Albums.swift
//  iTunesCatalog
//
//  Created by Dmitry on 02.10.2020.
//

import Foundation

struct Albums: Codable {
    let resultCount: Int
    let results: [Album]
}

struct Album: Codable {
    let wrapperType: WrapperType?
    let artistName: String
    let collectionId: Int?
    let collectionName: String?
    let artworkUrl60: String?
    let collectionPrice: Double?
    let currency: String?
}

enum WrapperType: String, Codable {
    case artist
    case collection
}

extension Album {
    var fullPrice: String {
        if let price = collectionPrice,
           let currency = currency {
            return "\(price.description) \(currency)"
        }
        
        return "N/A"
    }
}
