//
//  Plant+CoreDataProperties.swift
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

extension Plant {

    @NSManaged var art: String?
    @NSManaged var artKeimung: String?
    @NSManaged var aussatAbFrei: String?
    @NSManaged var aussatBisFrei: String?
    @NSManaged var dauerErnte: NSNumber?
    @NSManaged var dauerKeimung: NSNumber?
    @NSManaged var dauerWachsen: NSNumber?
    @NSManaged var duenger: String?
    @NSManaged var infosSaat: String?
    @NSManaged var infosSchaedlinge: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var latinName: String?
    @NSManaged var name: String?
    @NSManaged var familie: String?
    @NSManaged var gattung: String?
    @NSManaged var anzahlArten: NSNumber?
    @NSManaged var standort: String?
    @NSManaged var blaetter: String?
    @NSManaged var wuchshoehe: String?
    @NSManaged var aussatAbTopf: String?
    @NSManaged var aussatBisTopf: String?
    @NSManaged var ausgesaet: NSSet?
    @NSManaged var herkunft: NSSet?

}
