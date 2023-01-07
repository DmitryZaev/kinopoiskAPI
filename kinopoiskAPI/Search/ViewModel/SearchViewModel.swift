//
//  SearchViewModel.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 14.07.2022.
//

import Foundation

class SearchViewModel: SearchViewModelProtocol {
    
    var networkManager: NetManager!
    var collectionViewModel: CollectionViewModelProtocol!
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
        Task.detached { [unowned self] in
            let desiredMovie  = await self.makeDesiredMovieNameFrom(movieName: movie)
            let movies = try await self.networkManager.findInKinopoisk(movie: desiredMovie,
                                                                       with: nil,
                                                                       ascendingSorting: nil)
            await MainActor.run { [unowned self] in
                self.collectionViewModel.movies = Dynamic(movies)
                self.collectionViewModel.title = Dynamic(desiredMovie)
                completion()
            }
        }
    }
    
    private func makeDesiredMovieNameFrom(movieName: String) async -> String {
        var desiredMovie = movieName.lowercased()
        while desiredMovie.last == " " {
            desiredMovie.removeLast()
        }
        while desiredMovie.first == " " {
            desiredMovie.removeFirst()
        }
        return desiredMovie
    }
}
