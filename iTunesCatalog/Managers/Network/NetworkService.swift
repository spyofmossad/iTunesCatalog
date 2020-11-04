//
//  NetworkServise.swift
//  iTunesCatalog
//
//  Created by Dmitry on 06.10.2020.
//

import Foundation

class NetworkService: NetworkServicePotocol {

    func searchArtists(by text: String, completion: @escaping (Artists) -> Void) {
        var urlComponents = getUrl(for: .search)
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: text.replacingOccurrences(of: " ", with: "+")),
            URLQueryItem(name: "entity", value: "musicArtist"),
            URLQueryItem(name: "attribute", value: "artistTerm"),
            URLQueryItem(name: "limit", value: "25")
        ]
        
        fetchData(from: urlComponents, completion: completion)
    }
    
    func searchAlbums(by text: String, completion: @escaping (Albums) -> Void) {
        var urlComponents = getUrl(for: .search)
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: text.replacingOccurrences(of: " ", with: "+")),
            URLQueryItem(name: "entity", value: "album"),
            URLQueryItem(name: "attribute", value: "albumTerm"),
            URLQueryItem(name: "limit", value: "25")
        ]
        
        fetchData(from: urlComponents, completion: completion)
    }
    
    func searchMovies(by text: String, completion: @escaping (Movies) -> Void) {
        var urlComponents = getUrl(for: .search)
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: text.replacingOccurrences(of: " ", with: "+")),
            URLQueryItem(name: "entity", value: "movie"),
            URLQueryItem(name: "attribute", value: "movieTerm"),
            URLQueryItem(name: "limit", value: "25")
        ]
        
        fetchData(from: urlComponents, completion: completion)
    }
    
    func getAlbums(byArtist id: Int, completion: @escaping (Albums) -> Void) {
        var urlComponents = getUrl(for: .lookup)
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: id.description),
            URLQueryItem(name: "entity", value: "album")
        ]
        
        fetchData(from: urlComponents, completion: completion)
    }
    
    func getTracks(byAlbum id: Int, completion: @escaping (Tracks) -> Void) {
        var urlComponents = getUrl(for: .lookup)
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: id.description),
            URLQueryItem(name: "entity", value: "song")
        ]
        
        fetchData(from: urlComponents, completion: completion)
    }
    
    private func getUrl(for request: UrlRequestType) -> URLComponents {
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
    
    private func fetchData<T: Decodable>(from urlComponents: URLComponents, completion: @escaping (T) -> Void) {
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error { print(error.localizedDescription) }
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result)
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }).resume()
    }
}
