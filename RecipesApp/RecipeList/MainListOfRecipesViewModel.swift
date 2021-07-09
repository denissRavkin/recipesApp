//
//  MainListOfRecipesViewModel.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 07.02.2021.
//

import Foundation

class MainListOfRecipesViewModel: MainListOfRecipesViewModelProtocol {
    func viewModelDetailViewController(byIndexPath indexPath: IndexPath) -> DetailRecipeViewModelProtocol {
        return DetailRecipeViewModel(id: recipes.value[indexPath.row].id)
    }
    
    var titleForNavigationBar: Box<String> = Box(value:"Random recipes")
    
    var soughtRecipeName: String = "Random recipes"
    
    func viewModelFilterCollectionViewCell(index: Int) -> SearchFilterCollectionViewCellViewModel {
        
        var selectedFilters: [Filter] = []
        var filterName: String
        switch selectedFilterType {
        case is Cuisine.Type:
            selectedFilters = selectedCuisineFilters
            filterName = cuisinefilters[index].rawValue
        case is MealType.Type:
            selectedFilters = selectedMealTypeFilters
            filterName = mealTypeFilters[index].rawValue
        default:
            filterName = "?"
        }
        
        var filterIsSelected = false
        for selectedFilter in selectedFilters {
            switch selectedFilter {
            case is Cuisine:
                if selectedFilter as! Cuisine == cuisinefilters[index] {
                    filterIsSelected = true
                    break
                }
            case is MealType:
                if selectedFilter as! MealType == mealTypeFilters[index] {
                    filterIsSelected = true
                    break
                }
            default:
                print("f")
                break
            }
        }
        return SearchFilterCollectionViewCellViewModel(filterName: filterName, filterIsSelected: filterIsSelected) { filterName, filterIsSelected in
            
            if let mealTypeFilter = MealType(rawValue: filterName) {
                if filterIsSelected {
                    self.selectedMealTypeFilters.append(mealTypeFilter)
                } else {
                    for (index,filter) in self.selectedMealTypeFilters.enumerated() {
                        if filter == mealTypeFilter {
                            self.selectedMealTypeFilters.remove(at: index)
                        }
                    }
                }
            } else if let cuisineFilter = Cuisine(rawValue: filterName) {
                if filterIsSelected {
                    self.selectedCuisineFilters.append(cuisineFilter)
                } else {
                    for (index,filter) in self.selectedCuisineFilters.enumerated() {
                        if filter == cuisineFilter {
                            self.selectedCuisineFilters.remove(at: index)
                        }
                    }
                }
            }
      
        }
            
    }
            
   
    func viewModelCollectionViewCell(index: Int) -> RecipeEnvelopeCollectionViewCellViewModel {
        return RecipeEnvelopeCollectionViewCellViewModel(title: recipes.value[index].title, imageString: recipes.value[index].image)
    }
    
    func numberOfItems() -> Int {
        return countOfRandomRecipes
    }

    private var countOfRandomRecipes = 30
    
    var recipes: Box<[RecipeEnvelope]> = Box(value: [])
    
    //var searchType: SearchType = SearchType.randomSearch
    
    func fetchRecipeTittleImage(soughtRecipeName: String, completion: @escaping () -> Void){
        if soughtRecipeName.isEmpty {
            titleForNavigationBar.value = "Random Recipes"
            DataManager.fetchRandomRecipes(count: countOfRandomRecipes) {  (recipesList) in
                self.recipes.value = recipesList?.recipes ?? []
                completion()
            }
        } else {
            self.soughtRecipeName = soughtRecipeName
            titleForNavigationBar.value = "Recipes By Name"
            print(soughtRecipeName)
            DataManager.fetchRecipesByName(soughtForRecipeName: soughtRecipeName, mealTypes: selectedMealTypeFilters, cuisineTypes: selectedCuisineFilters) {(recipesList) in
                self.recipes.value = recipesList?.results ?? []
                completion()
            }
        }
    }
    var selectedCuisineFilters: [Cuisine] = []
    var selectedMealTypeFilters: [MealType] = []
    var selectedFilterType: Filter.Type?
    let cuisinefilters = Cuisine.allCases
    let mealTypeFilters = MealType.allCases
}

enum SearchType {
    case randomSearch
    case searchByName(cuisineFilters: [Cuisine], mealTypeFilters: [MealType])
}

let searchType = SearchType.searchByName(cuisineFilters: [.African, .Cajun], mealTypeFilters: [])

protocol Filter {}

enum Cuisine: String, CaseIterable, Filter {
    case African = "African"
    case American = "American"
    case British = "British"
    case Cajun = "Cajun"
    case Caribbean = "Caribbean"
    case Chinese = "Chinese"
    case EasternEuropean = "Eastern European"
    case European = "European"
    case French = "French"
    case German = "German"
    case Greek = "Greek"
    case Indian = "Indian"
    case Irish = "Irish"
    case Italian = "Italian"
    case Japanese = "Japanese"
    case Jewish = "Jewish"
    case Korean = "Korean"
    case LatinAmerican = "Latin American"
    case Mediterranean = "Mediterranean"
    case Mexican = "Mexican"
    case MiddleEastern = "Middle Eastern"
    case Nordic = "Nordic"
    case Southern = "Southern"
    case Spanish = "Spanish"
    case Thai = "Thai"
    case Vietnamese = "Vietnamese"
}

enum MealType: String, CaseIterable, Filter {
    case mainCourse = "main course"
    case sideDish = "side dish"
    case dessert = "dessert"
    case appetizer = "appetizer"
    case salad = "salad"
    case bread = "bread"
    case breakfast = "breakfast"
    case soup = "soup"
    case beverage = "beverage"
    case sauce = "sauce"
    case marinade = "marinade"
    case fingerfood = "fingerfood"
    case snack = "snack"
    case drink = "drink"
}
