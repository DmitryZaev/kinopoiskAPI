//
//  Dynamic.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 14.07.2022.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        listener?(value)
    }
}
