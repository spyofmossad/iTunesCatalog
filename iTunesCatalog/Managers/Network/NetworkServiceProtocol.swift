//
//  NetworkServiceProtocol.swift
//  iTunesCatalog
//
//  Created by Dmitry on 06.10.2020.
//

import Foundation

enum UrlRequestType {
    case search
    case lookup
}

protocol NetworkServicePotocol {
    func searchArtists(by text: String, completion: @escaping (Artists) -> Void)
    func searchAlbums(by text: String, completion: @escaping (Albums) -> Void)
    func searchMovies(by text: String, completion: @escaping (Movies) -> Void)
    func getAlbums(byArtist id: Int, completion: @escaping (Albums) -> Void)
    func getTracks(byAlbum id: Int, completion: @escaping (Tracks) -> Void)
}

extension NetworkServicePotocol {
    func getUrl(for request: UrlRequestType) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Api.Scheme
        urlComponents.host = Constants.Api.Host
        
        switch request {
        case .search:
            urlComponents.path = Constants.Api.Paths.Search
        case .lookup:
            urlComponents.path = Constants.Api.Paths.Lookup
        }
        
        return urlComponents
    }
}
