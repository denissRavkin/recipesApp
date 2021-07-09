//
//  SavedRecipeEntity.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 08.04.2021.
//

import Foundation
import CoreData

class SavedRecipeEntity: NSManagedObject {
    
    class func findOrSaveRecipe(SavedRecipe: SavedRecipe, context: NSManagedObjectContext) {
        context.perform {
            //find
            let request: NSFetchRequest<SavedRecipeEntity> = SavedRecipeEntity.
            
            let recipe = SavedRecipeEntity(context: self.persistentContainer.viewContext)
            recipe.recipeID = Int32(recipeID)
            recipe.imageData = imageData
            recipe.title = title
            recipe.text = text
            recipe.section = section
        }
    }
}
