//
//  SavedRecipeEntity+CoreDataProperties.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 08.04.2021.
//
//

import Foundation
import CoreData


extension SavedRecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRecipeEntity> {
        return NSFetchRequest<SavedRecipeEntity>(entityName: "SavedRecipeEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var text: String?

}

extension SavedRecipeEntity : Identifiable {

}
