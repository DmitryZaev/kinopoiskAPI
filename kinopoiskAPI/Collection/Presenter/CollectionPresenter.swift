//
//  CollectionPresenter.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import Foundation

class CollectionPresenter: CollectionPresenterProtocol {
    
    var viewHeight: Double = 0
    var viewWidth: Double = 0
    var movies = [MovieModel]()
    var title = String()
    var openSiteWithoutAlert: Bool? = false
    weak var collectionView: CollectionViewProtocol!
    var networkManager: NetManager!
    
    func getNumberOfItems() -> Int {
        return movies.count
    }
    
    func getSizeForItem() -> (Double, Double) {
        let itemWidth = viewWidth / 1.5
        let itemHeight = viewHeight / 2
        
        return (width: itemWidth, height: itemHeight)
    }
    
    func getCellModel(for index: Int, indexPath: IndexPath, opened: Bool) -> CellModel {
        let movie = movies[index]
        var imageData = Data()
        
        if let imageLink = movie.poster?.url {
            networkManager.getImageData(from: imageLink) { data in
                imageData = data
                self.collectionView.addImageToCell(with: indexPath, data: imageData)
            }
        }
        
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
        
        return CellModel(name: cellName,
                         year: cellYear,
                         picture: imageData,
                         kpRating: kpRating,
                         imdbRating: imdbRating,
                         description: cellDescription,
                         id: cellId,
        				 openedState: cellOpenedState)
    }
    
    func getTitle() -> String {
        return "Search: \"\(title)\""
    }
    
    func update(sortedBy: String, ascendingSort: Bool) {
        networkManager.findInKinopoisk(movie: title, with: sortedBy, ascendingSorting: ascendingSort) { [unowned self] newMovies in
            self.movies = newMovies
            self.collectionView.updateCollection()
        }
    }
    
    func checkNeedBackgroundLabel() {
        if movies.isEmpty {
            collectionView.addBackgroundLabel()
        }
    }
    
    func openSite(for id: String) {
        networkManager.openInKinopoiskSite(with: id)
    }
    
    func checkNeedAlertControllerOrOpenSite(for id: String) {
        guard let openSiteWithoutAlert = openSiteWithoutAlert else { return }
        if openSiteWithoutAlert {
            openSite(for: id)
        } else {
            collectionView.openAlertController(with: id)
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
