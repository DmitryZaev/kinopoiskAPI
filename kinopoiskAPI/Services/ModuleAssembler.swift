//
//  ModuleAssembler.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import Foundation
import UIKit

class ModuleAssembler {
    
    static let collectionViewModel = CollectionViewModel()
    
    static func configureSearchVC() -> UIViewController {
        
        let vc = SearchViewController()
        let searhViewModel = SearchViewModel()
        let networkManager = NetworkManager()
        
        vc.searchViewModel = searhViewModel
        searhViewModel.collectionViewModel = collectionViewModel
        searhViewModel.networkManager = networkManager
        
        return vc
    }
    
    static func configureCollectionVC() -> UICollectionViewController {
        let networkManager = NetworkManager()
        collectionViewModel.networkManager = networkManager
        let collectionVC = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        collectionVC.collectionViewModel = collectionViewModel
        
        return collectionVC
    }
}
