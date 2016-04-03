//
//  Sowed+CoreDataProperties.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 03.04.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sowed {

    @NSManaged var gesaetAm: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var plantID: NSNumber?
    @NSManaged var comments: String?
    @NSManaged var pflanze: Plant?
    @NSManaged var pflege: NSSet?

}
