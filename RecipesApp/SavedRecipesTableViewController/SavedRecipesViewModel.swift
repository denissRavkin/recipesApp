//
//  SavedRecipesViewModel.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 08.04.2021.
//

import Foundation

class SavedRecipesViewModel: SavedRecipesViewModelProtocol {
    
    var isFiltering: Bool = false
    
    func filterRecipesForSearchText(searchText: String) {
        filteredSavedRecipes = savedRecipes.map({ (savedRecipesInSection) -> [SavedRecipe] in
           return savedRecipesInSection.filter { (savedRecipe) -> Bool in
            return (savedRecipe.title?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        })
    }
    
    func saveChanges() {
        dataManager.saveContext()
    }
    
    let dataManager = DataManager()
    var titleForNavigationBar: String = "Saved Recipes"
    
    func cellIsDeployed(_ viewModel: SavedRecipeTableViewCellModelProtocol, isCellDeployed: Bool, indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        savedRecipes[indexPath.section][indexPath.row].isDeployed = isCellDeployed
    }
    
    private var filteredSavedRecipes: [[SavedRecipe]] = [[],[]]
    
    private var savedRecipes: [[SavedRecipe]] = [[],[]] {
        didSet {
            
        }
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        if isFiltering {
            return filteredSavedRecipes[section].count
        } else {
            return savedRecipes[section].count
        }
    }
    
    func numberOfSections() -> Int {
        return SavedRecipesSection.allCases.count
    }
    
    func viewModelForTableViewCell(by indexPath: IndexPath) -> SavedRecipeTableViewCellModel {
        var savedRecipe: SavedRecipe
        if isFiltering {
            savedRecipe = filteredSavedRecipes[indexPath.section][indexPath.row]
        } else {
            savedRecipe = savedRecipes[indexPath.section][indexPath.row]
        }
        return SavedRecipeTableViewCellModel(savedRecipe: savedRecipe, indexPath: indexPath)
    }
    
    func titleLabelForHeaderView(inSection section: Int) -> String {
        return SavedRecipesSection.allCases[section].rawValue
    }
    
    func systemNameOfImageForHeaderView(inSection section: Int) -> String {
        return SavedRecipesSection.allCases[section].systemNameOfImage
    }
    
    func fetchSavedRecipes(completion: @escaping () -> Void) {
        dataManager.fetchSavedRecipes { (savedRecipes) in
            self.savedRecipes[0] = savedRecipes.filter({ $0.section == SavedRecipesSection.New.rawValue })
            self.savedRecipes[1] = savedRecipes.filter({ $0.section == SavedRecipesSection.Favourite.rawValue})
            completion()
        }
    }
    
    func viewModelDetailViewController(byIndexPath indexPath: IndexPath) -> DetailRecipeViewModelProtocol {
        let recipeId = savedRecipes[indexPath.section][indexPath.row].recipeID
        return DetailRecipeViewModel(id: recipeId)
    }
    
    func changeSectionForRecipe(atIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let recipe = savedRecipes[0].remove(at: indexPath.row)
            recipe.changeSection()
            savedRecipes[1].insert(recipe, at: 0)
            dataManager.updateSectionInRecipe(savedRecipe: recipe, newSection: recipe.section)
        case 1:
            let recipe = savedRecipes[1].remove(at: indexPath.row)
            recipe.changeSection()
            savedRecipes[0].insert(recipe, at: 0)
            dataManager.updateSectionInRecipe(savedRecipe: recipe, newSection: recipe.section)
        default:
            break
        }
    }
    
    func newSectionForMovableCell(_ currentIndex: IndexPath) -> IndexPath {
        if currentIndex.section == 0 {
            return IndexPath(row: 0, section: 1)
        } else {
            return IndexPath(row: 0, section: 0)
        }
    }
    
    func deleteRecipe(byIndex index: IndexPath) {
        let deletedRecipe = savedRecipes[index.section].remove(at: index.row)
        dataManager.deleteSavedRecipe(recipe: deletedRecipe)
    }
    
    func systemNameImageForFavouriteSwipeAction(byIndex index: IndexPath) -> String {
        switch index.section {
        case 0:
            return "heart"
        case 1:
            return "heart.fill"
        default:
            return "heart"
        }
    }
}

enum SavedRecipesSection: String, CaseIterable {
    case New = "New"
    case Favourite = "Favourite"
    
    var systemNameOfImage: String {
        switch self {
        case .New:
            return "eye"
        case .Favourite:
            return "heart"
        }
    }
}


