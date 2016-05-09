//
//  Plant+CoreDataProperties.swift
//  
//
//  Created by Pascal Reitermann on 09.05.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Plant {

    @NSManaged var auspflanzungAb: String?
    @NSManaged var auspflanzungBis: String?
    @NSManaged var boden: String?
    @NSManaged var direktsaatAb: String?
    @NSManaged var direktsaatBis: String?
    @NSManaged var ernteAb: String?
    @NSManaged var ernteBis: String?
    @NSManaged var familie: String?
    @NSManaged var herkunft: String?
    @NSManaged var color: NSNumber?
    @NSManaged var infosErnte: String?
    @NSManaged var infosPflege: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var keimdauer: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var long: NSNumber?
    @NSManaged var name: String?
    @NSManaged var saattiefe: String?
    @NSManaged var sorte: String?
    @NSManaged var standort: String?
    @NSManaged var vorkulturAb: String?
    @NSManaged var vorkulturBis: String?
    @NSManaged var wissName: String?
    @NSManaged var wuchsdauer: NSNumber?
    @NSManaged var wuchshoehe: String?
    @NSManaged var ausgesaet: NSSet?

}
