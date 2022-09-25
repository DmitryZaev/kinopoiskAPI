//
//  NetworkManager.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import Foundation
import UIKit

protocol NetManager {
    func findInKinopoisk(movie: String, with sorting: String?, ascendingSorting: Bool?, comletion: @escaping ([MovieModel]) -> Void)
    func getImageData(from link: String, completion: @escaping (Data) -> Void)
    func openInKinopoiskSite(with id: String)
}

class NetworkManager: NetManager {
    
    func findInKinopoisk(movie: String, with sorting: String?, ascendingSorting: Bool?, comletion: @escaping ([MovieModel]) -> Void) {
        
        guard let url = obtainRightURL(movie: movie,
                                       with: sorting,
                                       ascendingSorting: ascendingSorting) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let response = response {
                print(response)
            }

            guard let data = data else { return }
            let movies = self.obtainMovies(from: data)
            comletion(movies)
        }.resume()
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
    
    func getImageData(from link: String, completion: @escaping (Data) -> Void) {
        
        if let imageData = CacheManager.getImageFromCache(for: link) {
            completion(imageData)
        } else {
            guard let url = URL(string: link) else { return }
            let session = URLSession.shared
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let data = data else { return }
                completion(data)
                CacheManager.putImageToCache(imageData: data, for: link)
            }.resume()
        }
    }
    
    func openInKinopoiskSite(with id: String) {
        let urlString = "https://www.kinopoisk.ru/film/\(id)"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
