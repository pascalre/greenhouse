//
//  FavoritesTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 25.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class FavoritesTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // MARK: Properties
    @IBOutlet weak var editButton: UIBarButtonItem!

    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)!.managedObjectContext
    @IBAction func editTable(sender: AnyObject) {
        if tableView.editing == false {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }

    // Array where the Favorite Plants are stored
    var favorites = [Plant]()

    override func viewWillAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Plant")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true)

        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            favorites = (results as? [Plant])!
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        if favorites.count == 0 {
            editButton.title = ""
        } else {
            editButton.title = "Bearbeiten"
        }

        tableView.setEditing(false, animated: false)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Keine Favoriten vorhanden"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Über den Stern auf einer Infoseite kannst Du Pflanzen zu Deinen Favoriten hinzufügen."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "BigStar")
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
        return favorites.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let favorite = favorites[indexPath.row]
        cell.textLabel!.text = String(favorite.name!)
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let batchRequest = NSBatchUpdateRequest(entityName: "Plant")
            batchRequest.predicate = NSPredicate(format: "name == %@", (favorites[indexPath.row].name)! as String)
            batchRequest.resultType = .UpdatedObjectsCountResultType
            batchRequest.propertiesToUpdate = ["isFavorite": true]
            favorites[indexPath.row].isFavorite = false
            print("Updated %@ 's attribute 'isFavorite' to true.", favorites[indexPath.row].name!)
            favorites.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if favorites.count == 0 {
                editButton.title = ""
            } else {
                editButton.title = "Bearbeiten"
            }
            tableView.reloadData()
        }
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let cell = sender as? UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell!)!

            let plant: Plant
            plant = favorites[indexPath.row]
            let controller = segue.destinationViewController as? DetailTableViewController
            controller!.detailPlant = plant
        }
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
