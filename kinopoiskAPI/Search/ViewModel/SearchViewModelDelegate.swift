//
//  SearchViewModelDelegate.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 14.07.2022.
//

import Foundation

protocol SearchViewModelDelegate {
    var searchTextFieldModel: Dynamic<SearchSubviewsModel>? { get set }
    func createSearchTextFieldModel(viewWidth: Double, viewHeight: Double)
    func find(movie: String, completion: @escaping () -> Void)
}
