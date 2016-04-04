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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var plantImageView: UIImageView!
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
            print("Updated %@ 's attribute 'isFavorite' to true.", detailPlant?.name!)
        } else {
            batchRequest.propertiesToUpdate = ["isFavorite": false]
            detailPlant?.isFavorite = false;
            favoriteButton.image = UIImage(named: "Star")
            print("Updated %@ 's attribute 'isFavorite' to false.", detailPlant?.name!)
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
            
            let origin: Origin = (detailPlant?.herkunft!)! as Origin
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D.init(latitude: origin.latitude as! Double, longitude: origin.longitude as! Double)
            point.title = origin.name
            mapView.addAnnotation(point)
            mapView.setCenterCoordinate(point.coordinate, animated: false)
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 11
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.attributName.text = "Lat. Name"
            cell.attributValue.text = detailPlant?.latinName
        case 1:
            cell.attributName.text = "Familie"
            cell.attributValue.text = detailPlant?.familie
        case 2:
            cell.attributName.text = "Anzahl an Arten"
            cell.attributValue.text = detailPlant?.anzahlArten
        case 3:
            cell.attributName.text = "Blätter"
            cell.attributValue.text = detailPlant?.blaetter
        case 4:
            cell.attributName.text = "Wuchshöhe"
            cell.attributValue.text = detailPlant?.wuchshoehe
        case 5:
            cell.attributName.text = "Aussaat im Topf"
            cell.attributValue.text = (detailPlant?.aussatAbTopf)! + " - " + (detailPlant?.aussatBisTopf)!
        case 6:
            cell.attributName.text = "Aussaat im Garten"
            cell.attributValue.text = "ab " + (detailPlant?.aussatAbFrei)!
        case 7:
            cell.attributName.text = "Keimdauer"
            cell.attributValue.text = String((detailPlant?.dauerKeimung)!) + " Tage"
        case 8:
            cell.attributName.text = "Erste Ernte"
            cell.attributValue.text = String((detailPlant?.dauerWachsen)!) + " Tage"
        case 9:
            cell.attributName.text = "Standort"
            cell.attributValue.text = detailPlant?.standort
        case 10:
            cell.attributName.text = "Dünger"
            cell.attributValue.text = detailPlant?.duenger
        default:
            cell.attributName.text = ""
            cell.attributValue.text = ""
        }
        
        return cell
    }
    
    // Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}