//
//  GardenTableViewCell.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 24.04.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class GardenTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var icon: UIView!
    @IBOutlet weak var iconChar: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
