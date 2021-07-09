//
//  Box.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 20.02.2021.
//

import Foundation


class Box<T> {
    var listeners: [((T) -> Void)] = []
    
    var value: T {
        didSet {
            for listener in listeners {
                listener(value)
            }
        }
    }
    
    func bindListener(listener: @escaping (T) -> ()) {
        self.listeners.append(listener)
    }
    
    init(value: T) {
        self.value = value
    }
}
