//
//  RecipeEnvelopeCollectionViewCellViewModel.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 07.02.2021.
//

import Foundation

class RecipeEnvelopeCollectionViewCellViewModel: RecipeEnvelopeCollectionViewCellViewModelProtocol {
    var title: String
    var imageStringUrl: String
    
    init(recipe: RecipeEnvelopeForCellViewModel) {
        self.title = recipe.title
        self.imageStringUrl = recipe.image ?? ""
    }
}
