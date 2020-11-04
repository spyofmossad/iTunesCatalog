//
//  ImageService.swift
//  iTunesCatalog
//
//  Created by Dmitry on 06.10.2020.
//

import Foundation

class ImageService {
    
    func getImage(from string: String?, completion: @escaping (Data?) -> Void) {
        guard let string = string, let url = URL(string: string) else {
            return
        }
                
        if let data = getCachedData(url: url) {
            completion(data)
        }
        
        fetchImageData(from: url) { (data, response) in
            self.saveDataToCache(with: data, and: response)
            completion(data)
        }
    }
    
    private func fetchImageData(from url: URL, completion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, _) in
            guard let data = data, let response = response else { return }
            completion(data, response)
        }).resume()
    }
    
    private func getCachedData(url: URL) -> Data? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return cachedResponse.data
        }
        return nil
    }
    
    private func saveDataToCache(with data: Data, and reponse: URLResponse) {
        guard let urlResponse = reponse.url else { return }
        let cachedResponse = CachedURLResponse(response: reponse, data: data)
        let urlRequest = URLRequest(url: urlResponse)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
}
