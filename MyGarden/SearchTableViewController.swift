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

    // MARK: Properties
    var detailViewController: DetailTableViewController? = nil
    var plants = [Plant]?()
    var filteredArray = [Plant]()
    var searchController = UISearchController()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)!.managedObjectContext

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
        tableView.tableHeaderView = searchController.searchBar

        let fetchRequest = NSFetchRequest(entityName: "Plant")

        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            plants = results as? [Plant]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        tableView.reloadData()
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
        if let plants = plants {
            return plants.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let plant: NSManagedObject

        if searchController.active && searchController.searchBar.text != "" {
            plant = filteredArray[indexPath.row]
        } else {
            plant = plants![indexPath.row]
        }
        cell.textLabel!.text = plant.valueForKey("name") as? String

        return cell
    }

    func filterContentForSearchText(searchText: String) {
        filteredArray = plants!.filter({( plant: NSManagedObject) -> Bool in
            return (plant.valueForKey("name") as? String)!.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let cell = sender as? UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell!)!

            let plant: Plant
            if searchController.active && searchController.searchBar.text != "" {
                plant = filteredArray[indexPath.row]
            } else {
                plant = plants![indexPath.row]
            }

            let controller = segue.destinationViewController as? DetailTableViewController
            controller!.detailPlant = plant
        }
    }
}
