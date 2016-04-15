//
//  CalendarTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 13.04.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import CoreData

class CalendarTableViewController: UITableViewController {
    // MARK: Properties & Outlets
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)!.managedObjectContext
    var calendar = Calendar?()
    @IBOutlet var label: [UILabel]!

    // MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Calendar")

        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            calendar = results.first as? Calendar
        } catch {
            print("error \(error)")
        }

        label[0].text = calendar!.januarIn!
        label[1].text = calendar!.januarOut!
        label[2].text = calendar!.februarIn!
        label[3].text = calendar!.februarOut!
        label[4].text = calendar!.maerzIn!
        label[5].text = calendar!.maerzOut!
        label[6].text = calendar!.aprilIn!
        label[7].text = calendar!.aprilOut!
        label[8].text = calendar!.maiIn!
        label[9].text = calendar!.maiOut!
        label[10].text = calendar!.juniIn!
        label[11].text = calendar!.juniOut!
        label[12].text = calendar!.juliIn!
        label[13].text = calendar!.juliOut!
        label[14].text = calendar!.augustIn!
        label[15].text = calendar!.augustOut!
        label[16].text = calendar!.septemberIn!
        label[17].text = calendar!.septemberOut!
        label[18].text = calendar!.oktoberIn!
        label[19].text = calendar!.oktoberOut!
        label[20].text = calendar!.novemberIn!
        label[21].text = calendar!.novemberOut!
        label[22].text = calendar!.dezemberIn!
        label[23].text = calendar!.dezemberOut!

        for l in label {
            if l.text?.characters.count == 0 {
                l.text = "-"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
