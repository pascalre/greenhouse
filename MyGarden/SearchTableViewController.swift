//
//  SearchTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    // MARK: - Properties
    var plants = [Plant]()
    var filteredArray = [Plant]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        plants = [
            Plant(name: "Basilikum"),
            Plant(name: "Petersilie"),
            Plant(name: "Schnittlauch"),
            Plant(name: "Erdbeere")
        ]
        self.tableView.reloadData()
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
        return plants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell?
        
        let plant = plants[indexPath.row]
        cell!.textLabel!.text = plant.name
        return cell!
    }
}
