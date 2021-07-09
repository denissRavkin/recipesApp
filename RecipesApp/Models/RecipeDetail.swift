//
//  RecipeDetail.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 10.02.2021.
//

import Foundation

struct RecipeDetail: Decodable {
    let id: Int
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let aggregateLikes: Int
    let spoonacularScore: Int
    let healthScore: Int
    let pricePerServing: Double
    let extendedIngredients: [Ingredient]
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let image: String?
    var summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    
    var imageData: Data? {
        guard let imageUrl = URL(string: self.image ?? "") else {return nil}
        guard let imageData = try? Data(contentsOf: imageUrl) else {return nil}
        return imageData
    }
}

struct Ingredient: Decodable {
    let name: String
    let amount: Double
    let unit: String
}
