//
//  RecipeEnvelope.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 05.02.2021.
//

import Foundation

struct Recipe: Codable {
    let recipes: [RecipeEnvelope]
}

struct RecipeEnvelope: Codable {
    let id: Int
    let title: String
    let image: String
}
