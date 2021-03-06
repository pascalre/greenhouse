//
//  AppDelegate.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

enum Month: Int {
    case January = 0
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let defaults = UserDefaults.standard

    var months: [Month] = [
        Month.January,
        Month.February,
        Month.March,
        Month.April,
        Month.May,
        Month.June,
        Month.July,
        Month.August,
        Month.September,
        Month.October,
        Month.November,
        Month.December
    ]

    var calendarArray = [
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""]
    ]

    func addPlantToCalendar(name: String, place: String, mon1: Month, mon2: Month) {
        for m in months {
            if m.rawValue >= mon1.rawValue && m.rawValue <= mon2.rawValue {

                var help = 0
                if place == "out" {
                    help = 1
                }

                if calendarArray[m.rawValue][help].characters.count != 0 {
                    calendarArray[m.rawValue][help] += ", "
                }
                calendarArray[m.rawValue][help] += name
            }
        }
    }

    func getMonthFromString(month: String) -> Month {
        switch month {
        case "Januar": return Month.January
        case "Februar": return Month.February
        case "März": return Month.March
        case "April": return Month.April
        case "Mai": return Month.May
        case "Juni": return Month.June
        case "Juli": return Month.July
        case "August": return Month.August
        case "September": return Month.September
        case "Oktober": return Month.October
        case "November": return Month.November
        default:
            return Month.December
        }
    }

    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UISearchBar.appearance().barTintColor = UIColor.candyGreenWithoutOpacity()
        UISearchBar.appearance().tintColor = UIColor.white
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.candyGreenWithoutOpacity()

        if !(defaults.bool(forKey: "databaseIsFilled")) {
            let filePath = Bundle.main.path(forResource: "garden", ofType:"json")
            let jsonData     = NSData(contentsOfFile:filePath!)
            let json = JSON(data: jsonData! as Data)

            print("JSON: \(json)")

            if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                let managedContext = self.managedObjectContext

                for result in json["results"].arrayValue {
                    let entity =  NSEntityDescription.entity(forEntityName: "Plant", in:managedContext)
                    let plant = Plant(entity: entity!, insertInto: managedContext)

                    plant.name = result["name"].stringValue
                    plant.sorte = result["sorte"].stringValue
                    plant.auspflanzungAb = result["auspflanzungAb"].stringValue
                    plant.auspflanzungBis = result["auspflanzungBis"].stringValue
                    plant.boden = result["boden"].stringValue
                    plant.direktsaatAb = result["direktsaatAb"].stringValue
                    plant.direktsaatBis = result["direktsaatBis"].stringValue
                    plant.ernteAb = result["ernteAb"].stringValue
                    plant.ernteBis = result["ernteBis"].stringValue
                    plant.familie = result["familie"].stringValue
                    plant.herkunft = result["herkunft"].stringValue
                    plant.lat = result["lat"].doubleValue as NSNumber
                    plant.long = result["long"].doubleValue as NSNumber
                    plant.infosErnte = result["infosErnte"].stringValue
                    plant.infosPflege  = result["infosPflege"].stringValue
                    plant.color = result["color"].stringValue
                    plant.isFavorite = false
                    plant.keimdauer = result["keimdauer"].intValue as NSNumber
                    plant.saattiefe = result["saattiefe"].stringValue
                    plant.standort = result["standort"].stringValue
                    plant.vorkulturAb = result["vorkulturAb"].stringValue
                    plant.vorkulturBis = result["vorkulturBis"].stringValue
                    plant.wissName = result["wissName"].stringValue
                    plant.wuchsdauer = result["wuchsdauer"].intValue as NSNumber
                    plant.wuchshoehe = result["wuchshoehe"].stringValue
                }

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }

                defaults.set(true, forKey: "databaseIsFilled")
            }
        }
        defaults.synchronize()
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "MyGarden", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
