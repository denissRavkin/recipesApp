//
//  SavedRecipeEntity.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 08.04.2021.
//

import Foundation
import CoreData

class SavedRecipeEntity: NSManagedObject {
    class func findOrSaveRecipe(savedRecipe: RecipeDetail, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<SavedRecipeEntity> = SavedRecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", savedRecipe.id)
        do {
            let fetchSavedRecipes = try context.fetch(request)
            if fetchSavedRecipes.isEmpty {
                let savedRecipeEntity = SavedRecipeEntity(context: context)
                savedRecipeEntity.recipeID = Int64(savedRecipe.id)
                savedRecipeEntity.imageData = savedRecipe.imageData
                savedRecipeEntity.title = savedRecipe.title
                savedRecipeEntity.text = savedRecipe.summary
                savedRecipeEntity.section = SavedRecipesSection.New.rawValue
                savedRecipeEntity.date = Date()
            } else if fetchSavedRecipes.count == 1 {
                print("this recipe has already been saved")
            } else {
                assert(true, "fetchSavedRecipes.count > 1, \(fetchSavedRecipes.first?.title ?? "")")
            }
        } catch {
            throw error
        }
    }
    
    class func findAndDeleteSavedRecipe(savedRecipe: SavedRecipe, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<SavedRecipeEntity> = SavedRecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", savedRecipe.recipeID)
        do {
            let fetchSavedRecipes = try context.fetch(request)
            if fetchSavedRecipes.isEmpty {
               print("this recipe does not exist in the database")
            } else if fetchSavedRecipes.count == 1, let fetchSavedRecipe = fetchSavedRecipes.first {
                context.delete(fetchSavedRecipe)
            } else {
                assert(false, "fetchSavedRecipes.count > 1, \(fetchSavedRecipes.first?.title ?? "")")
            }
        } catch {
            throw error
        }
    }
    
    class func findAndUpdateSectionInRecipe(savedRecipe: SavedRecipe, newSection: String, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<SavedRecipeEntity> = SavedRecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", savedRecipe.recipeID)
        do {
            let fetchSavedRecipes = try context.fetch(request)
            if fetchSavedRecipes.count > 1 {
                assert(false, "fetchSavedRecipes.count > 1, \(fetchSavedRecipes.first?.title ?? "")")
            }
            let mutableRecipe = fetchSavedRecipes.first
            mutableRecipe?.section = newSection
        } catch {
            throw error
        }
    }
    
    class func fetchSavedRecipes(completionHadler:@escaping ([SavedRecipeEntity]) -> Void, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<SavedRecipeEntity> = SavedRecipeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let savedRecipes = try context.fetch(request)
            print(savedRecipes.count)
            print(savedRecipes.last?.section)
            completionHadler(savedRecipes)
        } catch {
            throw error
        }
    }
}
