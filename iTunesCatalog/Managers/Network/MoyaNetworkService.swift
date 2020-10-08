//
//  MoyaNetworkService.swift
//  iTunesCatalog
//
//  Created by Dmitry on 06.10.2020.
//

import Foundation
import Moya

enum iTunesCatalogService {
    case searchArtists(text: String)
    case searchAlbums(text: String)
    case searchMovies(text: String)
    case getAlbums(id: Int)
    case getTracks(id: Int)
}

extension iTunesCatalogService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Api.BaseUrl)!
    }
    
    var path: String {
        switch self {
        case .searchArtists, .searchAlbums, .searchMovies:
            return Constants.Api.Paths.Search
        case .getAlbums, .getTracks:
            return Constants.Api.Paths.Lookup
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .searchArtists(let text):
            return .requestParameters(parameters: [
                "term": text,
                "entity": "musicArtist",
                "attribute": "artistTerm",
                "limit": 25
            ], encoding: URLEncoding.queryString)
        
        case .searchAlbums(text: let text):
            return .requestParameters(parameters: [
                "term": text,
                "entity": "album",
                "attribute": "albumTerm",
                "limit": 25
            ], encoding: URLEncoding.queryString)
        
        case .searchMovies(text: let text):
            return .requestParameters(parameters: [
                "term": text,
                "entity": "movie",
                "attribute": "movieTerm",
                "limit": 25
            ], encoding: URLEncoding.queryString)
        
        case .getAlbums(id: let id):
            return .requestParameters(parameters: [
                "id": id.description,
                "entity": "album"
            ], encoding: URLEncoding.queryString)
        
        case .getTracks(id: let id):
            return .requestParameters(parameters: [
                "id": id.description,
                "entity": "song"
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }

}

class MoyaNetworkManager: NetworkServicePotocol {
    
    private let provider: MoyaProvider<iTunesCatalogService>
    
    init() {
        provider = MoyaProvider<iTunesCatalogService>()
    }
    
    func searchArtists(by text: String, completion: @escaping (Artists) -> ()) {
        provider.request(.searchArtists(text: text)) { (result) in
            switch result {
            
            case .success(let moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let artists = try filteredResponse.map(Artists.self)
                    completion(artists)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchAlbums(by text: String, completion: @escaping (Albums) -> ()) {
        provider.request(.searchAlbums(text: text)) { (result) in
            switch result {
            
            case .success(let moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let albums = try filteredResponse.map(Albums.self)
                    completion(albums)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchMovies(by text: String, completion: @escaping (Movies) -> ()) {
        provider.request(.searchMovies(text: text)) { (result) in
            switch result {
            
            case .success(let moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let movies = try filteredResponse.map(Movies.self)
                    completion(movies)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getAlbums(byArtist id: Int, completion: @escaping (Albums) -> ()) {
        provider.request(.getAlbums(id: id)) { (result) in
            switch result {
            
            case .success(let moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let albums = try filteredResponse.map(Albums.self)
                    completion(albums)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getTracks(byAlbum id: Int, completion: @escaping (Tracks) -> ()) {
        provider.request(.getTracks(id: id)) { (result) in
            switch result {
            
            case .success(let moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let tracks = try filteredResponse.map(Tracks.self)
                    completion(tracks)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
