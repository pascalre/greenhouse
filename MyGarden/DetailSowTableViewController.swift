//
//  DetailSowTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 13.04.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import Charts

class DetailSowTableViewController: UITableViewController {
    // MARK: Properties
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet var label: [UILabel]!
    var sow: Sowed?

    // MARK: View Setup
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let name = sow?.pflanze?.name!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let gesaet: NSDate = (sow?.gesaetAm)!
        let keimDauer: Double = (sow?.pflanze?.dauerKeimung!)! as Double
        let wuchsDauer: Double = (sow?.pflanze?.dauerWachsen!)! as Double

        plantImageView.image = UIImage(named: name!)
        title = name
        label[0].text = dateFormatter.stringFromDate(gesaet)
        label[1].text = dateFormatter.stringFromDate(gesaet.dateByAddingTimeInterval(60.0*60.0*24.0*keimDauer))
        label[2].text = dateFormatter.stringFromDate(gesaet.dateByAddingTimeInterval(60.0*60.0*24.0*(keimDauer+wuchsDauer)))
        label[3].text = sow?.pflanze?.infos
        label[4].text = sow?.pflanze?.infosErnte

        let progress = getProgress(sow!)

        var units = ["Keimen"]
        if progress[1] == 0.0 {
            units.append("")
            units.append("")
        } else {
            units.append("Wachsen")
            if progress[2] == 0.0 {
                units.append("")
            } else {
                units.append("Ernte")
            }
        }
        units.append("")
        setChart(units, values: progress)
    }

    // MARK: Functions
    func getProgress(sow: Sowed) -> [Double] {
        let sowedDate = sow.gesaetAm!
        var passedDays: Double = NSDate().timeIntervalSinceDate(sowedDate) / 60.0 / 60.0 / 24.0
        let entireDays: Double = Double(sow.pflanze!.dauerKeimung!) + Double(sow.pflanze!.dauerWachsen!) + 10
        var keimung: Double = passedDays
        var wachsen: Double = 0.0
        var ernte: Double = 0.0
        var rest: Double = entireDays-passedDays

        if passedDays >= Double(sow.pflanze!.dauerKeimung!) {
            keimung = Double(sow.pflanze!.dauerKeimung!)
            passedDays = passedDays-keimung
            wachsen = passedDays
            rest = entireDays - keimung - wachsen

            if passedDays >= Double(sow.pflanze!.dauerWachsen!) {
                wachsen = Double(sow.pflanze!.dauerWachsen!)
                passedDays = passedDays-wachsen
                ernte = passedDays
                rest = entireDays - keimung - wachsen - ernte

                if passedDays >= 10 {
                    ernte = 10
                    rest = 0
                }
            }
        }
        return [keimung, wachsen, ernte, rest]
    }

    func setChart(dataPoints: [String], values: [Double]) {

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "vergangene Tage")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartData.setDrawValues(false)
        pieChartView.data = pieChartData
        pieChartView.legend.enabled = false
        pieChartView.descriptionText = "Fortschritt Deiner Pflanze"

        var colors: [UIColor] = []
        colors.append(UIColor.brownColor())
        colors.append(UIColor.orangeColor())
        colors.append(UIColor(red: 67/255.0, green: 205/255.0, blue: 98/255.0, alpha: 1))
        colors.append(UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1))

        pieChartView.animate(xAxisDuration: 0.2, yAxisDuration: 0.7, easingOption: .EaseInOutSine)
        pieChartDataSet.colors = colors
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destinationViewController as? DetailTableViewController
            controller!.detailPlant = sow?.pflanze!
        }
    }

    // MARK: - Table view data source

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
