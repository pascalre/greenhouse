//
//  CalendarTableViewCell.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 26.04.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!

    @IBOutlet weak var calendarView: UIView!
    @IBOutlet var viewCollection: [UIView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        if viewCollection != nil {
            let radius = CGFloat(3)
            viewCollection[0].layer.cornerRadius = radius
            viewCollection[1].layer.cornerRadius = radius
            viewCollection[2].layer.cornerRadius = radius
            viewCollection[3].layer.cornerRadius = radius
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCorrectBounds(from: String, until: String) {
        let bounds = calendarView.bounds.width
        NSLog("calendarView.bounds.width: %d", bounds)
        let x: Int = Int(bounds/12)

        let constrains = ([
            "Januar": x*0,
            "Februar": x*1,
            "März": x*2,
            "April": x*3,
            "Mai": x*4,
            "Juni": x*5,
            "Juli": x*6,
            "August": x*7,
            "September": x*8,
            "Oktober": x*9,
            "November": x*10,
            "Dezember": x*11,
            "": 0])

        let fromX = constrains[from]!
        let untilX = constrains[until]!

        NSLog("x: %d", x)
        NSLog("Januar : %d", constrains["Januar"]!)
        NSLog("Februar: %d", constrains["Februar"]!)
        NSLog("Dezember: %d", constrains["Dezember"]!)
        NSLog("fromX: %d", fromX)
        NSLog("untilX: %d", untilX)

/*
        var f = viewCollection[0].frame
        f.origin.x = fromX
        f.origin.y = untilX
*/
        viewCollection[0].frame = CGRectMake(CGFloat(fromX), CGFloat(7), CGFloat(untilX), CGFloat(6))
       // viewCollection[0].frame = CGRectMake(CGFloat(12), CGFloat(7), CGFloat(200), CGFloat(6))
    }

}
