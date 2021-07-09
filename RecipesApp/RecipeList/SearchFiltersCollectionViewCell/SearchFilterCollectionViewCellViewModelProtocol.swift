//
//  SearchFilterCollectionViewCellViewModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 01.03.2021.
//

import Foundation

protocol SearchFilterCollectionViewCellViewModelProtocol {
    //var filter: ( filterName: String, filterIsSelected: Bool) { get set}
    var filterName: String { get }
    var filterIsSelected: Box<Bool> { get set }
   // var filter: Box<(String,Bool)> { get set }

}
