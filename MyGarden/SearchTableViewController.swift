//
//  SearchTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Properties
    var detailViewController: DetailViewController? = nil
    var plants = [Plant]()
    var filteredArray = [Plant]()
    var searchController = UISearchController()

    // MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // hide searchbar in different VC
        self.definesPresentationContext = true
    
        // Setup the Scope Bar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Suche"
        searchController.searchBar.scopeButtonTitles = ["Name", "Saison", "Herkunft"]
        tableView.tableHeaderView = searchController.searchBar
        
        savePlant("Basilikum")
        savePlant("Petersilie")
        savePlant("Schnittlauch")
        savePlant("Erdbeere")
        
        tableView.reloadData()
    }
    
    func savePlant(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Plant",
            inManagedObjectContext:managedContext)
        
        let plant = Plant(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        plant.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            plants.append(plant)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredArray.count
        }
        return plants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let plant: NSManagedObject
        
        if searchController.active && searchController.searchBar.text != "" {
            plant = filteredArray[indexPath.row]
        } else {
            plant = plants[indexPath.row]
        }
        cell.textLabel!.text = plant.valueForKey("name") as? String
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredArray = plants.filter({( plant : NSManagedObject) -> Bool in
            let categoryMatch = (scope == "Name") || (plant.valueForKey("name") as? String == scope)
            return categoryMatch && (plant.valueForKey("name") as? String)!.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)!
            
            
            let plant: Plant
            if searchController.active && searchController.searchBar.text != "" {
                plant = filteredArray[indexPath.row]
            } else {
                plant = plants[indexPath.row]
            }
            
            let controller = segue.destinationViewController as! DetailViewController
            controller.detailPlant = plant
        }
    }
}