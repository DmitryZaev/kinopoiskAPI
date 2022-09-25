//
//  SearchViewController.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    var searchViewModel: SearchViewModelProtocol!
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
        searchViewModel.createSearchTextFieldModel(viewWidth: searchView.bounds.width,
                                                              viewHeight: searchView.bounds.height)
        
        searchViewModel.searchTextFieldModel?.bind { [weak self] model in
            self?.searchView.createSearchTextField(width: model.width,
                                                   height: model.height)
        }
        searchView.searchTextField.delegate = self
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
        checkNeedMoveSearchTextField(newViewSize: size)
    }
    
    private func checkNeedMoveSearchTextField(newViewSize: CGSize) {
        if searchView.searchTextField.isFirstResponder {
            searchView.searchTextField.resignFirstResponder()
            if newViewSize.width > searchView.frame.width {
                searchView.centerYTextFieldAnchor?.isActive = false
                searchView.liftedCenterYTextFieldAnchor?.isActive = true
            } else {
                searchView.liftedCenterYTextFieldAnchor?.isActive = false
                searchView.centerYTextFieldAnchor?.isActive = true
            }
            UIView.animate(withDuration: 0.3) {
                self.searchView.layoutIfNeeded()
            } completion: { _ in
                self.searchView.searchTextField.becomeFirstResponder()
            }
        }
    }
    
    private func returnTextField() {
        searchView.foldedWidthAnchor?.isActive = false
        searchView.foldedHeightAnchor?.isActive = false
        searchView.textFieldWidthAnchor?.isActive = true
        searchView.textFieldHeightAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.searchView.layoutIfNeeded()
        }
        
        searchView.searchTextField.text = nil
        searchView.searchTextField.textColor = .black
        searchView.configureAndAddPlaceholder()
    }
    
    private func createAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }

    private func goToCollection() {
        let configuredCollectionVC = ModuleAssembler.configureCollectionVC()
        navigationController?.pushViewController(configuredCollectionVC, animated: true)
    }
}

//MARK:  - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField == searchView.searchTextField else { return false }
        textField.placeholder = String()
        
        if UIDevice.current.orientation.isLandscape {
            searchView.centerYTextFieldAnchor?.isActive = false
            searchView.liftedCenterYTextFieldAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.searchView.layoutIfNeeded()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == searchView.searchTextField,
              let movieName = textField.text,
              movieName.isEmpty == false
        else { return false }
        
        textField.textColor = textField.backgroundColor
    
        searchView.textFieldWidthAnchor?.isActive = false
        searchView.textFieldHeightAnchor?.isActive = false
        searchView.foldedWidthAnchor?.isActive = true
        searchView.foldedHeightAnchor?.isActive = true

        UIView.animate(withDuration: 1) {
            self.searchView.layoutIfNeeded()
        } completion: { _ in
            self.searchView.activityIndicator.startAnimating()
            self.searchViewModel.find(movie: movieName) { [weak self] in
                self?.searchView.activityIndicator.stopAnimating()
                self?.goToCollection()
            }
            
            self.searchView.liftedCenterYTextFieldAnchor?.isActive = false
            self.searchView.centerYTextFieldAnchor?.isActive = true
            self.searchView.layoutIfNeeded()
        }
        textField.resignFirstResponder()
        return true
    }
}



