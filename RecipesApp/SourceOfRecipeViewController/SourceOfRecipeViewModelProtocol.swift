//
//  SourceOfRecipeViewModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 22.02.2021.
//

import Foundation

protocol SourceOfRecipeViewModelProtocol {
    var urlString: String { get }
    var urlRequest: URLRequest? { get }
}
