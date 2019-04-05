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
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    var garden = [Sowed]?()
    @IBOutlet weak var editButton: UIBarButtonItem!

    @IBAction func editTable(sender: AnyObject) {
        if tableView.isEditing == false {
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

    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sowed")

        do {
            let results = try managedObjectContext.fetch(fetchRequest)
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

    func viewWillDisappear(animated: Bool) {
        self.tabBarItem.image = UIImage(named: "Carrot")
    }

    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let garden = garden {
            return garden.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as? GardenTableViewCell
        let name: String = String(UTF8String: (garden![indexPath.row].pflanze?.name!)!)!
        cell!.nameLabel!.text = name
        cell!.icon!.backgroundColor = UIColor.init(hexString: garden![indexPath.row].pflanze!.color!)
        cell!.icon!.layer.cornerRadius = cell!.icon!.frame.size.width / 2
        cell!.icon!.clipsToBounds = true

        cell!.iconChar.text = String(name[name.startIndex])
        cell!.progressLabel.text = String(getProgress(sowed: garden![indexPath.row])) + " %"
        return cell!
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
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
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            tableView.reloadData()
        }
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Dein Garten ist leer"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Am besten Du fängst gleich an und legst eine neue Saat an."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Arrow")
    }

    func getProgress(sowed: Sowed) -> Int {
        let sowedDate = sowed.gesaetAm!
        let passedDays: Double = NSDate().timeIntervalSince(sowedDate as Date) / 60.0 / 60.0 / 24.0
        let entireDaysToGrow: Double = Double(truncating: sowed.pflanze!.keimdauer!) + Double(truncating: sowed.pflanze!.wuchsdauer!)

        let progress = 100.0 / entireDaysToGrow * passedDays
        if  progress > 100  || progress < 0 {
            return 100
        }
        return Int(progress)
    }

    // MARK: - Segues
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSow" {
            let cell = sender as? UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell!)!
            let sow = garden![indexPath.row]

            let controller = segue.destination as? DetailSowTableViewController
            controller!.sow = sow
        }
    }
}
