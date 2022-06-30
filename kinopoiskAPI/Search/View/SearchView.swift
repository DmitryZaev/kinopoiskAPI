//
//  SearchView.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import Foundation
import UIKit

class SearchView: UIView {
    
    var presenter: SearchPresenterProtocol!
    var searchTextField = UITextField()
    private var activityIndicator = UIActivityIndicatorView()
    private var networkManager: NetManager!
    private var textFieldWidthAnchor: NSLayoutConstraint?
    private var textFieldHeightAnchor: NSLayoutConstraint?
    private var foldedWidthAnchor: NSLayoutConstraint?
    private var foldedHeightAnchor: NSLayoutConstraint?
    private var centerYTextFieldAnchor: NSLayoutConstraint?
    private var liftedCenterYTextFieldAnchor: NSLayoutConstraint?
    private let lightBlueColor = UIColor(red: 0 / 255,
                                  green: 128 / 255,
                                  blue: 255 / 255,
                                  alpha: 1)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - SearchViewProtocol implementation
extension SearchView: SearchViewProtocol {
    
    func createSearchTextField(with model: SearchSubviewsModel) {
        addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldWidthAnchor = searchTextField.widthAnchor.constraint(equalToConstant: model.width)
        textFieldHeightAnchor = searchTextField.heightAnchor.constraint(equalToConstant: model.height)
        centerYTextFieldAnchor = searchTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
        searchTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textFieldWidthAnchor?.isActive = true
        textFieldHeightAnchor?.isActive = true
        centerYTextFieldAnchor?.isActive = true
        
        foldedWidthAnchor = searchTextField.widthAnchor.constraint(equalToConstant: 0)
        foldedHeightAnchor = searchTextField.heightAnchor.constraint(equalToConstant: 0)
        liftedCenterYTextFieldAnchor = searchTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        
        searchTextField.backgroundColor = .orange
        searchTextField.textColor = .black
        searchTextField.textAlignment = .center
        searchTextField.font = UIFont(name: "Galvji Bold", size: 20)
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        searchTextField.layer.cornerRadius = model.height / 3
        searchTextField.layer.masksToBounds = true
        searchTextField.delegate = self
        configureAndAddPlaceholder()
        layoutIfNeeded()
    }
    
    func returnTextField() {
        self.foldedWidthAnchor?.isActive = false
        self.foldedHeightAnchor?.isActive = false
        self.textFieldWidthAnchor?.isActive = true
        self.textFieldHeightAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        searchTextField.text = nil
        searchTextField.textColor = .black
        configureAndAddPlaceholder()
    }
    
    private func configureAndAddPlaceholder() {
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter movie name or part of it",
                                                                   attributes: [.foregroundColor : UIColor.gray,
                                                                                .font : UIFont(name: "Galvji Bold", size: 20)!,
                                                                                .paragraphStyle: centeredParagraphStyle])
    }
    
    func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = center
        activityIndicator.color = lightBlueColor
        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}


//MARK: - UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = String()
        
        
        if UIDevice.current.orientation.isLandscape {
            centerYTextFieldAnchor?.isActive = false
            liftedCenterYTextFieldAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let movieName = textField.text,
              movieName.isEmpty == false
        else { return false }
        
        textField.textColor = textField.backgroundColor
    
        self.textFieldWidthAnchor?.isActive = false
        self.textFieldHeightAnchor?.isActive = false
        self.foldedWidthAnchor?.isActive = true
        self.foldedHeightAnchor?.isActive = true

        UIView.animate(withDuration: 1) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.activityIndicator.startAnimating()
            self.presenter.find(movie: movieName)
            
            guard let liftedAnchor = self.liftedCenterYTextFieldAnchor else { return }
            liftedAnchor.isActive = false
            self.centerYTextFieldAnchor?.isActive = true
            self.layoutIfNeeded()
        }
        searchTextField.resignFirstResponder()
        return true
    }
    
    func checkNeedMoveSearchTextField(newViewSize: CGSize) {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
            if newViewSize.width > frame.width {
                centerYTextFieldAnchor?.isActive = false
                liftedCenterYTextFieldAnchor?.isActive = true
            } else {
                liftedCenterYTextFieldAnchor?.isActive = false
                centerYTextFieldAnchor?.isActive = true
            }
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            } completion: { _ in
                self.searchTextField.becomeFirstResponder()
            }
        }
    }
}


