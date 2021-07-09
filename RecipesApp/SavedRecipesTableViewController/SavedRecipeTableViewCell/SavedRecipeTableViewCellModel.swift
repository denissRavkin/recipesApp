//
//  SavedRecipeTableViewCellModel.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 10.04.2021.
//

import Foundation

class SavedRecipeTableViewCellModel: SavedRecipeTableViewCellModelProtocol {
    var indexPath: IndexPath
    var imageData: Data?
    var title: String
    var summary: String
    var savedRecipe: SavedRecipeForCellViewModel
    
    init(savedRecipe: SavedRecipeForCellViewModel, indexPath: IndexPath) {
        self.imageData = savedRecipe.imageData
        self.title = savedRecipe.title ?? ""
        self.summary = savedRecipe.text ?? ""
        self.indexPath = indexPath
        self.savedRecipe = savedRecipe
    }
}
