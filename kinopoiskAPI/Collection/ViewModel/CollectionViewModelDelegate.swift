//
//  CollectionViewModelDelegate.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 14.07.2022.
//

import Foundation

protocol CollectionViewModelDelegate {
    var viewHeight: Double! { get set }
    var viewWidth: Double! { get set }
    var movies: Dynamic<[MovieModel]>! { get set }
    var title: Dynamic<String>! { get set }
    
    func getSizeForItem() -> (Double, Double)
    func update(sortedBy: String, ascendingSort: Bool, completion: @escaping () -> Void)
    func checkNeedBackgroundLabel(completion: @escaping (Bool) -> Void)
    func getCellModel(for index: Int, opened: Bool, completion: @escaping (CellModel) -> Void)
    func getImageForCell(index: Int, completion: @escaping (Data) -> Void)
    func checkNeedAlertControllerOrOpenSite(for id: String, completion: @escaping () -> Void)
    func changeOpenSiteWithoutAlert(pressedYes: Bool)
    func openSite(for id: String)
    func cleanCache()
}
