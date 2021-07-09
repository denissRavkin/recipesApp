//
//  SavedRecipesViewModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 08.04.2021.
//

import Foundation

protocol SavedRecipesViewModelProtocol {
    var recipesCount: Int { get }
    func fetchSavedRecipes() 
}
