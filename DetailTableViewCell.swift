//
//  DetailTableViewCell.swift
//  MyGarden
//
//  Created by Pascal Reitermann on 27.03.16.
//  Copyright © 2016 Pascal Reitermann. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var attributName: UILabel!
    @IBOutlet weak var attributValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
