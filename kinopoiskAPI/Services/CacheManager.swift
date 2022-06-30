//
//  CacheManager.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 30.06.2022.
//

import Foundation
import UIKit

class CacheManager {
    
    static private let imageCache = NSCache<NSString, UIImage>()
    
    static func getImageFromCache(for key: String) -> Data? {
        
        if let cashedImage = imageCache.object(forKey: key as NSString) {
            return cashedImage.pngData()
        } else {
            return nil
        }
    }
    
    static func putImageToCache(imageData: Data, for key: String) {
        guard let image = UIImage(data: imageData) else { return }
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    static func cleanCache() {
        imageCache.removeAllObjects()
    }
}
