//
//  IngredientsManager.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 17.02.2021.
//

import Foundation

class IngredientsManager {
    let amountOfIngredients: Int
    
    private let startCountOfServings: Int
    
    private let ingredients: [Ingredient]
    
    init(ingredients: [Ingredient], servings: Int) {
        self.ingredients = ingredients
        self.startCountOfServings = servings
        self.amountOfIngredients = ingredients.count
    }
    
    func fetchIngredientsString(by servings: Double) -> [String] {
        var ingredientsString = [String]()
        for ingredient in ingredients {
            ingredientsString.append("\(ingredient.name) - \(calculateAmount(amount: ingredient.amount, servings: servings)) \(ingredient.unit)")
        }
        return ingredientsString
    }
    
    private func calculateAmount(amount: Double, servings: Double) -> Double {
        let amountPerServing = amount / Double(startCountOfServings)
        let amountPerCurrentNUmberOfServings = amountPerServing * Double(servings)
        let amountPerCurrentNUmberOfServingsRounded = (amountPerCurrentNUmberOfServings * 100).rounded()/100
        
        return amountPerCurrentNUmberOfServingsRounded
    }
}


