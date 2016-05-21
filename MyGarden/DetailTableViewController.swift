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
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    var cells: [[String]] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)!.managedObjectContext
    var detailPlant: Plant? {
        didSet {
            updateView()
            makeCellArray()
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
    func setTitle(title: String, subtitle: String) -> UIView {
        //Create a label programmatically and give it its property's
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.text = title
        titleLabel.sizeToFit()

        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRectMake(0, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.font = UIFont.systemFontOfSize(12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))

        // Center title or subtitle on screen (depending on which is larger)
        if titleLabel.frame.width >= subtitleLabel.frame.width {
            var adjustment = subtitleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
            subtitleLabel.frame = adjustment
        } else {
            var adjustment = titleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
            titleLabel.frame = adjustment
        }

        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        return titleView
    }

    func updateView() {
        if isViewLoaded() {
            let name = detailPlant?.name!

            //title = name
            self.navigationItem.titleView = setTitle(name!, subtitle: detailPlant!.sorte!)

            // Favoriten Icon setzen
            if (detailPlant!.valueForKey("isFavorite") as? Bool)! == true {
                favoriteButton.image = UIImage(named: "Star Filled")
            } else {
                favoriteButton.image = UIImage(named: "Star")
            }
            // Punkt auf MapView setzen
            let point = MKPointAnnotation()
            let latitude = detailPlant?.lat as? Double
            let longitude = detailPlant?.long as? Double
            point.coordinate = CLLocationCoordinate2D.init(latitude: latitude!, longitude: longitude!)
            point.title = detailPlant?.herkunft
            point.subtitle = "Herkunft"
            mapView.addAnnotation(point)
            mapView.setCenterCoordinate(point.coordinate, animated: false)
            self.mapView.selectAnnotation(point, animated: false)
        }
    }

    func makeCellArray() {
        cells = [["wiss. Name", detailPlant!.wissName!], ["Familie", detailPlant!.familie!], ["Wuchshöhe", detailPlant!.wuchshoehe!], ["Standort", detailPlant!.standort!]]
      /*  if let vorkulturAb = detailPlant!.vorkulturAb {
            cells.append(["Vorkultur", vorkulturAb + " - " + detailPlant!.vorkulturBis!])
        }
        if let auspflanzungAb = detailPlant!.auspflanzungAb {
            cells.append(["Auspflanzung", auspflanzungAb + " - " + detailPlant!.auspflanzungBis!])
        }
        if let direktsaatAb = detailPlant!.direktsaatAb {
            cells.append(["Direktsaat", direktsaatAb + " - " + detailPlant!.direktsaatBis!])
        }
        cells.append(["Ernte", detailPlant!.ernteAb! + " - " + detailPlant!.ernteBis!])*/
        cells.append(["Keimdauer", "\(detailPlant!.keimdauer!) Tage"])

        let firstHarvest: Int = Int(detailPlant!.keimdauer!) + Int(detailPlant!.wuchsdauer!)
        cells.append(["Erste Ernte", "\(firstHarvest) Tage"])
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

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Herkunft"
        }
        return ""
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return cells.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = cells[indexPath.row][0]
        cell.detailTextLabel!.text = cells[indexPath.row][1]
        return cell
    }
}
