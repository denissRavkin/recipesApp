//
//  DetailRecipeViewModel.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 10.02.2021.
//

import Foundation

class DetailRecipeViewModel: DetailRecipeViewModelProtocol {
    let dataManager = DataManager()
    
    var vegetarian: Bool {
        return recipeDetail.vegetarian
    }
    
    var vegan: Bool {
        return recipeDetail.vegan
    }
     
    var glutenFree: Bool {
        return recipeDetail.glutenFree
    }
    
    var dairyFree: Bool {
        return recipeDetail.dairyFree
    }
    
    var veryHealthy: Bool {
        return recipeDetail.veryHealthy
    }
    
    var cheap: Bool {
        return recipeDetail.cheap
    }
    
    var veryPopular: Bool {
        return recipeDetail.veryPopular
    }
    
    var aggregateLikes: String {
        return String(recipeDetail.aggregateLikes) + " likes"
    }
    
    var spoonacularScore: String {
        return "Score: " + String(recipeDetail.spoonacularScore) + "%"
    }
    
    var healthScore: String {
        return "Healthscore: " + String(recipeDetail.healthScore) + "%"
    }
    
    var pricePerServing: String {
        return "$\(String(recipeDetail.pricePerServing)) per serving "
    }
    
    var title: String {
        recipeDetail.title
    }
    
    var readyInMinutes: String {
        "Ready in " + String(recipeDetail.readyInMinutes) + " minutes"
    }
    
    var sourceUrl: String {
        recipeDetail.sourceUrl
    }
    
    var imageData: Data? {
        guard let imageUrl = URL(string: recipeDetail.image ?? "") else {return nil}
        guard let imageData = try? Data(contentsOf: imageUrl) else {return nil}
        return imageData
    }
    
    var summary: String {
        return recipeDetail.summary
    }
    
    var cuisines: String {
        if recipeDetail.cuisines.count == 0 {
            return "Cuisines: ?"
        } else {
            var cuisenes: String = "Cuisines: "
            for cuisene in recipeDetail.cuisines {
                cuisenes += cuisene + "; "
            }
            return cuisenes
        }
        
    }
    
    var dishTypes: String {
        if recipeDetail.dishTypes.count == 0 {
            return "Dish types: ?"
        } else {
            var dishTypes: String = "Dish types: "
            for dishType in recipeDetail.dishTypes {
                dishTypes += dishType + "; "
            }
            return dishTypes
        }
    }
    
    var diets: String {
        if recipeDetail.diets.count == 0 {
            return "Diets: ?"
        } else {
            var diets: String = "Diets: "
            for diet in recipeDetail.diets {
                diets += diet + "; "
            }
            return diets
        }
    }
    var servings: Double! {
        didSet {
            servingsString.value = String(servings)
            ingredients.value = ingredientsManager.fetchIngredientsString(by: servings)
        }
    }
    
    var servingsString: Box<String>!

    
    private var ingredientsManager: IngredientsManager!
    
    var ingredientsCount: Int {
        return ingredientsManager.amountOfIngredients
    }
    
    var ingredients: Box<[String]>!
   
    var id: Int
    var recipeDetail: RecipeDetail! {
        didSet {
            recipeDetail.summary = cleaningSummaryText(summaryText: recipeDetail.summary)
            servingsString = Box(value: String(recipeDetail.servings))
            ingredientsManager = IngredientsManager(ingredients: recipeDetail.extendedIngredients, servings: recipeDetail.servings)
            ingredients = Box(value: ingredientsManager.fetchIngredientsString(by: Double(recipeDetail.servings)))
            servings = Double(recipeDetail.servings)
        }
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func fetchRecipeData(complation: @escaping () -> Void) {
        dataManager.fetchRecipeDetails(by: id) { (recipeDetail) in
            if let recipeDetail = recipeDetail {
                self.recipeDetail = recipeDetail
            }
            complation()
        }
    }
    
    func cleaningSummaryText(summaryText: String) -> String {
        var cleanText = ""
        var invalidSymbols = false
        
        for char in summaryText {
            if char == "<" {
                invalidSymbols = true
            }
           
            if !invalidSymbols {
                cleanText.append(char)
            }
            
            if char == ">" {
                invalidSymbols = false
            }
        }
        return cleanText
    }
    
    func viewModelForSourceOfRecipeViewController() -> SourceOfRecipeViewModelProtocol {
        return SourceOfRecipeViewModel(urlString: sourceUrl)
    }
    
    func saveRecipe() {
        dataManager.saveRecipe(recipe: recipeDetail)
    }
}



