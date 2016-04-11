//
//  AppDelegate.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let defaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UISearchBar.appearance().barTintColor = UIColor.candyGreen()
        UISearchBar.appearance().tintColor = UIColor.whiteColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.candyGreen()

        if !(defaults.boolForKey("databaseIsFilled")) {
            savePlant("Basilikum", isFavorite: false, latinName: "Ocimum basilicum", anzahlArten: "ca. 60", artKeimung: "Lichtkeimer", aussatAbFrei: "März", aussatAbTopf: "Januar", aussatBisTopf: "Dezember", blaetter: "saftgrün, kelchförmig", dauerKeimung: 7, dauerWachsen: 24, duenger: "Bio-Kräuterdünger", familie: "Lippenblüter", infos: "", standort: "warm, sonnig", wuchshoehe: "15 - 60 cm", herkunftName: "Nordwest-Indien", latitude: 26.135583, longitude: 75.910403)
            savePlant("Petersilie", isFavorite: false, latinName: "Petroselinum crispum", anzahlArten: "4", artKeimung: "Dunkelkeimer", aussatAbFrei: "März", aussatAbTopf: "Februar", aussatBisTopf: "August", blaetter: "dunkelgrün, fiedrig", dauerKeimung: 7, dauerWachsen: 24, duenger: "Bio-Kräuterdünger", familie: "Doldenblütler", infos: "", standort: "halbschatten", wuchshoehe: "30 - 80 cm", herkunftName: "Mittelmeerraum", latitude: 39.486973, longitude: 13.552005)
            defaults.setBool(true, forKey: "databaseIsFilled")
        }
        defaults.synchronize()
        return true
    }

    func savePlant(name: String, isFavorite: Bool, latinName: String, anzahlArten: String, artKeimung: String, aussatAbFrei: String, aussatAbTopf: String, aussatBisTopf: String, blaetter: String, dauerKeimung: Int, dauerWachsen: Int, duenger: String, familie: String, infos: String, standort: String, wuchshoehe: String, herkunftName: String, latitude: Double, longitude: Double) {
        let managedContext = self.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Plant", inManagedObjectContext:managedContext)
        let plant = Plant(entity: entity!, insertIntoManagedObjectContext: managedContext)

        plant.anzahlArten = anzahlArten
        plant.artKeimung = artKeimung
        plant.aussatAbFrei = aussatAbFrei
        plant.aussatAbTopf = aussatAbTopf
        plant.aussatBisTopf = aussatBisTopf
        plant.blaetter = blaetter
        plant.dauerKeimung = dauerKeimung
        plant.dauerWachsen = dauerWachsen
        plant.duenger = duenger
        plant.familie = familie
        plant.infos = infos
        plant.isFavorite = isFavorite
        plant.latinName = latinName
        plant.name = name
        plant.standort = standort
        plant.wuchshoehe = wuchshoehe

        let originEntity = NSEntityDescription.entityForName("Origin", inManagedObjectContext: managedContext)
        let origin = Origin(entity: originEntity!, insertIntoManagedObjectContext: managedContext)

        origin.name = herkunftName
        origin.latitude = latitude
        origin.longitude = longitude
        origin.pflanze = plant

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "de.reitermann.MyGarden" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MyGarden", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
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
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
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
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
}
