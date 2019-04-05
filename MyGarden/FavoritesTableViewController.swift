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

    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    @IBAction func editTable(sender: AnyObject) {
        if tableView.isEditing == false {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }

    // Array where the Favorite Plants are stored
    var favorites = [Plant]()

    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true)

        do {
            let results = try managedObjectContext.fetch(fetchRequest)
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
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Über den Stern auf einer Infoseite kannst Du Pflanzen zu Deinen Favoriten hinzufügen."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)

        let favorite = favorites[indexPath.row]
        cell.textLabel!.text = String(favorite.name!)
        cell.detailTextLabel!.text = String(favorite.sorte!)
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
            let batchRequest = NSBatchUpdateRequest(entityName: "Plant")
            batchRequest.predicate = NSPredicate(format: "name == %@", (favorites[indexPath.row].name)! as String)
            batchRequest.resultType = .updatedObjectsCountResultType
            batchRequest.propertiesToUpdate = ["isFavorite": true]
            favorites[indexPath.row].isFavorite = false
            print("Updated %@ 's attribute 'isFavorite' to true.", favorites[indexPath.row].name!)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            if favorites.count == 0 {
                editButton.title = ""
            } else {
                editButton.title = "Bearbeiten"
            }
            tableView.reloadData()
        }
    }

    // MARK: - Segues
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let cell = sender as? UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell!)!

            let plant: Plant
            plant = favorites[indexPath.row]
            let controller = segue.destination as? DetailTableViewController
            controller!.detailPlant = plant
        }
    }
}
