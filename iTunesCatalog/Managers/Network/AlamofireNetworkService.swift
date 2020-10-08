//
//  AlamofireService.swift
//  iTunesCatalog
//
//  Created by Dmitry on 06.10.2020.
//

import Foundation
import Alamofire

class AlamofireNetworkService: NetworkServicePotocol {
    func searchArtists(by text: String, completion: @escaping (Artists) -> ()) {
        let params: [String : Any] = [
            "term": text,
            "entity": "musicArtist",
            "attribute": "artistTerm",
            "limit": 25
        ]
        AF.request(getUrl(for: .search), method: .get, parameters: params)
            .validate()
            .responseDecodable(of: Artists.self) { (dataResponse) in
                switch dataResponse.result {
                case .success(let artists):
                    completion(artists)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func searchAlbums(by text: String, completion: @escaping (Albums) -> ()) {
        let params: [String : Any] = [
            "term": text,
            "entity": "album",
            "attribute": "albumTerm",
            "limit": 25
        ]
        AF.request(getUrl(for: .search), method: .get, parameters: params)
            .validate()
            .responseDecodable(of: Albums.self) { (dataResponse) in
                switch dataResponse.result {
                case .success(let albums):
                    completion(albums)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func searchMovies(by text: String, completion: @escaping (Movies) -> ()) {
        let params: [String : Any] = [
            "term": text,
            "entity": "movie",
            "attribute": "movieTerm",
            "limit": 25
        ]
        AF.request(getUrl(for: .search), method: .get, parameters: params)
            .validate()
            .responseDecodable(of: Movies.self) { (dataResponse) in
                switch dataResponse.result {
                case .success(let movies):
                    completion(movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func getAlbums(byArtist id: Int, completion: @escaping (Albums) -> ()) {
        let params: [String : Any] = [
            "id":id.description,
            "entity":"album"
        ]
        AF.request(getUrl(for: .lookup), method: .get, parameters: params)
            .validate()
            .responseDecodable(of: Albums.self) { (dataResponse) in
                switch dataResponse.result {
                case .success(let albums):
                    completion(albums)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func getTracks(byAlbum id: Int, completion: @escaping (Tracks) -> ()) {
        let params: [String : Any] = [
            "id":id.description,
            "entity":"song"
        ]
        AF.request(getUrl(for: .lookup), method: .get, parameters: params)
            .validate()
            .responseDecodable(of: Tracks.self) { (dataResponse) in
                switch dataResponse.result {
                case .success(let tracks):
                    completion(tracks)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
