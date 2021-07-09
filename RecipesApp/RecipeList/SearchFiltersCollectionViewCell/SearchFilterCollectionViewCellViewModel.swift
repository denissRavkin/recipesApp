//
//  SearchFilterCollectionViewCellViewModel.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 01.03.2021.
//

import Foundation

class SearchFilterCollectionViewCellViewModel: SearchFilterCollectionViewCellViewModelProtocol {
    var filterName: String
    var filterIsSelected: Box<Bool>
    
    private var filter: Box<(String,Bool)>

    init(filterName: String, filterIsSelected: Bool, listener: @escaping (String,Bool) -> Void ) {
        self.filterName = filterName
        self.filterIsSelected = Box(value: filterIsSelected)
        self.filter = Box(value: (filterName,filterIsSelected))
        self.filter.bindListener(listener: listener)
        self.filterIsSelected.bindListener { [weak self] (filterIsSelected) in
            self?.filter.value.1 = filterIsSelected
        }
    }
    
    deinit {
        print("DEINIT FILTER CELL MODEL")
    }
}
