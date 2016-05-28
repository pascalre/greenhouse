//
//  GardenTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 30.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet
import Charts
import Foundation

class GardenTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // MARK: Properties
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)!.managedObjectContext
    var garden = [Sowed]?()
    @IBOutlet weak var editButton: UIBarButtonItem!

    @IBAction func editTable(sender: AnyObject) {
        if tableView.editing == false {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }

    // MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Sowed")

        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            garden = results as? [Sowed]
        } catch {
            print("error \(error)")
        }
        tableView.setEditing(false, animated: false)

        editButton.title = "Bearbeiten"
        if garden!.count == 0 {
            editButton.title = ""
        }
        tableView.reloadData()
    }

    override func viewWillDisappear(animated: Bool) {
        self.tabBarItem.image = UIImage(named: "Carrot")
    }

    // MARK: TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let garden = garden {
            return garden.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? GardenTableViewCell
        let name: String = String(UTF8String: (garden![indexPath.row].pflanze?.name!)!)!
        cell!.nameLabel!.text = name
        cell!.icon!.backgroundColor = UIColor.init(hexString: garden![indexPath.row].pflanze!.color!)
        cell!.icon!.layer.cornerRadius = cell!.icon!.frame.size.width / 2
        cell!.icon!.clipsToBounds = true

        cell!.iconChar.text = String(name[name.startIndex])
        cell!.progressLabel.text = String(getProgress(garden![indexPath.row])) + " %"
        return cell!
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            managedObjectContext.deleteObject(garden![indexPath.row] as NSManagedObject)
            garden!.removeAtIndex(indexPath.row)
            do {
                try managedObjectContext.save()
            } catch {
                print("error \(error)")
            }
            if garden!.count == 0 {
                editButton.title = ""
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Dein Garten ist leer"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Am besten Du fängst gleich an und legst eine neue Saat an."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Arrow")
    }

    func getProgress(sowed: Sowed) -> Int {
        let sowedDate = sowed.gesaetAm!
        let passedDays: Double = NSDate().timeIntervalSinceDate(sowedDate) / 60.0 / 60.0 / 24.0
        let entireDaysToGrow: Double = Double(sowed.pflanze!.keimdauer!) + Double(sowed.pflanze!.wuchsdauer!)

        let progress = 100.0 / entireDaysToGrow * passedDays
        if  progress > 100  || progress < 0 {
            return 100
        }
        return Int(progress)
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSow" {
            let cell = sender as? UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell!)!
            let sow = garden![indexPath.row]

            let controller = segue.destinationViewController as? DetailSowTableViewController
            controller!.sow = sow
        }
    }
}
