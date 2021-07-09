//
//  MainListOfRecipesViewModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 07.02.2021.
//

import Foundation

protocol MainListOfRecipesViewModelProtocol {
    var recipes: Box<[RecipeEnvelope]> {get set}
    func fetchRecipeTittleImage(soughtRecipeName: String, completion: @escaping () -> Void)
    func numberOfItems() -> Int
    func viewModelCollectionViewCell(index: Int) -> RecipeEnvelopeCollectionViewCellViewModel
    func viewModelFilterCollectionViewCell(index: Int) -> SearchFilterCollectionViewCellViewModel
    var selectedFilterType: Filter.Type? {get set}
    var soughtRecipeName: String { get }
    var selectedCuisineFilters: [Cuisine] { get }
    var selectedMealTypeFilters: [MealType] { get }
    var titleForNavigationBar: Box<String> { get }
    func viewModelDetailViewController(byIndexPath indexPath: IndexPath) -> DetailRecipeViewModelProtocol
}
