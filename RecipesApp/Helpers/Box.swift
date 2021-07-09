//
//  Box.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 20.02.2021.
//

import Foundation


class Box<T> {
    
    var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bindListener(listener: @escaping (T) -> ()) {
        self.listener = listener
    }
    
    init(value: T) {
        self.value = value
    }
}
