//
//  DataFetcher.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 11.02.2021.
//

import Foundation

// MARK: - Network

class DataManager {
    private let networkRequest: Networking
    private let coreDataManager = CoreDataManager.shared
    
    init(networkRequest: Networking = NetworkRequest()) {
        self.networkRequest = networkRequest
    }
    
    private enum Api: String {
        case hostName = "api.spoonacular.com"
        case apiKeyValue = "cd6a3ed86c004fea8fc64a8bc708cb79"
        enum KeysName: String {
            case apikey = "apiKey"
            case recipeName = "query"
            case cuisine = "cuisine"
            case mealType = "type"
            case numberRecipes = "number"
        }
    }

    private func makeUrl(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Api.hostName.rawValue
        components.path = path
        components.queryItems = [URLQueryItem(name: Api.KeysName.apikey.rawValue, value: Api.apiKeyValue.rawValue)] + queryItems
        return components.url
    }
    
    func fetchRandomRecipes(count: Int, completion: @escaping (RandomRecipe?) -> Void)  {
        guard let url = makeUrl(path: "/recipes/random", queryItems: [URLQueryItem(name: Api.KeysName.numberRecipes.rawValue, value: "\(count)")]) else { return }
        networkRequest.requestAndDecode(url: url, completion: completion)
    }
    
    func fetchRecipeDetails(by id:Int, completion: @escaping (RecipeDetail?) -> Void) {
        guard let url = makeUrl(path: "/recipes/\(id)/information") else { return }
        networkRequest.requestAndDecode(url: url, completion: completion)
    }
    
    func fetchRecipesByName(soughtForRecipeName: String, mealTypes: [MealType]?, cuisineTypes: [Cuisine]?, completion: @escaping (RecipeByName?) -> Void) {
      
        var queryItems = [URLQueryItem(name: Api.KeysName.recipeName.rawValue, value: soughtForRecipeName)]

        if let mealTypes = mealTypes {
            for mealType in mealTypes {
                queryItems.append(URLQueryItem(name: Api.KeysName.mealType.rawValue, value: mealType.rawValue))
            }
        }
        if let cuisineTypes = cuisineTypes {
            for cuisineType in cuisineTypes {
                queryItems.append(URLQueryItem(name: Api.KeysName.cuisine.rawValue, value: cuisineType.rawValue))
            }
        }
        guard let url = makeUrl(path: "/recipes/complexSearch", queryItems: queryItems) else { return }
        networkRequest.requestAndDecode(url: url, completion: completion)
    }
}

// MARK: - Core Data

extension DataManager {
    func saveRecipe(recipe: RecipeDetail) {
        coreDataManager.saveRecipe(recipe: recipe)
    }
    
    func updateSectionInRecipe(savedRecipe: SavedRecipe, newSection: String) {
        coreDataManager.updateSectionInRecipe(savedRecipe: savedRecipe, newSection: newSection)
    }
    
    func deleteSavedRecipe(recipe: SavedRecipe) {
        coreDataManager.deleteSavedRecipe(savedRecipe: recipe)
    }
    
    func fetchSavedRecipes(completionHadler: @escaping ([SavedRecipe]) -> Void) {
        coreDataManager.fetchSavedRecipes { (savedRecipesEntities) in
            let savedRecipes = savedRecipesEntities.map({ SavedRecipe(entity: $0)})
            completionHadler(savedRecipes)
        }
    }
    
    func saveContext() {
        coreDataManager.saveContext()
    }
}
