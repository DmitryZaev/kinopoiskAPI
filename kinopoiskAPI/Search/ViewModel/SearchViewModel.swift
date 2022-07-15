//
//  SearchViewModel.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 14.07.2022.
//

import Foundation

class SearchViewModel: SearchViewModelDelegate {
    
    var networkManager: NetManager!
    var collectionViewModel: CollectionViewModelDelegate!
    var searchTextFieldModel: Dynamic<SearchSubviewsModel>?
    
    func createSearchTextFieldModel(viewWidth: Double, viewHeight: Double) {
        let size = [viewWidth, viewHeight]
        let sortedSize = size.sorted(by: <)
        guard let realViewWidth = sortedSize.first,
              let realViewHeight = sortedSize.last else { return }
        collectionViewModel.viewWidth = realViewWidth
        collectionViewModel.viewHeight = realViewHeight
        
        searchTextFieldModel = Dynamic(SearchSubviewsModel(height: realViewHeight * 0.05,
                                                           width: realViewWidth * 0.9))
    }
    
    func find(movie: String, completion: @escaping () -> Void) {
        var desiredMovie = movie.lowercased()
        while desiredMovie.last == " " {
            desiredMovie.removeLast()
        }
        while desiredMovie.first == " " {
            desiredMovie.removeFirst()
        }
        networkManager.findInKinopoisk(movie: desiredMovie, with: nil, ascendingSorting: nil) { [unowned self] movies in
            self.collectionViewModel.movies = Dynamic(movies)
            self.collectionViewModel.title = Dynamic(desiredMovie)
                DispatchQueue.main.async {
                    completion()
            }
        }
    }
}
