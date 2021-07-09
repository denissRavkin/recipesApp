//
//  SearchFilterCollectionViewCellViewModelProtocol.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 01.03.2021.
//

import Foundation

protocol SearchFilterCollectionViewCellViewModelProtocol {
    var filterName: String { get }
    var filterIsSelected: Box<Bool> { get set }
}
