//
//  SowTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 30.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData

class SowTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var plants = [Plant]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        let fetchRequest = NSFetchRequest(entityName: "Plant")
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            plants = results as! [Plant]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

    @IBAction func sowPlant(sender: AnyObject) {
        
        let sowed = NSEntityDescription.insertNewObjectForEntityForName("Sowed", inManagedObjectContext: self.managedObjectContext) as! Sowed

        let plant = plants[pickerView.selectedRowInComponent(0)];
        let gesaetAm = datePicker.date;
        print(gesaetAm)
        
        sowed.setValue(plant, forKey: "pflanze")
        sowed.setValue(gesaetAm, forKey: "gesaetAm")
        sowed.setValue(1, forKey: "id")

        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plants.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return plants[row].valueForKey("name") as? String
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
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
