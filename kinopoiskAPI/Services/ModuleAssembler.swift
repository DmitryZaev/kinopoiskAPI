//
//  ModuleAssembler.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import Foundation
import UIKit

class ModuleAssembler {
    
    static let collectionPresenter = CollectionPresenter()
    
    static func configureSearchVC() -> UIViewController {
        
        let vc = SearchViewController()
        let presenter = SearchPresenter()
        let networkManager = NetworkManager()
        
        presenter.collectionPresenter = collectionPresenter
        presenter.searchVC = vc
        presenter.networkManager = networkManager
        
        guard let searchView = vc.view as? SearchView else { return vc }
        searchView.presenter = presenter
        presenter.searchView = searchView
        
        return vc
    }
    
    static func configureCollectionVC() -> UICollectionViewController {
        let networkManager = NetworkManager()
        collectionPresenter.networkManager = networkManager
        let collectionVC = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionPresenter.collectionView = collectionVC
        collectionVC.collectionPresenter = collectionPresenter
        
        return collectionVC
    }
}
