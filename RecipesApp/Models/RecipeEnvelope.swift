//
//  RecipeEnvelope.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 05.02.2021.
//

import Foundation

protocol RecipeEnvelopeForCellViewModel {
    var title: String { get }
    var image: String? { get }
}

struct RandomRecipe: Codable {
    let recipes: [RecipeEnvelope]
}

struct RecipeByName: Codable {
    let results: [RecipeEnvelope]
}

struct RecipeEnvelope: Codable, RecipeEnvelopeForCellViewModel {
    let id: Int
    let title: String
    let image: String?
}


