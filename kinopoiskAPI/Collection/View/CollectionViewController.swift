//
//  CollectionViewController.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var collectionPresenter: CollectionPresenterProtocol!
    var sortButtonItem = UIBarButtonItem()
    var activityIndicatorItem = UIBarButtonItem()
    var activityIndicator = UIActivityIndicatorView()
    var sortMenu = UIMenu()
    var plusHeightForOpenedCells = [IndexPath : Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        addMenu()
        addActivityIndicatorItem()
        addSortButtonItem()
        configureRightBarButtonItems()
        collectionPresenter.checkNeedBackgroundLabel()
        
        self.collectionView!.register(CustomCell.self,
                                      forCellWithReuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationHandler(notification:)),
                                               name: Notification.Name("Opening"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationHandler(notification:)),
                                               name: Notification.Name("Closing"),
                                               object: nil)
    }
    
    @objc private func notificationHandler(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let cellIndexPath = userInfo["indexPath"] as? IndexPath
        else { return }
        
        if let descriptionHeight = userInfo["descriptionHeight"] as? CGFloat {
            plusHeightForOpenedCells[cellIndexPath] = Double(descriptionHeight) + 20
        } else {
            plusHeightForOpenedCells[cellIndexPath] = nil
        }
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.collectionView.reloadItems(at: [cellIndexPath])
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .yellow
        createAppearance()
        collectionView.delegate = self
        collectionView.dataSource = self
        title = collectionPresenter.getTitle()
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .blue
    }
    
    private func addSortButtonItem() {
        sortButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        sortButtonItem.image = UIImage(systemName: "line.3.horizontal.decrease")
        sortButtonItem.menu = sortMenu
    }
    
    private func addMenu() {
        
        let upSymbol = " \u{2934}"
		let downSymbol = " \u{2935}"
        
        sortMenu = UIMenu(title: "Sort by", image: nil, identifier: .text, options: .singleSelection, children: [
            UIAction(title: "name" + upSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "name", ascendingSort: true)
            }),
            UIAction(title: "name" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "name", ascendingSort: false)
            }),
            UIAction(title: "year" + upSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "year", ascendingSort: true)
            }),
            UIAction(title: "year" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "year", ascendingSort: false)
            }),
            UIAction(title: "kinopoisk rating" + upSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "rating.kp", ascendingSort: true)
            }),
            UIAction(title: "kinopoisk rating" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "rating.kp", ascendingSort: false)
            }),
            UIAction(title: "imdb rating" + upSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "rating.imdb", ascendingSort: true)
            }),
            UIAction(title: "imdb rating" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionPresenter.update(sortedBy: "rating.imdb", ascendingSort: false)
            })
        ])
    }
    
    private func addActivityIndicatorItem() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.color = .blue
        activityIndicator.hidesWhenStopped = true
    }
    
    private func activityIndicatorChangeState() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    private func configureRightBarButtonItems() {
        navigationItem.rightBarButtonItems = [sortButtonItem, activityIndicatorItem]
    }
    
    private func createAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue,
                                          NSAttributedString.Key.font : UIFont(name: "Galvji",
                                                                               size: 15) as Any]
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.backward"),
                                         transitionMaskImage: UIImage(systemName: "arrow.backward"))
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func addBackgroundLabel() {
        let backgroundLabel = UILabel()
        backgroundLabel.text = "there is nothing like this \u{1F645}"
        backgroundLabel.font = UIFont(name: "Galvji", size: 25)
        backgroundLabel.textColor = .blue
        backgroundLabel.textAlignment = .center
        backgroundLabel.sizeToFit()
        collectionView.backgroundView = backgroundLabel
    }
    
    //MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionPresenter.getNumberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CustomCell

        let cellOpenedState: Bool = (plusHeightForOpenedCells[indexPath] != nil)
        cell?.configureCell(model: collectionPresenter.getCellModel(for: indexPath.item,
                                                                    indexPath: indexPath,
                                                                    opened: cellOpenedState),
                            indexPath: indexPath)
        return cell ?? UICollectionViewCell()
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 10,
                            bottom: 30,
                            right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell,
              let id = cell.id
        else { return }
        collectionPresenter.openSite(for: id)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionPresenter.getSizeForItem()
        if plusHeightForOpenedCells[indexPath] != nil {
            size.1 += plusHeightForOpenedCells[indexPath]!
        }
        return CGSize(width: size.0,
                      height: size.1)
    }
}

//MARK:  - CollectionViewProtocol implementation
extension CollectionViewController: CollectionViewProtocol {
    
    func addImageToCell(with indexPath: IndexPath, data: Data) {
        DispatchQueue.main.async {
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? CustomCell else { return }
            cell.addImage(from: data)
        }
    }
    
    func updateCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            var offsetY = -90
            if UIDevice.current.orientation.isLandscape {
                offsetY = -30
            }
            self.collectionView.setContentOffset(CGPoint(x: 0,
                                                         y: offsetY),
                                                 animated: true)
            self.activityIndicatorChangeState()
        }
    }
}


