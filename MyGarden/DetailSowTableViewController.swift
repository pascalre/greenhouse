//
//  DetailSowTableViewController.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 13.04.16.
//  Copyright Â© 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import Charts

class DetailSowTableViewController: UITableViewController {
    // MARK: Properties
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet var cells: [UITableViewCell]!
    @IBOutlet var labels: [UILabel]!
    var sow: Sowed?

    // MARK: View Setup
    func setTitle(title: String, subtitle: String) -> UIView {
        //Create a label programmatically and give it its property's
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()

        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))

        // Center title or subtitle on screen (depending on which is larger)
        if titleLabel.frame.width >= subtitleLabel.frame.width {
            var adjustment = subtitleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
            subtitleLabel.frame = adjustment
        } else {
            var adjustment = titleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
            titleLabel.frame = adjustment
        }

        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        return titleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 400.0
        }
        return UITableView.automaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let name = sow?.pflanze?.name!
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let gesaet: NSDate = (sow?.gesaetAm)!
        let keimDauer: Double = (sow?.pflanze?.keimdauer!)! as! Double
        let wuchsDauer: Double = (sow?.pflanze?.wuchsdauer!)! as! Double

        title = ""
        self.navigationItem.titleView = setTitle(title: name!, subtitle: (sow?.pflanze!.sorte!)!)

        cells[0].detailTextLabel!.text = dateFormatter.string(from: gesaet as Date)
        cells[1].detailTextLabel!.text = dateFormatter.string(from: gesaet.addingTimeInterval(60.0*60.0*24.0*keimDauer) as Date)
        cells[2].detailTextLabel!.text = dateFormatter.string(from: gesaet.addingTimeInterval(60.0*60.0*24.0*(keimDauer+wuchsDauer)) as Date)
        labels[0].text = sow?.pflanze?.infosPflege
        labels[1].text = sow?.pflanze?.infosErnte

        let progress = getProgress(sow: sow!)

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
        setChart(dataPoints: units, values: progress)
    }

    // MARK: Functions
    func getProgress(sow: Sowed) -> [Double] {
        let sowedDate = sow.gesaetAm!
        var passedDays: Double = NSDate().timeIntervalSince(sowedDate as Date) / 60.0 / 60.0 / 24.0
        let entireDays: Double = Double(truncating: sow.pflanze!.keimdauer!) + Double(truncating: sow.pflanze!.wuchsdauer!) + 10
        var keimung: Double = passedDays
        var wachsen: Double = 0.0
        var ernte: Double = 0.0
        var rest: Double = entireDays-passedDays

        if passedDays >= Double(truncating: sow.pflanze!.keimdauer!) {
            keimung = Double(truncating: sow.pflanze!.keimdauer!)
            passedDays = passedDays-keimung
            wachsen = passedDays
            rest = entireDays - keimung - wachsen

            if passedDays >= Double(truncating: sow.pflanze!.wuchsdauer!) {
                wachsen = Double(truncating: sow.pflanze!.wuchsdauer!)
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
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "vergangene Tage")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartData.setDrawValues(false)
        pieChartView.data = pieChartData
        pieChartView.legend.enabled = false
        pieChartView.descriptionText = "Fortschritt Deiner Pflanze"

        var colors: [UIColor] = []
        colors.append(UIColor.brown)
        colors.append(UIColor.orange)
        colors.append(UIColor(red: 67/255.0, green: 205/255.0, blue: 98/255.0, alpha: 1))
        colors.append(UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1))

        pieChartView?.animate(xAxisDuration: 0.2, yAxisDuration: 0.7, easingOption: .EaseInOutSine)
        pieChartDataSet.colors = colors
    }

    // MARK: - Segues
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destination as? DetailTableViewController
            controller!.detailPlant = sow?.pflanze!
        }
    }
}
