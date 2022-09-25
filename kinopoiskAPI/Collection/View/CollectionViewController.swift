//
//  CollectionViewController.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var collectionViewModel: CollectionViewModelProtocol!
    var sortButtonItem = UIBarButtonItem()
    var activityIndicatorItem = UIBarButtonItem()
    var activityIndicator = UIActivityIndicatorView()
    var sortMenu = UIMenu()
    var plusHeightForOpenedCells = [IndexPath : Double]()
    var centralCell: CustomCell?
    var decreasingCell: CustomCell?
    private let aquamarineColor = UIColor(red: 102 / 255,
                                  green: 205 / 255,
                                  blue: 170 / 255,
                                  alpha: 1)
    private let lightBlueColor = UIColor(red: 0 / 255,
                                  green: 128 / 255,
                                  blue: 255 / 255,
                                  alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        addMenu()
        addActivityIndicatorItem()
        addSortButtonItem()
        configureRightBarButtonItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationHandler(notification:)),
                                               name: Notification.Name("Opening"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationHandler(notification:)),
                                               name: Notification.Name("Closing"),
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        collectionViewModel.cleanCache()
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
        guard let cell = collectionView.cellForItem(at: cellIndexPath) as? CustomCell else { return }
        cell.openedState.toggle()
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.collectionView.performBatchUpdates {
                if notification.name == Notification.Name("Opening") {
                    cell.frame.size.height += self.plusHeightForOpenedCells[cellIndexPath]!
                    cell.changeDescriptionButtonState(opened: true)
                    cell.layoutIfNeeded()
                } else if notification.name == Notification.Name("Closing") {
                    cell.frame.size.height = self.collectionViewModel.getSizeForItem().1
                    cell.changeDescriptionButtonState(opened: false)
                    cell.layoutIfNeeded()
                }
            }
        }
        centralCell = nil
    }
    
    override func viewDidLayoutSubviews() {
        if !collectionView.isDecelerating {
        resizeCellInCenter()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(collectionView.safeAreaInsets)
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            collectionView.verticalScrollIndicatorInsets.right = size.width - 47 - 6
        } else {
            collectionView.verticalScrollIndicatorInsets.right = 0
        }
        print(collectionView.safeAreaInsets)
    }
    
    private func configureCollectionView() {
        self.collectionView!.register(CustomCell.self,
                                      forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .yellow
        createAppearance()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = lightBlueColor
        collectionView.decelerationRate = .normal
        collectionViewModel.title.bind { [weak self] newTitle in
            self?.title = "Search: \"\(newTitle)\""
        }
        
        collectionViewModel.checkNeedBackgroundLabel { [weak self] need in
            if need {
                self?.addBackgroundLabel()
            }
        }
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
                self.collectionViewModel.update(sortedBy: "name", ascendingSort: true) {
                    self.updateCollection()
                }
            }),
            UIAction(title: "name" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionViewModel.update(sortedBy: "name", ascendingSort: false) {
                    self.updateCollection()
                }
            }),
            UIAction(title: "year" + upSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionViewModel.update(sortedBy: "year", ascendingSort: true) {
                    self.updateCollection()
                }
            }),
            UIAction(title: "year" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionViewModel.update(sortedBy: "year", ascendingSort: false) {
                    self.updateCollection()
                }
            }),
            UIAction(title: "kinopoisk rating" + upSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionViewModel.update(sortedBy: "rating.kp", ascendingSort: true) {
                    self.updateCollection()
                }
            }),
            UIAction(title: "kinopoisk rating" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionViewModel.update(sortedBy: "rating.kp", ascendingSort: false) {
                    self.updateCollection()
                }
            }),
            UIAction(title: "imdb rating" + upSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionViewModel.update(sortedBy: "rating.imdb", ascendingSort: true) {
                    self.updateCollection()
                }
            }),
            UIAction(title: "imdb rating" + downSymbol, image: nil, handler: { _ in
                self.activityIndicatorChangeState()
                self.plusHeightForOpenedCells.removeAll()
                self.collectionViewModel.update(sortedBy: "rating.imdb", ascendingSort: false) {
                    self.updateCollection()
                }
            })
        ])
    }

    private func addActivityIndicatorItem() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.color = lightBlueColor
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
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : lightBlueColor,
                                          NSAttributedString.Key.font : UIFont(name: "Galvji",
                                                                               size: 15) as Any]
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.backward"),
                                         transitionMaskImage: UIImage(systemName: "arrow.backward"))
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    private func addBackgroundLabel() {
        let backgroundLabel = UILabel()
        backgroundLabel.text = "there is nothing like this \u{1F645}"
        backgroundLabel.font = UIFont(name: "Galvji", size: 25)
        backgroundLabel.textColor = lightBlueColor
        backgroundLabel.textAlignment = .center
        backgroundLabel.sizeToFit()
        collectionView.backgroundView = backgroundLabel
    }
    
    private func updateCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            var offsetY = -100
            if UIDevice.current.orientation.isLandscape {
                offsetY = -30
            }
            self.collectionView.setContentOffset(CGPoint(x: 0,
                                                         y: offsetY),
                                                 animated: true)
            self.activityIndicatorChangeState()
        }
    }
    
    private func openAlertController(with id: String) {
        let choiceSwitch = UISwitch()
        choiceSwitch.isOn = false
        choiceSwitch.onTintColor = aquamarineColor
        
        let choiceTextLabel = UILabel()
        choiceTextLabel.text = "remember my choice"
        choiceTextLabel.font = UIFont(name: "Galvji", size: 15)
        choiceTextLabel.textColor = lightBlueColor
        choiceTextLabel.sizeToFit()
        

        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .alert)
        let title = NSAttributedString(string: "Open in Safari?\n",
                                       attributes: [.foregroundColor : lightBlueColor,
                                                    .font : UIFont(name: "Galvji", size: 25)!])
        alertController.setValue(title, forKey: "attributedTitle")
        
        let choiceView = UIView()
        choiceView.layer.borderWidth = 0.5
        choiceView.layer.borderColor = lightBlueColor.cgColor
        choiceView.layer.cornerRadius = choiceSwitch.frame.height / 2
        choiceView.layer.masksToBounds = true
        choiceView.addSubview(choiceSwitch)
        choiceView.addSubview(choiceTextLabel)
        alertController.view.addSubview(choiceView)
        
        choiceTextLabel.translatesAutoresizingMaskIntoConstraints = false
        choiceSwitch.translatesAutoresizingMaskIntoConstraints = false
        choiceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            choiceView.heightAnchor.constraint(equalToConstant: choiceSwitch.frame.height),
            choiceView.widthAnchor.constraint(equalToConstant: choiceSwitch.frame.width + choiceTextLabel.frame.width + 20),
            choiceView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            choiceView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -50),
            
            choiceSwitch.centerYAnchor.constraint(equalTo: choiceView.centerYAnchor),
            choiceSwitch.leftAnchor.constraint(equalTo: choiceView.leftAnchor),
            
            choiceTextLabel.centerYAnchor.constraint(equalTo: choiceView.centerYAnchor),
            choiceTextLabel.rightAnchor.constraint(equalTo: choiceView.rightAnchor, constant: -10)
        ])
        
        
        let canselAction = UIAlertAction(title: "No", style: .destructive) { [weak self] _ in
            if choiceSwitch.isOn {
                self?.collectionViewModel.changeOpenSiteWithoutAlert(pressedYes: false)
            }
        }
        let openAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.collectionViewModel.openSite(for: id)
            if choiceSwitch.isOn {
                self?.collectionViewModel.changeOpenSiteWithoutAlert(pressedYes: true)
            }
        }
        alertController.addAction(canselAction)
        alertController.addAction(openAction)
        present(alertController, animated: true)
    }

    
    private func obtaintMovieId(cellIndexPath: IndexPath) -> String {
        guard let cell = collectionView.cellForItem(at: cellIndexPath) as? CustomCell,
              let id = cell.id
        else { return "" }
        return id
    }
    
//MARK: - Visible resizing cell in center
    private func resizeCellInCenter() {
        if centralCell == nil {
            guard collectionView.visibleSize.width < collectionView.visibleSize.height else { return }
            let centerPoint = CGPoint(x: collectionView.frame.size.width / 2 + collectionView.contentOffset.x,
                                      y: collectionView.frame.size.height / 2 + collectionView.contentOffset.y)
            
            if let centralCellIndexPath = collectionView.indexPathForItem(at: centerPoint) {
                centralCell = collectionView.cellForItem(at: centralCellIndexPath) as? CustomCell
                centralCell?.transformToLargeSize()
            }
        } else {
            let centerY = collectionView.frame.size.height / 2
            let cellTopBorder = centralCell!.frame.origin.y - collectionView.contentOffset.y
            let cellBottomBorder = cellTopBorder + centralCell!.frame.height
            if !(cellTopBorder...cellBottomBorder).contains(centerY) {
                centralCell?.transformToStandardSize()
                centralCell = nil
            }
        }
    }
    
    private func decreaseCell(cell: CustomCell) {
        let centerY = collectionView.frame.size.height / 2
        let cellTopBorder = cell.frame.origin.y - collectionView.contentOffset.y
        let cellBottomBorder = cellTopBorder + cell.frame.height
        
        if !(cellTopBorder...cellBottomBorder).contains(centerY) {
            cell.transformToStandardSize()
        }
    }
    
//MARK: - UIScrollViewDelegate
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if centralCell != nil {
        	decreasingCell = centralCell
        }
        centralCell = nil
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resizeCellInCenter()
        
        guard let decreasingCell = decreasingCell else { return }
        decreaseCell(cell: decreasingCell)
    }
    
//MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewModel.movies.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CustomCell

        let cellOpenedState: Bool = (plusHeightForOpenedCells[indexPath] != nil)
        
        collectionViewModel.getCellModel(for: indexPath.item, opened: cellOpenedState) { [weak self] cellModel in
            cell?.configureCell(model: cellModel, indexPath: indexPath)
            self?.collectionViewModel.getImageForCell(index: indexPath.item) { data in
                cell?.addImage(from: data)
            }
        }
        
        return cell ?? UICollectionViewCell()
    }
    
//MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = obtaintMovieId(cellIndexPath: indexPath)
        collectionViewModel.checkNeedAlertControllerOrOpenSite(for: movieId) { [weak self] in
            self?.openAlertController(with: movieId)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionViewModel.getSizeForItem()
        if plusHeightForOpenedCells[indexPath] != nil {
            size.1 += plusHeightForOpenedCells[indexPath]!
        }
        return CGSize(width: size.0,
                      height: size.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 10,
                            bottom: 30,
                            right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
}



