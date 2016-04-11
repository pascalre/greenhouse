//
//  GardenTableViewCell.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 30.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit
import Charts

class GardenTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fertilizeIcon: UIImageView!
    @IBOutlet weak var waterIcon: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!

    // MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
