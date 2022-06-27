//
//  SearchPresenterProtocol.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    
    func configureSearchVeiw()
    
    func find(movie: String)
}
