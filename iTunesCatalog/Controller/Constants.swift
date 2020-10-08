//
//  Constants.swift
//  iTunesCatalog
//
//  Created by Dmitry on 02.10.2020.
//

import Foundation

struct Constants {
    struct Api {
        static let Scheme = "https"
        static let Host = "itunes.apple.com"
        static var BaseUrl: String {
            return "\(Scheme)://\(Host)"
        }
        
        struct Paths {
            static let Search = "/search"
            static let Lookup = "/lookup"
        }
    }
    
    struct TableCells {
        static let Artist = "artistCell"
        static let Album = "albumCell"
        static let Track = "trackCell"
        static let SearchAlbum = "searchAlbumCell"
    }
    
    struct CollectionCells {
        static let Movie = "movieCell"
    }
    
    struct Segues {
        static let ShowAlbums = "showArtistAlbums"
        static let ShowTracks = "showAlbumTracks"
        static let ShowSearchAlbumTracks = "showSearchAlbumTracks"
        static let ShowMovie = "showMovie"
    }
    
    struct NavigationTitles {
        static let Albums = "Albums"
    }
}
