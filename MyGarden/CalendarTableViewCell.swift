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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCorrectBounds(view: Int, from: String, until: String) {
        contentView.layoutIfNeeded()
        let bounds = calendarView.bounds.width
        let x: Int = Int(bounds/11)

        let constrains = ([
            "Januar": 5,
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
            "Dezember": x*11-5,
            "": 0])

        let fromX = constrains[from]!
        let untilX = constrains[until]!

        viewCollection[view].frame = CGRect(x: CGFloat(fromX), y: CGFloat(7+view*8), width: CGFloat(untilX-fromX), height: CGFloat(6))
    }

}
