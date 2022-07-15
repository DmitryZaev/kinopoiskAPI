//
//  UIImageViewExtension.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 28.06.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func fromGif(resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let newImage = UIImage(cgImage: image)
                images.append(newImage)
            }
        }
        contentMode = .center
        animationImages = images
        animationDuration = 10
        startAnimating()
    }
    
    func stopGif() {
        stopAnimating()
        animationImages = nil
    }
}
