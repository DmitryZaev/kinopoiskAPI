//
//  CollectionPresenterProtocol.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject {
    
    var viewHeight: Double { get set }
    var viewWidth: Double { get set }
    var movies: [MovieModel] { get set }
    var title: String { get set }
    
    func getNumberOfItems() -> Int
    
    func getSizeForItem() -> (Double, Double)
    
    func getCellModel(for index: Int, indexPath: IndexPath, opened: Bool) -> CellModel
    
    func getTitle() -> String
    
    func update(sortedBy: String, ascendingSort: Bool)
    
    func checkNeedBackgroundLabel()
    
    func openSite(for id: String)
    
    func checkNeedAlertControllerOrOpenSite(for id: String)
    
    func changeOpenSiteWithoutAlert(pressedYes: Bool)
    
    func cleanCache()
}
