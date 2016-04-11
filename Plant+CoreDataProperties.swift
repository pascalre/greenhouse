//
//  Plant+CoreDataProperties.swift
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

extension Plant {

    @NSManaged var anzahlArten: String?
    @NSManaged var art: String?
    @NSManaged var artKeimung: String?
    @NSManaged var aussatAbFrei: String?
    @NSManaged var aussatAbTopf: String?
    @NSManaged var aussatBisTopf: String?
    @NSManaged var blaetter: String?
    @NSManaged var dauerKeimung: NSNumber?
    @NSManaged var dauerWachsen: NSNumber?
    @NSManaged var duenger: String?
    @NSManaged var familie: String?
    @NSManaged var infos: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var latinName: String?
    @NSManaged var name: String?
    @NSManaged var standort: String?
    @NSManaged var wuchshoehe: String?
    @NSManaged var ausgesaet: NSSet?
    @NSManaged var herkunft: Origin?

}
