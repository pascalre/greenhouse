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

class GardenTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editTable(sender: AnyObject) {
        if tableView.editing == false {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
        
    }
    
    var garden = [Sowed]()
    
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return garden.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GardenTableViewCell
        let name: String = String(UTF8String: (garden[indexPath.row].pflanze?.name!)!)!
        cell.nameLabel!.text = name
        cell.plantImageView!.image = UIImage(named: name)
        
        let months = ["Aktuell"]
        let unitsSold = [23.0]
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(value: unitsSold[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Fortschritt")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = [UIColor.brownColor()]
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        chartData.setDrawValues(false)
        cell.barChartView.legend.enabled = false
        cell.barChartView.xAxis.drawLabelsEnabled = false
        cell.barChartView.leftAxis.enabled = false
        cell.barChartView.rightAxis.enabled = false
        cell.barChartView.descriptionText = "Fortschritt"
        cell.barChartView.drawGridBackgroundEnabled = false
        cell.barChartView.data = chartData
        
        cell.barChartView.leftAxis.axisMinValue = 0.0
        cell.barChartView.leftAxis.axisMaxValue = 25.0
        cell.barChartView.animate(xAxisDuration: 0, yAxisDuration: 0.8, easingOption: .EaseInOutSine)
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Sowed")

        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            garden = results as! [Sowed]
        } catch {
            print("error \(error)")
        }
        tableView.setEditing(false, animated: false)
        
        
        if (garden.count == 0) {
            editButton.title = ""
        } else {
            editButton.title = "Bearbeiten"
        }
        
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            managedObjectContext.deleteObject(garden[indexPath.row] as NSManagedObject)
            garden.removeAtIndex(indexPath.row)
            do {
                try managedObjectContext.save()
            } catch {
                print("error \(error)")
            }
            editButton.title = ""
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
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSow" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)!
            
            let sow = garden[indexPath.row]
            
            let controller = segue.destinationViewController as! MySowTableViewController
            controller.sow = sow
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
