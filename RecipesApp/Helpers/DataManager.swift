//
//  DataFetcher.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 11.02.2021.
//

import Foundation

class DataManager {
    
    let coreDataManager = CoreDataManager.shared
    let networkRequest = NetworkRequest()
    
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

    private static func makeUrl(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Api.hostName.rawValue
        components.path = path
        components.queryItems = [URLQueryItem(name: Api.KeysName.apikey.rawValue, value: Api.apiKeyValue.rawValue)] + queryItems
        return components.url
    }
    
    static func fetchRandomRecipes(count: Int, completion: @escaping (RandomRecipe?) -> Void)  {
       // let urlStringRandomRecipes = "https://api.spoonacular.com/recipes/random?apiKey=cd6a3ed86c004fea8fc64a8bc708cb79&number=\(count)"
       
        guard let url = makeUrl(path: "/recipes/random", queryItems: [URLQueryItem(name: Api.KeysName.numberRecipes.rawValue, value: "\(count)")]) else { return }
        
       // guard let url = URL(string: urlStringRandomRecipes) else { return }
        NetworkRequest.getDataTask(url: url, completion: completion)
    }
    
    static func fetchRecipeDetails(by id:Int, completion: @escaping (RecipeDetail?) -> Void) {
       // let urlStringRecipeDetail = "https://api.spoonacular.com/recipes/\(id)/information?apiKey=cd6a3ed86c004fea8fc64a8bc708cb79"
        guard let url = makeUrl(path: "/recipes/\(id)/information") else { return }
        NetworkRequest.getDataTask(url: url, completion: completion)
    }
    
    static func fetchRecipesByName(soughtForRecipeName: String, mealTypes: [MealType]?, cuisineTypes: [Cuisine]?, completion: @escaping (RecipeByName?) -> Void) {
      
        var queryItems = [URLQueryItem(name: Api.KeysName.recipeName.rawValue, value: soughtForRecipeName)]
        
//        let urlStringFirstPart = "https://api.spoonacular.com/recipes/complexSearch?apiKey=cd6a3ed86c004fea8fc64a8bc708cb79&query=\(soughtForRecipeName)"
//        var urlStringSecondPart = ""
//        var urlStringThirdPart = ""
        if let mealTypes = mealTypes {
//            urlStringSecondPart = "&type="
            for mealType in mealTypes {
//                urlStringSecondPart += mealType.rawValue + ","
                queryItems.append(URLQueryItem(name: Api.KeysName.mealType.rawValue, value: mealType.rawValue))
            }
//            urlStringSecondPart.removeLast()
        }
        if let cuisineTypes = cuisineTypes {
//            urlStringThirdPart = "&cuisine="
            for cuisineType in cuisineTypes {
//                urlStringThirdPart += cuisineType.rawValue + ","
                queryItems.append(URLQueryItem(name: Api.KeysName.cuisine.rawValue, value: cuisineType.rawValue))
            }
//            urlStringThirdPart.removeLast()
        }
//        let urlStringRecipesByNameAndFilters = (urlStringFirstPart + urlStringSecondPart + urlStringThirdPart).replacingOccurrences(of: " ", with: "%20")
//        print(urlStringRecipesByNameAndFilters)
//        print(urlStringRecipesByNameAndFilters.replacingOccurrences(of: " ", with: "%20"))
       
        guard let url = makeUrl(path: "/recipes/complexSearch", queryItems: queryItems) else { return }
        NetworkRequest.getDataTask(url: url, completion: completion)
    }
}
