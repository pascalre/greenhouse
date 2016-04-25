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
    let defaults = NSUserDefaults.standardUserDefaults()

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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UISearchBar.appearance().barTintColor = UIColor.candyGreenWithoutOpacity()
        UISearchBar.appearance().tintColor = UIColor.whiteColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.candyGreenWithoutOpacity()

        if !(defaults.boolForKey("databaseIsFilled")) {
            let filePath = NSBundle.mainBundle().pathForResource("garden", ofType:"json")
            let jsonData     = NSData(contentsOfFile:filePath!)
            let json = JSON(data: jsonData!)

            print("JSON: \(json)")

            if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                let managedContext = self.managedObjectContext

                for result in json["results"].arrayValue {
                    let entity =  NSEntityDescription.entityForName("Plant", inManagedObjectContext:managedContext)
                    let plant = Plant(entity: entity!, insertIntoManagedObjectContext: managedContext)

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
                    plant.lat = result["lat"].doubleValue
                    plant.long = result["long"].doubleValue
                    plant.infosErnte = result["infosErnte"].stringValue
                    plant.infosPflege  = result["infosPflege"].stringValue
                    plant.isFavorite = false
                    plant.keimdauer = result["keimdauer"].intValue
                    plant.saattiefe = result["saattiefe"].stringValue
                    plant.standort = result["standort"].stringValue
                    plant.vorkulturAb = result["vorkulturAb"].stringValue
                    plant.vorkulturBis = result["vorkulturBis"].stringValue
                    plant.wissName = result["wissName"].stringValue
                    plant.wuchsdauer = result["wuchsdauer"].intValue
                    plant.wuchshoehe = result["wuchshoehe"].stringValue

                    //addPlantToCalendar(plant.name!, place: "in", mon1: getMonthFromString(plant.aussatAbTopf!), mon2: getMonthFromString(plant.aussatBisTopf!))
                    //addPlantToCalendar(plant.name!, place: "out", mon1: getMonthFromString(plant.aussatAbFrei!), mon2: getMonthFromString(plant.aussatBisFrei!))
                }
/*
                let calEntity =  NSEntityDescription.entityForName("Calendar", inManagedObjectContext:managedContext)
                let cal = Calendar(entity: calEntity!, insertIntoManagedObjectContext: managedContext)

                cal.januarIn = calendarArray[0][0]
                cal.januarOut = calendarArray[0][1]
                cal.februarIn = calendarArray[1][0]
                cal.februarOut = calendarArray[1][1]
                cal.maerzIn = calendarArray[2][0]
                cal.maerzOut = calendarArray[2][1]
                cal.aprilIn = calendarArray[3][0]
                cal.aprilOut = calendarArray[3][1]
                cal.maiIn = calendarArray[4][0]
                cal.maiOut = calendarArray[4][1]
                cal.juniIn = calendarArray[5][0]
                cal.juniOut = calendarArray[5][1]
                cal.juliIn = calendarArray[6][0]
                cal.juliOut = calendarArray[6][1]
                cal.augustIn = calendarArray[7][0]
                cal.augustOut = calendarArray[7][1]
                cal.septemberIn = calendarArray[8][0]
                cal.septemberOut = calendarArray[8][1]
                cal.oktoberIn = calendarArray[9][0]
                cal.oktoberOut = calendarArray[9][1]
                cal.novemberIn = calendarArray[10][0]
                cal.novemberOut = calendarArray[10][1]
                cal.dezemberIn = calendarArray[11][0]
                cal.dezemberOut = calendarArray[11][1]
*/
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }

                defaults.setBool(true, forKey: "databaseIsFilled")
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
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("MyGarden", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
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

extension UIColor {
    static func candyGreen() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    }
    static func candyGreenWithoutOpacity() -> UIColor {
        return UIColor(red: 94.0/255.0, green: 211.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    }
}
