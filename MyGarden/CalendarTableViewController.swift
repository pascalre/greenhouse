//
//  CalendarTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 26.04.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData

class CalendarTableViewController: UITableViewController {

    var plants = [Plant]?()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)!.managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest(entityName: "Plant")

        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            plants = results as? [Plant]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

   /* override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        tableView.reloadData()
    }*/

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
        if let plantsCount = self.plants?.count {
            return plantsCount + 2
        }
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Header", forIndexPath: indexPath)
            return cell
        }
        if indexPath.row == (plants?.count)! + 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Legend", forIndexPath: indexPath) as UITableViewCell
            return cell
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? CalendarTableViewCell
        cell!.title.text = plants![indexPath.row-1].name
        cell!.subtitle.text = plants![indexPath.row-1].sorte
        cell!.setCorrectBounds(0, from: plants![indexPath.row-1].vorkulturAb!, until: plants![indexPath.row-1].vorkulturBis!)
        cell!.setCorrectBounds(1, from: plants![indexPath.row-1].auspflanzungAb!, until: plants![indexPath.row-1].auspflanzungBis!)
        cell!.setCorrectBounds(2, from: plants![indexPath.row-1].direktsaatAb!, until: plants![indexPath.row-1].direktsaatBis!)
        cell!.setCorrectBounds(3, from: plants![indexPath.row-1].ernteAb!, until: plants![indexPath.row-1].ernteBis!)
        return cell!
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            print("Test..")
            let cell = sender as? CalendarTableViewCell
            let indexPath = self.tableView.indexPathForCell(cell!)!

            let controller = segue.destinationViewController as? DetailTableViewController
            controller!.detailPlant = plants![indexPath.row-1]
        }
    }

/*
    func makeHeader(cell: CalendarTableViewCell) -> UIView {
        let titleView = UIView(frame: CGRectMake(0, 0, cell.calendarView.frame.width, cell.calendarView.frame.height))
        let x: Int = Int(cell.calendarView.frame.width/12)

        for (i, month) in ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"].enumerate() {
            let titleLabel = UILabel(frame: CGRectMake(CGFloat(2+x*i), 10, 20, 20)) //x, y, width, height where y is to offset from the view center
            titleLabel.backgroundColor = UIColor.clearColor()
            titleLabel.textColor = UIColor.blackColor()
            titleLabel.font = UIFont.systemFontOfSize(13)
            titleLabel.text = month
            titleLabel.textAlignment = .Center
            //titleLabel.sizeToFit()
            titleView.addSubview(titleLabel)
        }
        return titleView
    }
*/
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
