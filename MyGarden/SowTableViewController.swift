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
    var plants = [Plant]?()
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext

    // MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = NSDate() as Date
        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            plants = results as? [Plant]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Functions
    @IBAction func sowPlant(sender: AnyObject) {
        let sowed = NSEntityDescription.insertNewObject(forEntityName: "Sowed", into: self.managedObjectContext) as? Sowed

        let plant = plants![pickerView.selectedRowInComponent(0)]
        let gesaetAm = datePicker.date

        sowed!.setValue(plant, forKey: "pflanze")
        sowed!.setValue(gesaetAm, forKey: "gesaetAm")

        do {
            try managedObjectContext.save()
            NSLog("New Entry in 'Sowed': %@", plant.name!)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plants!.count
    }

    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return plants![row].valueForKey("name") as? String
    }
}
