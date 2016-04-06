//
//  MySowTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 30.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import Charts

class MySowTableViewController: UITableViewController {
    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    var sow: Sowed? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if isViewLoaded() {
            let name = (sow!.pflanze?.name!)!
            plantImageView.image = UIImage(named: name)
            title = name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let months = ["Keimen", "Wachsen", "Ernte", ""]
        
        var days = (sow?.gesaetAm!.timeIntervalSinceNow)! / 60.0 / 60.0 / 24.0 * -1
        
        let unitsSold = [14.0, 28.0, 28.0, 7.0]
        
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "vergangene Tage")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.legend.enabled = false
        pieChartView.descriptionText = "Fortschritt Deiner Pflanze"
        
        var colors: [UIColor] = []
    
        colors.append(UIColor.brownColor())
        colors.append(UIColor.orangeColor())
        colors.append(UIColor(red: 67/255.0, green: 205/255.0, blue: 98/255.0, alpha: 1))
        colors.append(UIColor(red: 67/255.0, green: 205/255.0, blue: 98/255.0, alpha: 0.3))
        
        pieChartView.animate(xAxisDuration: 0.2, yAxisDuration: 0.7, easingOption: .EaseInOutSine)
        
        pieChartDataSet.colors = colors
        
    }

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
        return 5
    }

    override func viewWillAppear(animated: Bool) {
        updateView()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let gesaet : NSDate = (sow?.gesaetAm)!
       
        switch indexPath.row {
        case 0 :
            cell.attributName.text = "Ausgesät am"
            cell.attributValue.text = dateFormatter.stringFromDate(gesaet)
        case 1 :
            cell.attributName.text = "vsl. Wachstum ab"
            let keimDauer : Double = (sow?.pflanze?.dauerKeimung!)! as Double
            cell.attributValue.text = dateFormatter.stringFromDate(gesaet.dateByAddingTimeInterval(60.0*60.0*24.0*keimDauer))
        case 2 :
            cell.attributName.text = "vsl. Ernte ab"
            let keimDauer : Double = (sow?.pflanze?.dauerKeimung!)! as Double
            let wuchsDauer : Double = (sow?.pflanze?.dauerWachsen!)! as Double
            cell.attributValue.text = dateFormatter.stringFromDate(gesaet.dateByAddingTimeInterval(60.0*60.0*24.0*(keimDauer+wuchsDauer)))
        case 3 :
            cell.attributName.text = "nächste Wässerung"
            cell.attributName.text = dateFormatter.stringFromDate(NSDate())
        default:
            cell.attributName.text = ""
        }
        return cell
    }

    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let plant: Plant
            plant = (sow?.pflanze)!
            
            let controller = segue.destinationViewController as! DetailTableViewController
            controller.detailPlant = plant
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
