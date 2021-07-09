//
//  DetailRecipeViewModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 10.02.2021.
//

import Foundation

protocol DetailRecipeViewModelProtocol {
    var id: Int { get set }
    func fetchRecipeData(complation: @escaping () -> Void)
    var vegetarian: Bool { get }
    var vegan: Bool { get  }
    var glutenFree: Bool { get  }
    var dairyFree: Bool { get  }
    var veryHealthy: Bool { get }
    var cheap: Bool { get  }
    var veryPopular: Bool { get }
    var aggregateLikes: String { get }
    var spoonacularScore: String { get }
    var healthScore: String { get }
    var pricePerServing: String { get }
    var title: String { get }
    var readyInMinutes: String { get }
    var servings: Double! { get set }
    var servingsString: Box<String>! { get }
    var sourceUrl: String { get }
    var imageData: Data? { get }
    var summary: String { get }
    var cuisines: String { get }
    var dishTypes: String { get }
    var diets: String { get }
    var ingredientsCount: Int { get }
    var ingredients: Box<[String]>! { get }
    func viewModelForSourceOfRecipeViewController() -> SourceOfRecipeViewModelProtocol
    func saveRecipe()
}
