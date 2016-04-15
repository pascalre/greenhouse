//
//  Sowed+CoreDataProperties.swift
//
//
//  Created by Pascal Reitermann on 13.04.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sowed {

    @NSManaged var comments: String?
    @NSManaged var gesaetAm: NSDate?
    @NSManaged var pflanze: Plant?

}
