//
//  SavedRecipe.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 23.04.2021.
//

import Foundation

protocol SavedRecipeForCellViewModel {
    var imageData: Data? { get }
    var title: String? { get }
    var text: String? { get }
    var section: String { get set }
    var isDeployed: Bool { get set }
}

class SavedRecipe: SavedRecipeForCellViewModel {
    let recipeID: Int
    let imageData: Data?
    let title: String?
    let text: String?
    var section: String
    var isDeployed: Bool = false
    
    func changeSection() {
        if section == SavedRecipesSection.New.rawValue {
            section = SavedRecipesSection.Favourite.rawValue
        } else {
            section = SavedRecipesSection.New.rawValue
        }
    }
    
    init(recipeID:Int, imageData: Data, title: String, text: String, section: String = SavedRecipesSection.New.rawValue) {
        self.recipeID = recipeID
        self.imageData = imageData
        self.title = title
        self.text = text
        self.section = section
    }
    
    init(entity: SavedRecipeEntity) {
        recipeID = Int(entity.recipeID)
        imageData = entity.imageData
        title = entity.title
        text = entity.text
        section = entity.section ?? SavedRecipesSection.New.rawValue
    }
}
