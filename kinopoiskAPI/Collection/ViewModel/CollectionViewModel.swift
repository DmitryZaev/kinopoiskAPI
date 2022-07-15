//
//  CollectionViewModel.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 14.07.2022.
//

import Foundation

class CollectionViewModel: CollectionViewModelDelegate {
    
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
        networkManager.findInKinopoisk(movie: title.value, with: sortedBy, ascendingSorting: ascendingSort) { [unowned self] newMovies in
            self.movies.value = newMovies
            completion()
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
        if let imageLink = movie.poster?.url {
            networkManager.getImageData(from: imageLink) { data in
                DispatchQueue.main.async {
                    completion(data)
                }
            }
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

