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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
