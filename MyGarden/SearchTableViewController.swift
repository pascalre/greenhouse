//
//  SearchTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

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
    
        // Setup the Scope Bar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Name", "Saison", "Herkunft"]
        tableView.tableHeaderView = searchController.searchBar
        
        plants = [
            Plant(name: "Basilikum"),
            Plant(name: "Petersilie"),
            Plant(name: "Schnittlauch"),
            Plant(name: "Erdbeere")
        ]
        
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
        return plants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let plant: Plant
        
        if searchController.active && searchController.searchBar.text != "" {
            plant = filteredArray[indexPath.row]
        } else {
            plant = plants[indexPath.row]
        }
        cell.textLabel!.text = plant.name
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredArray = plants.filter({( plant : Plant) -> Bool in
            let categoryMatch = (scope == "Name") || (plant.name == scope)
            return categoryMatch && plant.name.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}