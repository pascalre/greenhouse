//
//  DetailTableViewCell.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 27.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var attributName: UILabel!
    @IBOutlet weak var attributValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
