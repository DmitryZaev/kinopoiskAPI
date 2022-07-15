//
//  SearchViewController.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private var viewSize: CGSize!
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.configureView()
        }
    }
    
    private func configureView() {
        searchView.searchViewModel.createSearchTextFieldModel(viewWidth: searchView.bounds.width,
                                                              viewHeight: searchView.bounds.height)
        
        searchView.searchViewModel.searchTextFieldModel?.bind { [weak self] model in
            self?.searchView.createSearchTextField(width: model.width,
                                                   height: model.height)
        }
        searchView.createActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchView.returnTextField()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        searchView.checkNeedMoveSearchTextField(newViewSize: size)
    }
    
    private func createAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
}

extension SearchViewController: SearchVCDelegate {
    
    func goToCollection() {
        let configuredCollectionVC = ModuleAssembler.configureCollectionVC()
        navigationController?.pushViewController(configuredCollectionVC, animated: true)
    }
}



