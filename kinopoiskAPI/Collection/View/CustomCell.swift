//
//  CustomCell.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import Foundation
import UIKit

class CustomCell: UICollectionViewCell {
    
    enum Rating: String {
        case kp = "kinopoiskLogo"
        case imdb = "imdbLogo"
    }
    
    private var myIndexPath: IndexPath!
    private var myDecriptionHeight: CGFloat!
    private var openedState: Bool!
    var id: String!
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let yearLabel = UILabel()
    private let kpRatingView = UIView()
    private let imdbRatingVeiw = UIView()
    private let kpRatingLabel = UILabel()
    private let imbdRatingLabel = UILabel()
    private let descriptionButton = UIButton()
    private let descriptionLabel = UILabel()
    private let aquamarineColor = UIColor(red: 102 / 255,
                                  green: 205 / 255,
                                  blue: 170 / 255,
                                  alpha: 1)
    
    func configureCell(model: CellModel, indexPath: IndexPath) {
        
        openedState = model.openedState
        myIndexPath = indexPath
        id = model.id
        
        layer.cornerRadius = bounds.width / 20
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = aquamarineColor
        layer.shadowColor = aquamarineColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        
        addImageView()
        addYearLabel(year: model.year)
        addNameLabel(name: model.name)
        addRatingViews(rating: .kp, textLabel: kpRatingLabel, ratingNumbers: model.kpRating)
        addRatingViews(rating: .imdb, textLabel: imbdRatingLabel, ratingNumbers: model.imdbRating)
        addDescriptionButton()
        addDescriptionLabel(text: model.description)
    }
    
    private func addImageView() {
        
        imageView.layer.cornerRadius =  5
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3)
        ])
    }
    
    private func addNameLabel(name: String) {
        
        nameLabel.text = name
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.isUserInteractionEnabled = false
        nameLabel.font = UIFont.init(name: "Noteworthy Bold", size: 20)
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4)
        ])
    }
    
    private func addYearLabel(year: String) {
        contentView.addSubview(yearLabel)
        yearLabel.text = "released in \(year)"
        yearLabel.textColor = .black
        yearLabel.isUserInteractionEnabled = false
        yearLabel.font = UIFont.init(name: "Noteworthy", size: 12)
        yearLabel.textAlignment = .center
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            yearLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.05),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            yearLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            yearLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        yearLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    func addImage(from data: Data) {
        let image = UIImage(data: data)
        imageView.image = image
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        imageView.image = nil
        yearLabel.text = nil
        kpRatingLabel.text = nil
        imbdRatingLabel.text = nil
        descriptionLabel.text = nil
    }
    
    private func addRatingViews(rating: Rating, textLabel: UILabel, ratingNumbers: Double) {
        var view = UIView()
        switch rating {
        case .kp:
            view = kpRatingView
        case .imdb:
            view = imdbRatingVeiw
        }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            view.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
        switch rating {
        case .kp:
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        case .imdb:
            view.topAnchor.constraint(equalTo: kpRatingView.bottomAnchor, constant: 20).isActive = true
        }
        
        let imageView = UIImageView(image: UIImage(named: rating.rawValue))
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            textLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        textLabel.text = "\(ratingNumbers) / 10"
        textLabel.textColor = .black
        textLabel.isUserInteractionEnabled = false
        textLabel.font = UIFont.init(name: "Noteworthy Bold", size: 12)
        textLabel.textAlignment = .center
    }
    
    private func addDescriptionButton() {
        contentView.addSubview(descriptionButton)
        descriptionButton.tintColor = .blue
        descriptionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            descriptionButton.heightAnchor.constraint(equalTo: descriptionButton.widthAnchor),
            descriptionButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            descriptionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        if openedState {
            descriptionButton.setImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
            descriptionButton.addTarget(self, action: #selector(closeDescription), for: .touchUpInside)
        } else {
            descriptionButton.setImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
            descriptionButton.addTarget(self, action: #selector(openDescription), for: .touchUpInside)
        }
    }
    
    private func addDescriptionLabel(text: String) {
        descriptionLabel.font = UIFont.init(name: "Noteworthy", size: 14)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.frame.size.width = contentView.bounds.width - 20
        descriptionLabel.text = text
        descriptionLabel.sizeToFit()
        myDecriptionHeight = descriptionLabel.frame.height
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: yearLabel.topAnchor, constant: -10),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
        
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    @objc private func openDescription() {
        let userInfo = ["indexPath" : myIndexPath as Any,
                        "descriptionHeight" : myDecriptionHeight as Any]
        NotificationCenter.default.post(name: Notification.Name("Opening"),
                                        object: nil,
                                        userInfo: userInfo)
    }
    
    @objc private func closeDescription() {
        let userInfo = ["indexPath" : myIndexPath as Any]
        NotificationCenter.default.post(name: Notification.Name("Closing"),
                                        object: nil,
                                        userInfo: userInfo)
    }
}
