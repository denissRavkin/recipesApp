//
//  SavedRecipeTableViewCellModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 10.04.2021.
//

import Foundation

protocol SavedRecipeTableViewCellModelProtocol {
    var imageData:Data? { get }
    var title: String { get }
    var summary: String { get }
}
