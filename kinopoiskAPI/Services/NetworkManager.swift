//
//  NetworkManager.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import Foundation
import UIKit

protocol NetManager {
    func findInKinopoisk(movie: String, with sorting: String?, ascendingSorting: Bool?) async throws -> [MovieModel]
    func getImageData(from link: String) async throws -> Data?
    func openInKinopoiskSite(with id: String)
}

class NetworkManager: NetManager {
    
    func findInKinopoisk(movie: String, with sorting: String?, ascendingSorting: Bool?) async throws -> [MovieModel] {
        
        guard let url = obtainRightURL(movie: movie,
                                       with: sorting,
                                       ascendingSorting: ascendingSorting) else { return [MovieModel]() }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return [MovieModel]() }
            let movies = self.obtainMovies(from: data)
            return movies
        } catch let error as NSError {
            print(error.localizedDescription)
            return [MovieModel]()
        }
    }
    
    private func obtainRightURL(movie: String, with sorting: String?, ascendingSorting: Bool?) -> URL? {
        
        let token = obtainToken()
        var url = URL(string: "")
        
        if sorting != nil, ascendingSorting != nil {
            var sortingType: String!
            switch ascendingSorting {
            case true: sortingType = "1"
            case false: sortingType = "-1"
            default: break
            }
            guard let sorting = sorting,
                  let sortingType = sortingType else { return url }
            var urlString = "https://api.kinopoisk.dev/movie?field=name&search=\(movie)&&sortField=\(sorting)&sortType=\(sortingType)&limit=500&isStrict=false&token=\(token)"
            url = URL(string: urlString)
            
            if url == nil {
                guard let codedMovie = movie.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return url }
                urlString = "https://api.kinopoisk.dev/movie?field=name&search=\(codedMovie)&&sortField=\(sorting)&sortType=\(sortingType)&limit=500&isStrict=false&token=\(token)"
                url = URL(string: urlString)
            }
        } else {
            var urlString = "https://api.kinopoisk.dev/movie?field=name&search=\(movie)&limit=500&isStrict=false&token=\(token)"
            url = URL(string: urlString)
            
            if url == nil {
                guard let codedMovie = movie.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return url }
                urlString = "https://api.kinopoisk.dev/movie?field=name&search=\(codedMovie)&limit=500&isStrict=false&token=\(token)"
                url = URL(string: urlString)
            }
        }
        return url
    }
    
    private func obtainToken() -> String {
        
        let path = Bundle.main.path(forResource: "Keys", ofType: "plist")
        guard let path = path else { return ""}
        let pathUrl = URL(fileURLWithPath: path)
        guard let keys = try? NSDictionary(contentsOf: pathUrl, error: ()) else { return ""}
        guard let token = keys["token"] as? String else { return ""}
        return token
    }
    
    private func obtainMovies(from data: Data) -> [MovieModel] {
        
        var movies = [MovieModel]()
        let decoder = JSONDecoder()
        var siteAnswer = SiteAnswer(docs: [MovieModel]())
        do {
            siteAnswer = try decoder.decode(SiteAnswer.self, from: data)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        movies = siteAnswer.docs
        return movies
    }
    
    func getImageData(from link: String) async throws -> Data? {
        
        if let imageData = CacheManager.getImageFromCache(for: link) {
            return imageData
        } else {
            guard let url = URL(string: link) else { return nil }
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
                defer {
                    CacheManager.putImageToCache(imageData: data, for: link)
                }
                return data
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    func openInKinopoiskSite(with id: String) {
        let urlString = "https://www.kinopoisk.ru/film/\(id)"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
