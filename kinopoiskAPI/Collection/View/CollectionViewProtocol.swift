//
//  CollectionViewProtocol.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import Foundation

protocol CollectionViewProtocol: AnyObject {
    
    func addImageToCell(with indexPath: IndexPath, data: Data)
    
    func updateCollection()
    
    func addBackgroundLabel()
}
