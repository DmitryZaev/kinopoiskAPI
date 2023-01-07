//
//  CollectionViewModel.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 14.07.2022.
//

import Foundation

class CollectionViewModel: CollectionViewModelProtocol {
    
    var viewHeight: Double!
    var viewWidth: Double!
    var openSiteWithoutAlert: Bool? = false
    
    var networkManager: NetManager!
    var title: Dynamic<String>!
    var movies: Dynamic<[MovieModel]>!
    
    func getSizeForItem() -> (Double, Double) {
        let itemWidth = viewWidth / 1.5
        let itemHeight = viewHeight / 2
        
        return (width: itemWidth, height: itemHeight)
    }
    
    func update(sortedBy: String, ascendingSort: Bool, completion: @escaping () -> Void) {
        Task.detached { [unowned self] in
            let newMovies = try await networkManager.findInKinopoisk(movie: title.value,
                                                                     with: sortedBy,
                                                                     ascendingSorting: ascendingSort)
            await MainActor.run { [unowned self] in
                self.movies.value = newMovies
                completion()
            }
        }
    }
    
    func checkNeedBackgroundLabel(completion: @escaping (Bool) -> Void) {
        completion(movies.value.isEmpty)
    }
    
    func getCellModel(for index: Int, opened: Bool, completion: @escaping (CellModel) -> Void) {
        
        let movie = movies.value[index]
        let cellName = movie.name ?? "??????????????"
        var cellYear = "????"
        if let year = movie.year, year != 0 {
            cellYear = String(year)
        }
        let kpRating = movie.rating.kp ?? 0.0
        let imdbRating = movie.rating.imdb ?? 0.0
        let cellDescription = movie.description ?? "No description \u{1F937}"
        let cellOpenedState = opened
        var cellId = ""
        if let id = movie.id {
            cellId = String(id)
        }
        
        completion(CellModel(name: cellName,
                        	 year: cellYear,
                         	 kpRating: kpRating,
                         	 imdbRating: imdbRating,
                         	 description: cellDescription,
                          	 id: cellId,
                         	 openedState: cellOpenedState))
    }
    
    func getImageForCell(index: Int, completion: @escaping (Data) -> Void) {
        let movie = movies.value[index]
        let imageLink : String
        if let poster = movie.poster {
            imageLink = poster.url
            Task.detached { [weak self] in
                guard let imageData = try await self?.networkManager.getImageData(from: imageLink) else { return }
                await MainActor.run {
                    completion(imageData)
                }
            }
        } else {
            guard let noImageUrl = Bundle.main.url(forResource: "haveNoImage", withExtension: "jpeg"),
                  let imageData = try? Data(contentsOf: noImageUrl) else { return }
            completion(imageData)
        }
        
    }
    
    func openSite(for id: String) {
        networkManager.openInKinopoiskSite(with: id)
    }
    
    func checkNeedAlertControllerOrOpenSite(for id: String, completion: @escaping () -> Void) {
        guard let openSiteWithoutAlert = openSiteWithoutAlert else { return }
        if openSiteWithoutAlert {
            openSite(for: id)
        } else {
            completion()
        }
    }
    
    func changeOpenSiteWithoutAlert(pressedYes: Bool) {
        if pressedYes {
            openSiteWithoutAlert = true
        } else {
            openSiteWithoutAlert = nil
        }
    }
    
    func cleanCache() {
        CacheManager.cleanCache()
    }

}

