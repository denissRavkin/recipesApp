//
//  SavedRecipesViewModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 08.04.2021.
//

import Foundation

protocol SavedRecipesViewModelProtocol {
    func numberOfSections() -> Int
    var titleForNavigationBar: String { get }
    func numberOfRows(inSection section: Int) -> Int
    func fetchSavedRecipes(completion: @escaping () -> Void)
    func viewModelForTableViewCell(by indexPath: IndexPath) -> SavedRecipeTableViewCellModel
    func titleLabelForHeaderView(inSection section: Int) -> String
    func systemNameOfImageForHeaderView(inSection section: Int) -> String
    func viewModelDetailViewController(byIndexPath indexPath: IndexPath) -> DetailRecipeViewModelProtocol
    func changeSectionForRecipe(atIndexPath indexPath: IndexPath)
    func newSectionForMovableCell(_ currentIndex: IndexPath) -> IndexPath
    func deleteRecipe(byIndex index: IndexPath)
    func systemNameImageForFavouriteSwipeAction(byIndex index: IndexPath) -> String
    func saveChanges()
    func filterRecipesForSearchText(searchText: String)
    var isFiltering: Bool { get set }
}
