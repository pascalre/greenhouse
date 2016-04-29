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
    @IBOutlet weak var vorkulturView: UIView!
    @IBOutlet weak var auspflanzungView: UIView!
    @IBOutlet weak var direktsaatView: UIView!
    @IBOutlet weak var ernteView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
       // vorkulturView.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
