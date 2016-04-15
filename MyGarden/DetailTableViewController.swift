//
//  DetailTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 30.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class DetailTableViewController: UITableViewController {
    // MARK: Properties
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var label: [UILabel]!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)!.managedObjectContext
    var detailPlant: Plant? {
        didSet {
            updateView()
        }
    }

    // MARK: Functions
    @IBAction func markAsFavorite(sender: AnyObject) {
        let isFavorite = (detailPlant!.valueForKey("isFavorite") as? Bool)!
        let batchRequest = NSBatchUpdateRequest(entityName: "Plant")
        batchRequest.predicate = NSPredicate(format: "name == %@", (detailPlant?.name)! as String)
        batchRequest.resultType = .UpdatedObjectsCountResultType

        if isFavorite == false {
            batchRequest.propertiesToUpdate = ["isFavorite": true]
            detailPlant?.isFavorite = true
            favoriteButton.image = UIImage(named: "Star Filled")
            print("Updated \((detailPlant?.name!)!)'s attribute 'isFavorite' to true.")
        } else {
            batchRequest.propertiesToUpdate = ["isFavorite": false]
            detailPlant?.isFavorite = false
            favoriteButton.image = UIImage(named: "Star")
            print("Updated \((detailPlant?.name!)!)'s attribute 'isFavorite' to false.")
        }

        do {
            // Execute Batch Request
            try managedObjectContext.executeRequest(batchRequest)
        } catch {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
    }

    // MARK: View Setup
    func updateView() {
        if isViewLoaded() {
            let name = detailPlant?.name!
            plantImageView.image = UIImage(named: name!)
            title = name
            // Favoriten Icon setzen
            if (detailPlant!.valueForKey("isFavorite") as? Bool)! == true {
                favoriteButton.image = UIImage(named: "Star Filled")
            } else {
                favoriteButton.image = UIImage(named: "Star")
            }
            let firstHarvest: Int = Int((detailPlant?.dauerKeimung!)!) + Int((detailPlant?.dauerWachsen!)!)

            label[0].text = detailPlant?.latinName!
            label[1].text = detailPlant?.familie!
            label[2].text = detailPlant?.anzahlArten!
            label[3].text = detailPlant?.blaetter!
            label[4].text = detailPlant?.wuchshoehe!
            label[5].text = (detailPlant?.aussatAbTopf!)! + " - " + (detailPlant?.aussatBisTopf!)!
            label[6].text = (detailPlant?.aussatAbFrei!)! + " - " + (detailPlant?.aussatBisFrei!)!
            label[7].text = detailPlant?.artKeimung!
            label[8].text = "\((detailPlant?.dauerKeimung!)!) Tage"
            label[9].text = "\(firstHarvest) Tage"
            label[10].text = detailPlant?.standort!

            // Punkt auf MapView setzen
            let point = MKPointAnnotation()
            let latitude = detailPlant?.latitude as? Double
            let longitude = detailPlant?.longitude as? Double
            point.coordinate = CLLocationCoordinate2D.init(latitude: latitude!, longitude: longitude!)
            point.title = detailPlant?.herkunft
            point.subtitle = "Herkunft"
            mapView.addAnnotation(point)
            mapView.setCenterCoordinate(point.coordinate, animated: false)
            self.mapView.selectAnnotation(point, animated: false)
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
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
