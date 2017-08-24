//
//  PSTableViewCell.swift
//  Planetary
//
//  Created by Matthew Turk on 7/20/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit

class PSTableViewCell: UITableViewCell {

    @IBOutlet var PSTitleLabel: UILabel!
    @IBOutlet var PSDescriptionLabel: UILabel!
    @IBOutlet var PSImageView: UIImageView!
    @IBOutlet var PSAuthorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
