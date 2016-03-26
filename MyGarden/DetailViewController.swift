//
//  DetailViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 22.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBAction func markAsFavorite(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let batchRequest = NSBatchUpdateRequest(entityName: "Plant")
        batchRequest.predicate = NSPredicate(format: "name == %@", (detailPlant?.name)!)
        batchRequest.propertiesToUpdate = ["isFavorite": NSNumber(bool: true)]
        
        do {
            // Execute Batch Request
            try managedContext.executeRequest(batchRequest) as! NSBatchUpdateResult
            favoriteButton.image = UIImage(named: "Star Filled")
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
            title = name
            print(name)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}