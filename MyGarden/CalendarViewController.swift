//
//  CalendarViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 21.05.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var plants = [Plant]?()
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")

        do {
            let results = try managedObjectContext.fetch(fetchRequest)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let plantsCount = self.plants?.count {
            return plantsCount
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CalendarTableViewCell
        cell!.title.text = plants![i].name
        cell!.subtitle.text = plants![i].sorte
        cell!.setCorrectBounds(view: 0, from: plants![i].vorkulturAb!, until: plants![i].vorkulturBis!)
        cell!.setCorrectBounds(view: 1, from: plants![i].auspflanzungAb!, until: plants![i].auspflanzungBis!)
        cell!.setCorrectBounds(view: 2, from: plants![i].direktsaatAb!, until: plants![i].direktsaatBis!)
        cell!.setCorrectBounds(view: 3, from: plants![i].ernteAb!, until: plants![i].ernteBis!)
        return cell!
    }

    // MARK: - Segues
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            print("Test..")
            let cell = sender as? CalendarTableViewCell
            let indexPath = self.tableView.indexPath(for: cell!)!

            let controller = segue.destination as? DetailTableViewController
            controller!.detailPlant = plants![indexPath.row-1]
        }
    }


}
