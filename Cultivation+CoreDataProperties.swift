//
//  Cultivation+CoreDataProperties.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 30.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cultivation {

    @NSManaged var geduengtAm: NSDate?
    @NSManaged var gewaessertAm: NSDate?
    @NSManaged var sowedID: NSNumber?
    @NSManaged var aussaat: Sowed?

}
