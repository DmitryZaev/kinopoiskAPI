//
//  SearchViewProtocol.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    
    func createSearchTextField(with model: SearchSubviewsModel)
    
    func createActivityIndicator()
    
    func stopActivityIndicator()
}
