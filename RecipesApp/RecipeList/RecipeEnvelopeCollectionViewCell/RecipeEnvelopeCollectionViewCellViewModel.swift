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
//    var recipeImageStringUrl: String!
//    var imageData: Data?
//    //private var imageString: Data
    
    init(title: String, imageString: String?) {
        self.title = title
        self.imageStringUrl = imageString ?? ""
    }
    
}
