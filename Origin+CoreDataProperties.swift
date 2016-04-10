//
//  Origin+CoreDataProperties.swift
//  
//
//  Created by Pascal Reitermann on 10.04.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Origin {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var plantID: NSNumber?
    @NSManaged var pflanze: Plant?

}
