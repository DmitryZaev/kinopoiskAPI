//
//  SearchView.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 22.06.2022.
//

import Foundation
import UIKit

class SearchView: UIView {
    
    var searchTextField = UITextField()
    var activityIndicator = UIActivityIndicatorView()
    var textFieldWidthAnchor: NSLayoutConstraint?
    var textFieldHeightAnchor: NSLayoutConstraint?
    var foldedWidthAnchor: NSLayoutConstraint?
    var foldedHeightAnchor: NSLayoutConstraint?
    var centerYTextFieldAnchor: NSLayoutConstraint?
    var liftedCenterYTextFieldAnchor: NSLayoutConstraint?
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
    
    func createSearchTextField(width: Double, height: Double) {
        addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldWidthAnchor = searchTextField.widthAnchor.constraint(equalToConstant: width)
        textFieldHeightAnchor = searchTextField.heightAnchor.constraint(equalToConstant: height)
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
        searchTextField.layer.cornerRadius = height / 3
        searchTextField.layer.masksToBounds = true
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
    
    func configureAndAddPlaceholder() {
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter movie name or part of it",
                                                                   attributes: [.foregroundColor : UIColor.gray,
                                                                                .font : UIFont(name: "Galvji Bold", size: 20)!,
                                                                                .paragraphStyle: centeredParagraphStyle])
    }
    
    func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = lightBlueColor
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}


