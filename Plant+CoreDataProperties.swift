//
//  Plant+CoreDataProperties.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 26.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Plant {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var isFavorite: NSNumber?

}
