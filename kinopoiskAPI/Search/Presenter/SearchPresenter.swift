//
//  SearchPresenter.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import Foundation

class SearchPresenter: SearchPresenterProtocol {
    
    weak var searchView: SearchViewProtocol!
    var searchVC: SearchVCProtocol!
    var collectionPresenter: CollectionPresenterProtocol!
    var networkManager: NetManager!
    private var viewWidth: Double!
    private var viewHeight: Double!
    
    func configureSearchVeiw() {
        if let searchView = searchView as? SearchView {
            let size = [Double(searchView.bounds.width), Double(searchView.bounds.height)]
            let sortedSize = size.sorted(by: <)
            viewWidth = sortedSize.first
            viewHeight = sortedSize.last
            collectionPresenter.viewWidth = viewWidth
            collectionPresenter.viewHeight = viewHeight
        }
        let searchTextFieldModel = SearchSubviewsModel(height: viewHeight * 0.05,
                                                       width: viewWidth * 0.9)
        
        searchView.createSearchTextField(with: searchTextFieldModel)
        searchView.createActivityIndicator()
    }
    
    func find(movie: String) {
        var desiredMovie = movie.lowercased()
        while desiredMovie.last == " " {
            desiredMovie.removeLast()
        }
        while desiredMovie.first == " " {
            desiredMovie.removeFirst()
        }
        networkManager.findInKinopoisk(movie: desiredMovie, with: nil, ascendingSorting: nil) { [unowned self] movies in
            self.collectionPresenter.movies = movies
            self.collectionPresenter.title = desiredMovie
            self.searchView.stopActivityIndicator()
                DispatchQueue.main.async {
                    self.searchVC.goToCollection()
            }
        }
    }
    
}
