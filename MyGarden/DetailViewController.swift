//
//  DetailViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func markAsFavorite(sender: AnyObject) {
        let isFavorite = (detailPlant!.valueForKey("isFavorite") as? Bool)!
        let batchRequest = NSBatchUpdateRequest(entityName: "Plant")
        batchRequest.predicate = NSPredicate(format: "name == %@", (detailPlant?.name)! as String)
        batchRequest.resultType = .UpdatedObjectsCountResultType
        
        if (isFavorite == false){
            batchRequest.propertiesToUpdate = ["isFavorite": true]
            detailPlant?.isFavorite = true;
            favoriteButton.image = UIImage(named: "Star Filled")
        } else {
            batchRequest.propertiesToUpdate = ["isFavorite": false]
            detailPlant?.isFavorite = false;
            favoriteButton.image = UIImage(named: "Star")
        }
        
        do {
            // Execute Batch Request
            try managedObjectContext.executeRequest(batchRequest)
        } catch {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
    }
    
    var detailPlant: Plant? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if isViewLoaded() {
            let name = (detailPlant!.valueForKey("name") as? String)!
            plantImageView.image = UIImage(named: name)
            let isFavorite = (detailPlant!.valueForKey("isFavorite") as? Bool)!
            if (isFavorite == true){
                favoriteButton.image = UIImage(named: "Star Filled")
            }
            title = name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // DataSource
    func numberOfSectionsInTableView(tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.attributeName.text = "Lat. Name"
        cell.attributeValue.text = detailPlant!.valueForKey("latinName") as? String
        return cell
    }
    
    // Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}